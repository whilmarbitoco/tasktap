import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as app_user;

extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final UserRepository _userRepository;

  AuthService(this._userRepository) {
    _googleSignIn = GoogleSignIn();
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw 'Please fill in all fields';
      }
      print('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in successful: ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('Unexpected error: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw 'Please fill in all fields';
      }
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }
      print('Attempting to create account with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Account created successfully: ${credential.user?.email}');

      if (credential.user != null) {
        await _createUserRecord(credential.user!, name);
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('Unexpected error: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // Clear any existing sign-in state
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return null;
      }

      print('Google user signed in: ${googleUser.email}');

      // Check if user exists in our database BEFORE Firebase Auth
      final existingUsers = await _userRepository.getAllUsers();
      final existingUser = existingUsers
          .where((u) => u.email == googleUser.email)
          .firstOrNull;

      if (existingUser == null) {
        print('User not registered in system: ${googleUser.email}');
        await _googleSignIn.signOut();
        throw 'Account not found. Please sign up first.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
          
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Failed to get Google authentication tokens';
      }
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Attempting Firebase authentication with Google credentials...');
      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw 'Google sign-in failed: no Firebase user returned';
      }

      print('User exists in system: ${user.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      await _googleSignIn.signOut();
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('Google Sign-In error: $e');
      await _googleSignIn.signOut();
      throw 'Account not found. Please sign up first.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<User?> signUpWithGoogle(String name) async {
    try {
      print('Starting Google Sign-Up...');
      
      // Clear any existing sign-in state
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-Up cancelled by user');
        return null;
      }

      print('Google user signed up: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
          
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Failed to get Google authentication tokens';
      }
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Creating Firebase account with Google credentials...');
      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw 'Google sign-up failed: no Firebase user returned';
      }

      // Create user record in database
      await _createUserRecord(
        user,
        name.isNotEmpty ? name : (user.displayName ?? 'User'),
      );

      print('User record created: ${user.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      await _googleSignIn.signOut();
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('Google Sign-Up error: $e');
      await _googleSignIn.signOut();
      throw 'Google sign-up failed. Please try again.';
    }
  }

  Future<void> _createUserRecord(User firebaseUser, String name) async {
    try {
      final user = app_user.User(
        id: firebaseUser.uid,
        name: name,
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber,
        profileImageUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );

      print('Creating user record in database: ${user.email}');
      await _userRepository.createUser(user);
      print('User record created successfully');
    } catch (e) {
      print('Error creating user record: $e');
      throw 'Failed to create user profile: $e';
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart' as app_user;

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

  Future<User?> signUpWithEmail(String email, String password, String name) async {
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return null;
      }

      print('Google user signed in: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Attempting Firebase authentication with Google credentials...');
      final userCredential = await _auth.signInWithCredential(credential);
      print(
        'Firebase authentication successful: ${userCredential.user?.email}',
      );
      
      if (userCredential.user != null) {
        final existingUser = await _userRepository.getUser(userCredential.user!.uid);
        if (existingUser == null) {
          await _createUserRecord(userCredential.user!, userCredential.user!.displayName ?? 'User');
        }
      }
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      print('Google Sign-In error: $e');
      // Check if user is actually signed in despite the error
      if (_auth.currentUser != null) {
        print('User is actually signed in, ignoring error');
        return _auth.currentUser;
      }
      // Check if it's the type casting error but authentication succeeded
      if (e.toString().contains('PigeonUserDetails')) {
        // Wait a moment and check if user is signed in
        await Future.delayed(const Duration(milliseconds: 500));
        if (_auth.currentUser != null) {
          print('Authentication succeeded despite PigeonUserDetails error');
          return _auth.currentUser;
        }
        throw 'Google Sign-In configuration error. Please try again.';
      }
      throw 'Google sign-in failed: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> _createUserRecord(User firebaseUser, String name) async {
    final user = app_user.User(
      id: firebaseUser.uid,
      name: name,
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber,
      profileImageUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
    
    await _userRepository.createUser(user);
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

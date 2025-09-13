import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginViewModel(UserRepository userRepository)
    : _authService = AuthService(userRepository);

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> signInWithEmail(BuildContext context) async {
    _setLoading(true);
    try {
      final user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _setLoading(true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

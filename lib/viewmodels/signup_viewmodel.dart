import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SignUpViewModel(UserRepository userRepository)
    : _authService = AuthService(userRepository);

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      _showError(context, 'Passwords do not match');
      return;
    }

    _setLoading(true);
    try {
      final user = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text,
        nameController.text.trim(),
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

  Future<void> signUpWithGoogle(BuildContext context) async {
    _setLoading(true);
    try {
      final user = await _authService.signUpWithGoogle(
        nameController.text.trim(),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/google_sign_in_button.dart';
import '../repositories/user_repository.dart';
import 'signup_page.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(context.read<UserRepository>()),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildEmailField(vm),
                      const SizedBox(height: 16),
                      _buildPasswordField(vm),
                      const SizedBox(height: 24),
                      _buildSignInButton(context, vm),
                      const SizedBox(height: 16),
                      _buildGoogleSignInButton(context, vm),
                      const SizedBox(height: 24),
                      _buildSignUpLink(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const AuthHeader(
      icon: Icons.task_alt,
      title: 'Welcome to TaskTap',
      subtitle: 'Sign in to find or offer tasks',
    );
  }

  Widget _buildEmailField(LoginViewModel vm) {
    return CustomTextField(
      controller: vm.emailController,
      labelText: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(LoginViewModel vm) {
    return CustomTextField(
      controller: vm.passwordController,
      labelText: 'Password',
      prefixIcon: Icons.lock_outlined,
      obscureText: vm.obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          vm.obscurePassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: vm.togglePasswordVisibility,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, LoginViewModel vm) {
    return CustomButton(
      text: vm.isLoading ? 'Signing In...' : 'Sign In',
      onPressed: vm.isLoading ? null : () => vm.signInWithEmail(context),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, LoginViewModel vm) {
    return GoogleSignInButton(
      onPressed: vm.isLoading ? null : () => vm.signInWithGoogle(context),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      ),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

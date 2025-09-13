import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/google_sign_in_button.dart';
import '../repositories/user_repository.dart';
import '../viewmodels/signup_viewmodel.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(context.read<UserRepository>()),
      child: Consumer<SignUpViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildNameField(vm),
                      const SizedBox(height: 16),
                      _buildEmailField(vm),
                      const SizedBox(height: 16),
                      _buildPasswordField(vm),
                      const SizedBox(height: 16),
                      _buildConfirmPasswordField(vm),
                      const SizedBox(height: 24),
                      _buildSignUpButton(context, vm),
                      const SizedBox(height: 16),
                      _buildGoogleSignInButton(context, vm),
                      const SizedBox(height: 24),
                      _buildSignInLink(context),
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
      icon: Icons.person_add_outlined,
      title: 'Join TaskTap',
      subtitle: 'Create your account to get started',
    );
  }

  Widget _buildNameField(SignUpViewModel vm) {
    return CustomTextField(
      controller: vm.nameController,
      labelText: 'Full Name',
      prefixIcon: Icons.person_outlined,
    );
  }

  Widget _buildEmailField(SignUpViewModel vm) {
    return CustomTextField(
      controller: vm.emailController,
      labelText: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(SignUpViewModel vm) {
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

  Widget _buildConfirmPasswordField(SignUpViewModel vm) {
    return CustomTextField(
      controller: vm.confirmPasswordController,
      labelText: 'Confirm Password',
      prefixIcon: Icons.lock_outlined,
      obscureText: vm.obscureConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          vm.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: vm.toggleConfirmPasswordVisibility,
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, SignUpViewModel vm) {
    return CustomButton(
      text: vm.isLoading ? 'Creating Account...' : 'Sign Up',
      onPressed: vm.isLoading ? null : () => vm.signUpWithEmail(context),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, SignUpViewModel vm) {
    return GoogleSignInButton(
      onPressed: vm.isLoading ? null : () => vm.signUpWithGoogle(context),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: 'Sign In',
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

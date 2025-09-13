import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.grey),
        ),
        icon: Image.network(
          'https://developers.google.com/identity/images/g-logo.png',
          height: 20,
          width: 20,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
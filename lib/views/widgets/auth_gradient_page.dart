import 'package:flutter/material.dart';

class AuthGradientPage extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const AuthGradientPage({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.infinity, 55),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        buttonText,

        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        // Logo - Cerveau stylisé
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.psychology,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 56,
          ),
        ),
        const SizedBox(height: 24),
        // Titre
        Text(
          'CEREBRAL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        // Slogan
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Gestion intelligente de projets immobiliers',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF5B6478), fontSize: 16),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

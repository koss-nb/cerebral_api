import 'package:flutter/material.dart';

class TestCredentials extends StatelessWidget {
  const TestCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Identifiants de test :',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 8),
          _buildTestCredential(
            'admin@cerebral.com',
            'admin123',
            'Administrateur',
          ),
          _buildTestCredential(
            'manager@cerebral.com',
            'manager123',
            'Chef de Projet',
          ),
          _buildTestCredential(
            'chef@cerebral.com',
            'chef123',
            'Chef de Chantier',
          ),
          _buildTestCredential(
            'technicien@cerebral.com',
            'tech123',
            'Technicien',
          ),
          _buildTestCredential('user@cerebral.com', 'user123', 'Utilisateur'),
        ],
      ),
    );
  }

  Widget _buildTestCredential(String email, String password, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$role: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Color(0xFF6C757D),
            ),
          ),
          Expanded(
            child: Text(
              '$email / $password',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2549B2),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

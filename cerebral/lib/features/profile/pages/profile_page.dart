import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du profil
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  user?.initials ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Utilisateur',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.role ?? 'Rôle non défini',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: 'Modifier',
                onPressed: () {
                  // TODO: Implémenter la modification du profil
                },
                type: ButtonType.outline,
                icon: Icons.edit,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Informations du profil
          _buildProfileSection(
            title: 'Informations personnelles',
            children: [
              _buildProfileField('Prénom', user?.firstName ?? 'Non défini'),
              _buildProfileField('Nom', user?.lastName ?? 'Non défini'),
              _buildProfileField('Email', user?.email ?? 'Non défini'),
              _buildProfileField('Rôle', user?.role ?? 'Non défini'),
            ],
          ),

          const SizedBox(height: 24),

          // Permissions
          _buildProfileSection(
            title: 'Permissions',
            children: [_buildPermissionsList(user?.permissions ?? [])],
          ),

          const SizedBox(height: 24),

          // Statistiques
          _buildProfileSection(
            title: 'Statistiques',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Dernière connexion',
                      user?.lastLoginAt != null
                          ? '${user!.lastLoginAt!.day}/${user.lastLoginAt!.month}/${user.lastLoginAt!.year}'
                          : 'Jamais',
                      Icons.access_time,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Membre depuis',
                      user?.createdAt != null
                          ? '${user!.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                          : 'N/A',
                      Icons.calendar_today,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Actions
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Changer le mot de passe',
                  onPressed: () {
                    // TODO: Implémenter le changement de mot de passe
                  },
                  type: ButtonType.outline,
                  icon: Icons.lock,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Exporter les données',
                  onPressed: () {
                    // TODO: Implémenter l'export des données
                  },
                  type: ButtonType.secondary,
                  icon: Icons.download,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildPermissionsList(List<String> permissions) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: permissions.map((permission) {
        return Chip(
          label: Text(permission),
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

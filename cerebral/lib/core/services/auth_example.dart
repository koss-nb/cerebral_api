import 'package:flutter/material.dart';
import 'auth_service.dart';

/// Exemple d'utilisation de l'AuthService
/// Ce fichier montre comment utiliser tous les services d'authentification
class AuthServiceExample extends StatefulWidget {
  const AuthServiceExample({super.key});

  @override
  State<AuthServiceExample> createState() => _AuthServiceExampleState();
}

class _AuthServiceExampleState extends State<AuthServiceExample> {
  final AuthService _authService = AuthService();
  String _status = 'En attente...';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemple AuthService'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Statut actuel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statut de l\'authentification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Boutons d'action
            ElevatedButton(
              onPressed: _isLoading ? null : _checkAuthStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Vérifier le statut d\'authentification'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : _getCurrentUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Obtenir l\'utilisateur actuel'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : _checkPermissions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Vérifier les permissions'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Se déconnecter'),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Vérifier le statut d'authentification
  Future<void> _checkAuthStatus() async {
    setState(() {
      _isLoading = true;
      _status = 'Vérification en cours...';
    });

    try {
      final isAuthenticated = await _authService.isAuthenticated();
      final token = await _authService.getToken();

      setState(() {
        _status = 'Authentifié: $isAuthenticated\n'
            'Token: ${token != null ? 'Présent' : 'Absent'}';
      });
    } catch (e) {
      setState(() {
        _status = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Obtenir l'utilisateur actuel
  Future<void> _getCurrentUser() async {
    setState(() {
      _isLoading = true;
      _status = 'Récupération de l\'utilisateur...';
    });

    try {
      final user = await _authService.getCurrentUser();
      setState(() {
        _status = 'Utilisateur: ${user.toString()}';
      });
    } catch (e) {
      setState(() {
        _status = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Vérifier les permissions
  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
      _status = 'Vérification des permissions...';
    });

    try {
      final hasProjectPermission =
          await _authService.hasPermission('project.manage');
      final hasTaskPermission = await _authService.hasPermission('task.manage');
      final hasPersonnelPermission =
          await _authService.hasPermission('personnel.manage');
      final hasBudgetPermission =
          await _authService.hasPermission('budget.manage');

      setState(() {
        _status = 'Permissions:\n'
            '• Projets: $hasProjectPermission\n'
            '• Tâches: $hasTaskPermission\n'
            '• Personnel: $hasPersonnelPermission\n'
            '• Budget: $hasBudgetPermission';
      });
    } catch (e) {
      setState(() {
        _status = 'Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Se déconnecter
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
      _status = 'Déconnexion en cours...';
    });

    try {
      await _authService.logout();
      setState(() {
        _status = 'Déconnecté avec succès !';
      });
    } catch (e) {
      setState(() {
        _status = 'Erreur lors de la déconnexion: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

/// Exemple d'utilisation des méthodes d'inscription et de connexion
class AuthMethodsExample {
  final AuthService _authService = AuthService();

  // Exemple d'inscription
  Future<void> registerExample() async {
    try {
      final response = await _authService.register(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
        role: 'technicien',
        phone: '+33123456789',
        companyName: 'Entreprise ABC',
        companyType: 'construction',
        acceptTerms: true,
        acceptNewsletter: false,
      );

      print('Inscription réussie: ${response.toString()}');
    } catch (e) {
      print('Erreur d\'inscription: $e');
    }
  }

  // Exemple de connexion
  Future<void> loginExample() async {
    try {
      final response = await _authService.login(
        'john.doe@example.com',
        'password123',
      );

      print('Connexion réussie: ${response.toString()}');
    } catch (e) {
      print('Erreur de connexion: $e');
    }
  }

  // Exemple de vérification de rôle
  Future<void> checkRoleExample() async {
    try {
      final userRole = await _authService.getUserRole();
      final hasAdminRole = await _authService.hasRole('admin');
      final hasManagerRole = await _authService.hasRole('manager');

      print('Rôle utilisateur: $userRole');
      print('Est admin: $hasAdminRole');
      print('Est manager: $hasManagerRole');
    } catch (e) {
      print('Erreur de vérification de rôle: $e');
    }
  }

  // Exemple de vérification de permissions multiples
  Future<void> checkMultiplePermissionsExample() async {
    try {
      final hasAnyPermission = await _authService.hasAnyPermission([
        'project.manage',
        'task.manage',
        'personnel.manage',
      ]);

      print('A au moins une permission: $hasAnyPermission');
    } catch (e) {
      print('Erreur de vérification des permissions: $e');
    }
  }
}

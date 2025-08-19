import 'package:flutter/material.dart';
import 'lib/core/services/auth_service.dart';

void main() {
  runApp(const AdminInscriptionTest());
}

class AdminInscriptionTest extends StatelessWidget {
  const AdminInscriptionTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Inscription Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdminInscriptionTestPage(),
    );
  }
}

class AdminInscriptionTestPage extends StatefulWidget {
  const AdminInscriptionTestPage({super.key});

  @override
  State<AdminInscriptionTestPage> createState() =>
      _AdminInscriptionTestPageState();
}

class _AdminInscriptionTestPageState extends State<AdminInscriptionTestPage> {
  final AuthService _authService = AuthService();
  String _status = 'Prêt pour le test';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Inscription Administrateur'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Statut du test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statut du test',
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

            const SizedBox(height: 20),

            // Bouton de test d'inscription admin
            ElevatedButton(
              onPressed: _isLoading ? null : _testAdminInscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Test en cours...'),
                      ],
                    )
                  : const Text(
                      'Tester l\'inscription d\'un administrateur',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 16),

            // Informations sur le test
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1976D2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations du test',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Email: admin.test.1@cerebral.com\n'
                    '• Nom: Admin Test\n'
                    '• Rôle: admin\n'
                    '• Mot de passe: password123\n'
                    '• Téléphone: +1234567891\n'
                    '• Entreprise: CEREBRAL Test',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF9800)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Cliquez sur le bouton de test\n'
                    '2. Vérifiez la réponse de l\'API\n'
                    '3. Si l\'inscription réussit, testez la connexion\n'
                    '4. Vérifiez la redirection vers le dashboard admin',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Test d'inscription d'un administrateur
  Future<void> _testAdminInscription() async {
    setState(() {
      _isLoading = true;
      _status = '🔄 Test d\'inscription en cours...';
    });

    try {
      // Données de test pour un administrateur
      const firstName = 'Admin';
      const lastName = 'Test';
      const email = 'admin.test.1@cerebral.com';
      const password = 'password123';
      const passwordConfirmation = 'password123';
      const role = 'admin';
      const phone = '+1234567891';
      const companyName = 'CEREBRAL Test';
      const companyType = 'technology';
      const acceptTerms = true;
      const acceptNewsletter = false;

      _status = '📤 Envoi des données d\'inscription...\n'
          'Email: $email\n'
          'Rôle: $role';

      // Appel de l'API d'inscription
      final response = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        companyName: companyName,
        companyType: companyType,
        acceptTerms: acceptTerms,
        acceptNewsletter: acceptNewsletter,
      );

      // Analyse de la réponse
      if (response['success'] == true || response['token'] != null) {
        setState(() {
          _status = '✅ Inscription réussie !\n\n'
              '📋 Réponse de l\'API:\n'
              '${_formatResponse(response)}\n\n'
              '🎯 Prochaines étapes:\n'
              '1. Testez la connexion avec ces identifiants\n'
              '2. Vérifiez la redirection vers le dashboard admin';
        });
      } else {
        setState(() {
          _status = '⚠️ Inscription échouée\n\n'
              '📋 Réponse de l\'API:\n'
              '${_formatResponse(response)}\n\n'
              '🔍 Vérifiez les erreurs et réessayez';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Erreur lors du test:\n\n'
            '🔍 Détails de l\'erreur:\n'
            '$e\n\n'
            '💡 Vérifiez:\n'
            '• La connexion à l\'API Laravel\n'
            '• Les paramètres de l\'API\n'
            '• Les logs du serveur';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Formater la réponse de l'API pour l'affichage
  String _formatResponse(Map<String, dynamic> response) {
    final buffer = StringBuffer();

    response.forEach((key, value) {
      if (value != null) {
        if (value is Map) {
          buffer.writeln('  $key: ${value.toString()}');
        } else if (value is List) {
          buffer.writeln('  $key: ${value.toString()}');
        } else {
          buffer.writeln('  $key: $value');
        }
      }
    });

    return buffer.toString();
  }
}

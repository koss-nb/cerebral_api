import 'package:flutter/material.dart';
import 'package:cerebral/core/services/auth_service.dart';

void main() {
  runApp(const TestTechnicienApp());
}

class TestTechnicienApp extends StatelessWidget {
  const TestTechnicienApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Technicien Inscription',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const TestTechnicienPage(),
    );
  }
}

class TestTechnicienPage extends StatefulWidget {
  const TestTechnicienPage({super.key});

  @override
  State<TestTechnicienPage> createState() => _TestTechnicienPageState();
}

class _TestTechnicienPageState extends State<TestTechnicienPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _status = 'En attente...';
  Map<String, dynamic>? _response;

  Future<void> _testTechnicienRegistration() async {
    setState(() {
      _isLoading = true;
      _status = 'Inscription en cours...';
    });

    try {
      // Données de test pour un technicien
      final userData = {
        'first_name': 'Technicien',
        'last_name': 'Test',
        'email': 'technicien.test.1@cerebral.com',
        'password': 'password123',
        'password_confirmation': 'password123',
        'role': 'technicien',
        'phone': '+1234567894',
        'company_name': 'Cerebral Construction',
        'company_type': 'construction',
        'accept_terms': true,
        'accept_newsletter': false,
      };

      final response = await _authService.register(
        firstName: userData['first_name'] as String,
        lastName: userData['last_name'] as String,
        email: userData['email'] as String,
        password: userData['password'] as String,
        passwordConfirmation: userData['password_confirmation'] as String,
        role: userData['role'] as String,
        phone: userData['phone'] as String?,
        companyName: userData['company_name'] as String?,
        companyType: userData['company_type'] as String?,
        acceptTerms: userData['accept_terms'] as bool?,
        acceptNewsletter: userData['accept_newsletter'] as bool?,
      );

      setState(() {
        _status = 'Inscription réussie !';
        _response = response;
      });

      print('✅ Technicien créé avec succès: $response');
    } catch (e) {
      setState(() {
        _status = 'Erreur: $e';
      });
      print('❌ Erreur création technicien: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Inscription Technicien'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bouton de test
            ElevatedButton(
              onPressed: _isLoading ? null : _testTechnicienRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Créer un Technicien de Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),

            const SizedBox(height: 30),

            // Statut
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _status.contains('Erreur')
                    ? Colors.red[100]
                    : Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _status.contains('Erreur') ? Colors.red : Colors.green,
                ),
              ),
              child: Text(
                'Statut: $_status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _status.contains('Erreur')
                      ? Colors.red[800]
                      : Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Réponse API
            if (_response != null) ...[
              const Text(
                'Réponse API:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _response.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

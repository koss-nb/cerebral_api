import 'package:flutter/material.dart';
import 'package:cerebral/core/services/auth_service.dart';

void main() {
  runApp(const TestSupervisorApp());
}

class TestSupervisorApp extends StatelessWidget {
  const TestSupervisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Supervisor Inscription',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TestSupervisorPage(),
    );
  }
}

class TestSupervisorPage extends StatefulWidget {
  const TestSupervisorPage({super.key});

  @override
  State<TestSupervisorPage> createState() => _TestSupervisorPageState();
}

class _TestSupervisorPageState extends State<TestSupervisorPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _status = 'En attente...';
  Map<String, dynamic>? _response;

  Future<void> _testSupervisorRegistration() async {
    setState(() {
      _isLoading = true;
      _status = 'Inscription en cours...';
    });

    try {
      // Données de test pour un supervisor
      final userData = {
        'first_name': 'Supervisor',
        'last_name': 'Test',
        'email': 'supervisor.test.1@cerebral.com',
        'password': 'password123',
        'password_confirmation': 'password123',
        'role': 'chef',
        'phone': '+1234567892',
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

      print('✅ Supervisor créé avec succès: $response');
    } catch (e) {
      setState(() {
        _status = 'Erreur: $e';
      });
      print('❌ Erreur création supervisor: $e');
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
        title: const Text('Test Inscription Supervisor'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bouton de test
            ElevatedButton(
              onPressed: _isLoading ? null : _testSupervisorRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Créer un Supervisor de Test',
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

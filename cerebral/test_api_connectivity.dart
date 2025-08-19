import 'package:flutter/material.dart';
import 'lib/core/services/api_service.dart';

void main() {
  runApp(const ApiConnectivityTest());
}

class ApiConnectivityTest extends StatelessWidget {
  const ApiConnectivityTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Connectivité API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ApiConnectivityTestPage(),
    );
  }
}

class ApiConnectivityTestPage extends StatefulWidget {
  const ApiConnectivityTestPage({super.key});

  @override
  State<ApiConnectivityTestPage> createState() =>
      _ApiConnectivityTestPageState();
}

class _ApiConnectivityTestPageState extends State<ApiConnectivityTestPage> {
  final ApiService _apiService = ApiService.instance;
  String _status = 'Prêt pour le test de connectivité';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Connectivité API Laravel'),
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
                      'Statut de la connectivité',
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

            // Bouton de test de connectivité
            ElevatedButton(
              onPressed: _isLoading ? null : _testApiConnectivity,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
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
                      'Tester la connectivité avec l\'API Laravel',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 16),

            // Bouton de test de l'endpoint de santé
            ElevatedButton(
              onPressed: _isLoading ? null : _testHealthEndpoint,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tester l\'endpoint de santé (Health Check)',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Informations sur l'API
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
                    'Configuration de l\'API',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Base URL: Vérifiez dans api_service.dart\n'
                    '• Endpoint de test: /health\n'
                    '• Endpoint d\'inscription: /register\n'
                    '• Méthode: POST pour l\'inscription',
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
                    '1. Vérifiez que votre serveur Laravel est démarré\n'
                    '2. Testez d\'abord la connectivité générale\n'
                    '3. Testez l\'endpoint de santé\n'
                    '4. Si tout fonctionne, testez l\'inscription admin',
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

  // Test de connectivité générale avec l'API
  Future<void> _testApiConnectivity() async {
    setState(() {
      _isLoading = true;
      _status = '🔄 Test de connectivité en cours...';
    });

    try {
      // Test simple avec une requête GET
      final response = await _apiService.get('/health');

      setState(() {
        _status = '✅ Connectivité réussie !\n\n'
            '📋 Réponse de l\'API:\n'
            '${_formatResponse(response)}\n\n'
            '🎯 L\'API Laravel est accessible !';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Erreur de connectivité:\n\n'
            '🔍 Détails de l\'erreur:\n'
            '$e\n\n'
            '💡 Vérifiez:\n'
            '• Le serveur Laravel est-il démarré ?\n'
            '• L\'URL de base est-elle correcte ?\n'
            '• Y a-t-il des erreurs CORS ?\n'
            '• Le port est-il correct ?';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Test de l'endpoint de santé
  Future<void> _testHealthEndpoint() async {
    setState(() {
      _isLoading = true;
      _status = '🔄 Test de l\'endpoint de santé...';
    });

    try {
      // Test de l'endpoint de santé
      final response = await _apiService.get('/health');

      setState(() {
        _status = '✅ Endpoint de santé accessible !\n\n'
            '📋 Réponse de l\'API:\n'
            '${_formatResponse(response)}\n\n'
            '🎯 Le serveur Laravel fonctionne correctement !';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Erreur avec l\'endpoint de santé:\n\n'
            '🔍 Détails de l\'erreur:\n'
            '$e\n\n'
            '💡 Vérifiez:\n'
            '• L\'endpoint /health existe-t-il ?\n'
            '• Les routes sont-elles bien définies ?\n'
            '• Y a-t-il des erreurs dans les logs Laravel ?';
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

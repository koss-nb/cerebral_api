import 'package:flutter/material.dart';
import '../../core/services/api_test_service.dart';
import '../../core/config/api_config.dart';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final ApiTestService _testService = ApiTestService();
  Map<String, dynamic>? _testResults;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de l\'API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration de l'API
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuration de l\'API',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('URL de base: ${ApiConfig.baseUrl}'),
                    Text('Version: ${ApiConfig.version}'),
                    Text('Timeout: ${ApiConfig.connectionTimeout.inSeconds}s'),
                    Text('Mode debug: ${ApiConfig.enableDebugMode}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Boutons de test
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testConnection,
                    icon: const Icon(Icons.wifi),
                    label: const Text('Test Connexion'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testFullApi,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Test Complet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Indicateur de chargement
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Test en cours...'),
                  ],
                ),
              ),
            
            // Affichage des erreurs
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Résultats des tests
            if (_testResults != null) ...[
              const Text(
                'Résultats des tests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildTestResults(_testResults!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestResults(Map<String, dynamic> results) {
    return Column(
      children: results.entries.map((entry) {
        final testName = entry.key;
        final testResult = entry.value as Map<String, dynamic>;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      testResult['success'] == true
                          ? Icons.check_circle
                          : Icons.error,
                      color: testResult['success'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTestName(testName),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  testResult['message'] ?? 'Aucun message',
                  style: TextStyle(
                    color: testResult['success'] == true
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                if (testResult['statusCode'] != null)
                  Text('Status: ${testResult['statusCode']}'),
                if (testResult['data'] != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Données:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      testResult['data'].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                if (testResult['error'] != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Erreur:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      testResult['error'].toString(),
                      style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getTestName(String key) {
    switch (key) {
      case 'connection':
        return 'Test de Connexion';
      case 'authentication':
        return 'Test d\'Authentification';
      case 'dashboard_stats':
        return 'Test des Statistiques Dashboard';
      default:
        return key;
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _testResults = null;
    });

    try {
      final result = await _testService.testConnection();
      setState(() {
        _testResults = {'connection': result};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du test: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testFullApi() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _testResults = null;
    });

    try {
      final results = await _testService.runFullTest();
      setState(() {
        _testResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du test complet: $e';
        _isLoading = false;
      });
    }
  }
}

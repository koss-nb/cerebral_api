import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiTestService {
  static final ApiTestService _instance = ApiTestService._internal();
  factory ApiTestService() => _instance;
  ApiTestService._internal();

  // Test de connexion à l'API
  Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 Test de connexion à l\'API: ${ApiConfig.baseUrl}');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthEndpoint}'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.connectionTimeout);

      print('📡 Status code: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Connexion réussie',
          'data': data,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur de connexion',
          'statusCode': response.statusCode,
          'error': response.body,
        };
      }
    } catch (e) {
      print('❌ Erreur de test de connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
        'error': e.toString(),
      };
    }
  }

  // Test d'authentification
  Future<Map<String, dynamic>> testAuthentication(String email, String password) async {
    try {
      print('🔐 Test d\'authentification pour: $email');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      print('📡 Status code: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Authentification réussie',
          'data': data,
          'statusCode': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Échec de l\'authentification',
          'statusCode': response.statusCode,
          'error': data,
        };
      }
    } catch (e) {
      print('❌ Erreur de test d\'authentification: $e');
      return {
        'success': false,
        'message': 'Erreur d\'authentification: $e',
        'error': e.toString(),
      };
    }
  }

  // Test de récupération des statistiques du dashboard
  Future<Map<String, dynamic>> testDashboardStats(String token) async {
    try {
      print('📊 Test de récupération des statistiques du dashboard');
      
      final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
      headers['Authorization'] = 'Bearer $token';
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.dashboardStats}'),
        headers: headers,
      ).timeout(ApiConfig.connectionTimeout);

      print('📡 Status code: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Statistiques récupérées avec succès',
          'data': data,
          'statusCode': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Échec de récupération des statistiques',
          'statusCode': response.statusCode,
          'error': data,
        };
      }
    } catch (e) {
      print('❌ Erreur de test des statistiques: $e');
      return {
        'success': false,
        'message': 'Erreur de récupération des statistiques: $e',
        'error': e.toString(),
      };
    }
  }

  // Test complet de l'API
  Future<Map<String, dynamic>> runFullTest() async {
    print('🚀 Démarrage du test complet de l\'API');
    
    final results = <String, dynamic>{};
    
    // Test de connexion
    print('\n1️⃣ Test de connexion...');
    final connectionTest = await testConnection();
    results['connection'] = connectionTest;
    
    if (!connectionTest['success']) {
      print('❌ Test de connexion échoué');
      return results;
    }
    
    // Test d'authentification avec des identifiants de test
    print('\n2️⃣ Test d\'authentification...');
    final authTest = await testAuthentication('test@example.com', 'password');
    results['authentication'] = authTest;
    
    if (authTest['success'] && authTest['data']?['token'] != null) {
      // Test des statistiques du dashboard
      print('\n3️⃣ Test des statistiques du dashboard...');
      final statsTest = await testDashboardStats(authTest['data']['token']);
      results['dashboard_stats'] = statsTest;
    }
    
    print('\n✅ Test complet terminé');
    return results;
  }
}

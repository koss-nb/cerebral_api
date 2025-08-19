import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/material.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  final http.Client _client = http.Client();

  // Getters
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  // Configuration du token
  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  // Headers avec authentification
  Map<String, String> get _headers {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Gestion des erreurs
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final error = json.decode(response.body);
      throw ApiException(
        message: error['message'] ?? 'Une erreur est survenue',
        statusCode: response.statusCode,
      );
    }
  }

  // AUTHENTIFICATION
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: _headers,
        body: json.encode(LoginRequest(email: email, password: password).toJson()),
      ).timeout(ApiConfig.timeout);

      _handleError(response);
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        final loginResponse = LoginResponse.fromJson(data);
        setToken(loginResponse.token);
        return loginResponse;
      } else {
        throw ApiException(message: data['message'] ?? 'Échec de la connexion');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur de connexion: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
        headers: _headers,
      ).timeout(ApiConfig.timeout);
      
      clearToken();
    } catch (e) {
      // Même en cas d'erreur, on efface le token local
      clearToken();
      throw ApiException(message: 'Erreur lors de la déconnexion: $e');
    }
  }

  // PROJETS
  Future<List<Project>> getProjects({String? search, int page = 1}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': ApiConfig.defaultPageSize.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.projects}').replace(queryParameters: queryParams);
      
      final response = await _client.get(uri, headers: _headers).timeout(ApiConfig.timeout);
      _handleError(response);
      
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((json) => Project.fromJson(json)).toList();
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors de la récupération des projets');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors de la récupération des projets: $e');
    }
  }

  // TÂCHES
  Future<List<Task>> getTasks({String? search, int page = 1}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': ApiConfig.defaultPageSize.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasks}').replace(queryParameters: queryParams);
      
      final response = await _client.get(uri, headers: _headers).timeout(ApiConfig.timeout);
      _handleError(response);
      
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((json) => Task.fromJson(json)).toList();
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors de la récupération des tâches');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors de la récupération des tâches: $e');
    }
  }

  // MATÉRIAUX
  Future<List<Material>> getMaterials({String? search, int page = 1}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': ApiConfig.defaultPageSize.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.materials}').replace(queryParameters: queryParams);
      
      final response = await _client.get(uri, headers: _headers).timeout(ApiConfig.timeout);
      _handleError(response);
      
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data']['data'] as List).map((json) => Material.fromJson(json)).toList();
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors de la récupération des matériaux');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors de la récupération des matériaux: $e');
    }
  }

  // DASHBOARD
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.dashboardStats}'),
        headers: _headers,
      ).timeout(ApiConfig.timeout);

      _handleError(response);
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors de la récupération des statistiques');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors de la récupération des statistiques: $e');
    }
  }

  // POINTAGE
  Future<Map<String, dynamic>> clockIn({
    required int userId,
    required int projectId,
    String? location,
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.clockIn}'),
        headers: _headers,
        body: json.encode({
          'user_id': userId,
          'project_id': projectId,
          'location': location,
          'notes': notes,
        }),
      ).timeout(ApiConfig.timeout);

      _handleError(response);
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors du pointage d\'arrivée');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors du pointage d\'arrivée: $e');
    }
  }

  Future<Map<String, dynamic>> clockOut({
    required int userId,
    required int projectId,
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.clockOut}'),
        headers: _headers,
        body: json.encode({
          'user_id': userId,
          'project_id': projectId,
          'notes': notes,
        }),
      ).timeout(ApiConfig.timeout);

      _handleError(response);
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors du pointage de départ');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors du pointage de départ: $e');
    }
  }

  // PROBLÈMES
  Future<Map<String, dynamic>> createIssue({
    required String title,
    required String description,
    required String priority,
    required String type,
    int? projectId,
    int? taskId,
    String? location,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.issues}'),
        headers: _headers,
        body: json.encode({
          'title': title,
          'description': description,
          'priority': priority,
          'type': type,
          'project_id': projectId,
          'task_id': taskId,
          'location': location,
        }),
      ).timeout(ApiConfig.timeout);

      _handleError(response);
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw ApiException(message: data['message'] ?? 'Erreur lors de la création du problème');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erreur lors de la création du problème: $e');
    }
  }

  // SANTÉ DE L'API
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.health}'),
        headers: _headers,
      ).timeout(ApiConfig.timeout);

      return json.decode(response.body);
    } catch (e) {
      throw ApiException(message: 'Erreur lors de la vérification de la santé de l\'API: $e');
    }
  }
}

// Exception personnalisée pour l'API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

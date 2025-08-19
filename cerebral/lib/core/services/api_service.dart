import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static const String tokenKey = 'auth_token';

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  ApiService._();

  // Headers avec token d'authentification
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erreur de connexion: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('🚀 POST vers: ${ApiConfig.baseUrl}$endpoint');
      print('🚀 Données: $data');
      print('🚀 Taille des données: ${jsonEncode(data).length} bytes');

      final headers = await _getHeaders();
      print('🚀 Headers: $headers');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      print('🔍 Status code: ${response.statusCode}');
      print('🔍 Headers de réponse: ${response.headers}');
      print('🔍 Corps de réponse: ${response.body}');
      print('🔍 URL complète: ${ApiConfig.baseUrl}$endpoint');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erreur POST: $e');
      print('❌ Type d\'erreur: ${e.runtimeType}');
      throw ApiException('Erreur de connexion: $e');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erreur de connexion: $e');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erreur de connexion: $e');
    }
  }

  // Gestion de la réponse
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Non autorisé');
    } else if (response.statusCode == 403) {
      throw ForbiddenException('Accès interdit');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Ressource non trouvée');
    } else if (response.statusCode == 422) {
      throw ValidationException('Erreur de validation', body['errors']);
    } else {
      throw ApiException('Erreur serveur: ${response.statusCode}', body);
    }
  }

  // Sauvegarder le token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Récupérer le token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Supprimer le token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Créer une requête multipart pour l'upload de fichiers
  Future<http.MultipartRequest> createMultipartRequest(
    String endpoint,
    Map<String, String> fields,
    Map<String, File> files,
  ) async {
    final headers = await _getHeaders();
    // Retirer Content-Type pour permettre au navigateur de le définir automatiquement
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
    );

    // Ajouter les headers
    request.headers.addAll(headers);

    // Ajouter les champs texte
    request.fields.addAll(fields);

    // Ajouter les fichiers
    for (final entry in files.entries) {
      final fieldName = entry.key;
      final file = entry.value;

      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      final multipartFile = http.MultipartFile(
        fieldName,
        stream,
        length,
        filename: file.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    return request;
  }

  // Parser une réponse JSON
  Map<String, dynamic> parseJsonResponse(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (e) {
      throw ApiException('Erreur de parsing JSON: $e');
    }
  }
}

// Exceptions personnalisées
class ApiException implements Exception {
  final String message;
  final dynamic data;

  ApiException(this.message, [this.data]);

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;

  ValidationException(String message, this.errors) : super(message);
}

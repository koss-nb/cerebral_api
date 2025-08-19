import 'dart:convert';
import 'dart:io';
import 'api_service.dart';
import '../config/api_config.dart';

class TechnicienService {
  final ApiService _apiService = ApiService.instance;

  // Méthode utilitaire pour convertir les réponses en List<Map<String, dynamic>>
  List<Map<String, dynamic>> _parseListResponse(dynamic response) {
    if (response is List) {
      final List<Map<String, dynamic>> result = [];
      for (var item in response) {
        if (item is Map<String, dynamic>) {
          result.add(item);
        }
      }
      return result;
    } else if (response is Map && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        final List<Map<String, dynamic>> result = [];
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            result.add(item);
          }
        }
        return result;
      }
    }
    return [];
  }

  // Dashboard et statistiques
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      return await _apiService.get(ApiConfig.technicienDashboard);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      return await _apiService.get(ApiConfig.technicienStats);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPerformance() async {
    try {
      return await _apiService.get(ApiConfig.technicienPerformance);
    } catch (e) {
      rethrow;
    }
  }

  // Tâches
  Future<List<Map<String, dynamic>>> getAssignedTasks() async {
    try {
      final response = await _apiService.get(ApiConfig.assignedTasks);
      print('🔍 getAssignedTasks response: $response');
      return _parseListResponse(response);
    } catch (e) {
      print('❌ Erreur getAssignedTasks: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAssignedProjects() async {
    try {
      final response =
          await _apiService.get(ApiConfig.technicienAssignedProjects);
      print('🔍 getAssignedProjects response: $response');
      return _parseListResponse(response);
    } catch (e) {
      print('❌ Erreur getAssignedProjects: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedTasks() async {
    try {
      final response =
          await _apiService.get(ApiConfig.technicienCompletedTasks);
      print('🔍 getCompletedTasks response: $response');
      return _parseListResponse(response);
    } catch (e) {
      print('❌ Erreur getCompletedTasks: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentTasks() async {
    try {
      final response = await _apiService.get(ApiConfig.technicienCurrentTasks);
      print('🔍 getCurrentTasks response: $response');
      return _parseListResponse(response);
    } catch (e) {
      print('❌ Erreur getCurrentTasks: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUrgentTasks() async {
    try {
      final response = await _apiService.get(ApiConfig.technicienUrgentTasks);
      print('🔍 getUrgentTasks response: $response');
      return _parseListResponse(response);
    } catch (e) {
      print('❌ Erreur getUrgentTasks: $e');
      rethrow;
    }
  }

  // Actions sur les tâches
  Future<Map<String, dynamic>> completeTask(
      String taskId, Map<String, dynamic> completionData) async {
    try {
      return await _apiService.post(
          '/technicien/tasks/$taskId/complete', completionData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateTask(
      String taskId, Map<String, dynamic> validationData) async {
    try {
      return await _apiService.post(
          '/technicien/tasks/$taskId/validate', validationData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reportIssue(
      String taskId, Map<String, dynamic> issueData) async {
    try {
      return await _apiService.post(
          '/technicien/tasks/$taskId/report-issue', issueData);
    } catch (e) {
      rethrow;
    }
  }

  // Pointage (Clock-in/Clock-out)
  Future<Map<String, dynamic>> clockIn(Map<String, dynamic> clockInData) async {
    try {
      return await _apiService.post(ApiConfig.technicienClockIn, clockInData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> clockOut(
      Map<String, dynamic> clockOutData) async {
    try {
      return await _apiService.post(ApiConfig.technicienClockOut, clockOutData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTimeSheet() async {
    try {
      return await _apiService.get(ApiConfig.technicienTimeSheet);
    } catch (e) {
      rethrow;
    }
  }

  // Documents
  Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final response = await _apiService.get(ApiConfig.technicienDocuments);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadDocument(
      Map<String, String> documentData, Map<String, File> fileData) async {
    try {
      // Créer une requête multipart pour l'upload
      final request = await _apiService.createMultipartRequest(
        ApiConfig.technicienUploadDocument,
        documentData,
        fileData,
      );

      final streamedResponse = await request.send();
      final response = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        return Map<String, dynamic>.from(jsonDecode(response));
      } else {
        throw ApiException(
            'Erreur lors de l\'upload: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> downloadDocument(String documentId) async {
    try {
      return await _apiService.get('/technicien/documents/$documentId');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires
  Future<Map<String, dynamic>> getCurrentStatus() async {
    try {
      final response = await _apiService.get('/time-tracking/current');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    try {
      final response = await _apiService.get('/time-tracking/history');
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Méthode pour charger toutes les données du dashboard en une fois
  Future<Map<String, dynamic>> loadDashboardData() async {
    print('🔍 TechnicienService: Début du chargement des données du dashboard');
    try {
      print('🔍 TechnicienService: Appel de toutes les APIs...');
      final results = await Future.wait([
        getDashboard(),
        getStats(),
        getPerformance(),
        getAssignedTasks(),
        getAssignedProjects(),
        getCurrentTasks(),
        getUrgentTasks(),
        getCompletedTasks(),
        getTimeSheet(),
        getDocuments(),
        getCurrentStatus(),
        getRecentActivities(),
      ]);

      print('✅ TechnicienService: Toutes les APIs ont répondu');
      print('📊 TechnicienService: Résultats:');
      print('  - Dashboard: ${results[0]}');
      print('  - Stats: ${results[1]}');
      print('  - Performance: ${results[2]}');
      print('  - Tâches assignées: ${(results[3] as List?)?.length ?? 0}');
      print('  - Projets assignés: ${(results[4] as List?)?.length ?? 0}');
      print('  - Tâches actuelles: ${(results[5] as List?)?.length ?? 0}');
      print('  - Tâches urgentes: ${(results[6] as List?)?.length ?? 0}');
      print('  - Tâches terminées: ${(results[7] as List?)?.length ?? 0}');
      print('  - Timesheet: ${results[8]}');
      print('  - Documents: ${(results[9] as List?)?.length ?? 0}');
      print('  - Statut actuel: ${results[10]}');
      print('  - Activités récentes: ${(results[11] as List?)?.length ?? 0}');

      final dashboardData = {
        'dashboard': results[0],
        'stats': results[1],
        'performance': results[2],
        'assignedTasks': results[3],
        'assignedProjects': results[4],
        'currentTasks': results[5],
        'urgentTasks': results[6],
        'completedTasks': results[7],
        'timeSheet': results[8],
        'documents': results[9],
        'currentStatus': results[10],
        'recentActivities': results[11],
      };

      print(
          '✅ TechnicienService: Données du dashboard préparées: $dashboardData');
      return dashboardData;
    } catch (e) {
      print('❌ TechnicienService: Erreur lors du chargement des données: $e');
      rethrow;
    }
  }
}

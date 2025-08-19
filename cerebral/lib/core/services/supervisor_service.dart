import 'dart:convert';
import 'dart:io';
import 'api_service.dart';
import '../config/api_config.dart';

class SupervisorService {
  final ApiService _apiService = ApiService.instance;

  // Dashboard et statistiques
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      return await _apiService.get(ApiConfig.supervisorDashboard);
    } catch (e) {
      rethrow;
    }
  }

  // Équipes supervisées
  Future<List<Map<String, dynamic>>> getMyTeams() async {
    try {
      final response = await _apiService.get(ApiConfig.myTeams);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Projets supervisés
  Future<List<Map<String, dynamic>>> getSupervisedProjects() async {
    try {
      final response = await _apiService.get(ApiConfig.supervisorSupervisedProjects);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Rapports de supervision
  Future<List<Map<String, dynamic>>> getSupervisionReports() async {
    try {
      final response = await _apiService.get(ApiConfig.supervisorSupervisionReports);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Contrôles qualité
  Future<List<Map<String, dynamic>>> getQualityChecks() async {
    try {
      final response = await _apiService.get(ApiConfig.qualityChecks);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> approveQualityCheck(String checkId, Map<String, dynamic> approvalData) async {
    try {
      return await _apiService.post('${ApiConfig.supervisorApproveQualityCheck}/$checkId/approve', approvalData);
    } catch (e) {
      rethrow;
    }
  }

  // Incidents
  Future<List<Map<String, dynamic>>> getIncidents() async {
    try {
      final response = await _apiService.get(ApiConfig.supervisorIncidents);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resolveIncident(Map<String, dynamic> resolutionData) async {
    try {
      return await _apiService.post(ApiConfig.supervisorResolveIncident, resolutionData);
    } catch (e) {
      rethrow;
    }
  }

  // Revue technique
  Future<Map<String, dynamic>> technicalReview(String taskId, Map<String, dynamic> reviewData) async {
    try {
      return await _apiService.post('${ApiConfig.supervisorTechnicalReview}/$taskId', reviewData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTechnicalIssues() async {
    try {
      final response = await _apiService.get(ApiConfig.supervisorTechnicalIssues);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Escalade
  Future<Map<String, dynamic>> escalateIssue(Map<String, dynamic> escalationData) async {
    try {
      return await _apiService.post(ApiConfig.supervisorEscalateIssue, escalationData);
    } catch (e) {
      rethrow;
    }
  }

  // Approbations finales
  Future<Map<String, dynamic>> finalApproval(String projectId, Map<String, dynamic> approvalData) async {
    try {
      return await _apiService.post('${ApiConfig.supervisorFinalApproval}/$projectId', approvalData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPendingApprovals() async {
    try {
      final response = await _apiService.get(ApiConfig.supervisorPendingApprovals);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Rapports spécialisés
  Future<Map<String, dynamic>> getTechnicalPerformanceReport() async {
    try {
      return await _apiService.get(ApiConfig.supervisorTechnicalPerformanceReport);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getQualityMetricsReport() async {
    try {
      return await _apiService.get(ApiConfig.supervisorQualityMetricsReport);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getEscalationsReport() async {
    try {
      return await _apiService.get(ApiConfig.supervisorEscalationsReport);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires
  Future<Map<String, dynamic>> getTeamDetails(String teamId) async {
    try {
      return await _apiService.get('/personnel/department/$teamId');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProjectDetails(String projectId) async {
    try {
      return await _apiService.get('/projects/$projectId');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTaskDetails(String taskId) async {
    try {
      return await _apiService.get('/tasks/$taskId');
    } catch (e) {
      rethrow;
    }
  }

  // Méthode pour charger toutes les données du dashboard en une fois
  Future<Map<String, dynamic>> loadDashboardData() async {
    try {
      final results = await Future.wait([
        getDashboard(),
        getMyTeams(),
        getSupervisedProjects(),
        getSupervisionReports(),
        getQualityChecks(),
        getIncidents(),
        getTechnicalIssues(),
        getPendingApprovals(),
      ]);

      return {
        'dashboard': results[0],
        'myTeams': results[1],
        'supervisedProjects': results[2],
        'supervisionReports': results[3],
        'qualityChecks': results[4],
        'incidents': results[5],
        'technicalIssues': results[6],
        'pendingApprovals': results[7],
      };
    } catch (e) {
      rethrow;
    }
  }
}

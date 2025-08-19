import 'dart:convert';
import 'dart:io';
import 'api_service.dart';
import '../config/api_config.dart';

class ManagerService {
  final ApiService _apiService = ApiService.instance;

  // Dashboard et statistiques
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      return await _apiService.get(ApiConfig.managerDashboard);
    } catch (e) {
      rethrow;
    }
  }

  // Équipe
  Future<List<Map<String, dynamic>>> getMyTeam() async {
    try {
      final response = await _apiService.get(ApiConfig.myTeam);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTeamPerformance() async {
    try {
      return await _apiService.get(ApiConfig.teamPerformance);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTeamTasks() async {
    try {
      final response = await _apiService.get(ApiConfig.managerTeamTasks);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTeamWorkload() async {
    try {
      return await _apiService.get(ApiConfig.managerTeamWorkload);
    } catch (e) {
      rethrow;
    }
  }

  // Projets gérés
  Future<List<Map<String, dynamic>>> getMyManagedProjects() async {
    try {
      final response = await _apiService.get(ApiConfig.managerManagedProjects);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Budgets
  Future<List<Map<String, dynamic>>> getMyBudgets() async {
    try {
      final response = await _apiService.get(ApiConfig.managerBudgets);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Gestion des tâches
  Future<Map<String, dynamic>> assignTask(
      Map<String, dynamic> assignmentData) async {
    try {
      return await _apiService.post(
          ApiConfig.managerAssignTask, assignmentData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reassignTask(
      Map<String, dynamic> reassignmentData) async {
    try {
      return await _apiService.put(
          ApiConfig.managerReassignTask, reassignmentData);
    } catch (e) {
      rethrow;
    }
  }

  // Approbations
  Future<Map<String, dynamic>> approveTask(
      String taskId, Map<String, dynamic> approvalData) async {
    try {
      return await _apiService.post(
          '${ApiConfig.managerApproveTask}/$taskId', approvalData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> approveBudget(
      String budgetId, Map<String, dynamic> approvalData) async {
    try {
      return await _apiService.post(
          '${ApiConfig.managerApproveBudget}/$budgetId', approvalData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> approveTimesheet(
      Map<String, dynamic> timesheetData) async {
    try {
      return await _apiService.post(
          ApiConfig.managerApproveTimesheet, timesheetData);
    } catch (e) {
      rethrow;
    }
  }

  // Rapports
  Future<Map<String, dynamic>> getProductivityReport() async {
    try {
      return await _apiService.get(ApiConfig.managerProductivityReport);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBudgetVarianceReport() async {
    try {
      return await _apiService.get(ApiConfig.managerBudgetVarianceReport);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTimelineReport() async {
    try {
      return await _apiService.get(ApiConfig.managerTimelineReport);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTeamReports() async {
    try {
      final response = await _apiService.get(ApiConfig.managerTeamReports);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires
  Future<Map<String, dynamic>> getTeamMemberDetails(String memberId) async {
    try {
      return await _apiService.get('/personnel/$memberId');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateTeamMember(
      String memberId, Map<String, dynamic> updateData) async {
    try {
      return await _apiService.put('/personnel/$memberId', updateData);
    } catch (e) {
      rethrow;
    }
  }

  // Méthode pour charger toutes les données du dashboard en une fois
  Future<Map<String, dynamic>> loadDashboardData() async {
    try {
      final results = await Future.wait([
        getDashboard(),
        getMyTeam(),
        getTeamPerformance(),
        getTeamTasks(),
        getTeamWorkload(),
        getMyManagedProjects(),
        getMyBudgets(),
        getTeamReports(),
      ]);

      return {
        'dashboard': results[0],
        'myTeam': results[1],
        'teamPerformance': results[2],
        'teamTasks': results[3],
        'teamWorkload': results[4],
        'myManagedProjects': results[5],
        'myBudgets': results[6],
        'teamReports': results[7],
      };
    } catch (e) {
      rethrow;
    }
  }
}

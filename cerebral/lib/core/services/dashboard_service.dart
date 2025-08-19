import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir les statistiques complètes du tableau de bord
  Future<Map<String, dynamic>> getStats() async {
    try {
      return await _apiService.get('/dashboard/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données pour les graphiques
  Future<Map<String, dynamic>> getChartData() async {
    try {
      return await _apiService.get('/dashboard/chart-data');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les actions rapides disponibles
  Future<Map<String, dynamic>> getQuickActions() async {
    try {
      return await _apiService.get('/dashboard/quick-actions');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des projets pour le tableau de bord
  Future<Map<String, dynamic>> getProjects() async {
    try {
      return await _apiService.get('/dashboard/projects');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des tâches pour le tableau de bord
  Future<Map<String, dynamic>> getTasks() async {
    try {
      return await _apiService.get('/dashboard/tasks');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données du personnel pour le tableau de bord
  Future<Map<String, dynamic>> getPersonnel() async {
    try {
      return await _apiService.get('/dashboard/personnel');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des budgets pour le tableau de bord
  Future<Map<String, dynamic>> getBudgets() async {
    try {
      return await _apiService.get('/dashboard/budgets');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des workflows pour le tableau de bord
  Future<Map<String, dynamic>> getWorkflows() async {
    try {
      return await _apiService.get('/dashboard/workflows');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des notifications pour le tableau de bord
  Future<Map<String, dynamic>> getNotifications() async {
    try {
      return await _apiService.get('/dashboard/notifications');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données des rapports pour le tableau de bord
  Future<Map<String, dynamic>> getReports() async {
    try {
      return await _apiService.get('/dashboard/reports');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les mises à jour en temps réel
  Future<Map<String, dynamic>> getRealTimeUpdates() async {
    try {
      return await _apiService.get('/dashboard/real-time-updates');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les alertes et avertissements
  Future<Map<String, dynamic>> getAlerts() async {
    try {
      return await _apiService.get('/dashboard/alerts');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la distribution de la charge de travail
  Future<Map<String, dynamic>> getWorkloadDistribution() async {
    try {
      return await _apiService.get('/dashboard/workload-distribution');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les analyses de performance des projets
  Future<Map<String, dynamic>> getProjectAnalytics() async {
    try {
      return await _apiService.get('/dashboard/project-analytics');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les métriques d'efficacité des tâches
  Future<Map<String, dynamic>> getTaskEfficiency() async {
    try {
      return await _apiService.get('/dashboard/task-efficiency');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'analyse et la prévision des budgets
  Future<Map<String, dynamic>> getBudgetAnalysis() async {
    try {
      return await _apiService.get('/dashboard/budget-analysis');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données de la chronologie des projets pour les graphiques
  Future<Map<String, dynamic>> getProjectTimelineData() async {
    try {
      final chartData = await getChartData();
      return chartData['data']['project_timeline'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la distribution des statuts des tâches pour les graphiques
  Future<Map<String, dynamic>> getTaskStatusDistribution() async {
    try {
      final chartData = await getChartData();
      return chartData['data']['task_status_distribution'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tendances des budgets pour les graphiques
  Future<Map<String, dynamic>> getBudgetTrends() async {
    try {
      final chartData = await getChartData();
      return chartData['data']['budget_trends'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données de performance du personnel pour les graphiques
  Future<Map<String, dynamic>> getPersonnelPerformanceData() async {
    try {
      final chartData = await getChartData();
      return chartData['data']['personnel_performance'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les données d'activité mensuelle pour les graphiques
  Future<Map<String, dynamic>> getMonthlyActivityData() async {
    try {
      final chartData = await getChartData();
      return chartData['data']['monthly_activity'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques de performance
  Future<Map<String, dynamic>> getPerformanceStats() async {
    try {
      final stats = await getStats();
      return stats['data']['performance'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des projets
  Future<Map<String, dynamic>> getProjectStats() async {
    try {
      final stats = await getStats();
      return stats['data']['projects'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des tâches
  Future<Map<String, dynamic>> getTaskStats() async {
    try {
      final stats = await getStats();
      return stats['data']['tasks'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques du personnel
  Future<Map<String, dynamic>> getPersonnelStats() async {
    try {
      final stats = await getStats();
      return stats['data']['personnel'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des budgets
  Future<Map<String, dynamic>> getBudgetStats() async {
    try {
      final stats = await getStats();
      return stats['data']['budgets'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des workflows
  Future<Map<String, dynamic>> getWorkflowStats() async {
    try {
      final stats = await getStats();
      return stats['data']['workflows'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des notifications
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final stats = await getStats();
      return stats['data']['notifications'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques d'aperçu général
  Future<Map<String, dynamic>> getOverviewStats() async {
    try {
      final stats = await getStats();
      return stats['data']['overview'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les rapports des projets
  Future<Map<String, dynamic>> getProjectReports() async {
    try {
      final reports = await getReports();
      return reports['data']['project_reports'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les rapports des tâches
  Future<Map<String, dynamic>> getTaskReports() async {
    try {
      final reports = await getReports();
      return reports['data']['task_reports'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les rapports des budgets
  Future<Map<String, dynamic>> getBudgetReports() async {
    try {
      final reports = await getReports();
      return reports['data']['budget_reports'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les rapports du personnel
  Future<Map<String, dynamic>> getPersonnelReports() async {
    try {
      final reports = await getReports();
      return reports['data']['personnel_reports'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les métriques de performance système
  Future<Map<String, dynamic>> getSystemPerformanceMetrics() async {
    try {
      final realTimeUpdates = await getRealTimeUpdates();
      return realTimeUpdates['data']['performance_metrics'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les activités récentes
  Future<Map<String, dynamic>> getRecentActivities() async {
    try {
      final realTimeUpdates = await getRealTimeUpdates();
      return realTimeUpdates['data']['recent_activities'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les alertes système
  Future<Map<String, dynamic>> getSystemAlerts() async {
    try {
      final realTimeUpdates = await getRealTimeUpdates();
      return realTimeUpdates['data']['system_alerts'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le nombre d'utilisateurs actifs
  Future<int> getActiveUsersCount() async {
    try {
      final realTimeUpdates = await getRealTimeUpdates();
      return realTimeUpdates['data']['active_users'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tendances de completion des projets
  Future<Map<String, dynamic>> getProjectCompletionTrends() async {
    try {
      final projectAnalytics = await getProjectAnalytics();
      return projectAnalytics['data']['completion_trends'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la performance des projets par manager
  Future<Map<String, dynamic>> getProjectPerformanceByManager() async {
    try {
      final projectAnalytics = await getProjectAnalytics();
      return projectAnalytics['data']['performance_by_manager'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'analyse de variance des budgets
  Future<Map<String, dynamic>> getBudgetVariance() async {
    try {
      final projectAnalytics = await getProjectAnalytics();
      return projectAnalytics['data']['budget_variance'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'efficacité des délais
  Future<Map<String, dynamic>> getTimelineEfficiency() async {
    try {
      final projectAnalytics = await getProjectAnalytics();
      return projectAnalytics['data']['timeline_efficiency'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les métriques de qualité
  Future<Map<String, dynamic>> getQualityMetrics() async {
    try {
      final projectAnalytics = await getProjectAnalytics();
      return projectAnalytics['data']['quality_metrics'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'analyse du temps de completion des tâches
  Future<Map<String, dynamic>> getTaskCompletionTime() async {
    try {
      final taskEfficiency = await getTaskEfficiency();
      return taskEfficiency['data']['completion_time'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la distribution des priorités des tâches
  Future<Map<String, dynamic>> getTaskPriorityDistribution() async {
    try {
      final taskEfficiency = await getTaskEfficiency();
      return taskEfficiency['data']['priority_distribution'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la performance des assignés
  Future<Map<String, dynamic>> getAssigneePerformance() async {
    try {
      final taskEfficiency = await getTaskEfficiency();
      return taskEfficiency['data']['assignee_performance'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le ratio des tâches par projet
  Future<Map<String, dynamic>> getProjectTaskRatio() async {
    try {
      final taskEfficiency = await getTaskEfficiency();
      return taskEfficiency['data']['project_task_ratio'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tendances de dépenses
  Future<Map<String, dynamic>> getSpendingTrends() async {
    try {
      final budgetAnalysis = await getBudgetAnalysis();
      return budgetAnalysis['data']['spending_trends'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'analyse des catégories de budget
  Future<Map<String, dynamic>> getBudgetCategoryAnalysis() async {
    try {
      final budgetAnalysis = await getBudgetAnalysis();
      return budgetAnalysis['data']['category_analysis'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'efficacité d'approbation des budgets
  Future<Map<String, dynamic>> getBudgetApprovalEfficiency() async {
    try {
      final budgetAnalysis = await getBudgetAnalysis();
      return budgetAnalysis['data']['approval_efficiency'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la prévision des budgets
  Future<Map<String, dynamic>> getBudgetForecasting() async {
    try {
      final budgetAnalysis = await getBudgetAnalysis();
      return budgetAnalysis['data']['forecasting'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // ===== DASHBOARDS SPÉCIALISÉS PAR RÔLE =====

  // Dashboard Technicien - Utilise les APIs existantes
  Future<Map<String, dynamic>> getTechnicienDashboard() async {
    try {
      // Utilise les APIs existantes pour construire le dashboard technicien
      final results = await Future.wait([
        getStats(),
        getTasks(),
        getProjects(),
        getPersonnel(),
        getNotifications(),
      ]);

      return {
        'data': {
          'stats': results[0]['data'] ?? {},
          'tasks': results[1]['data'] ?? [],
          'projects': results[2]['data'] ?? [],
          'personnel': results[3]['data'] ?? [],
          'notifications': results[4]['data'] ?? [],
        }
      };
    } catch (e) {
      rethrow;
    }
  }

  // Dashboard Manager - Utilise les APIs existantes
  Future<Map<String, dynamic>> getManagerDashboard() async {
    try {
      final results = await Future.wait([
        getStats(),
        getProjects(),
        getPersonnel(),
        getBudgets(),
        getNotifications(),
      ]);

      return {
        'data': {
          'stats': results[0]['data'] ?? {},
          'projects': results[1]['data'] ?? [],
          'personnel': results[2]['data'] ?? [],
          'budgets': results[3]['data'] ?? [],
          'notifications': results[4]['data'] ?? [],
        }
      };
    } catch (e) {
      rethrow;
    }
  }

  // Dashboard Supervisor - Utilise les APIs existantes
  Future<Map<String, dynamic>> getSupervisorDashboard() async {
    try {
      final results = await Future.wait([
        getStats(),
        getProjects(),
        getPersonnel(),
        getReports(),
        getNotifications(),
      ]);

      return {
        'data': {
          'stats': results[0]['data'] ?? {},
          'projects': results[1]['data'] ?? [],
          'personnel': results[2]['data'] ?? [],
          'reports': results[3]['data'] ?? [],
          'notifications': results[4]['data'] ?? [],
        }
      };
    } catch (e) {
      rethrow;
    }
  }

  // ===== DONNÉES SPÉCIALISÉES PAR RÔLE =====

  // Données pour le dashboard technicien
  Future<Map<String, dynamic>> getTechnicienStats() async {
    try {
      final stats = await getStats();
      return stats['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Tâches assignées au technicien - Utilise l'API existante
  Future<List<Map<String, dynamic>>> getTechnicienTasks() async {
    try {
      // Utilise l'API my-tasks qui existe déjà
      final response = await _apiService.get('/tasks/my-tasks');
      final allTasks = List<Map<String, dynamic>>.from(response['data'] ?? []);
      return allTasks.take(5).toList(); // Retourne les 5 premières tâches
    } catch (e) {
      // Fallback vers l'API générale si my-tasks échoue
      try {
        final tasks = await getTasks();
        final allTasks = List<Map<String, dynamic>>.from(tasks['data'] ?? []);
        return allTasks.take(5).toList();
      } catch (e2) {
        rethrow;
      }
    }
  }

  // Projets du technicien - Utilise l'API existante
  Future<List<Map<String, dynamic>>> getTechnicienProjects() async {
    try {
      final projects = await getProjects();
      final allProjects = List<Map<String, dynamic>>.from(projects['data'] ?? []);
      return allProjects.take(3).toList(); // Retourne les 3 premiers projets
    } catch (e) {
      rethrow;
    }
  }

  // Performance du technicien - Utilise les stats existantes
  Future<Map<String, dynamic>> getTechnicienPerformance() async {
    try {
      final stats = await getStats();
      return stats['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Données pour le dashboard manager
  Future<Map<String, dynamic>> getManagerStats() async {
    try {
      final stats = await getStats();
      return stats['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Équipe du manager - Utilise l'API personnel existante
  Future<List<Map<String, dynamic>>> getManagerTeam() async {
    try {
      final personnel = await getPersonnel();
      final allPersonnel = List<Map<String, dynamic>>.from(personnel['data'] ?? []);
      return allPersonnel.take(10).toList(); // Retourne les 10 premiers
    } catch (e) {
      rethrow;
    }
  }

  // Projets du manager - Utilise l'API projets existante
  Future<List<Map<String, dynamic>>> getManagerProjects() async {
    try {
      final projects = await getProjects();
      final allProjects = List<Map<String, dynamic>>.from(projects['data'] ?? []);
      return allProjects.take(5).toList(); // Retourne les 5 premiers projets
    } catch (e) {
      rethrow;
    }
  }

  // Budgets du manager - Utilise l'API budgets existante
  Future<Map<String, dynamic>> getManagerBudgets() async {
    try {
      final budgets = await getBudgets();
      return budgets['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Données pour le dashboard supervisor
  Future<Map<String, dynamic>> getSupervisorStats() async {
    try {
      final stats = await getStats();
      return stats['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // Équipes du supervisor - Utilise l'API personnel existante
  Future<List<Map<String, dynamic>>> getSupervisorTeams() async {
    try {
      final personnel = await getPersonnel();
      final allPersonnel = List<Map<String, dynamic>>.from(personnel['data'] ?? []);
      return allPersonnel.take(15).toList(); // Retourne les 15 premiers
    } catch (e) {
      rethrow;
    }
  }

  // Projets du supervisor - Utilise l'API projets existante
  Future<List<Map<String, dynamic>>> getSupervisorProjects() async {
    try {
      final projects = await getProjects();
      final allProjects = List<Map<String, dynamic>>.from(projects['data'] ?? []);
      return allProjects.take(8).toList(); // Retourne les 8 premiers projets
    } catch (e) {
      rethrow;
    }
  }

  // Rapports du supervisor - Utilise l'API rapports existante
  Future<Map<String, dynamic>> getSupervisorReports() async {
    try {
      final reports = await getReports();
      return reports['data'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  // ===== MÉTRIQUES SPÉCIALISÉES =====

  // Activités récentes - Utilise l'API notifications existante
  Future<List<Map<String, dynamic>>> getRoleRecentActivities(String role) async {
    try {
      final notifications = await getNotifications();
      final allNotifications = List<Map<String, dynamic>>.from(notifications['data'] ?? []);
      return allNotifications.take(10).toList(); // Retourne les 10 dernières notifications
    } catch (e) {
      rethrow;
    }
  }

  // Notifications par rôle - Utilise l'API notifications existante
  Future<List<Map<String, dynamic>>> getRoleNotifications(String role) async {
    try {
      final notifications = await getNotifications();
      final allNotifications = List<Map<String, dynamic>>.from(notifications['data'] ?? []);
      return allNotifications.take(5).toList(); // Retourne les 5 dernières notifications
    } catch (e) {
      rethrow;
    }
  }
}

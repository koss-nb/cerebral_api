import 'api_service.dart';

class ReportService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir le rapport de vue d'ensemble du tableau de bord
  Future<Map<String, dynamic>> getDashboardReport() async {
    try {
      return await _apiService.get('/reports/dashboard');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le rapport de performance des projets
  Future<Map<String, dynamic>> getProjectPerformanceReport({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (dateFrom != null) {
        queryParams['date_from'] = dateFrom.toIso8601String();
      }
      
      if (dateTo != null) {
        queryParams['date_to'] = dateTo.toIso8601String();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/reports/project-performance$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le rapport d'efficacité des tâches
  Future<Map<String, dynamic>> getTaskEfficiencyReport({
    int? projectId,
    DateTime? dateFrom,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (dateFrom != null) {
        queryParams['date_from'] = dateFrom.toIso8601String();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/reports/task-efficiency$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le rapport d'analyse budgétaire
  Future<Map<String, dynamic>> getBudgetAnalysisReport({
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (dateFrom != null) {
        queryParams['date_from'] = dateFrom.toIso8601String();
      }
      
      if (dateTo != null) {
        queryParams['date_to'] = dateTo.toIso8601String();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/reports/budget-analysis$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le rapport de productivité des utilisateurs
  Future<Map<String, dynamic>> getUserProductivityReport() async {
    try {
      return await _apiService.get('/reports/user-productivity');
    } catch (e) {
      rethrow;
    }
  }

  // Exporter les données de rapport
  Future<Map<String, dynamic>> exportReport({
    required String reportType,
    String format = 'json',
    Map<String, dynamic>? filters,
  }) async {
    try {
      final data = <String, dynamic>{
        'type': reportType,
        'format': format,
      };

      if (filters != null) {
        data.addAll(filters);
      }

      return await _apiService.post('/reports/export', data);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour analyser les rapports

  // Obtenir les statistiques du tableau de bord
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final dashboardReport = await getDashboardReport();
      
      if (dashboardReport['success'] == true) {
        return dashboardReport['data'];
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir le nombre total de projets
  Future<int> getTotalProjects() async {
    try {
      final stats = await getDashboardStats();
      return stats['projects']?['total'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de projets actifs
  Future<int> getActiveProjects() async {
    try {
      final stats = await getDashboardStats();
      return stats['projects']?['active'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de projets terminés
  Future<int> getCompletedProjects() async {
    try {
      final stats = await getDashboardStats();
      return stats['projects']?['completed'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de projets en retard
  Future<int> getOverdueProjects() async {
    try {
      final stats = await getDashboardStats();
      return stats['projects']?['overdue'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre total de tâches
  Future<int> getTotalTasks() async {
    try {
      final stats = await getDashboardStats();
      return stats['tasks']?['total'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de tâches en attente
  Future<int> getPendingTasks() async {
    try {
      final stats = await getDashboardStats();
      return stats['tasks']?['pending'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de tâches en cours
  Future<int> getInProgressTasks() async {
    try {
      final stats = await getDashboardStats();
      return stats['tasks']?['in_progress'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de tâches terminées
  Future<int> getCompletedTasks() async {
    try {
      final stats = await getDashboardStats();
      return stats['tasks']?['completed'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de tâches en retard
  Future<int> getOverdueTasks() async {
    try {
      final stats = await getDashboardStats();
      return stats['tasks']?['overdue'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le revenu total
  Future<double> getTotalIncome() async {
    try {
      final stats = await getDashboardStats();
      return (stats['budget']?['total_income'] ?? 0).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir les dépenses totales
  Future<double> getTotalExpenses() async {
    try {
      final stats = await getDashboardStats();
      return (stats['budget']?['total_expenses'] ?? 0).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir le budget net
  Future<double> getNetBudget() async {
    try {
      final stats = await getDashboardStats();
      return (stats['budget']?['net_budget'] ?? 0).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir le nombre total d'utilisateurs
  Future<int> getTotalUsers() async {
    try {
      final stats = await getDashboardStats();
      return stats['users']?['total'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre d'utilisateurs actifs
  Future<int> getActiveUsers() async {
    try {
      final stats = await getDashboardStats();
      return stats['users']?['active'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le taux de progression des projets
  Future<double> getProjectProgressRate() async {
    try {
      final totalProjects = await getTotalProjects();
      final completedProjects = await getCompletedProjects();
      
      if (totalProjects > 0) {
        return (completedProjects / totalProjects) * 100;
      }
      
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir le taux de progression des tâches
  Future<double> getTaskProgressRate() async {
    try {
      final totalTasks = await getTotalTasks();
      final completedTasks = await getCompletedTasks();
      
      if (totalTasks > 0) {
        return (completedTasks / totalTasks) * 100;
      }
      
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir le taux d'utilisation des utilisateurs
  Future<double> getUserUtilizationRate() async {
    try {
      final totalUsers = await getTotalUsers();
      final activeUsers = await getActiveUsers();
      
      if (totalUsers > 0) {
        return (activeUsers / totalUsers) * 100;
      }
      
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir les projets par performance
  Future<List<Map<String, dynamic>>> getProjectsByPerformance({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final report = await getProjectPerformanceReport(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      if (report['success'] == true) {
        return List<Map<String, dynamic>>.from(report['data']);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les projets les plus performants
  Future<List<Map<String, dynamic>>> getTopPerformingProjects({
    DateTime? dateFrom,
    DateTime? dateTo,
    int limit = 10,
  }) async {
    try {
      final projects = await getProjectsByPerformance(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      // Trier par taux de complétion
      projects.sort((a, b) {
        final aRate = (a['completion_rate'] ?? 0).toDouble();
        final bRate = (b['completion_rate'] ?? 0).toDouble();
        return bRate.compareTo(aRate);
      });
      
      return projects.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir les projets en retard
  Future<List<Map<String, dynamic>>> getOverdueProjectsList({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final projects = await getProjectsByPerformance(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      return projects.where((project) {
        return project['is_overdue'] == true;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir les tâches par efficacité
  Future<List<Map<String, dynamic>>> getTasksByEfficiency({
    int? projectId,
    DateTime? dateFrom,
  }) async {
    try {
      final report = await getTaskEfficiencyReport(
        projectId: projectId,
        dateFrom: dateFrom,
      );
      
      if (report['success'] == true) {
        return List<Map<String, dynamic>>.from(report['data']);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les tâches les plus efficaces
  Future<List<Map<String, dynamic>>> getMostEfficientTasks({
    int? projectId,
    DateTime? dateFrom,
    int limit = 10,
  }) async {
    try {
      final tasks = await getTasksByEfficiency(
        projectId: projectId,
        dateFrom: dateFrom,
      );
      
      // Trier par efficacité
      tasks.sort((a, b) {
        final aEfficiency = (a['efficiency'] ?? 0).toDouble();
        final bEfficiency = (b['efficiency'] ?? 0).toDouble();
        return bEfficiency.compareTo(aEfficiency);
      });
      
      return tasks.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir les tâches en retard
  Future<List<Map<String, dynamic>>> getOverdueTasksList({
    int? projectId,
    DateTime? dateFrom,
  }) async {
    try {
      final tasks = await getTasksByEfficiency(
        projectId: projectId,
        dateFrom: dateFrom,
      );
      
      return tasks.where((task) {
        return task['is_overdue'] == true;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir l'analyse budgétaire
  Future<Map<String, dynamic>> getBudgetAnalysis({
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final report = await getBudgetAnalysisReport(
        projectId: projectId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      if (report['success'] == true) {
        return report['data'];
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir le résumé budgétaire
  Future<Map<String, dynamic>> getBudgetSummary({
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final analysis = await getBudgetAnalysis(
        projectId: projectId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      return analysis['summary'] ?? {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir l'analyse budgétaire par catégorie
  Future<Map<String, dynamic>> getBudgetByCategory({
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final analysis = await getBudgetAnalysis(
        projectId: projectId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      return analysis['by_category'] ?? {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir l'analyse budgétaire par mois
  Future<Map<String, dynamic>> getBudgetByMonth({
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final analysis = await getBudgetAnalysis(
        projectId: projectId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      
      return analysis['by_month'] ?? {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir la productivité des utilisateurs
  Future<List<Map<String, dynamic>>> getUsersProductivity() async {
    try {
      final report = await getUserProductivityReport();
      
      if (report['success'] == true) {
        return List<Map<String, dynamic>>.from(report['data']);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les utilisateurs les plus productifs
  Future<List<Map<String, dynamic>>> getMostProductiveUsers({int limit = 10}) async {
    try {
      final users = await getUsersProductivity();
      
      // Trier par score de productivité
      users.sort((a, b) {
        final aScore = (a['productivity_score'] ?? 0).toDouble();
        final bScore = (b['productivity_score'] ?? 0).toDouble();
        return bScore.compareTo(aScore);
      });
      
      return users.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir les utilisateurs par taux de complétion
  Future<List<Map<String, dynamic>>> getUsersByCompletionRate({int limit = 10}) async {
    try {
      final users = await getUsersProductivity();
      
      // Trier par taux de complétion
      users.sort((a, b) {
        final aRate = (a['completion_rate'] ?? 0).toDouble();
        final bRate = (b['completion_rate'] ?? 0).toDouble();
        return bRate.compareTo(aRate);
      });
      
      return users.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtenir les utilisateurs avec le plus de tâches en retard
  Future<List<Map<String, dynamic>>> getUsersWithOverdueTasks({int limit = 10}) async {
    try {
      final users = await getUsersProductivity();
      
      // Trier par nombre de tâches en retard
      users.sort((a, b) {
        final aOverdue = (a['overdue_tasks'] ?? 0);
        final bOverdue = (b['overdue_tasks'] ?? 0);
        return bOverdue.compareTo(aOverdue);
      });
      
      return users.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  // Exporter le rapport du tableau de bord
  Future<Map<String, dynamic>> exportDashboardReport({
    String format = 'json',
    Map<String, dynamic>? filters,
  }) async {
    try {
      return await exportReport(
        reportType: 'dashboard',
        format: format,
        filters: filters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Exporter le rapport de performance des projets
  Future<Map<String, dynamic>> exportProjectPerformanceReport({
    String format = 'json',
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final filters = <String, dynamic>{};
      
      if (dateFrom != null) {
        filters['date_from'] = dateFrom.toIso8601String();
      }
      
      if (dateTo != null) {
        filters['date_to'] = dateTo.toIso8601String();
      }

      return await exportReport(
        reportType: 'project_performance',
        format: format,
        filters: filters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Exporter le rapport d'efficacité des tâches
  Future<Map<String, dynamic>> exportTaskEfficiencyReport({
    String format = 'json',
    int? projectId,
    DateTime? dateFrom,
  }) async {
    try {
      final filters = <String, dynamic>{};
      
      if (projectId != null) {
        filters['project_id'] = projectId;
      }
      
      if (dateFrom != null) {
        filters['date_from'] = dateFrom.toIso8601String();
      }

      return await exportReport(
        reportType: 'task_efficiency',
        format: format,
        filters: filters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Exporter le rapport d'analyse budgétaire
  Future<Map<String, dynamic>> exportBudgetAnalysisReport({
    String format = 'json',
    int? projectId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final filters = <String, dynamic>{};
      
      if (projectId != null) {
        filters['project_id'] = projectId;
      }
      
      if (dateFrom != null) {
        filters['date_from'] = dateFrom.toIso8601String();
      }
      
      if (dateTo != null) {
        filters['date_to'] = dateTo.toIso8601String();
      }

      return await exportReport(
        reportType: 'budget_analysis',
        format: format,
        filters: filters,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Exporter le rapport de productivité des utilisateurs
  Future<Map<String, dynamic>> exportUserProductivityReport({
    String format = 'json',
  }) async {
    try {
      return await exportReport(
        reportType: 'user_productivity',
        format: format,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un rapport personnalisé
  Future<Map<String, dynamic>> getCustomReport({
    required String reportType,
    Map<String, dynamic>? filters,
  }) async {
    try {
      switch (reportType) {
        case 'dashboard':
          return await getDashboardReport();
        case 'project_performance':
          return await getProjectPerformanceReport(
            dateFrom: filters?['date_from'] != null 
                ? DateTime.parse(filters!['date_from']) 
                : null,
            dateTo: filters?['date_to'] != null 
                ? DateTime.parse(filters!['date_to']) 
                : null,
          );
        case 'task_efficiency':
          return await getTaskEfficiencyReport(
            projectId: filters?['project_id'],
            dateFrom: filters?['date_from'] != null 
                ? DateTime.parse(filters!['date_from']) 
                : null,
          );
        case 'budget_analysis':
          return await getBudgetAnalysisReport(
            projectId: filters?['project_id'],
            dateFrom: filters?['date_from'] != null 
                ? DateTime.parse(filters!['date_from']) 
                : null,
            dateTo: filters?['date_to'] != null 
                ? DateTime.parse(filters!['date_to']) 
                : null,
          );
        case 'user_productivity':
          return await getUserProductivityReport();
        default:
          throw ArgumentError('Type de rapport invalide: $reportType');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un rapport avec export automatique
  Future<Map<String, dynamic>> getReportWithExport({
    required String reportType,
    Map<String, dynamic>? filters,
    String format = 'json',
  }) async {
    try {
      // Obtenir le rapport
      final report = await getCustomReport(
        reportType: reportType,
        filters: filters,
      );
      
      // Exporter le rapport
      final export = await exportReport(
        reportType: reportType,
        format: format,
        filters: filters,
      );
      
      return {
        'report': report,
        'export': export,
        'summary': {
          'report_type': reportType,
          'format': format,
          'export_date': DateTime.now().toIso8601String(),
          'filters_applied': filters ?? {},
        },
      };
    } catch (e) {
      rethrow;
    }
  }
}

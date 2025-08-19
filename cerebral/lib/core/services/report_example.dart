import 'report_service.dart';

/// Exemple d'utilisation complète du service rapport
/// Basé sur le ReportController Laravel avec toutes les fonctionnalités avancées
class ReportExample {
  final ReportService _reportService = ReportService();

  /// Exemple d'obtention du rapport de vue d'ensemble du tableau de bord
  Future<void> getDashboardReportExample() async {
    try {
      print(
          '📊 Récupération du rapport de vue d\'ensemble du tableau de bord...');

      final dashboardReport = await _reportService.getDashboardReport();

      print('✅ Rapport du tableau de bord récupéré avec succès !');

      print('\n🏗️ STATISTIQUES DES PROJETS:');
      print('   Total: ${dashboardReport['data']['projects']['total']}');
      print('   Actifs: ${dashboardReport['data']['projects']['active']}');
      print('   Terminés: ${dashboardReport['data']['projects']['completed']}');
      print('   En retard: ${dashboardReport['data']['projects']['overdue']}');

      print('\n📋 STATISTIQUES DES TÂCHES:');
      print('   Total: ${dashboardReport['data']['tasks']['total']}');
      print('   En attente: ${dashboardReport['data']['tasks']['pending']}');
      print('   En cours: ${dashboardReport['data']['tasks']['in_progress']}');
      print('   Terminées: ${dashboardReport['data']['tasks']['completed']}');
      print('   En retard: ${dashboardReport['data']['tasks']['overdue']}');

      print('\n💰 STATISTIQUES BUDGÉTAIRES:');
      print(
          '   Revenu total: ${dashboardReport['data']['budget']['total_income']}€');
      print(
          '   Dépenses totales: ${dashboardReport['data']['budget']['total_expenses']}€');
      print(
          '   Budget net: ${dashboardReport['data']['budget']['net_budget']}€');

      print('\n👥 STATISTIQUES DES UTILISATEURS:');
      print('   Total: ${dashboardReport['data']['users']['total']}');
      print('   Actifs: ${dashboardReport['data']['users']['active']}');
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération du rapport du tableau de bord: $e');
    }
  }

  /// Exemple d'obtention des statistiques du tableau de bord
  Future<void> getDashboardStatsExample() async {
    try {
      print('📈 Récupération des statistiques du tableau de bord...');

      final stats = await _reportService.getDashboardStats();

      print('✅ Statistiques du tableau de bord récupérées avec succès !');

      print('\n📊 STATISTIQUES DÉTAILLÉES:');
      print('   Projets: ${stats['projects']}');
      print('   Tâches: ${stats['tasks']}');
      print('   Budget: ${stats['budget']}');
      print('   Utilisateurs: ${stats['users']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple d'obtention des métriques individuelles
  Future<void> getIndividualMetricsExample() async {
    try {
      print('🔍 Récupération des métriques individuelles...');

      // Métriques des projets
      final totalProjects = await _reportService.getTotalProjects();
      final activeProjects = await _reportService.getActiveProjects();
      final completedProjects = await _reportService.getCompletedProjects();
      final overdueProjects = await _reportService.getOverdueProjects();

      print('\n🏗️ MÉTRIQUES DES PROJETS:');
      print('   Total: $totalProjects');
      print('   Actifs: $activeProjects');
      print('   Terminés: $completedProjects');
      print('   En retard: $overdueProjects');

      // Métriques des tâches
      final totalTasks = await _reportService.getTotalTasks();
      final pendingTasks = await _reportService.getPendingTasks();
      final inProgressTasks = await _reportService.getInProgressTasks();
      final completedTasks = await _reportService.getCompletedTasks();
      final overdueTasks = await _reportService.getOverdueTasks();

      print('\n📋 MÉTRIQUES DES TÂCHES:');
      print('   Total: $totalTasks');
      print('   En attente: $pendingTasks');
      print('   En cours: $inProgressTasks');
      print('   Terminées: $completedTasks');
      print('   En retard: $overdueTasks');

      // Métriques budgétaires
      final totalIncome = await _reportService.getTotalIncome();
      final totalExpenses = await _reportService.getTotalExpenses();
      final netBudget = await _reportService.getNetBudget();

      print('\n💰 MÉTRIQUES BUDGÉTAIRES:');
      print('   Revenu total: ${totalIncome.toStringAsFixed(2)}€');
      print('   Dépenses totales: ${totalExpenses.toStringAsFixed(2)}€');
      print('   Budget net: ${netBudget.toStringAsFixed(2)}€');

      // Métriques des utilisateurs
      final totalUsers = await _reportService.getTotalUsers();
      final activeUsers = await _reportService.getActiveUsers();

      print('\n👥 MÉTRIQUES DES UTILISATEURS:');
      print('   Total: $totalUsers');
      print('   Actifs: $activeUsers');
    } catch (e) {
      print('❌ Erreur lors de la récupération des métriques individuelles: $e');
    }
  }

  /// Exemple d'obtention des taux de progression
  Future<void> getProgressRatesExample() async {
    try {
      print('📈 Récupération des taux de progression...');

      final projectProgressRate = await _reportService.getProjectProgressRate();
      final taskProgressRate = await _reportService.getTaskProgressRate();
      final userUtilizationRate = await _reportService.getUserUtilizationRate();

      print('✅ Taux de progression récupérés avec succès !');

      print('\n📊 TAUX DE PROGRESSION:');
      print('   Projets: ${projectProgressRate.toStringAsFixed(2)}%');
      print('   Tâches: ${taskProgressRate.toStringAsFixed(2)}%');
      print(
          '   Utilisation des utilisateurs: ${userUtilizationRate.toStringAsFixed(2)}%');
    } catch (e) {
      print('❌ Erreur lors de la récupération des taux de progression: $e');
    }
  }

  /// Exemple d'obtention du rapport de performance des projets
  Future<void> getProjectPerformanceReportExample() async {
    try {
      print('🏗️ Récupération du rapport de performance des projets...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final projectReport = await _reportService.getProjectPerformanceReport(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Rapport de performance des projets récupéré avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de projets: ${projectReport['data'].length}');

      print('\n🏗️ PERFORMANCE DES PROJETS:');
      for (final project in projectReport['data'].take(5)) {
        print('   • ${project['name']}');
        print('     Manager: ${project['manager']}');
        print('     Progrès: ${project['progress']}%');
        print('     Tâches totales: ${project['total_tasks']}');
        print('     Tâches terminées: ${project['completed_tasks']}');
        print(
            '     Taux de complétion: ${project['completion_rate'].toStringAsFixed(2)}%');
        print('     En retard: ${project['is_overdue'] ? 'Oui' : 'Non'}');
        print(
            '     Utilisation du budget: ${project['budget_utilization'].toStringAsFixed(2)}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport de performance: $e');
    }
  }

  /// Exemple d'obtention des projets par performance
  Future<void> getProjectsByPerformanceExample() async {
    try {
      print('🏆 Récupération des projets par performance...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final projects = await _reportService.getProjectsByPerformance(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Projets par performance récupérés avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de projets: ${projects.length}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets par performance: $e');
    }
  }

  /// Exemple d'obtention des projets les plus performants
  Future<void> getTopPerformingProjectsExample() async {
    try {
      print('🥇 Récupération des projets les plus performants...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final topProjects = await _reportService.getTopPerformingProjects(
        dateFrom: startDate,
        dateTo: endDate,
        limit: 5,
      );

      print('✅ Projets les plus performants récupérés avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de projets: ${topProjects.length}');

      print('\n🥇 TOP 5 DES PROJETS:');
      for (int i = 0; i < topProjects.length; i++) {
        final project = topProjects[i];
        print('   ${i + 1}. ${project['name']}');
        print(
            '      Taux de complétion: ${project['completion_rate'].toStringAsFixed(2)}%');
        print('      Manager: ${project['manager']}');
        print('      Progrès: ${project['progress']}%');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des projets les plus performants: $e');
    }
  }

  /// Exemple d'obtention des projets en retard
  Future<void> getOverdueProjectsListExample() async {
    try {
      print('⏰ Récupération des projets en retard...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final overdueProjects = await _reportService.getOverdueProjectsList(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Projets en retard récupérés avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de projets en retard: ${overdueProjects.length}');

      if (overdueProjects.isNotEmpty) {
        print('\n⏰ PROJETS EN RETARD:');
        for (final project in overdueProjects) {
          print('   • ${project['name']}');
          print('     Manager: ${project['manager']}');
          print('     Progrès: ${project['progress']}%');
          print('     Date de fin: ${project['end_date']}');
          print('');
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets en retard: $e');
    }
  }

  /// Exemple d'obtention du rapport d'efficacité des tâches
  Future<void> getTaskEfficiencyReportExample() async {
    try {
      print('📋 Récupération du rapport d\'efficacité des tâches...');

      final startDate = DateTime(2024, 1, 1);

      final taskReport = await _reportService.getTaskEfficiencyReport(
        dateFrom: startDate,
      );

      print('✅ Rapport d\'efficacité des tâches récupéré avec succès !');
      print('   Date de début: ${startDate.toIso8601String()}');
      print('   Nombre de tâches: ${taskReport['data'].length}');

      print('\n📋 EFFICACITÉ DES TÂCHES:');
      for (final task in taskReport['data'].take(5)) {
        print('   • ${task['title']}');
        print('     Projet: ${task['project']}');
        print('     Assignée à: ${task['assigned_to']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print(
            '     Heures estimées: ${task['estimated_hours'] ?? 'Non définies'}');
        print('     Heures réelles: ${task['actual_hours'] ?? 'Non définies'}');
        print('     Efficacité: ${task['efficiency']}%');
        print('     Date d\'échéance: ${task['due_date'] ?? 'Non définie'}');
        print('     En retard: ${task['is_overdue'] ? 'Oui' : 'Non'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport d\'efficacité: $e');
    }
  }

  /// Exemple d'obtention des tâches par efficacité
  Future<void> getTasksByEfficiencyExample() async {
    try {
      print('📊 Récupération des tâches par efficacité...');

      final startDate = DateTime(2024, 1, 1);

      final tasks = await _reportService.getTasksByEfficiency(
        dateFrom: startDate,
      );

      print('✅ Tâches par efficacité récupérées avec succès !');
      print('   Date de début: ${startDate.toIso8601String()}');
      print('   Nombre de tâches: ${tasks.length}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches par efficacité: $e');
    }
  }

  /// Exemple d'obtention des tâches les plus efficaces
  Future<void> getMostEfficientTasksExample() async {
    try {
      print('🚀 Récupération des tâches les plus efficaces...');

      final startDate = DateTime(2024, 1, 1);

      final efficientTasks = await _reportService.getMostEfficientTasks(
        dateFrom: startDate,
        limit: 5,
      );

      print('✅ Tâches les plus efficaces récupérées avec succès !');
      print('   Date de début: ${startDate.toIso8601String()}');
      print('   Nombre de tâches: ${efficientTasks.length}');

      print('\n🚀 TOP 5 DES TÂCHES EFFICACES:');
      for (int i = 0; i < efficientTasks.length; i++) {
        final task = efficientTasks[i];
        print('   ${i + 1}. ${task['title']}');
        print('      Efficacité: ${task['efficiency']}%');
        print('      Projet: ${task['project']}');
        print('      Assignée à: ${task['assigned_to']}');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des tâches les plus efficaces: $e');
    }
  }

  /// Exemple d'obtention des tâches en retard
  Future<void> getOverdueTasksListExample() async {
    try {
      print('⏰ Récupération des tâches en retard...');

      final startDate = DateTime(2024, 1, 1);

      final overdueTasks = await _reportService.getOverdueTasksList(
        dateFrom: startDate,
      );

      print('✅ Tâches en retard récupérées avec succès !');
      print('   Date de début: ${startDate.toIso8601String()}');
      print('   Nombre de tâches en retard: ${overdueTasks.length}');

      if (overdueTasks.isNotEmpty) {
        print('\n⏰ TÂCHES EN RETARD:');
        for (final task in overdueTasks) {
          print('   • ${task['title']}');
          print('     Projet: ${task['project']}');
          print('     Assignée à: ${task['assigned_to']}');
          print('     Date d\'échéance: ${task['due_date']}');
          print('');
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches en retard: $e');
    }
  }

  /// Exemple d'obtention du rapport d'analyse budgétaire
  Future<void> getBudgetAnalysisReportExample() async {
    try {
      print('💰 Récupération du rapport d\'analyse budgétaire...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final budgetReport = await _reportService.getBudgetAnalysisReport(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Rapport d\'analyse budgétaire récupéré avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');

      print('\n💰 RÉSUMÉ BUDGÉTAIRE:');
      final summary = budgetReport['data']['summary'];
      print('   Revenu total: ${summary['total_income']}€');
      print('   Dépenses totales: ${summary['total_expenses']}€');
      print('   Budget net: ${summary['net_budget']}€');
      print('   Total des transactions: ${summary['total_transactions']}');

      print('\n🏷️ ANALYSE PAR CATÉGORIE:');
      final byCategory = budgetReport['data']['by_category'];
      for (final entry in byCategory.entries) {
        print('   • ${entry.key}:');
        print('     Revenus: ${entry.value['income']}€');
        print('     Dépenses: ${entry.value['expenses']}€');
        print('     Net: ${entry.value['net']}€');
      }

      print('\n📅 ANALYSE PAR MOIS:');
      final byMonth = budgetReport['data']['by_month'];
      for (final entry in byMonth.entries) {
        print('   • ${entry.key}:');
        print('     Revenus: ${entry.value['income']}€');
        print('     Dépenses: ${entry.value['expenses']}€');
        print('     Net: ${entry.value['net']}€');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport budgétaire: $e');
    }
  }

  /// Exemple d'obtention de l'analyse budgétaire
  Future<void> getBudgetAnalysisExample() async {
    try {
      print('📊 Récupération de l\'analyse budgétaire...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final analysis = await _reportService.getBudgetAnalysis(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Analyse budgétaire récupérée avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');

      print('\n📊 ANALYSE COMPLÈTE:');
      print('   Résumé: ${analysis['summary']}');
      print('   Par catégorie: ${analysis['by_category']}');
      print('   Par mois: ${analysis['by_month']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'analyse budgétaire: $e');
    }
  }

  /// Exemple d'obtention du résumé budgétaire
  Future<void> getBudgetSummaryExample() async {
    try {
      print('💡 Récupération du résumé budgétaire...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final summary = await _reportService.getBudgetSummary(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Résumé budgétaire récupéré avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');

      print('\n💡 RÉSUMÉ:');
      print('   Revenu total: ${summary['total_income']}€');
      print('   Dépenses totales: ${summary['total_expenses']}€');
      print('   Budget net: ${summary['net_budget']}€');
      print('   Total des transactions: ${summary['total_transactions']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération du résumé budgétaire: $e');
    }
  }

  /// Exemple d'obtention de l'analyse budgétaire par catégorie
  Future<void> getBudgetByCategoryExample() async {
    try {
      print('🏷️ Récupération de l\'analyse budgétaire par catégorie...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final byCategory = await _reportService.getBudgetByCategory(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Analyse budgétaire par catégorie récupérée avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');

      print('\n🏷️ ANALYSE PAR CATÉGORIE:');
      for (final entry in byCategory.entries) {
        print('   • ${entry.key}:');
        print('     Revenus: ${entry.value['income']}€');
        print('     Dépenses: ${entry.value['expenses']}€');
        print('     Net: ${entry.value['net']}€');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'analyse par catégorie: $e');
    }
  }

  /// Exemple d'obtention de l'analyse budgétaire par mois
  Future<void> getBudgetByMonthExample() async {
    try {
      print('📅 Récupération de l\'analyse budgétaire par mois...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      final byMonth = await _reportService.getBudgetByMonth(
        dateFrom: startDate,
        dateTo: endDate,
      );

      print('✅ Analyse budgétaire par mois récupérée avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');

      print('\n📅 ANALYSE PAR MOIS:');
      for (final entry in byMonth.entries) {
        print('   • ${entry.key}:');
        print('     Revenus: ${entry.value['income']}€');
        print('     Dépenses: ${entry.value['expenses']}€');
        print('     Net: ${entry.value['net']}€');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'analyse par mois: $e');
    }
  }

  /// Exemple d'obtention du rapport de productivité des utilisateurs
  Future<void> getUserProductivityReportExample() async {
    try {
      print('👥 Récupération du rapport de productivité des utilisateurs...');

      final userReport = await _reportService.getUserProductivityReport();

      print(
          '✅ Rapport de productivité des utilisateurs récupéré avec succès !');
      print('   Nombre d\'utilisateurs: ${userReport['data'].length}');

      print('\n👥 PRODUCTIVITÉ DES UTILISATEURS:');
      for (final user in userReport['data'].take(5)) {
        print('   • ${user['name']}');
        print('     Rôle: ${user['role']}');
        print('     Département: ${user['department'] ?? 'Non défini'}');
        print('     Tâches totales: ${user['total_tasks']}');
        print('     Tâches terminées: ${user['completed_tasks']}');
        print(
            '     Taux de complétion: ${user['completion_rate'].toStringAsFixed(2)}%');
        print('     Tâches en retard: ${user['overdue_tasks']}');
        print(
            '     Score de productivité: ${user['productivity_score'].toStringAsFixed(2)}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport de productivité: $e');
    }
  }

  /// Exemple d'obtention de la productivité des utilisateurs
  Future<void> getUsersProductivityExample() async {
    try {
      print('📊 Récupération de la productivité des utilisateurs...');

      final users = await _reportService.getUsersProductivity();

      print('✅ Productivité des utilisateurs récupérée avec succès !');
      print('   Nombre d\'utilisateurs: ${users.length}');
    } catch (e) {
      print('❌ Erreur lors de la récupération de la productivité: $e');
    }
  }

  /// Exemple d'obtention des utilisateurs les plus productifs
  Future<void> getMostProductiveUsersExample() async {
    try {
      print('🏆 Récupération des utilisateurs les plus productifs...');

      final productiveUsers =
          await _reportService.getMostProductiveUsers(limit: 5);

      print('✅ Utilisateurs les plus productifs récupérés avec succès !');
      print('   Nombre d\'utilisateurs: ${productiveUsers.length}');

      print('\n🏆 TOP 5 DES UTILISATEURS PRODUCTIFS:');
      for (int i = 0; i < productiveUsers.length; i++) {
        final user = productiveUsers[i];
        print('   ${i + 1}. ${user['name']}');
        print(
            '      Score de productivité: ${user['productivity_score'].toStringAsFixed(2)}%');
        print('      Rôle: ${user['role']}');
        print(
            '      Taux de complétion: ${user['completion_rate'].toStringAsFixed(2)}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des utilisateurs productifs: $e');
    }
  }

  /// Exemple d'obtention des utilisateurs par taux de complétion
  Future<void> getUsersByCompletionRateExample() async {
    try {
      print('📈 Récupération des utilisateurs par taux de complétion...');

      final usersByRate =
          await _reportService.getUsersByCompletionRate(limit: 5);

      print('✅ Utilisateurs par taux de complétion récupérés avec succès !');
      print('   Nombre d\'utilisateurs: ${usersByRate.length}');

      print('\n📈 TOP 5 PAR TAUX DE COMPLÉTION:');
      for (int i = 0; i < usersByRate.length; i++) {
        final user = usersByRate[i];
        print('   ${i + 1}. ${user['name']}');
        print(
            '      Taux de complétion: ${user['completion_rate'].toStringAsFixed(2)}%');
        print('      Rôle: ${user['role']}');
        print(
            '      Score de productivité: ${user['productivity_score'].toStringAsFixed(2)}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par taux de complétion: $e');
    }
  }

  /// Exemple d'obtention des utilisateurs avec le plus de tâches en retard
  Future<void> getUsersWithOverdueTasksExample() async {
    try {
      print(
          '⏰ Récupération des utilisateurs avec le plus de tâches en retard...');

      final usersWithOverdue =
          await _reportService.getUsersWithOverdueTasks(limit: 5);

      print('✅ Utilisateurs avec tâches en retard récupérés avec succès !');
      print('   Nombre d\'utilisateurs: ${usersWithOverdue.length}');

      print('\n⏰ UTILISATEURS AVEC TÂCHES EN RETARD:');
      for (int i = 0; i < usersWithOverdue.length; i++) {
        final user = usersWithOverdue[i];
        print('   ${i + 1}. ${user['name']}');
        print('      Tâches en retard: ${user['overdue_tasks']}');
        print('      Rôle: ${user['role']}');
        print(
            '      Score de productivité: ${user['productivity_score'].toStringAsFixed(2)}%');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des utilisateurs avec tâches en retard: $e');
    }
  }

  /// Exemple d'export de rapport
  Future<void> exportReportExample() async {
    try {
      print('📤 Export de rapport...');

      final export = await _reportService.exportReport(
        reportType: 'dashboard',
        format: 'json',
        filters: {'date_from': '2024-01-01'},
      );

      print('✅ Rapport exporté avec succès !');
      print('   Type de rapport: ${export['data']['type']}');
      print('   Format: ${export['data']['format']}');
      print('   Date d\'export: ${export['data']['export_date']}');
      print('   Filtres appliqués: ${export['data']['filters']}');
    } catch (e) {
      print('❌ Erreur lors de l\'export du rapport: $e');
    }
  }

  /// Exemple d'export du rapport du tableau de bord
  Future<void> exportDashboardReportExample() async {
    try {
      print('📊 Export du rapport du tableau de bord...');

      final export = await _reportService.exportDashboardReport(
        format: 'json',
        filters: {'date_from': '2024-01-01'},
      );

      print('✅ Rapport du tableau de bord exporté avec succès !');
      print('   Type: ${export['data']['type']}');
      print('   Format: ${export['data']['format']}');
      print('   Date d\'export: ${export['data']['export_date']}');
    } catch (e) {
      print('❌ Erreur lors de l\'export du rapport du tableau de bord: $e');
    }
  }

  /// Exemple d'obtention d'un rapport personnalisé
  Future<void> getCustomReportExample() async {
    try {
      print('🔧 Récupération d\'un rapport personnalisé...');

      final customReport = await _reportService.getCustomReport(
        reportType: 'project_performance',
        filters: {
          'date_from': '2024-01-01',
          'date_to': '2024-12-31',
        },
      );

      print('✅ Rapport personnalisé récupéré avec succès !');
      print('   Type: project_performance');
      print(
          '   Filtres appliqués: ${customReport['data'] != null ? 'Oui' : 'Non'}');
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport personnalisé: $e');
    }
  }

  /// Exemple d'obtention d'un rapport avec export automatique
  Future<void> getReportWithExportExample() async {
    try {
      print('📋 Récupération d\'un rapport avec export automatique...');

      final reportWithExport = await _reportService.getReportWithExport(
        reportType: 'task_efficiency',
        filters: {
          'date_from': '2024-01-01',
        },
        format: 'json',
      );

      print('✅ Rapport avec export récupéré avec succès !');
      print(
          '   Type de rapport: ${reportWithExport['summary']['report_type']}');
      print('   Format: ${reportWithExport['summary']['format']}');
      print('   Date d\'export: ${reportWithExport['summary']['export_date']}');
      print(
          '   Filtres appliqués: ${reportWithExport['summary']['filters_applied']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération du rapport avec export: $e');
    }
  }

  /// Exemple complet d'utilisation du service rapport
  Future<void> completeReportWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE RAPPORT ===\n');

      // 1. Rapport du tableau de bord
      await getDashboardReportExample();
      print('');

      // 2. Statistiques du tableau de bord
      await getDashboardStatsExample();
      print('');

      // 3. Métriques individuelles
      await getIndividualMetricsExample();
      print('');

      // 4. Taux de progression
      await getProgressRatesExample();
      print('');

      // 5. Rapport de performance des projets
      await getProjectPerformanceReportExample();
      print('');

      // 6. Projets par performance
      await getProjectsByPerformanceExample();
      print('');

      // 7. Projets les plus performants
      await getTopPerformingProjectsExample();
      print('');

      // 8. Projets en retard
      await getOverdueProjectsListExample();
      print('');

      // 9. Rapport d'efficacité des tâches
      await getTaskEfficiencyReportExample();
      print('');

      // 10. Tâches par efficacité
      await getTasksByEfficiencyExample();
      print('');

      // 11. Tâches les plus efficaces
      await getMostEfficientTasksExample();
      print('');

      // 12. Tâches en retard
      await getOverdueTasksListExample();
      print('');

      // 13. Rapport d'analyse budgétaire
      await getBudgetAnalysisReportExample();
      print('');

      // 14. Analyse budgétaire
      await getBudgetAnalysisExample();
      print('');

      // 15. Résumé budgétaire
      await getBudgetSummaryExample();
      print('');

      // 16. Analyse par catégorie
      await getBudgetByCategoryExample();
      print('');

      // 17. Analyse par mois
      await getBudgetByMonthExample();
      print('');

      // 18. Rapport de productivité des utilisateurs
      await getUserProductivityReportExample();
      print('');

      // 19. Productivité des utilisateurs
      await getUsersProductivityExample();
      print('');

      // 20. Utilisateurs les plus productifs
      await getMostProductiveUsersExample();
      print('');

      // 21. Utilisateurs par taux de complétion
      await getUsersByCompletionRateExample();
      print('');

      // 22. Utilisateurs avec tâches en retard
      await getUsersWithOverdueTasksExample();
      print('');

      // 23. Export de rapport
      await exportReportExample();
      print('');

      // 24. Export du tableau de bord
      await exportDashboardReportExample();
      print('');

      // 25. Rapport personnalisé
      await getCustomReportExample();
      print('');

      // 26. Rapport avec export automatique
      await getReportWithExportExample();
      print('');

      print('✅ Workflow du service rapport terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service rapport: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de rapports
      print('📊 TABLEAU DE BORD DES RAPPORTS:');

      // Récupérer les statistiques globales
      final totalProjects = await _reportService.getTotalProjects();
      final totalTasks = await _reportService.getTotalTasks();
      final totalIncome = await _reportService.getTotalIncome();
      final totalUsers = await _reportService.getTotalUsers();

      print('📈 STATISTIQUES GLOBALES:');
      print('   Projets: $totalProjects');
      print('   Tâches: $totalTasks');
      print('   Revenus: ${totalIncome.toStringAsFixed(2)}€');
      print('   Utilisateurs: $totalUsers');

      // Récupérer les taux de progression
      final projectProgressRate = await _reportService.getProjectProgressRate();
      final taskProgressRate = await _reportService.getTaskProgressRate();
      final userUtilizationRate = await _reportService.getUserUtilizationRate();

      print('\n📊 TAUX DE PROGRESSION:');
      print('   Projets: ${projectProgressRate.toStringAsFixed(2)}%');
      print('   Tâches: ${taskProgressRate.toStringAsFixed(2)}%');
      print('   Utilisateurs: ${userUtilizationRate.toStringAsFixed(2)}%');

      // Récupérer les projets les plus performants
      final topProjects =
          await _reportService.getTopPerformingProjects(limit: 3);
      print('\n🏆 TOP 3 DES PROJETS:');
      for (int i = 0; i < topProjects.length; i++) {
        final project = topProjects[i];
        print(
            '   ${i + 1}. ${project['name']} (${project['completion_rate'].toStringAsFixed(1)}%)');
      }

      // Récupérer les utilisateurs les plus productifs
      final topUsers = await _reportService.getMostProductiveUsers(limit: 3);
      print('\n👥 TOP 3 DES UTILISATEURS:');
      for (int i = 0; i < topUsers.length; i++) {
        final user = topUsers[i];
        print(
            '   ${i + 1}. ${user['name']} (${user['productivity_score'].toStringAsFixed(1)}%)');
      }
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service rapport
void main() async {
  final reportExample = ReportExample();

  // Exécuter le workflow complet
  await reportExample.completeReportWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await reportExample.uiExample();
}

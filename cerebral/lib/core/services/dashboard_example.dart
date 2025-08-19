import 'dashboard_service.dart';

/// Exemple d'utilisation complète du service dashboard
/// Basé sur le DashboardController Laravel avec toutes les fonctionnalités avancées
class DashboardExample {
  final DashboardService _dashboardService = DashboardService();

  /// Exemple d'obtention des statistiques complètes
  Future<void> getCompleteStatsExample() async {
    try {
      print('📊 Récupération des statistiques complètes du tableau de bord...');
      
      final stats = await _dashboardService.getStats();

      print('✅ Statistiques récupérées avec succès !');
      
      // Afficher les statistiques d'aperçu
      final overview = stats['data']['overview'];
      print('\n📈 APERÇU GÉNÉRAL:');
      print('   Projets totaux: ${overview['total_projects']}');
      print('   Tâches totales: ${overview['total_tasks']}');
      print('   Personnel total: ${overview['total_personnel']}');
      print('   Budgets totaux: ${overview['total_budgets']}');
      print('   Utilisateurs totaux: ${overview['total_users']}');

      // Afficher les statistiques des projets
      final projects = stats['data']['projects'];
      print('\n🏗️ STATISTIQUES DES PROJETS:');
      print('   Projets actifs: ${projects['active']}');
      print('   Projets complétés: ${projects['completed']}');
      print('   Projets en attente: ${projects['on_hold']}');
      print('   Projets annulés: ${projects['cancelled']}');
      print('   Projets récents (30j): ${projects['recent']}');

      // Afficher les statistiques des tâches
      final tasks = stats['data']['tasks'];
      print('\n📋 STATISTIQUES DES TÂCHES:');
      print('   Tâches en attente: ${tasks['pending']}');
      print('   Tâches en cours: ${tasks['in_progress']}');
      print('   Tâches en révision: ${tasks['review']}');
      print('   Tâches complétées: ${tasks['completed']}');
      print('   Tâches en retard: ${tasks['overdue']}');
      print('   Tâches haute priorité: ${tasks['high_priority']}');

      // Afficher les statistiques du personnel
      final personnel = stats['data']['personnel'];
      print('\n👥 STATISTIQUES DU PERSONNEL:');
      print('   Personnel actif: ${personnel['active']}');
      print('   Personnel inactif: ${personnel['inactive']}');
      print('   Personnel en congé: ${personnel['on_leave']}');
      print('   Personnel licencié: ${personnel['terminated']}');

      // Afficher les statistiques des budgets
      final budgets = stats['data']['budgets'];
      print('\n💰 STATISTIQUES DES BUDGETS:');
      print('   Montant total: ${budgets['total_amount']}');
      print('   Budgets approuvés: ${budgets['approved']}');
      print('   Budgets en attente: ${budgets['pending']}');
      print('   Budgets exécutés: ${budgets['executed']}');

      // Afficher les statistiques des workflows
      final workflows = stats['data']['workflows'];
      print('\n🔄 STATISTIQUES DES WORKFLOWS:');
      print('   Workflows totaux: ${workflows['total']}');
      print('   Workflows actifs: ${workflows['active']}');
      print('   Workflows en attente: ${workflows['pending']}');
      print('   Workflows complétés: ${workflows['completed']}');

      // Afficher les statistiques des notifications
      final notifications = stats['data']['notifications'];
      print('\n🔔 STATISTIQUES DES NOTIFICATIONS:');
      print('   Notifications non lues: ${notifications['unread']}');
      print('   Notifications totales: ${notifications['total']}');
      print('   Notifications récentes (7j): ${notifications['recent']}');

      // Afficher les métriques de performance
      final performance = stats['data']['performance'];
      print('\n🎯 MÉTRIQUES DE PERFORMANCE:');
      print('   Taux de completion des tâches: ${performance['task_completion_rate']}%');
      print('   Taux de succès des projets: ${performance['project_success_rate']}%');
      print('   Efficacité des budgets: ${performance['budget_efficiency']}%');
      print('   Utilisation du personnel: ${performance['personnel_utilization']}%');
      print('   Efficacité des workflows: ${performance['workflow_efficiency']}%');

    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple d'obtention des données pour graphiques
  Future<void> getChartDataExample() async {
    try {
      print('📊 Récupération des données pour graphiques...');
      
      final chartData = await _dashboardService.getChartData();

      print('✅ Données des graphiques récupérées avec succès !');
      
      // Afficher les données de la chronologie des projets
      final projectTimeline = chartData['data']['project_timeline'];
      print('\n📅 CHRONOLOGIE DES PROJETS (12 derniers mois):');
      for (final month in projectTimeline) {
        print('   ${month['month']}: ${month['created']} créés, ${month['completed']} complétés');
      }

      // Afficher la distribution des statuts des tâches
      final taskStatusDistribution = chartData['data']['task_status_distribution'];
      print('\n📋 DISTRIBUTION DES STATUTS DES TÂCHES:');
      for (final status in taskStatusDistribution) {
        print('   ${status['status']}: ${status['count']} tâches');
      }

      // Afficher les tendances des budgets
      final budgetTrends = chartData['data']['budget_trends'];
      print('\n💰 TENDANCES DES BUDGETS (12 derniers mois):');
      for (final month in budgetTrends) {
        print('   ${month['month']}: Total ${month['total_amount']}, Approuvé ${month['approved_amount']}');
      }

      // Afficher les données de performance du personnel
      final personnelPerformance = chartData['data']['personnel_performance'];
      print('\n👥 PERFORMANCE DU PERSONNEL PAR DÉPARTEMENT:');
      for (final dept in personnelPerformance) {
        print('   ${dept['department']}: Note moyenne ${dept['avg_rating']}');
      }

      // Afficher les données d'activité mensuelle
      final monthlyActivity = chartData['data']['monthly_activity'];
      print('\n📈 ACTIVITÉ MENSUELLE (12 derniers mois):');
      for (final month in monthlyActivity) {
        print('   ${month['month']}: ${month['projects_created']} projets, ${month['tasks_created']} tâches, ${month['personnel_hired']} personnel');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des données des graphiques: $e');
    }
  }

  /// Exemple d'obtention des actions rapides
  Future<void> getQuickActionsExample() async {
    try {
      print('⚡ Récupération des actions rapides...');
      
      final actions = await _dashboardService.getQuickActions();

      print('✅ Actions rapides récupérées avec succès !');
      print('\n🚀 ACTIONS RAPIDES DISPONIBLES:');
      
      for (final action in actions['data']) {
        print('   • ${action['title']}');
        print('     Description: ${action['description']}');
        print('     Icône: ${action['icon']}');
        print('     Route: ${action['route']}');
        print('     Permission: ${action['permission']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des actions rapides: $e');
    }
  }

  /// Exemple d'obtention des données des projets
  Future<void> getProjectsDashboardExample() async {
    try {
      print('🏗️ Récupération des données des projets pour le tableau de bord...');
      
      final projects = await _dashboardService.getProjects();

      print('✅ Données des projets récupérées avec succès !');
      print('\n📋 PROJETS RÉCENTS:');
      
      for (final project in projects['data']) {
        print('   • ${project['name']}');
        print('     Statut: ${project['status']}');
        print('     Progression: ${project['progress']}%');
        print('     Manager: ${project['manager']}');
        print('     Tâches: ${project['task_count']} total, ${project['completed_tasks']} complétées');
        print('     Tâches en retard: ${project['overdue_tasks']}');
        print('     Budget: ${project['budget']}');
        print('     En retard: ${project['is_overdue'] ? 'Oui' : 'Non'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des données des projets: $e');
    }
  }

  /// Exemple d'obtention des données des tâches
  Future<void> getTasksDashboardExample() async {
    try {
      print('📋 Récupération des données des tâches pour le tableau de bord...');
      
      final tasks = await _dashboardService.getTasks();

      print('✅ Données des tâches récupérées avec succès !');
      print('\n📝 TÂCHES RÉCENTES:');
      
      for (final task in tasks['data']) {
        print('   • ${task['title']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('     Progression: ${task['progress']}%');
        print('     Projet: ${task['project']}');
        print('     Assigné à: ${task['assigned_to']}');
        print('     Date d\'échéance: ${task['due_date']}');
        print('     En retard: ${task['is_overdue'] ? 'Oui' : 'Non'}');
        print('     Heures estimées: ${task['estimated_hours']}');
        print('     Heures réelles: ${task['actual_hours']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des données des tâches: $e');
    }
  }

  /// Exemple d'obtention des alertes
  Future<void> getAlertsExample() async {
    try {
      print('⚠️ Récupération des alertes et avertissements...');
      
      final alerts = await _dashboardService.getAlerts();

      print('✅ Alertes récupérées avec succès !');
      print('\n🚨 ALERTES ACTIVES:');
      print('   Total des alertes: ${alerts['data']['total_alerts']}');
      print('   Alertes critiques: ${alerts['data']['critical_alerts']}');
      print('   Dernière vérification: ${alerts['data']['last_checked']}');
      
      for (final alert in alerts['data']['alerts']) {
        print('\n   • ${alert['title']}');
        print('     Type: ${alert['type']}');
        print('     Message: ${alert['message']}');
        print('     Priorité: ${alert['priority']}');
        print('     Action: ${alert['action']}');
        print('     Nombre: ${alert['count']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des alertes: $e');
    }
  }

  /// Exemple d'obtention de la distribution de la charge de travail
  Future<void> getWorkloadDistributionExample() async {
    try {
      print('⚖️ Récupération de la distribution de la charge de travail...');
      
      final workload = await _dashboardService.getWorkloadDistribution();

      print('✅ Distribution de la charge de travail récupérée avec succès !');
      print('\n📊 RÉPARTITION DE LA CHARGE DE TRAVAIL:');
      print('   Charge faible: ${workload['data']['low_workload']} personnes');
      print('   Charge moyenne: ${workload['data']['medium_workload']} personnes');
      print('   Charge élevée: ${workload['data']['high_workload']} personnes');
      print('   Surchargées: ${workload['data']['overloaded']} personnes');
      
      print('\n👥 DÉTAIL PAR PERSONNE:');
      for (final person in workload['data']['personnel']) {
        print('   • ${person['name']} (${person['department']})');
        print('     Position: ${person['position']}');
        print('     Tâches actives: ${person['active_tasks']}');
        print('     Tâches complétées: ${person['completed_tasks']}');
        print('     Niveau de charge: ${person['workload_level']}');
        print('     Taux d\'utilisation: ${person['utilization_rate']}%');
        print('     Note de performance: ${person['performance_rating']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de la distribution de la charge de travail: $e');
    }
  }

  /// Exemple d'obtention des analyses de performance des projets
  Future<void> getProjectAnalyticsExample() async {
    try {
      print('📈 Récupération des analyses de performance des projets...');
      
      final analytics = await _dashboardService.getProjectAnalytics();

      print('✅ Analyses de performance des projets récupérées avec succès !');
      
      // Afficher les tendances de completion
      final completionTrends = analytics['data']['completion_trends'];
      print('\n📅 TENDANCES DE COMPLETION DES PROJETS:');
      for (final month in completionTrends) {
        print('   ${month['month']}: ${month['total']} projets, ${month['completed']} complétés (${month['completion_rate']}%)');
      }

      // Afficher la performance par manager
      final performanceByManager = analytics['data']['performance_by_manager'];
      print('\n👑 PERFORMANCE PAR MANAGER:');
      for (final manager in performanceByManager) {
        print('   • ${manager['manager_name']}');
        print('     Projets totaux: ${manager['total_projects']}');
        print('     Projets complétés: ${manager['completed_projects']}');
        print('     Projets en retard: ${manager['overdue_projects']}');
        print('     Taux de succès: ${manager['success_rate']}%');
        print('');
      }

      // Afficher l'analyse de variance des budgets
      final budgetVariance = analytics['data']['budget_variance'];
      print('\n💰 ANALYSE DE VARIANCE DES BUDGETS:');
      for (final budget in budgetVariance) {
        print('   • ${budget['project_name']}');
        print('     Montant planifié: ${budget['planned_amount']}');
        print('     Montant exécuté: ${budget['executed_amount']}');
        print('     Variance: ${budget['variance']} (${budget['variance_percentage']}%)');
        print('     Statut: ${budget['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des analyses de performance: $e');
    }
  }

  /// Exemple d'obtention des métriques d'efficacité des tâches
  Future<void> getTaskEfficiencyExample() async {
    try {
      print('⚡ Récupération des métriques d\'efficacité des tâches...');
      
      final efficiency = await _dashboardService.getTaskEfficiency();

      print('✅ Métriques d\'efficacité des tâches récupérées avec succès !');
      
      // Afficher l'analyse du temps de completion
      final completionTime = efficiency['data']['completion_time'];
      print('\n⏱️ ANALYSE DU TEMPS DE COMPLETION:');
      print('   Temps moyen: ${completionTime['average_completion_time']} heures');
      print('   Temps médian: ${completionTime['median_completion_time']} heures');
      print('   Plus rapide: ${completionTime['fastest_completion']} heures');
      print('   Plus lent: ${completionTime['slowest_completion']} heures');
      
      print('\n📊 DISTRIBUTION:');
      print('   Moins d\'1 heure: ${completionTime['distribution']['under_1_hour']} tâches');
      print('   1 à 4 heures: ${completionTime['distribution']['1_to_4_hours']} tâches');
      print('   4 à 8 heures: ${completionTime['distribution']['4_to_8_hours']} tâches');
      print('   Plus de 8 heures: ${completionTime['distribution']['over_8_hours']} tâches');

      // Afficher la distribution des priorités
      final priorityDistribution = efficiency['data']['priority_distribution'];
      print('\n🎯 DISTRIBUTION DES PRIORITÉS:');
      for (final priority in priorityDistribution) {
        print('   ${priority['priority']}: ${priority['count']} tâches');
      }

      // Afficher la performance des assignés
      final assigneePerformance = efficiency['data']['assignee_performance'];
      print('\n👤 PERFORMANCE DES ASSIGNÉS:');
      for (final assignee in assigneePerformance) {
        print('   • ${assignee['name']} (${assignee['department']})');
        print('     Tâches totales: ${assignee['total_tasks']}');
        print('     Tâches complétées: ${assignee['completed_tasks']}');
        print('     Tâches en retard: ${assignee['overdue_tasks']}');
        print('     Taux de completion: ${assignee['completion_rate']}%');
        print('     Note de performance: ${assignee['performance_rating']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des métriques d\'efficacité: $e');
    }
  }

  /// Exemple d'obtention de l'analyse des budgets
  Future<void> getBudgetAnalysisExample() async {
    try {
      print('💰 Récupération de l\'analyse et de la prévision des budgets...');
      
      final analysis = await _dashboardService.getBudgetAnalysis();

      print('✅ Analyse des budgets récupérée avec succès !');
      
      // Afficher les tendances de dépenses
      final spendingTrends = analysis['data']['spending_trends'];
      print('\n📈 TENDANCES DE DÉPENSES (12 derniers mois):');
      for (final month in spendingTrends) {
        print('   ${month['month']}: Total ${month['total_spent']}, Approuvé ${month['approved_amount']}, Exécuté ${month['executed_amount']}');
      }

      // Afficher l'analyse des catégories
      final categoryAnalysis = analysis['data']['category_analysis'];
      print('\n📁 ANALYSE PAR CATÉGORIE:');
      for (final category in categoryAnalysis) {
        print('   • ${category['category']}');
        print('     Nombre de budgets: ${category['count']}');
        print('     Montant total: ${category['total_amount']}');
        print('     Pourcentage du total: ${category['percentage_of_total']}%');
        print('');
      }

      // Afficher l'efficacité d'approbation
      final approvalEfficiency = analysis['data']['approval_efficiency'];
      print('\n✅ EFFICACITÉ D\'APPROBATION:');
      print('   Budgets totaux: ${approvalEfficiency['total_budgets']}');
      print('   Budgets approuvés: ${approvalEfficiency['approved_budgets']}');
      print('   Budgets en attente: ${approvalEfficiency['pending_budgets']}');
      print('   Temps moyen d\'approbation: ${approvalEfficiency['average_approval_time']} heures');
      print('   Taux d\'approbation: ${approvalEfficiency['approval_rate']}%');

      // Afficher la prévision
      final forecasting = analysis['data']['forecasting'];
      print('\n🔮 PRÉVISION DES BUDGETS:');
      print('   Mois actuel (${forecasting['current_month']['month']}):');
      print('     Dépenses projetées: ${forecasting['current_month']['projected_spending']}');
      print('     Dépenses réelles: ${forecasting['current_month']['actual_spending']}');
      print('   Mois prochain (${forecasting['next_month']['month']}):');
      print('     Dépenses projetées: ${forecasting['next_month']['projected_spending']}');
      print('     Niveau de confiance: ${forecasting['next_month']['confidence_level']}');
      print('   Mois suivant (${forecasting['following_month']['month']}):');
      print('     Dépenses projetées: ${forecasting['following_month']['projected_spending']}');
      print('     Niveau de confiance: ${forecasting['following_month']['confidence_level']}');

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'analyse des budgets: $e');
    }
  }

  /// Exemple complet d'utilisation du tableau de bord
  Future<void> completeDashboardWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU TABLEAU DE BORD ===\n');

      // 1. Obtenir les statistiques complètes
      await getCompleteStatsExample();
      print('');

      // 2. Obtenir les données pour graphiques
      await getChartDataExample();
      print('');

      // 3. Obtenir les actions rapides
      await getQuickActionsExample();
      print('');

      // 4. Obtenir les données des projets
      await getProjectsDashboardExample();
      print('');

      // 5. Obtenir les données des tâches
      await getTasksDashboardExample();
      print('');

      // 6. Obtenir les alertes
      await getAlertsExample();
      print('');

      // 7. Obtenir la distribution de la charge de travail
      await getWorkloadDistributionExample();
      print('');

      // 8. Obtenir les analyses de performance des projets
      await getProjectAnalyticsExample();
      print('');

      // 9. Obtenir les métriques d'efficacité des tâches
      await getTaskEfficiencyExample();
      print('');

      // 10. Obtenir l'analyse des budgets
      await getBudgetAnalysisExample();
      print('');

      print('✅ Workflow du tableau de bord terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du tableau de bord: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord complet
      print('📊 TABLEAU DE BORD COMPLET:');
      
      // Récupérer les statistiques d'aperçu
      final overview = await _dashboardService.getOverviewStats();
      print('📈 APERÇU GÉNÉRAL:');
      print('   Projets: ${overview['total_projects']}');
      print('   Tâches: ${overview['total_tasks']}');
      print('   Personnel: ${overview['total_personnel']}');
      print('   Budgets: ${overview['total_budgets']}');

      // Récupérer les statistiques des projets
      final projectStats = await _dashboardService.getProjectStats();
      print('\n🏗️ PROJETS:');
      print('   Actifs: ${projectStats['active']}');
      print('   Complétés: ${projectStats['completed']}');
      print('   En attente: ${projectStats['on_hold']}');

      // Récupérer les statistiques des tâches
      final taskStats = await _dashboardService.getTaskStats();
      print('\n📋 TÂCHES:');
      print('   En attente: ${taskStats['pending']}');
      print('   En cours: ${taskStats['in_progress']}');
      print('   Complétées: ${taskStats['completed']}');
      print('   En retard: ${taskStats['overdue']}');

      // Récupérer les alertes
      final alerts = await _dashboardService.getAlerts();
      print('\n⚠️ ALERTES:');
      print('   Total: ${alerts['data']['total_alerts']}');
      print('   Critiques: ${alerts['data']['critical_alerts']}');

      // Récupérer les actions rapides
      final actions = await _dashboardService.getQuickActions();
      print('\n⚡ ACTIONS RAPIDES:');
      print('   Disponibles: ${actions['data'].length}');

      // Récupérer les métriques de performance système
      final systemMetrics = await _dashboardService.getSystemPerformanceMetrics();
      print('\n💻 PERFORMANCE SYSTÈME:');
      print('   Temps de réponse: ${systemMetrics['response_time']}');
      print('   Disponibilité: ${systemMetrics['uptime']}');
      print('   Utilisation mémoire: ${systemMetrics['memory_usage']}');
      print('   Utilisation CPU: ${systemMetrics['cpu_usage']}');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service dashboard
void main() async {
  final dashboardExample = DashboardExample();
  
  // Exécuter le workflow complet
  await dashboardExample.completeDashboardWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await dashboardExample.uiExample();
}

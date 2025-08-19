import 'project_service.dart';

/// Exemple d'utilisation complète du service projet
/// Basé sur le ProjectController Laravel avec toutes les fonctionnalités avancées
class ProjectExample {
  final ProjectService _projectService = ProjectService();

  /// Exemple de création d'un nouveau projet
  Future<void> createProjectExample() async {
    try {
      print('🏗️ Création d\'un nouveau projet...');

      final project = await _projectService.createProject(
        name: 'Résidence Les Jardins du Lac',
        type: 'residential',
        status: 'planning',
        priority: 'high',
        clientName: 'Promoteur Immobilier ABC',
        clientEmail: 'contact@promoteur-abc.com',
        location: '123 Avenue des Lacs, 75016 Paris',
        managerId: 1,
        description:
            'Construction d\'une résidence de luxe avec 50 appartements, piscine et spa',
        budget: 2500000.0,
        currency: 'EUR',
        clientPhone: '+33 1 23 45 67 89',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2026, 12, 31),
        progress: 0.0,
        teamMembers: [1, 2, 3, 4, 5],
        tags: ['résidentiel', 'luxe', 'piscine', 'spa', 'paris'],
        attachments: [
          'plans_architecte.pdf',
          'etude_terrain.pdf',
          'permis_construire.pdf'
        ],
      );

      print('✅ Projet créé avec succès !');
      print('   Nom: ${project['project']['name']}');
      print('   Type: ${project['project']['type']}');
      print('   Statut: ${project['project']['status']}');
      print('   Priorité: ${project['project']['priority']}');
      print('   Client: ${project['project']['client_name']}');
      print('   Email client: ${project['project']['client_email']}');
      print('   Localisation: ${project['project']['location']}');
      print(
          '   Manager: ${project['project']['manager']?['name'] ?? 'Non défini'}');
      print('   Budget: ${project['project']['budget']}€');
      print('   Devise: ${project['project']['currency']}');
      print('   Date de début: ${project['project']['start_date']}');
      print('   Date de fin: ${project['project']['end_date']}');
      print('   Progrès: ${project['project']['progress']}%');
      print('   Membres de l\'équipe: ${project['project']['team_members']}');
      print('   Tags: ${project['project']['tags']}');
      print('   Pièces jointes: ${project['project']['attachments']}');
      print('   Message: ${project['message']}');
    } catch (e) {
      print('❌ Erreur lors de la création du projet: $e');
    }
  }

  /// Exemple d'obtention de tous les projets
  Future<void> getAllProjectsExample() async {
    try {
      print('🏗️ Récupération de tous les projets...');

      final projects = await _projectService.getProjects(perPage: 10);

      print('✅ Projets récupérés avec succès !');
      print('   Total: ${projects['meta']['total']} projets');
      print('   Page actuelle: ${projects['meta']['current_page']}');
      print('   Par page: ${projects['meta']['per_page']}');

      print('\n🏗️ PROJETS:');
      for (final project in projects['data']) {
        print('   • ${project['name']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('     Priorité: ${project['priority']}');
        print('     Client: ${project['client_name']}');
        print('     Localisation: ${project['location']}');
        print('     Manager: ${project['manager']?['name'] ?? 'Non défini'}');
        print('     Budget: ${project['budget'] ?? 'Non défini'}€');
        print('     Progrès: ${project['progress'] ?? 0}%');
        print('     Date de début: ${project['start_date'] ?? 'Non définie'}');
        print('     Date de fin: ${project['end_date'] ?? 'Non définie'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets: $e');
    }
  }

  /// Exemple de filtrage des projets par statut
  Future<void> getProjectsByStatusExample() async {
    try {
      print('📊 Récupération des projets par statut...');

      // Projets en planification
      final planningProjects =
          await _projectService.getPlanningProjects(perPage: 5);
      print('\n📋 PROJETS EN PLANIFICATION:');
      print('   Nombre: ${planningProjects['data'].length}');

      // Projets en cours
      final inProgressProjects =
          await _projectService.getInProgressProjects(perPage: 5);
      print('\n🔄 PROJETS EN COURS:');
      print('   Nombre: ${inProgressProjects['data'].length}');

      // Projets en attente
      final onHoldProjects =
          await _projectService.getOnHoldProjects(perPage: 5);
      print('\n⏸️ PROJETS EN ATTENTE:');
      print('   Nombre: ${onHoldProjects['data'].length}');

      // Projets terminés
      final completedProjects =
          await _projectService.getCompletedProjects(perPage: 5);
      print('\n✅ PROJETS TERMINÉS:');
      print('   Nombre: ${completedProjects['data'].length}');

      // Projets annulés
      final cancelledProjects =
          await _projectService.getCancelledProjects(perPage: 5);
      print('\n❌ PROJETS ANNULÉS:');
      print('   Nombre: ${cancelledProjects['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple de filtrage des projets par type
  Future<void> getProjectsByTypeExample() async {
    try {
      print('🏠 Récupération des projets par type...');

      // Projets résidentiels
      final residentialProjects =
          await _projectService.getResidentialProjects(perPage: 5);
      print('\n🏠 PROJETS RÉSIDENTIELS:');
      print('   Nombre: ${residentialProjects['data'].length}');

      // Projets commerciaux
      final commercialProjects =
          await _projectService.getCommercialProjects(perPage: 5);
      print('\n🏢 PROJETS COMMERCIAUX:');
      print('   Nombre: ${commercialProjects['data'].length}');

      // Projets industriels
      final industrialProjects =
          await _projectService.getIndustrialProjects(perPage: 5);
      print('\n🏭 PROJETS INDUSTRIELS:');
      print('   Nombre: ${industrialProjects['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par type: $e');
    }
  }

  /// Exemple de filtrage des projets par priorité
  Future<void> getProjectsByPriorityExample() async {
    try {
      print('⭐ Récupération des projets par priorité...');

      // Projets de priorité basse
      final lowPriorityProjects =
          await _projectService.getLowPriorityProjects(perPage: 5);
      print('\n🟢 PRIORITÉ BASSE:');
      print('   Nombre: ${lowPriorityProjects['data'].length}');

      // Projets de priorité moyenne
      final mediumPriorityProjects =
          await _projectService.getMediumPriorityProjects(perPage: 5);
      print('\n🟡 PRIORITÉ MOYENNE:');
      print('   Nombre: ${mediumPriorityProjects['data'].length}');

      // Projets de priorité haute
      final highPriorityProjects =
          await _projectService.getHighPriorityProjects(perPage: 5);
      print('\n🟠 PRIORITÉ HAUTE:');
      print('   Nombre: ${highPriorityProjects['data'].length}');

      // Projets de priorité critique
      final criticalPriorityProjects =
          await _projectService.getCriticalPriorityProjects(perPage: 5);
      print('\n🔴 PRIORITÉ CRITIQUE:');
      print('   Nombre: ${criticalPriorityProjects['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par priorité: $e');
    }
  }

  /// Exemple de recherche de projets
  Future<void> searchProjectsExample() async {
    try {
      print('🔍 Recherche de projets...');

      final searchResults =
          await _projectService.searchProjects('résidence', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: résidence');
      print('   Résultats trouvés: ${searchResults['data'].length}');

      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final project in searchResults['data']) {
        print('   • ${project['name']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('     Client: ${project['client_name']}');
        print('     Localisation: ${project['location']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des projets par gamme de budget
  Future<void> getProjectsByBudgetRangeExample() async {
    try {
      print('💰 Récupération des projets par gamme de budget...');

      final budgetRangeProjects =
          await _projectService.getProjectsByBudgetRange(
        minBudget: 1000000.0,
        maxBudget: 5000000.0,
        perPage: 10,
      );

      print('✅ Projets de la gamme de budget récupérés avec succès !');
      print('   Gamme: 1 000 000€ à 5 000 000€');
      print(
          '   Nombre de projets: ${budgetRangeProjects['meta']['budget_range_count']}');

      print('\n💰 PROJETS DE LA GAMME DE BUDGET:');
      for (final project in budgetRangeProjects['data']) {
        print('   • ${project['name']}');
        print('     Budget: ${project['budget']}€');
        print('     Devise: ${project['currency']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par gamme de budget: $e');
    }
  }

  /// Exemple d'obtention des projets par gamme de progrès
  Future<void> getProjectsByProgressRangeExample() async {
    try {
      print('📈 Récupération des projets par gamme de progrès...');

      final progressRangeProjects =
          await _projectService.getProjectsByProgressRange(
        minProgress: 50.0,
        maxProgress: 100.0,
        perPage: 10,
      );

      print('✅ Projets de la gamme de progrès récupérés avec succès !');
      print('   Gamme: 50% à 100%');
      print(
          '   Nombre de projets: ${progressRangeProjects['meta']['progress_range_count']}');

      print('\n📈 PROJETS DE LA GAMME DE PROGRÈS:');
      for (final project in progressRangeProjects['data']) {
        print('   • ${project['name']}');
        print('     Progrès: ${project['progress']}%');
        print('     Statut: ${project['status']}');
        print('     Type: ${project['type']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par gamme de progrès: $e');
    }
  }

  /// Exemple d'obtention des projets par période
  Future<void> getProjectsByPeriodExample() async {
    try {
      print('📅 Récupération des projets par période...');

      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2025, 12, 31);

      final periodProjects = await _projectService.getProjectsByPeriod(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Projets de la période récupérés avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de projets: ${periodProjects['meta']['period_count']}');

      print('\n📅 PROJETS DE LA PÉRIODE:');
      for (final project in periodProjects['data']) {
        print('   • ${project['name']}');
        print('     Date de début: ${project['start_date']}');
        print('     Date de fin: ${project['end_date']}');
        print('     Statut: ${project['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par période: $e');
    }
  }

  /// Exemple d'obtention des projets par localisation
  Future<void> getProjectsByLocationExample() async {
    try {
      print('📍 Récupération des projets par localisation...');

      final locationProjects =
          await _projectService.getProjectsByLocation('Paris', perPage: 10);

      print('✅ Projets de la localisation récupérés avec succès !');
      print('   Localisation: Paris');
      print(
          '   Nombre de projets: ${locationProjects['meta']['location_count']}');

      print('\n📍 PROJETS DE LA LOCALISATION:');
      for (final project in locationProjects['data']) {
        print('   • ${project['name']}');
        print('     Localisation: ${project['location']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par localisation: $e');
    }
  }

  /// Exemple d'obtention des projets par client
  Future<void> getProjectsByClientExample() async {
    try {
      print('👤 Récupération des projets par client...');

      final clientProjects =
          await _projectService.getProjectsByClient('Promoteur', perPage: 10);

      print('✅ Projets du client récupérés avec succès !');
      print('   Client: Promoteur');
      print('   Nombre de projets: ${clientProjects['meta']['client_count']}');

      print('\n👤 PROJETS DU CLIENT:');
      for (final project in clientProjects['data']) {
        print('   • ${project['name']}');
        print('     Client: ${project['client_name']}');
        print('     Email: ${project['client_email']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par client: $e');
    }
  }

  /// Exemple d'obtention des projets par tags
  Future<void> getProjectsByTagsExample() async {
    try {
      print('🏷️ Récupération des projets par tags...');

      final tagsProjects = await _projectService.getProjectsByTags(
        ['luxe', 'piscine'],
        perPage: 10,
      );

      print('✅ Projets avec les tags requis récupérés avec succès !');
      print('   Tags requis: luxe, piscine');
      print(
          '   Nombre de projets: ${tagsProjects['meta']['tags_match_count']}');

      print('\n🏷️ PROJETS AVEC LES TAGS:');
      for (final project in tagsProjects['data']) {
        print('   • ${project['name']}');
        print('     Tags: ${project['tags']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par tags: $e');
    }
  }

  /// Exemple d'obtention des projets en retard
  Future<void> getOverdueProjectsExample() async {
    try {
      print('⏰ Récupération des projets en retard...');

      final overdueProjects =
          await _projectService.getOverdueProjects(perPage: 10);

      print('✅ Projets en retard récupérés avec succès !');
      print(
          '   Nombre de projets: ${overdueProjects['meta']['overdue_count']}');

      print('\n⏰ PROJETS EN RETARD:');
      for (final project in overdueProjects['data']) {
        print('   • ${project['name']}');
        print('     Date de fin: ${project['end_date']}');
        print('     Statut: ${project['status']}');
        print('     Type: ${project['type']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets en retard: $e');
    }
  }

  /// Exemple d'obtention des projets à venir
  Future<void> getUpcomingProjectsExample() async {
    try {
      print('🚀 Récupération des projets à venir...');

      final upcomingProjects =
          await _projectService.getUpcomingProjects(perPage: 10);

      print('✅ Projets à venir récupérés avec succès !');
      print(
          '   Nombre de projets: ${upcomingProjects['meta']['upcoming_count']}');

      print('\n🚀 PROJETS À VENIR:');
      for (final project in upcomingProjects['data']) {
        print('   • ${project['name']}');
        print('     Date de début: ${project['start_date']}');
        print('     Statut: ${project['status']}');
        print('     Type: ${project['type']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets à venir: $e');
    }
  }

  /// Exemple d'obtention des projets récents
  Future<void> getRecentProjectsExample() async {
    try {
      print('🕐 Récupération des projets récents...');

      final recentProjects =
          await _projectService.getRecentProjects(perPage: 10);

      print('✅ Projets récents récupérés avec succès !');
      print('   Nombre de projets: ${recentProjects['meta']['recent_count']}');
      print('   Période: 30 derniers jours');

      print('\n🕐 PROJETS RÉCENTS:');
      for (final project in recentProjects['data']) {
        print('   • ${project['name']}');
        print('     Date de création: ${project['created_at']}');
        print('     Statut: ${project['status']}');
        print('     Type: ${project['type']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets récents: $e');
    }
  }

  /// Exemple d'obtention des projets par membre d'équipe
  Future<void> getProjectsByTeamMemberExample() async {
    try {
      print('👥 Récupération des projets par membre d\'équipe...');

      final teamProjects =
          await _projectService.getProjectsByTeamMember(1, perPage: 10);

      print('✅ Projets du membre d\'équipe récupérés avec succès !');
      print('   ID Membre: 1');
      print(
          '   Nombre de projets: ${teamProjects['meta']['team_projects_count']}');

      print('\n👥 PROJETS DU MEMBRE D\'ÉQUIPE:');
      for (final project in teamProjects['data']) {
        print('   • ${project['name']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('     Membres de l\'équipe: ${project['team_members']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par membre d\'équipe: $e');
    }
  }

  /// Exemple d'obtention des projets par devise
  Future<void> getProjectsByCurrencyExample() async {
    try {
      print('💱 Récupération des projets par devise...');

      final currencyProjects =
          await _projectService.getProjectsByCurrency('EUR', perPage: 10);

      print('✅ Projets de la devise récupérés avec succès !');
      print('   Devise: EUR');
      print(
          '   Nombre de projets: ${currencyProjects['meta']['currency_count']}');

      print('\n💱 PROJETS DE LA DEVISE:');
      for (final project in currencyProjects['data']) {
        print('   • ${project['name']}');
        print('     Budget: ${project['budget']}€');
        print('     Devise: ${project['currency']}');
        print('     Type: ${project['type']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par devise: $e');
    }
  }

  /// Exemple de mise à jour du progrès d'un projet
  Future<void> updateProjectProgressExample() async {
    try {
      print('🔄 Mise à jour du progrès du projet...');

      final updatedProject = await _projectService.updateProjectProgress(
        1, // ID du projet
        status: 'in_progress',
        progress: 25.0,
      );

      print('✅ Progrès du projet mis à jour avec succès !');
      print('   Nom: ${updatedProject['data']['name']}');
      print('   Nouveau statut: ${updatedProject['data']['status']}');
      print('   Nouveau progrès: ${updatedProject['data']['progress']}%');
      print('   Message: ${updatedProject['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du progrès: $e');
    }
  }

  /// Exemple d'obtention des statistiques d'un projet
  Future<void> getProjectStatsExample() async {
    try {
      print('📊 Récupération des statistiques du projet...');

      final stats = await _projectService.getProjectStats(1);

      print('✅ Statistiques du projet récupérées avec succès !');

      print('\n📈 STATISTIQUES DES TÂCHES:');
      print('   Total des tâches: ${stats['data']['total_tasks']}');
      print('   Tâches terminées: ${stats['data']['completed_tasks']}');
      print('   Tâches en attente: ${stats['data']['pending_tasks']}');
      print('   Tâches en cours: ${stats['data']['in_progress_tasks']}');

      print('\n💰 STATISTIQUES BUDGÉTAIRES:');
      print('   Budget total dépensé: ${stats['data']['total_budget_spent']}€');
      print('   Budget restant: ${stats['data']['remaining_budget']}€');

      print('\n📊 MÉTRIQUES DE PROGRÈS:');
      print(
          '   Pourcentage de progrès: ${stats['data']['progress_percentage']}%');
      print(
          '   Jours restants: ${stats['data']['days_remaining'] ?? 'Non défini'}');
      print('   En retard: ${stats['data']['is_overdue'] ? 'Oui' : 'Non'}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de mise à jour du projet
  Future<void> updateProjectExample() async {
    try {
      print('✏️ Mise à jour du projet...');

      final updatedProject = await _projectService.updateProject(
        1, // ID du projet
        status: 'in_progress',
        progress: 30.0,
        budget: 2750000.0,
        // notes: 'Budget augmenté suite à l\'ajout d\'équipements de luxe',
      );

      print('✅ Projet mis à jour avec succès !');
      print('   Nom: ${updatedProject['data']['name']}');
      print('   Nouveau statut: ${updatedProject['data']['status']}');
      print('   Nouveau progrès: ${updatedProject['data']['progress']}%');
      print('   Nouveau budget: ${updatedProject['data']['budget']}€');
      print('   Message: ${updatedProject['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du projet: $e');
    }
  }

  /// Exemple de suppression du projet
  Future<void> deleteProjectExample() async {
    try {
      print('🗑️ Suppression du projet...');

      // Vérifier si le projet peut être supprimé
      final canDelete = await _projectService.canDeleteProject(1);
      print('   Peut être supprimé: ${canDelete ? 'Oui' : 'Non'}');

      if (canDelete) {
        final result = await _projectService.deleteProject(1);
        print('✅ Projet supprimé avec succès !');
        print('   Message: ${result['message']}');
      } else {
        print('❌ Le projet ne peut pas être supprimé');
        print('   Raison: A des tâches ou des budgets associés');
      }
    } catch (e) {
      print('❌ Erreur lors de la suppression du projet: $e');
    }
  }

  /// Exemple de vérification des informations du projet
  Future<void> checkProjectInfoExample() async {
    try {
      print('🔍 Vérification des informations du projet...');

      final projectId = 1;

      // Obtenir le nom du projet
      final projectName = await _projectService.getProjectName(projectId);
      print('   Nom du projet: $projectName');

      // Obtenir le type du projet
      final projectType = await _projectService.getProjectType(projectId);
      print('   Type: ${projectType ?? 'Non défini'}');

      // Obtenir le statut du projet
      final projectStatus = await _projectService.getProjectStatus(projectId);
      print('   Statut: ${projectStatus ?? 'Non défini'}');

      // Obtenir la priorité du projet
      final projectPriority =
          await _projectService.getProjectPriority(projectId);
      print('   Priorité: ${projectPriority ?? 'Non définie'}');

      // Obtenir le budget du projet
      final projectBudget = await _projectService.getProjectBudget(projectId);
      print('   Budget: ${projectBudget ?? 'Non défini'}€');

      // Obtenir la devise du projet
      final projectCurrency =
          await _projectService.getProjectCurrency(projectId);
      print('   Devise: ${projectCurrency ?? 'Non définie'}');

      // Obtenir le nom du client
      final clientName = await _projectService.getProjectClientName(projectId);
      print('   Client: ${clientName ?? 'Non défini'}');

      // Obtenir l'email du client
      final clientEmail =
          await _projectService.getProjectClientEmail(projectId);
      print('   Email client: ${clientEmail ?? 'Non défini'}');

      // Obtenir la localisation
      final location = await _projectService.getProjectLocation(projectId);
      print('   Localisation: ${location ?? 'Non définie'}');

      // Obtenir le manager
      final manager = await _projectService.getProjectManager(projectId);
      print('   Manager: ${manager?['name'] ?? 'Aucun'}');

      // Obtenir le nombre de tâches
      final tasksCount = await _projectService.getProjectTasksCount(projectId);
      print('   Nombre de tâches: $tasksCount');

      // Obtenir le nombre de budgets
      final budgetsCount =
          await _projectService.getProjectBudgetsCount(projectId);
      print('   Nombre de budgets: $budgetsCount');

      // Obtenir les tâches
      final tasks = await _projectService.getProjectTasks(projectId);
      print('   Tâches: ${tasks.length}');

      // Obtenir les budgets
      final budgets = await _projectService.getProjectBudgets(projectId);
      print('   Budgets: ${budgets.length}');

      // Obtenir les membres de l'équipe
      final teamMembers =
          await _projectService.getProjectTeamMembers(projectId);
      print('   Membres de l\'équipe: $teamMembers');

      // Obtenir les tags
      final tags = await _projectService.getProjectTags(projectId);
      print('   Tags: $tags');

      // Obtenir les pièces jointes
      final attachments =
          await _projectService.getProjectAttachments(projectId);
      print('   Pièces jointes: $attachments');
    } catch (e) {
      print('❌ Erreur lors de la vérification des informations: $e');
    }
  }

  /// Exemple d'obtention des projets de l'utilisateur connecté
  Future<void> getMyProjectsExample() async {
    try {
      print('👤 Récupération de mes projets...');

      final myProjects = await _projectService.getMyProjects(perPage: 10);

      print('✅ Mes projets récupérés avec succès !');
      print('   Total: ${myProjects['pagination']['total']} projets');
      print('   Page actuelle: ${myProjects['pagination']['current_page']}');
      print('   Par page: ${myProjects['pagination']['per_page']}');

      print('\n👤 MES PROJETS:');
      for (final project in myProjects['data']) {
        print('   • ${project['name']}');
        print('     Type: ${project['type']}');
        print('     Statut: ${project['status']}');
        print('     Priorité: ${project['priority']}');
        print('     Client: ${project['client_name']}');
        print('     Localisation: ${project['location']}');
        print('     Manager: ${project['manager']?['name'] ?? 'Non défini'}');
        print('     Progrès: ${project['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de mes projets: $e');
    }
  }

  /// Exemple complet d'utilisation du service projet
  Future<void> completeProjectWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE PROJET ===\n');

      // 1. Créer un nouveau projet
      await createProjectExample();
      print('');

      // 2. Obtenir tous les projets
      await getAllProjectsExample();
      print('');

      // 3. Filtrer par statut
      await getProjectsByStatusExample();
      print('');

      // 4. Filtrer par type
      await getProjectsByTypeExample();
      print('');

      // 5. Filtrer par priorité
      await getProjectsByPriorityExample();
      print('');

      // 6. Rechercher des projets
      await searchProjectsExample();
      print('');

      // 7. Filtrer par gamme de budget
      await getProjectsByBudgetRangeExample();
      print('');

      // 8. Filtrer par gamme de progrès
      await getProjectsByProgressRangeExample();
      print('');

      // 9. Filtrer par période
      await getProjectsByPeriodExample();
      print('');

      // 10. Filtrer par localisation
      await getProjectsByLocationExample();
      print('');

      // 11. Filtrer par client
      await getProjectsByClientExample();
      print('');

      // 12. Filtrer par tags
      await getProjectsByTagsExample();
      print('');

      // 13. Obtenir les projets en retard
      await getOverdueProjectsExample();
      print('');

      // 14. Obtenir les projets à venir
      await getUpcomingProjectsExample();
      print('');

      // 15. Obtenir les projets récents
      await getRecentProjectsExample();
      print('');

      // 16. Filtrer par membre d'équipe
      await getProjectsByTeamMemberExample();
      print('');

      // 17. Filtrer par devise
      await getProjectsByCurrencyExample();
      print('');

      // 18. Mettre à jour le progrès
      await updateProjectProgressExample();
      print('');

      // 19. Obtenir les statistiques
      await getProjectStatsExample();
      print('');

      // 20. Mettre à jour le projet
      await updateProjectExample();
      print('');

      // 21. Vérifier les informations
      await checkProjectInfoExample();
      print('');

      // 22. Obtenir mes projets
      await getMyProjectsExample();
      print('');

      // 23. Supprimer le projet
      await deleteProjectExample();
      print('');

      print('✅ Workflow du service projet terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service projet: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de projets
      print('🏗️ TABLEAU DE BORD DES PROJETS:');

      // Récupérer les statistiques globales
      final allProjects = await _projectService.getProjects(perPage: 1000);
      print('📊 STATISTIQUES GLOBALES:');
      print('   Total des projets: ${allProjects['meta']['total']}');

      // Récupérer les projets en cours
      final inProgressProjects =
          await _projectService.getInProgressProjects(perPage: 5);
      print('\n🔄 PROJETS EN COURS:');
      print('   Projets actifs: ${inProgressProjects['data'].length}');

      // Récupérer les projets en retard
      final overdueProjects =
          await _projectService.getOverdueProjects(perPage: 5);
      print('\n⏰ PROJETS EN RETARD:');
      print(
          '   Projets en retard: ${overdueProjects['meta']['overdue_count']}');

      // Récupérer les projets à venir
      final upcomingProjects =
          await _projectService.getUpcomingProjects(perPage: 5);
      print('\n🚀 PROJETS À VENIR:');
      print(
          '   Projets à venir: ${upcomingProjects['meta']['upcoming_count']}');

      // Récupérer mes projets
      final myProjects = await _projectService.getMyProjects(perPage: 5);
      print('\n👤 MES PROJETS:');
      print('   Mes projets: ${myProjects['pagination']['total']}');
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service projet
void main() async {
  final projectExample = ProjectExample();

  // Exécuter le workflow complet
  await projectExample.completeProjectWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await projectExample.uiExample();
}

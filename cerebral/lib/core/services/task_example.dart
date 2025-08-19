import 'task_service.dart';

/// Exemple d'utilisation complète du service tâche
/// Basé sur le TaskController Laravel avec toutes les fonctionnalités avancées
class TaskExample {
  final TaskService _taskService = TaskService();

  /// Exemple de création d'une nouvelle tâche
  Future<void> createTaskExample() async {
    try {
      print('📋 Création d\'une nouvelle tâche...');

      final task = await _taskService.createTask(
        title: 'Développer l\'interface utilisateur du tableau de bord',
        description:
            'Créer une interface moderne et responsive pour le tableau de bord principal avec des graphiques et des métriques en temps réel',
        projectId: 1,
        status: 'pending',
        priority: 'high',
        dueDate: DateTime(2024, 12, 31),
        assignedTo: 2,
        estimatedHours: 40,
        actualHours: 0,
        notes: 'Utiliser Flutter avec des packages de graphiques avancés',
        attachments: ['maquettes_ui.pdf', 'specifications_techniques.md'],
        customFields: {
          'sprint': 'Sprint 3',
          'epic': 'Interface utilisateur',
          'story_points': 8,
        },
      );

      print('✅ Tâche créée avec succès !');
      print('   Titre: ${task['task']['title']}');
      print('   Description: ${task['task']['description']}');
      print('   Projet: ${task['task']['project']?['name'] ?? 'Non défini'}');
      print('   Statut: ${task['task']['status']}');
      print('   Priorité: ${task['task']['priority']}');
      print('   Date d\'échéance: ${task['task']['due_date']}');
      print(
          '   Assignée à: ${task['task']['assigned_to']?['name'] ?? 'Non assignée'}');
      print(
          '   Heures estimées: ${task['task']['estimated_hours'] ?? 'Non définies'}');
      print(
          '   Heures réelles: ${task['task']['actual_hours'] ?? 'Non définies'}');
      print('   Notes: ${task['task']['notes'] ?? 'Aucune'}');
      print('   Pièces jointes: ${task['task']['attachments'] ?? []}');
      print('   Champs personnalisés: ${task['task']['custom_fields'] ?? {}}');
      print('   Message: ${task['message']}');
    } catch (e) {
      print('❌ Erreur lors de la création de la tâche: $e');
    }
  }

  /// Exemple d'obtention de toutes les tâches
  Future<void> getAllTasksExample() async {
    try {
      print('📋 Récupération de toutes les tâches...');

      final tasks = await _taskService.getTasks(perPage: 10);

      print('✅ Tâches récupérées avec succès !');
      print('   Total: ${tasks['meta']['total']} tâches');
      print('   Page actuelle: ${tasks['meta']['current_page']}');
      print('   Par page: ${tasks['meta']['per_page']}');

      print('\n📋 TÂCHES:');
      for (final task in tasks['data']) {
        print('   • ${task['title']}');
        print('     Description: ${task['description']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('     Date d\'échéance: ${task['due_date'] ?? 'Non définie'}');
        print(
            '     Assignée à: ${task['assigned_to']?['name'] ?? 'Non assignée'}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print(
            '     Heures estimées: ${task['estimated_hours'] ?? 'Non définies'}');
        print('     Heures réelles: ${task['actual_hours'] ?? 'Non définies'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches: $e');
    }
  }

  /// Exemple de filtrage des tâches par statut
  Future<void> getTasksByStatusExample() async {
    try {
      print('📊 Récupération des tâches par statut...');

      // Tâches en attente
      final pendingTasks = await _taskService.getPendingTasks(perPage: 5);
      print('\n⏳ TÂCHES EN ATTENTE:');
      print('   Nombre: ${pendingTasks['data'].length}');

      // Tâches en cours
      final inProgressTasks = await _taskService.getInProgressTasks(perPage: 5);
      print('\n🔄 TÂCHES EN COURS:');
      print('   Nombre: ${inProgressTasks['data'].length}');

      // Tâches en révision
      final reviewTasks = await _taskService.getReviewTasks(perPage: 5);
      print('\n👀 TÂCHES EN RÉVISION:');
      print('   Nombre: ${reviewTasks['data'].length}');

      // Tâches terminées
      final completedTasks = await _taskService.getCompletedTasks(perPage: 5);
      print('\n✅ TÂCHES TERMINÉES:');
      print('   Nombre: ${completedTasks['data'].length}');

      // Tâches annulées
      final cancelledTasks = await _taskService.getCancelledTasks(perPage: 5);
      print('\n❌ TÂCHES ANNULÉES:');
      print('   Nombre: ${cancelledTasks['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple de filtrage des tâches par priorité
  Future<void> getTasksByPriorityExample() async {
    try {
      print('⭐ Récupération des tâches par priorité...');

      // Tâches de priorité basse
      final lowPriorityTasks =
          await _taskService.getLowPriorityTasks(perPage: 5);
      print('\n🟢 PRIORITÉ BASSE:');
      print('   Nombre: ${lowPriorityTasks['data'].length}');

      // Tâches de priorité moyenne
      final mediumPriorityTasks =
          await _taskService.getMediumPriorityTasks(perPage: 5);
      print('\n🟡 PRIORITÉ MOYENNE:');
      print('   Nombre: ${mediumPriorityTasks['data'].length}');

      // Tâches de priorité haute
      final highPriorityTasks =
          await _taskService.getHighPriorityTasks(perPage: 5);
      print('\n🟠 PRIORITÉ HAUTE:');
      print('   Nombre: ${highPriorityTasks['data'].length}');

      // Tâches de priorité critique
      final criticalPriorityTasks =
          await _taskService.getCriticalPriorityTasks(perPage: 5);
      print('\n🔴 PRIORITÉ CRITIQUE:');
      print('   Nombre: ${criticalPriorityTasks['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par priorité: $e');
    }
  }

  /// Exemple de filtrage des tâches par projet
  Future<void> getTasksByProjectExample() async {
    try {
      print('🏗️ Récupération des tâches par projet...');

      final projectTasks = await _taskService.getTasksByProject(1, perPage: 10);

      print('✅ Tâches du projet récupérées avec succès !');
      print('   ID Projet: 1');
      print('   Nombre de tâches: ${projectTasks['data'].length}');

      print('\n🏗️ TÂCHES DU PROJET:');
      for (final task in projectTasks['data']) {
        print('   • ${task['title']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print(
            '     Assignée à: ${task['assigned_to']?['name'] ?? 'Non assignée'}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors du filtrage par projet: $e');
    }
  }

  /// Exemple de filtrage des tâches par utilisateur
  Future<void> getTasksByUserExample() async {
    try {
      print('👤 Récupération des tâches par utilisateur...');

      final userTasks = await _taskService.getTasksByUser(2, perPage: 10);

      print('✅ Tâches de l\'utilisateur récupérées avec succès !');
      print('   ID Utilisateur: 2');
      print('   Nombre de tâches: ${userTasks['data'].length}');

      print('\n👤 TÂCHES DE L\'UTILISATEUR:');
      for (final task in userTasks['data']) {
        print('   • ${task['title']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors du filtrage par utilisateur: $e');
    }
  }

  /// Exemple de recherche de tâches
  Future<void> searchTasksExample() async {
    try {
      print('🔍 Recherche de tâches...');

      final searchResults =
          await _taskService.searchTasks('développement', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: développement');
      print('   Résultats trouvés: ${searchResults['data'].length}');

      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final task in searchResults['data']) {
        print('   • ${task['title']}');
        print('     Description: ${task['description']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des tâches par gamme de progression
  Future<void> getTasksByProgressRangeExample() async {
    try {
      print('📈 Récupération des tâches par gamme de progression...');

      final progressRangeTasks = await _taskService.getTasksByProgressRange(
        minProgress: 50.0,
        maxProgress: 100.0,
        perPage: 10,
      );

      print('✅ Tâches de la gamme de progression récupérées avec succès !');
      print('   Gamme: 50% à 100%');
      print(
          '   Nombre de tâches: ${progressRangeTasks['meta']['progress_range_count']}');

      print('\n📈 TÂCHES DE LA GAMME DE PROGRESSION:');
      for (final task in progressRangeTasks['data']) {
        print('   • ${task['title']}');
        print('     Progression: ${task['progress']}%');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par gamme de progression: $e');
    }
  }

  /// Exemple d'obtention des tâches par gamme d'heures estimées
  Future<void> getTasksByEstimatedHoursRangeExample() async {
    try {
      print('⏱️ Récupération des tâches par gamme d\'heures estimées...');

      final hoursRangeTasks = await _taskService.getTasksByEstimatedHoursRange(
        minHours: 20,
        maxHours: 80,
        perPage: 10,
      );

      print('✅ Tâches de la gamme d\'heures estimées récupérées avec succès !');
      print('   Gamme: 20 à 80 heures');
      print(
          '   Nombre de tâches: ${hoursRangeTasks['meta']['hours_range_count']}');

      print('\n⏱️ TÂCHES DE LA GAMME D\'HEURES:');
      for (final task in hoursRangeTasks['data']) {
        print('   • ${task['title']}');
        print('     Heures estimées: ${task['estimated_hours']}');
        print('     Heures réelles: ${task['actual_hours'] ?? 'Non définies'}');
        print('     Statut: ${task['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par gamme d\'heures: $e');
    }
  }

  /// Exemple d'obtention des tâches par gamme d'heures réelles
  Future<void> getTasksByActualHoursRangeExample() async {
    try {
      print('⏱️ Récupération des tâches par gamme d\'heures réelles...');

      final hoursRangeTasks = await _taskService.getTasksByActualHoursRange(
        minHours: 10,
        maxHours: 50,
        perPage: 10,
      );

      print('✅ Tâches de la gamme d\'heures réelles récupérées avec succès !');
      print('   Gamme: 10 à 50 heures');
      print(
          '   Nombre de tâches: ${hoursRangeTasks['meta']['hours_range_count']}');

      print('\n⏱️ TÂCHES DE LA GAMME D\'HEURES RÉELLES:');
      for (final task in hoursRangeTasks['data']) {
        print('   • ${task['title']}');
        print(
            '     Heures estimées: ${task['estimated_hours'] ?? 'Non définies'}');
        print('     Heures réelles: ${task['actual_hours']}');
        print('     Statut: ${task['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par gamme d\'heures réelles: $e');
    }
  }

  /// Exemple d'obtention des tâches par période d'échéance
  Future<void> getTasksByDueDateRangeExample() async {
    try {
      print('📅 Récupération des tâches par période d\'échéance...');

      final startDate = DateTime(2024, 12, 1);
      final endDate = DateTime(2024, 12, 31);

      final dueDateRangeTasks = await _taskService.getTasksByDueDateRange(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Tâches de la période d\'échéance récupérées avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print(
          '   Nombre de tâches: ${dueDateRangeTasks['meta']['due_date_range_count']}');

      print('\n📅 TÂCHES DE LA PÉRIODE D\'ÉCHÉANCE:');
      for (final task in dueDateRangeTasks['data']) {
        print('   • ${task['title']}');
        print('     Date d\'échéance: ${task['due_date']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par période d\'échéance: $e');
    }
  }

  /// Exemple d'obtention des tâches par période de création
  Future<void> getTasksByCreationDateRangeExample() async {
    try {
      print('📅 Récupération des tâches par période de création...');

      final startDate = DateTime(2024, 11, 1);
      final endDate = DateTime(2024, 11, 30);

      final creationDateRangeTasks =
          await _taskService.getTasksByCreationDateRange(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Tâches de la période de création récupérées avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print(
          '   Nombre de tâches: ${creationDateRangeTasks['meta']['creation_date_range_count']}');

      print('\n📅 TÂCHES DE LA PÉRIODE DE CRÉATION:');
      for (final task in creationDateRangeTasks['data']) {
        print('   • ${task['title']}');
        print('     Date de création: ${task['created_at']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par période de création: $e');
    }
  }

  /// Exemple d'obtention des tâches par efficacité
  Future<void> getTasksByEfficiencyExample() async {
    try {
      print('🚀 Récupération des tâches par efficacité...');

      final efficiencyTasks = await _taskService.getTasksByEfficiency(
        minEfficiency: 20.0,
        maxEfficiency: 100.0,
        perPage: 10,
      );

      print('✅ Tâches par efficacité récupérées avec succès !');
      print('   Gamme d\'efficacité: 20% à 100%');
      print(
          '   Nombre de tâches: ${efficiencyTasks['meta']['efficiency_range_count']}');

      print('\n🚀 TÂCHES PAR EFFICACITÉ:');
      for (final task in efficiencyTasks['data']) {
        final estimatedHours = task['estimated_hours'] ?? 0;
        final actualHours = task['actual_hours'] ?? 0;
        final efficiency = estimatedHours > 0
            ? ((estimatedHours - actualHours) / estimatedHours) * 100
            : 0;

        print('   • ${task['title']}');
        print('     Heures estimées: $estimatedHours');
        print('     Heures réelles: $actualHours');
        print('     Efficacité: ${efficiency.toStringAsFixed(2)}%');
        print('     Statut: ${task['status']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par efficacité: $e');
    }
  }

  /// Exemple d'obtention des tâches récentes
  Future<void> getRecentTasksExample() async {
    try {
      print('🕐 Récupération des tâches récentes...');

      final recentTasks = await _taskService.getRecentTasks(perPage: 10);

      print('✅ Tâches récentes récupérées avec succès !');
      print('   Nombre de tâches: ${recentTasks['meta']['recent_count']}');
      print('   Période: 7 derniers jours');

      print('\n🕐 TÂCHES RÉCENTES:');
      for (final task in recentTasks['data']) {
        print('   • ${task['title']}');
        print('     Date de création: ${task['created_at']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches récentes: $e');
    }
  }

  /// Exemple d'obtention des tâches à venir
  Future<void> getUpcomingTasksExample() async {
    try {
      print('🚀 Récupération des tâches à venir...');

      final upcomingTasks = await _taskService.getUpcomingTasks(perPage: 10);

      print('✅ Tâches à venir récupérées avec succès !');
      print('   Nombre de tâches: ${upcomingTasks['meta']['upcoming_count']}');
      print('   Période: 7 prochains jours');

      print('\n🚀 TÂCHES À VENIR:');
      for (final task in upcomingTasks['data']) {
        print('   • ${task['title']}');
        print('     Date d\'échéance: ${task['due_date']}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches à venir: $e');
    }
  }

  /// Exemple d'obtention des tâches par projet et statut
  Future<void> getTasksByProjectAndStatusExample() async {
    try {
      print('🏗️ Récupération des tâches par projet et statut...');

      final projectStatusTasks = await _taskService.getTasksByProjectAndStatus(
        projectId: 1,
        status: 'in_progress',
        perPage: 10,
      );

      print('✅ Tâches du projet par statut récupérées avec succès !');
      print('   ID Projet: 1');
      print('   Statut: in_progress');
      print('   Nombre de tâches: ${projectStatusTasks['data'].length}');

      print('\n🏗️ TÂCHES DU PROJET EN COURS:');
      for (final task in projectStatusTasks['data']) {
        print('   • ${task['title']}');
        print('     Priorité: ${task['priority']}');
        print(
            '     Assignée à: ${task['assigned_to']?['name'] ?? 'Non assignée'}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par projet et statut: $e');
    }
  }

  /// Exemple d'obtention des tâches par utilisateur et priorité
  Future<void> getTasksByUserAndPriorityExample() async {
    try {
      print('👤 Récupération des tâches par utilisateur et priorité...');

      final userPriorityTasks = await _taskService.getTasksByUserAndPriority(
        userId: 2,
        priority: 'high',
        perPage: 10,
      );

      print('✅ Tâches de l\'utilisateur par priorité récupérées avec succès !');
      print('   ID Utilisateur: 2');
      print('   Priorité: high');
      print('   Nombre de tâches: ${userPriorityTasks['data'].length}');

      print('\n👤 TÂCHES HAUTE PRIORITÉ DE L\'UTILISATEUR:');
      for (final task in userPriorityTasks['data']) {
        print('   • ${task['title']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print('     Statut: ${task['status']}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération par utilisateur et priorité: $e');
    }
  }

  /// Exemple de mise à jour du statut d'une tâche
  Future<void> updateTaskStatusExample() async {
    try {
      print('🔄 Mise à jour du statut de la tâche...');

      final updatedTask = await _taskService.updateTaskStatus(
        1, // ID de la tâche
        status: 'in_progress',
        progress: 25.0,
      );

      print('✅ Statut de la tâche mis à jour avec succès !');
      print('   Titre: ${updatedTask['data']['title']}');
      print('   Nouveau statut: ${updatedTask['data']['status']}');
      print('   Nouvelle progression: ${updatedTask['data']['progress']}%');
      print('   Message: ${updatedTask['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du statut: $e');
    }
  }

  /// Exemple de mise à jour de la progression d'une tâche
  Future<void> updateTaskProgressExample() async {
    try {
      print('📈 Mise à jour de la progression de la tâche...');

      final updatedTask = await _taskService.updateTaskProgress(
        1, // ID de la tâche
        progress: 50.0,
      );

      print('✅ Progression de la tâche mise à jour avec succès !');
      print('   Titre: ${updatedTask['data']['title']}');
      print('   Nouvelle progression: ${updatedTask['data']['progress']}%');
      print('   Message: ${updatedTask['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour de la progression: $e');
    }
  }

  /// Exemple d'assignation d'une tâche
  Future<void> assignTaskExample() async {
    try {
      print('👤 Assignation d\'une tâche...');

      final assignedTask = await _taskService.assignTask(
        1, // ID de la tâche
        assignedTo: 3,
        assignmentNotes: 'Assignation pour expertise technique',
      );

      print('✅ Tâche assignée avec succès !');
      print('   Titre: ${assignedTask['data']['title']}');
      print(
          '   Assignée à: ${assignedTask['data']['assigned_to']?['name'] ?? 'Non défini'}');
      print(
          '   Assignée par: ${assignedTask['data']['assigned_by']?['name'] ?? 'Non défini'}');
      print(
          '   Notes d\'assignation: ${assignedTask['data']['assignment_notes'] ?? 'Aucune'}');
      print('   Date d\'assignation: ${assignedTask['data']['assigned_at']}');
      print('   Message: ${assignedTask['message']}');
    } catch (e) {
      print('❌ Erreur lors de l\'assignation: $e');
    }
  }

  /// Exemple d'obtention de mes tâches
  Future<void> getMyTasksExample() async {
    try {
      print('👤 Récupération de mes tâches...');

      final myTasks = await _taskService.getMyTasks(perPage: 10);

      print('✅ Mes tâches récupérées avec succès !');
      print('   Total: ${myTasks['meta']['total']} tâches');
      print('   Page actuelle: ${myTasks['meta']['current_page']}');
      print('   Par page: ${myTasks['meta']['per_page']}');

      print('\n👤 MES TÂCHES:');
      for (final task in myTasks['data']) {
        print('   • ${task['title']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print('     Statut: ${task['status']}');
        print('     Priorité: ${task['priority']}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('     Date d\'échéance: ${task['due_date'] ?? 'Non définie'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de mes tâches: $e');
    }
  }

  /// Exemple d'obtention des tâches en retard
  Future<void> getOverdueTasksExample() async {
    try {
      print('⏰ Récupération des tâches en retard...');

      final overdueTasks = await _taskService.getOverdueTasks(perPage: 10);

      print('✅ Tâches en retard récupérées avec succès !');
      print('   Total: ${overdueTasks['meta']['total']} tâches');
      print('   Page actuelle: ${overdueTasks['meta']['current_page']}');
      print('   Par page: ${overdueTasks['meta']['per_page']}');

      print('\n⏰ TÂCHES EN RETARD:');
      for (final task in overdueTasks['data']) {
        print('   • ${task['title']}');
        print('     Projet: ${task['project']?['name'] ?? 'Non défini'}');
        print(
            '     Assignée à: ${task['assigned_to']?['name'] ?? 'Non assignée'}');
        print('     Date d\'échéance: ${task['due_date']}');
        print('     Statut: ${task['status']}');
        print('     Progression: ${task['progress'] ?? 0}%');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des tâches en retard: $e');
    }
  }

  /// Exemple de vérification des informations de la tâche
  Future<void> checkTaskInfoExample() async {
    try {
      print('🔍 Vérification des informations de la tâche...');

      final taskId = 1;

      // Obtenir le titre de la tâche
      final taskTitle = await _taskService.getTaskTitle(taskId);
      print('   Titre: $taskTitle');

      // Obtenir le statut de la tâche
      final taskStatus = await _taskService.getTaskStatus(taskId);
      print('   Statut: ${taskStatus ?? 'Non défini'}');

      // Obtenir la priorité de la tâche
      final taskPriority = await _taskService.getTaskPriority(taskId);
      print('   Priorité: ${taskPriority ?? 'Non définie'}');

      // Obtenir la progression de la tâche
      final taskProgress = await _taskService.getTaskProgress(taskId);
      print('   Progression: ${taskProgress ?? 'Non définie'}%');

      // Obtenir la date d'échéance de la tâche
      final taskDueDate = await _taskService.getTaskDueDate(taskId);
      print(
          '   Date d\'échéance: ${taskDueDate?.toIso8601String() ?? 'Non définie'}');

      // Obtenir le projet de la tâche
      final taskProject = await _taskService.getTaskProject(taskId);
      print('   Projet: ${taskProject?['name'] ?? 'Non défini'}');

      // Obtenir l'utilisateur assigné à la tâche
      final taskAssignedTo = await _taskService.getTaskAssignedTo(taskId);
      print('   Assignée à: ${taskAssignedTo?['name'] ?? 'Non assignée'}');

      // Obtenir l'utilisateur qui a créé la tâche
      final taskCreatedBy = await _taskService.getTaskCreatedBy(taskId);
      print('   Créée par: ${taskCreatedBy?['name'] ?? 'Non défini'}');

      // Obtenir les heures estimées de la tâche
      final taskEstimatedHours =
          await _taskService.getTaskEstimatedHours(taskId);
      print('   Heures estimées: ${taskEstimatedHours ?? 'Non définies'}');

      // Obtenir les heures réelles de la tâche
      final taskActualHours = await _taskService.getTaskActualHours(taskId);
      print('   Heures réelles: ${taskActualHours ?? 'Non définies'}');

      // Obtenir l'efficacité de la tâche
      final taskEfficiency = await _taskService.getTaskEfficiency(taskId);
      print(
          '   Efficacité: ${taskEfficiency?.toStringAsFixed(2) ?? 'Non définie'}%');

      // Obtenir les notes de la tâche
      final taskNotes = await _taskService.getTaskNotes(taskId);
      print('   Notes: ${taskNotes ?? 'Aucune'}');

      // Obtenir les pièces jointes de la tâche
      final taskAttachments = await _taskService.getTaskAttachments(taskId);
      print('   Pièces jointes: $taskAttachments');

      // Obtenir les champs personnalisés de la tâche
      final taskCustomFields = await _taskService.getTaskCustomFields(taskId);
      print('   Champs personnalisés: $taskCustomFields');

      // Vérifier si la tâche est en retard
      final isTaskOverdue = await _taskService.isTaskOverdue(taskId);
      print('   En retard: ${isTaskOverdue ? 'Oui' : 'Non'}');

      // Obtenir le nombre de jours de retard
      final taskOverdueDays = await _taskService.getTaskOverdueDays(taskId);
      print('   Jours de retard: ${taskOverdueDays ?? 'Aucun'}');

      // Obtenir le nombre de jours restants
      final taskRemainingDays = await _taskService.getTaskRemainingDays(taskId);
      print('   Jours restants: ${taskRemainingDays ?? 'Non défini'}');
    } catch (e) {
      print('❌ Erreur lors de la vérification des informations: $e');
    }
  }

  /// Exemple de mise à jour de la tâche
  Future<void> updateTaskExample() async {
    try {
      print('✏️ Mise à jour de la tâche...');

      final updatedTask = await _taskService.updateTask(
        1, // ID de la tâche
        status: 'in_progress',
        // progress: 75.0,
        actualHours: 30,
        notes: 'Progression significative sur l\'interface utilisateur',
      );

      print('✅ Tâche mise à jour avec succès !');
      print('   Titre: ${updatedTask['data']['title']}');
      print('   Nouveau statut: ${updatedTask['data']['status']}');
      print('   Nouvelle progression: ${updatedTask['data']['progress']}%');
      print(
          '   Nouvelles heures réelles: ${updatedTask['data']['actual_hours']}');
      print('   Nouvelles notes: ${updatedTask['data']['notes']}');
      print('   Message: ${updatedTask['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour de la tâche: $e');
    }
  }

  /// Exemple de suppression de la tâche
  Future<void> deleteTaskExample() async {
    try {
      print('🗑️ Suppression de la tâche...');

      // Vérifier si la tâche peut être supprimée
      final canDelete = await _taskService.canDeleteTask(1);
      print('   Peut être supprimée: ${canDelete ? 'Oui' : 'Non'}');

      if (canDelete) {
        final result = await _taskService.deleteTask(1);
        print('✅ Tâche supprimée avec succès !');
        print('   Message: ${result['message']}');
      } else {
        print('❌ La tâche ne peut pas être supprimée');
        print('   Raison: Tâche terminée ou en cours');
      }
    } catch (e) {
      print('❌ Erreur lors de la suppression de la tâche: $e');
    }
  }

  /// Exemple complet d'utilisation du service tâche
  Future<void> completeTaskWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE TÂCHE ===\n');

      // 1. Créer une nouvelle tâche
      await createTaskExample();
      print('');

      // 2. Obtenir toutes les tâches
      await getAllTasksExample();
      print('');

      // 3. Filtrer par statut
      await getTasksByStatusExample();
      print('');

      // 4. Filtrer par priorité
      await getTasksByPriorityExample();
      print('');

      // 5. Filtrer par projet
      await getTasksByProjectExample();
      print('');

      // 6. Filtrer par utilisateur
      await getTasksByUserExample();
      print('');

      // 7. Rechercher des tâches
      await searchTasksExample();
      print('');

      // 8. Filtrer par gamme de progression
      await getTasksByProgressRangeExample();
      print('');

      // 9. Filtrer par gamme d'heures estimées
      await getTasksByEstimatedHoursRangeExample();
      print('');

      // 10. Filtrer par gamme d'heures réelles
      await getTasksByActualHoursRangeExample();
      print('');

      // 11. Filtrer par période d'échéance
      await getTasksByDueDateRangeExample();
      print('');

      // 12. Filtrer par période de création
      await getTasksByCreationDateRangeExample();
      print('');

      // 13. Filtrer par efficacité
      await getTasksByEfficiencyExample();
      print('');

      // 14. Obtenir les tâches récentes
      await getRecentTasksExample();
      print('');

      // 15. Obtenir les tâches à venir
      await getUpcomingTasksExample();
      print('');

      // 16. Filtrer par projet et statut
      await getTasksByProjectAndStatusExample();
      print('');

      // 17. Filtrer par utilisateur et priorité
      await getTasksByUserAndPriorityExample();
      print('');

      // 18. Mettre à jour le statut
      await updateTaskStatusExample();
      print('');

      // 19. Mettre à jour la progression
      await updateTaskProgressExample();
      print('');

      // 20. Assigner la tâche
      await assignTaskExample();
      print('');

      // 21. Obtenir mes tâches
      await getMyTasksExample();
      print('');

      // 22. Obtenir les tâches en retard
      await getOverdueTasksExample();
      print('');

      // 23. Vérifier les informations
      await checkTaskInfoExample();
      print('');

      // 24. Mettre à jour la tâche
      await updateTaskExample();
      print('');

      // 25. Supprimer la tâche
      await deleteTaskExample();
      print('');

      print('✅ Workflow du service tâche terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service tâche: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de tâches
      print('📋 TABLEAU DE BORD DES TÂCHES:');

      // Récupérer les statistiques globales
      final allTasks = await _taskService.getTasks(perPage: 1000);
      print('📊 STATISTIQUES GLOBALES:');
      print('   Total des tâches: ${allTasks['meta']['total']}');

      // Récupérer les tâches par statut
      final pendingTasks = await _taskService.getPendingTasks(perPage: 5);
      print('\n⏳ TÂCHES EN ATTENTE:');
      print('   Tâches en attente: ${pendingTasks['data'].length}');

      final inProgressTasks = await _taskService.getInProgressTasks(perPage: 5);
      print('\n🔄 TÂCHES EN COURS:');
      print('   Tâches en cours: ${inProgressTasks['data'].length}');

      final completedTasks = await _taskService.getCompletedTasks(perPage: 5);
      print('\n✅ TÂCHES TERMINÉES:');
      print('   Tâches terminées: ${completedTasks['data'].length}');

      // Récupérer les tâches par priorité
      final highPriorityTasks =
          await _taskService.getHighPriorityTasks(perPage: 5);
      print('\n🟠 TÂCHES HAUTE PRIORITÉ:');
      print('   Tâches haute priorité: ${highPriorityTasks['data'].length}');

      // Récupérer mes tâches
      final myTasks = await _taskService.getMyTasks(perPage: 5);
      print('\n👤 MES TÂCHES:');
      print('   Mes tâches: ${myTasks['meta']['total']}');

      // Récupérer les tâches en retard
      final overdueTasks = await _taskService.getOverdueTasks(perPage: 5);
      print('\n⏰ TÂCHES EN RETARD:');
      print('   Tâches en retard: ${overdueTasks['meta']['total']}');
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service tâche
void main() async {
  final taskExample = TaskExample();

  // Exécuter le workflow complet
  await taskExample.completeTaskWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await taskExample.uiExample();
}

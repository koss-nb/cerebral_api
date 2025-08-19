import 'time_tracking_service.dart';

/// Exemple d'utilisation complète du service de suivi du temps
/// Basé sur le TimeTrackingController Laravel avec toutes les fonctionnalités avancées
class TimeTrackingExample {
  final TimeTrackingService _timeTrackingService = TimeTrackingService();

  /// Exemple de pointage d'arrivée
  Future<void> clockInExample() async {
    try {
      print('⏰ Pointage d\'arrivée...');
      
      // Vérifier si l'utilisateur peut pointer l'arrivée
      final canClockIn = await _timeTrackingService.canClockIn();
      
      if (canClockIn) {
        final clockIn = await _timeTrackingService.clockIn(
          projectId: 1,
          notes: 'Arrivée sur le chantier - Villa A3',
          location: 'Villa A3 - Zone résidentielle',
        );

        print('✅ Pointage d\'arrivée enregistré avec succès !');
        print('   Projet: ${clockIn['data']['project']?['name'] ?? 'Non défini'}');
        print('   Localisation: ${clockIn['data']['location'] ?? 'Non définie'}');
        print('   Heure d\'arrivée: ${clockIn['data']['clock_in']}');
        print('   Notes: ${clockIn['data']['notes'] ?? 'Aucune'}');
        print('   Statut: ${clockIn['data']['status']}');
        print('   Message: ${clockIn['message']}');
      } else {
        print('❌ Impossible de pointer l\'arrivée');
        print('   Raison: Pointage actif déjà en cours');
      }

    } catch (e) {
      print('❌ Erreur lors du pointage d\'arrivée: $e');
    }
  }

  /// Exemple de pointage de départ
  Future<void> clockOutExample() async {
    try {
      print('⏰ Pointage de départ...');
      
      // Vérifier si l'utilisateur peut pointer le départ
      final canClockOut = await _timeTrackingService.canClockOut();
      
      if (canClockOut) {
        final clockOut = await _timeTrackingService.clockOut(
          notes: 'Fin de journée - Travaux terminés',
        );

        print('✅ Pointage de départ enregistré avec succès !');
        print('   Projet: ${clockOut['data']['project']?['name'] ?? 'Non défini'}');
        print('   Heure d\'arrivée: ${clockOut['data']['clock_in']}');
        print('   Heure de départ: ${clockOut['data']['clock_out']}');
        print('   Notes: ${clockOut['data']['notes'] ?? 'Aucune'}');
        print('   Statut: ${clockOut['data']['status']}');
        print('   Message: ${clockOut['message']}');
      } else {
        print('❌ Impossible de pointer le départ');
        print('   Raison: Aucun pointage actif trouvé');
      }

    } catch (e) {
      print('❌ Erreur lors du pointage de départ: $e');
    }
  }

  /// Exemple d'obtention de l'historique des pointages
  Future<void> getHistoryExample() async {
    try {
      print('📋 Récupération de l\'historique des pointages...');
      
      final history = await _timeTrackingService.getHistory(perPage: 10);

      print('✅ Historique des pointages récupéré avec succès !');
      print('   Total: ${history['data']['total'] ?? 0} entrées');
      print('   Page actuelle: ${history['data']['current_page'] ?? 1}');
      print('   Par page: ${history['data']['per_page'] ?? 20}');
      
      print('\n📋 HISTORIQUE DES POINTAGES:');
      for (final entry in history['data']['data'] ?? []) {
        print('   • ${entry['user']?['first_name'] ?? 'Utilisateur'} ${entry['user']?['last_name'] ?? 'Inconnu'}');
        print('     Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique: $e');
    }
  }

  /// Exemple d'obtention du statut de l'équipe
  Future<void> getTeamStatusExample() async {
    try {
      print('👥 Récupération du statut de l\'équipe...');
      
      final teamStatus = await _timeTrackingService.getTeamStatus();

      print('✅ Statut de l\'équipe récupéré avec succès !');
      print('   Total d\'utilisateurs actifs: ${teamStatus['data']['total_active']}');
      
      print('\n👥 UTILISATEURS ACTIFS:');
      for (final user in teamStatus['data']['users'] ?? []) {
        print('   • ${user['user_name']}');
        print('     Projet: ${user['project_name']}');
        print('     Heure d\'arrivée: ${user['clock_in']}');
        print('     Localisation: ${user['location'] ?? 'Non définie'}');
        print('     Durée: ${user['duration']?.toStringAsFixed(2) ?? '0'} heures');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du statut de l\'équipe: $e');
    }
  }

  /// Exemple d'obtention du pointage actuel
  Future<void> getCurrentExample() async {
    try {
      print('🕐 Récupération du pointage actuel...');
      
      final current = await _timeTrackingService.getCurrent();

      print('✅ Pointage actuel récupéré avec succès !');
      
      if (current['data'] != null) {
        print('   Projet: ${current['data']['project']?['name'] ?? 'Non défini'}');
        print('   Heure d\'arrivée: ${current['data']['clock_in']}');
        print('   Localisation: ${current['data']['location'] ?? 'Non définie'}');
        print('   Notes: ${current['data']['notes'] ?? 'Aucune'}');
        print('   Statut: ${current['data']['status']}');
      } else {
        print('   Aucun pointage actif');
        print('   Message: ${current['message']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du pointage actuel: $e');
    }
  }

  /// Exemple de vérification du statut du pointage
  Future<void> checkTrackingStatusExample() async {
    try {
      print('🔍 Vérification du statut du pointage...');
      
      // Vérifier si l'utilisateur a un pointage actif
      final hasActive = await _timeTrackingService.hasActiveTracking();
      print('   Pointage actif: ${hasActive ? 'Oui' : 'Non'}');
      
      // Obtenir le statut du pointage
      final status = await _timeTrackingService.getTrackingStatus();
      print('   Statut: $status');
      
      // Vérifier si l'utilisateur peut pointer l'arrivée
      final canClockIn = await _timeTrackingService.canClockIn();
      print('   Peut pointer l\'arrivée: ${canClockIn ? 'Oui' : 'Non'}');
      
      // Vérifier si l'utilisateur peut pointer le départ
      final canClockOut = await _timeTrackingService.canClockOut();
      print('   Peut pointer le départ: ${canClockOut ? 'Oui' : 'Non'}');

    } catch (e) {
      print('❌ Erreur lors de la vérification du statut: $e');
    }
  }

  /// Exemple d'obtention du pointage actif
  Future<void> getActiveTrackingExample() async {
    try {
      print('🔄 Récupération du pointage actif...');
      
      final activeTracking = await _timeTrackingService.getActiveTracking();

      if (activeTracking != null) {
        print('✅ Pointage actif récupéré avec succès !');
        print('   Projet: ${activeTracking['project']?['name'] ?? 'Non défini'}');
        print('   Heure d\'arrivée: ${activeTracking['clock_in']}');
        print('   Localisation: ${activeTracking['location'] ?? 'Non définie'}');
        print('   Notes: ${activeTracking['notes'] ?? 'Aucune'}');
        print('   Statut: ${activeTracking['status']}');
      } else {
        print('ℹ️ Aucun pointage actif trouvé');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du pointage actif: $e');
    }
  }

  /// Exemple d'obtention de l'historique personnel
  Future<void> getMyHistoryExample() async {
    try {
      print('👤 Récupération de mon historique...');
      
      final myHistory = await _timeTrackingService.getMyHistory(perPage: 10);

      print('✅ Mon historique récupéré avec succès !');
      print('   Total: ${myHistory['data']['total'] ?? 0} entrées');
      print('   Page actuelle: ${myHistory['data']['current_page'] ?? 1}');
      print('   Par page: ${myHistory['data']['per_page'] ?? 20}');
      
      print('\n👤 MON HISTORIQUE:');
      for (final entry in myHistory['data']['data'] ?? []) {
        print('   • Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de mon historique: $e');
    }
  }

  /// Exemple d'obtention de l'historique d'un projet
  Future<void> getProjectHistoryExample() async {
    try {
      print('🏗️ Récupération de l\'historique du projet...');
      
      final projectHistory = await _timeTrackingService.getProjectHistory(
        projectId: 1,
        perPage: 10,
      );

      print('✅ Historique du projet récupéré avec succès !');
      print('   ID Projet: 1');
      print('   Total: ${projectHistory['data']['total'] ?? 0} entrées');
      print('   Page actuelle: ${projectHistory['data']['current_page'] ?? 1}');
      print('   Par page: ${projectHistory['data']['per_page'] ?? 20}');
      
      print('\n🏗️ HISTORIQUE DU PROJET:');
      for (final entry in projectHistory['data']['data'] ?? []) {
        print('   • ${entry['user']?['first_name'] ?? 'Utilisateur'} ${entry['user']?['last_name'] ?? 'Inconnu'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique du projet: $e');
    }
  }

  /// Exemple d'obtention de l'historique d'un utilisateur
  Future<void> getUserHistoryExample() async {
    try {
      print('👤 Récupération de l\'historique d\'un utilisateur...');
      
      final userHistory = await _timeTrackingService.getUserHistory(
        userId: 2,
        perPage: 10,
      );

      print('✅ Historique de l\'utilisateur récupéré avec succès !');
      print('   ID Utilisateur: 2');
      print('   Total: ${userHistory['data']['total'] ?? 0} entrées');
      print('   Page actuelle: ${userHistory['data']['current_page'] ?? 1}');
      print('   Par page: ${userHistory['data']['per_page'] ?? 20}');
      
      print('\n👤 HISTORIQUE DE L\'UTILISATEUR:');
      for (final entry in userHistory['data']['data'] ?? []) {
        print('   • Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique de l\'utilisateur: $e');
    }
  }

  /// Exemple d'obtention de l'historique d'une date
  Future<void> getDateHistoryExample() async {
    try {
      print('📅 Récupération de l\'historique d\'une date...');
      
      final date = DateTime.now();
      final dateHistory = await _timeTrackingService.getDateHistory(
        date: date,
        perPage: 10,
      );

      print('✅ Historique de la date récupéré avec succès !');
      print('   Date: ${date.toIso8601String().split('T')[0]}');
      print('   Total: ${dateHistory['data']['total'] ?? 0} entrées');
      print('   Page actuelle: ${dateHistory['data']['current_page'] ?? 1}');
      print('   Par page: ${dateHistory['data']['per_page'] ?? 20}');
      
      print('\n📅 HISTORIQUE DE LA DATE:');
      for (final entry in dateHistory['data']['data'] ?? []) {
        print('   • ${entry['user']?['first_name'] ?? 'Utilisateur'} ${entry['user']?['last_name'] ?? 'Inconnu'}');
        print('     Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique de la date: $e');
    }
  }

  /// Exemple d'obtention de l'historique de la semaine en cours
  Future<void> getCurrentWeekHistoryExample() async {
    try {
      print('📅 Récupération de l\'historique de la semaine en cours...');
      
      final weekHistory = await _timeTrackingService.getCurrentWeekHistory(perPage: 10);

      print('✅ Historique de la semaine récupéré avec succès !');
      print('   Période: ${weekHistory['meta']['start_date']} à ${weekHistory['meta']['end_date']}');
      print('   Total d\'entrées: ${weekHistory['meta']['total_entries']}');
      
      print('\n📅 HISTORIQUE DE LA SEMAINE:');
      for (final entry in weekHistory['data']) {
        print('   • ${entry['user']?['first_name'] ?? 'Utilisateur'} ${entry['user']?['last_name'] ?? 'Inconnu'}');
        print('     Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Date: ${entry['clock_in']?.split('T')[0] ?? 'Date inconnue'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique de la semaine: $e');
    }
  }

  /// Exemple d'obtention de l'historique du mois en cours
  Future<void> getCurrentMonthHistoryExample() async {
    try {
      print('📅 Récupération de l\'historique du mois en cours...');
      
      final monthHistory = await _timeTrackingService.getCurrentMonthHistory(perPage: 10);

      print('✅ Historique du mois récupéré avec succès !');
      print('   Période: ${monthHistory['meta']['start_date']} à ${monthHistory['meta']['end_date']}');
      print('   Total d\'entrées: ${monthHistory['meta']['total_entries']}');
      
      print('\n📅 HISTORIQUE DU MOIS:');
      for (final entry in monthHistory['data']) {
        print('   • ${entry['user']?['first_name'] ?? 'Utilisateur'} ${entry['user']?['last_name'] ?? 'Inconnu'}');
        print('     Projet: ${entry['project']?['name'] ?? 'Non défini'}');
        print('     Date: ${entry['clock_in']?.split('T')[0] ?? 'Date inconnue'}');
        print('     Heure d\'arrivée: ${entry['clock_in']}');
        print('     Heure de départ: ${entry['clock_out'] ?? 'En cours'}');
        print('     Localisation: ${entry['location'] ?? 'Non définie'}');
        print('     Notes: ${entry['notes'] ?? 'Aucune'}');
        print('     Statut: ${entry['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique du mois: $e');
    }
  }

  /// Exemple d'obtention du statut de l'équipe d'un projet
  Future<void> getProjectTeamStatusExample() async {
    try {
      print('🏗️ Récupération du statut de l\'équipe du projet...');
      
      final projectTeamStatus = await _timeTrackingService.getProjectTeamStatus(1);

      print('✅ Statut de l\'équipe du projet récupéré avec succès !');
      print('   ID Projet: 1');
      print('   Total d\'utilisateurs actifs: ${projectTeamStatus['data']['total_active']}');
      
      print('\n🏗️ ÉQUIPE DU PROJET:');
      for (final user in projectTeamStatus['data']['users'] ?? []) {
        print('   • ${user['user_name']}');
        print('     Heure d\'arrivée: ${user['clock_in']}');
        print('     Localisation: ${user['location'] ?? 'Non définie'}');
        print('     Durée: ${user['duration']?.toStringAsFixed(2) ?? '0'} heures');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du statut de l\'équipe du projet: $e');
    }
  }

  /// Exemple d'obtention du statut global de l'équipe
  Future<void> getGlobalTeamStatusExample() async {
    try {
      print('🌍 Récupération du statut global de l\'équipe...');
      
      final globalTeamStatus = await _timeTrackingService.getGlobalTeamStatus();

      print('✅ Statut global de l\'équipe récupéré avec succès !');
      print('   Total d\'utilisateurs actifs: ${globalTeamStatus['data']['total_active']}');
      
      print('\n🌍 ÉQUIPE GLOBALE:');
      for (final user in globalTeamStatus['data']['users'] ?? []) {
        print('   • ${user['user_name']}');
        print('     Projet: ${user['project_name']}');
        print('     Heure d\'arrivée: ${user['clock_in']}');
        print('     Localisation: ${user['location'] ?? 'Non définie'}');
        print('     Durée: ${user['duration']?.toStringAsFixed(2) ?? '0'} heures');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du statut global de l\'équipe: $e');
    }
  }

  /// Exemple d'obtention du nombre d'utilisateurs actifs
  Future<void> getActiveUsersCountExample() async {
    try {
      print('👥 Récupération du nombre d\'utilisateurs actifs...');
      
      // Nombre global d'utilisateurs actifs
      final globalActiveCount = await _timeTrackingService.getActiveUsersCount();
      print('   Total global: $globalActiveCount utilisateurs actifs');
      
      // Nombre d'utilisateurs actifs par projet
      final projectActiveCount = await _timeTrackingService.getActiveUsersCount(projectId: 1);
      print('   Projet 1: $projectActiveCount utilisateurs actifs');

    } catch (e) {
      print('❌ Erreur lors de la récupération du nombre d\'utilisateurs actifs: $e');
    }
  }

  /// Exemple d'obtention de la liste des utilisateurs actifs
  Future<void> getActiveUsersExample() async {
    try {
      print('👥 Récupération de la liste des utilisateurs actifs...');
      
      // Utilisateurs actifs globaux
      final globalActiveUsers = await _timeTrackingService.getActiveUsers();
      print('   Total global: ${globalActiveUsers.length} utilisateurs actifs');
      
      // Utilisateurs actifs par projet
      final projectActiveUsers = await _timeTrackingService.getActiveUsers(projectId: 1);
      print('   Projet 1: ${projectActiveUsers.length} utilisateurs actifs');
      
      print('\n👥 UTILISATEURS ACTIFS GLOBAUX:');
      for (final user in globalActiveUsers) {
        print('   • ${user['user_name']}');
        print('     Projet: ${user['project_name']}');
        print('     Heure d\'arrivée: ${user['clock_in']}');
        print('     Localisation: ${user['location'] ?? 'Non définie'}');
        print('     Durée: ${user['duration']?.toStringAsFixed(2) ?? '0'} heures');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de la liste des utilisateurs actifs: $e');
    }
  }

  /// Exemple d'obtention des utilisateurs actifs par projet
  Future<void> getActiveUsersByProjectExample() async {
    try {
      print('🏗️ Récupération des utilisateurs actifs par projet...');
      
      final usersByProject = await _timeTrackingService.getActiveUsersByProject();

      print('✅ Utilisateurs actifs par projet récupérés avec succès !');
      print('   Nombre de projets avec utilisateurs actifs: ${usersByProject.length}');
      
      for (final entry in usersByProject.entries) {
        final projectId = entry.key;
        final users = entry.value;
        
        print('\n🏗️ PROJET $projectId:');
        print('   Nombre d\'utilisateurs actifs: ${users.length}');
        
        for (final user in users) {
          print('     • ${user['user_name']}');
          print('       Heure d\'arrivée: ${user['clock_in']}');
          print('       Localisation: ${user['location'] ?? 'Non définie'}');
          print('       Durée: ${user['duration']?.toStringAsFixed(2) ?? '0'} heures');
        }
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des utilisateurs actifs par projet: $e');
    }
  }

  /// Exemple d'obtention de la durée du pointage actuel
  Future<void> getCurrentTrackingDurationExample() async {
    try {
      print('⏱️ Récupération de la durée du pointage actuel...');
      
      // Durée en Duration
      final duration = await _timeTrackingService.getCurrentTrackingDuration();
      if (duration != null) {
        print('   Durée totale: ${duration.inMinutes} minutes');
      }
      
      // Durée en heures
      final hours = await _timeTrackingService.getCurrentTrackingHours();
      if (hours != null) {
        print('   Durée en heures: ${hours.toStringAsFixed(2)} heures');
      }
      
      // Durée en minutes
      final minutes = await _timeTrackingService.getCurrentTrackingMinutes();
      if (minutes != null) {
        print('   Durée en minutes: $minutes minutes');
      }
      
      // Durée formatée
      final formatted = await _timeTrackingService.getCurrentTrackingFormatted();
      if (formatted != null) {
        print('   Durée formatée: $formatted');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération de la durée: $e');
    }
  }

  /// Exemple d'obtention des informations du pointage actuel
  Future<void> getCurrentTrackingInfoExample() async {
    try {
      print('🔍 Récupération des informations du pointage actuel...');
      
      // Projet du pointage actuel
      final project = await _timeTrackingService.getCurrentTrackingProject();
      if (project != null) {
        print('   Projet: ${project['name'] ?? 'Nom inconnu'}');
      }
      
      // Localisation du pointage actuel
      final location = await _timeTrackingService.getCurrentTrackingLocation();
      if (location != null) {
        print('   Localisation: $location');
      }
      
      // Notes du pointage actuel
      final notes = await _timeTrackingService.getCurrentTrackingNotes();
      if (notes != null) {
        print('   Notes: $notes');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des informations: $e');
    }
  }

  /// Exemple de calcul des statistiques de pointage
  Future<void> calculateTrackingStatsExample() async {
    try {
      print('📊 Calcul des statistiques de pointage...');
      
      final startDate = DateTime.now().subtract(Duration(days: 7));
      final endDate = DateTime.now();
      
      // Statistiques globales
      final globalStats = await _timeTrackingService.getTrackingStats(
        startDate: startDate,
        endDate: endDate,
      );
      
      print('✅ Statistiques globales calculées avec succès !');
      print('   Période: ${globalStats['start_date']} à ${globalStats['end_date']}');
      print('   Total d\'heures: ${globalStats['total_hours'].toStringAsFixed(2)} heures');
      print('   Total de jours: ${globalStats['total_days']} jours');
      print('   Moyenne par jour: ${globalStats['average_hours_per_day'].toStringAsFixed(2)} heures');
      
      // Statistiques par utilisateur
      final userStats = await _timeTrackingService.getTrackingStats(
        startDate: startDate,
        endDate: endDate,
        userId: 1,
      );
      
      print('\n✅ Statistiques utilisateur calculées avec succès !');
      print('   ID Utilisateur: 1');
      print('   Total d\'heures: ${userStats['total_hours'].toStringAsFixed(2)} heures');
      print('   Total de jours: ${userStats['total_days']} jours');
      print('   Moyenne par jour: ${userStats['average_hours_per_day'].toStringAsFixed(2)} heures');
      
      // Statistiques par projet
      final projectStats = await _timeTrackingService.getTrackingStats(
        startDate: startDate,
        endDate: endDate,
        projectId: 1,
      );
      
      print('\n✅ Statistiques projet calculées avec succès !');
      print('   ID Projet: 1');
      print('   Total d\'heures: ${projectStats['total_hours'].toStringAsFixed(2)} heures');
      print('   Total de jours: ${projectStats['total_days']} jours');
      print('   Moyenne par jour: ${projectStats['average_hours_per_day'].toStringAsFixed(2)} heures');

    } catch (e) {
      print('❌ Erreur lors du calcul des statistiques: $e');
    }
  }

  /// Exemple d'obtention du résumé du pointage actuel
  Future<void> getCurrentTrackingSummaryExample() async {
    try {
      print('📋 Récupération du résumé du pointage actuel...');
      
      final summary = await _timeTrackingService.getCurrentTrackingSummary();

      if (summary != null) {
        print('✅ Résumé du pointage actuel récupéré avec succès !');
        print('   Projet: ${summary['project_name']}');
        print('   Localisation: ${summary['location']}');
        print('   Heure d\'arrivée: ${summary['clock_in']}');
        print('   Durée: ${summary['duration']} minutes');
        print('   Durée formatée: ${summary['duration_formatted']}');
        print('   Notes: ${summary['notes']}');
      } else {
        print('ℹ️ Aucun pointage actif pour afficher le résumé');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du résumé: $e');
    }
  }

  /// Exemple d'obtention du résumé de l'équipe
  Future<void> getTeamSummaryExample() async {
    try {
      print('👥 Récupération du résumé de l\'équipe...');
      
      // Résumé global de l'équipe
      final globalSummary = await _timeTrackingService.getTeamSummary();
      print('✅ Résumé global de l\'équipe récupéré avec succès !');
      print('   Total d\'utilisateurs actifs: ${globalSummary['total_active']}');
      print('   Nombre d\'utilisateurs: ${globalSummary['users_count']}');
      print('   Nombre de projets: ${globalSummary['projects_count']}');
      print('   Durée moyenne: ${globalSummary['average_duration'].toStringAsFixed(2)} heures');
      
      // Résumé de l'équipe par projet
      final projectSummary = await _timeTrackingService.getTeamSummary(projectId: 1);
      print('\n✅ Résumé de l\'équipe du projet récupéré avec succès !');
      print('   ID Projet: 1');
      print('   Total d\'utilisateurs actifs: ${projectSummary['total_active']}');
      print('   Nombre d\'utilisateurs: ${projectSummary['users_count']}');
      print('   Nombre de projets: ${projectSummary['projects_count']}');
      print('   Durée moyenne: ${projectSummary['average_duration'].toStringAsFixed(2)} heures');

    } catch (e) {
      print('❌ Erreur lors de la récupération du résumé de l\'équipe: $e');
    }
  }

  /// Exemple complet d'utilisation du service de suivi du temps
  Future<void> completeTimeTrackingWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE DE SUIVI DU TEMPS ===\n');

      // 1. Vérifier le statut du pointage
      await checkTrackingStatusExample();
      print('');

      // 2. Pointer l'arrivée
      await clockInExample();
      print('');

      // 3. Obtenir le pointage actuel
      await getCurrentExample();
      print('');

      // 4. Obtenir le pointage actif
      await getActiveTrackingExample();
      print('');

      // 5. Vérifier le statut du pointage
      await checkTrackingStatusExample();
      print('');

      // 6. Obtenir la durée du pointage actuel
      await getCurrentTrackingDurationExample();
      print('');

      // 7. Obtenir les informations du pointage actuel
      await getCurrentTrackingInfoExample();
      print('');

      // 8. Obtenir le résumé du pointage actuel
      await getCurrentTrackingSummaryExample();
      print('');

      // 9. Pointer le départ
      await clockOutExample();
      print('');

      // 10. Vérifier le statut du pointage
      await checkTrackingStatusExample();
      print('');

      // 11. Obtenir l'historique personnel
      await getMyHistoryExample();
      print('');

      // 12. Obtenir l'historique global
      await getHistoryExample();
      print('');

      // 13. Obtenir l'historique d'un projet
      await getProjectHistoryExample();
      print('');

      // 14. Obtenir l'historique d'un utilisateur
      await getUserHistoryExample();
      print('');

      // 15. Obtenir l'historique d'une date
      await getDateHistoryExample();
      print('');

      // 16. Obtenir l'historique de la semaine
      await getCurrentWeekHistoryExample();
      print('');

      // 17. Obtenir l'historique du mois
      await getCurrentMonthHistoryExample();
      print('');

      // 18. Obtenir le statut de l'équipe
      await getTeamStatusExample();
      print('');

      // 19. Obtenir le statut de l'équipe d'un projet
      await getProjectTeamStatusExample();
      print('');

      // 20. Obtenir le statut global de l'équipe
      await getGlobalTeamStatusExample();
      print('');

      // 21. Obtenir le nombre d'utilisateurs actifs
      await getActiveUsersCountExample();
      print('');

      // 22. Obtenir la liste des utilisateurs actifs
      await getActiveUsersExample();
      print('');

      // 23. Obtenir les utilisateurs actifs par projet
      await getActiveUsersByProjectExample();
      print('');

      // 24. Calculer les statistiques
      await calculateTrackingStatsExample();
      print('');

      // 25. Obtenir le résumé de l'équipe
      await getTeamSummaryExample();
      print('');

      print('✅ Workflow du service de suivi du temps terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du service de suivi du temps: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de suivi du temps
      print('⏰ TABLEAU DE BORD DU SUIVI DU TEMPS:');
      
      // Vérifier le statut du pointage
      final hasActive = await _timeTrackingService.hasActiveTracking();
      print('📊 STATUT DU POINTAGE:');
      print('   Pointage actif: ${hasActive ? 'Oui' : 'Non'}');
      
      if (hasActive) {
        // Obtenir le résumé du pointage actuel
        final summary = await _timeTrackingService.getCurrentTrackingSummary();
        if (summary != null) {
          print('\n🔄 POINTAGE ACTUEL:');
          print('   Projet: ${summary['project_name']}');
          print('   Localisation: ${summary['location']}');
          print('   Durée: ${summary['duration_formatted']}');
          print('   Notes: ${summary['notes']}');
        }
      }
      
      // Obtenir le statut de l'équipe
      final teamStatus = await _timeTrackingService.getTeamStatus();
      print('\n👥 STATUT DE L\'ÉQUIPE:');
      print('   Utilisateurs actifs: ${teamStatus['data']['total_active']}');
      
      // Obtenir les statistiques de la semaine
      final startDate = DateTime.now().subtract(Duration(days: 7));
      final endDate = DateTime.now();
      final weekStats = await _timeTrackingService.getTrackingStats(
        startDate: startDate,
        endDate: endDate,
      );
      
      print('\n📈 STATISTIQUES DE LA SEMAINE:');
      print('   Total d\'heures: ${weekStats['total_hours'].toStringAsFixed(2)} heures');
      print('   Moyenne par jour: ${weekStats['average_hours_per_day'].toStringAsFixed(2)} heures');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service de suivi du temps
void main() async {
  final timeTrackingExample = TimeTrackingExample();
  
  // Exécuter le workflow complet
  await timeTrackingExample.completeTimeTrackingWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await timeTrackingExample.uiExample();
}

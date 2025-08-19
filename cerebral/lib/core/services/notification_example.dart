import 'notification_service.dart';

/// Exemple d'utilisation complète du service notification
/// Basé sur le NotificationController Laravel avec toutes les fonctionnalités avancées
class NotificationExample {
  final NotificationService _notificationService = NotificationService();

  /// Exemple d'obtention de toutes les notifications
  Future<void> getAllNotificationsExample() async {
    try {
      print('📋 Récupération de toutes les notifications...');

      final notifications =
          await _notificationService.getNotifications(perPage: 10);

      print('✅ Notifications récupérées avec succès !');
      print('   Total: ${notifications['pagination']['total']} notifications');
      print('   Page actuelle: ${notifications['pagination']['current_page']}');
      print('   Par page: ${notifications['pagination']['per_page']}');

      print('\n📋 NOTIFICATIONS:');
      for (final notification in notifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Message: ${notification['message']}');
        print('     Statut: ${notification['status']}');
        print('     Date: ${notification['created_at']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications: $e');
    }
  }

  /// Exemple d'obtention du nombre de notifications non lues
  Future<void> getUnreadCountExample() async {
    try {
      print('🔔 Récupération du nombre de notifications non lues...');

      final unreadCount = await _notificationService.getUnreadCount();

      print('✅ Nombre de notifications non lues récupéré avec succès !');
      print(
          '   Notifications non lues: ${unreadCount['data']['unread_count']}');
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération du nombre de notifications non lues: $e');
    }
  }

  /// Exemple de filtrage des notifications par statut
  Future<void> getNotificationsByStatusExample() async {
    try {
      print('📊 Récupération des notifications par statut...');

      // Notifications non lues
      final unreadNotifications =
          await _notificationService.getUnreadNotifications(perPage: 5);
      print('\n🔔 NOTIFICATIONS NON LUES:');
      print('   Nombre: ${unreadNotifications['data'].length}');

      // Notifications lues
      final readNotifications =
          await _notificationService.getReadNotifications(perPage: 5);
      print('\n✅ NOTIFICATIONS LUES:');
      print('   Nombre: ${readNotifications['data'].length}');

      // Notifications archivées
      final archivedNotifications =
          await _notificationService.getArchivedNotifications(perPage: 5);
      print('\n📁 NOTIFICATIONS ARCHIVÉES:');
      print('   Nombre: ${archivedNotifications['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple de filtrage des notifications par type
  Future<void> getNotificationsByTypeExample() async {
    try {
      print('🏷️ Récupération des notifications par type...');

      // Notifications de tâches assignées
      final taskAssignedNotifications =
          await _notificationService.getTaskAssignedNotifications(perPage: 5);
      print('\n📋 TÂCHES ASSIGNÉES:');
      print('   Nombre: ${taskAssignedNotifications['data'].length}');

      // Notifications de mise à jour de projet
      final projectUpdateNotifications =
          await _notificationService.getProjectUpdateNotifications(perPage: 5);
      print('\n🔄 MISES À JOUR DE PROJET:');
      print('   Nombre: ${projectUpdateNotifications['data'].length}');

      // Notifications de rappel de deadline
      final deadlineReminderNotifications = await _notificationService
          .getDeadlineReminderNotifications(perPage: 5);
      print('\n⏰ RAPPELS DE DEADLINE:');
      print('   Nombre: ${deadlineReminderNotifications['data'].length}');

      // Notifications d'alerte budget
      final budgetAlertNotifications =
          await _notificationService.getBudgetAlertNotifications(perPage: 5);
      print('\n💰 ALERTES BUDGET:');
      print('   Nombre: ${budgetAlertNotifications['data'].length}');

      // Notifications de changement de statut
      final statusChangeNotifications =
          await _notificationService.getStatusChangeNotifications(perPage: 5);
      print('\n🔄 CHANGEMENTS DE STATUT:');
      print('   Nombre: ${statusChangeNotifications['data'].length}');

      // Notifications de commentaires ajoutés
      final commentAddedNotifications =
          await _notificationService.getCommentAddedNotifications(perPage: 5);
      print('\n💬 COMMENTAIRES AJOUTÉS:');
      print('   Nombre: ${commentAddedNotifications['data'].length}');

      // Notifications de fichiers téléchargés
      final fileUploadedNotifications =
          await _notificationService.getFileUploadedNotifications(perPage: 5);
      print('\n📁 FICHIERS TÉLÉCHARGÉS:');
      print('   Nombre: ${fileUploadedNotifications['data'].length}');

      // Notifications d'approbation requise
      final approvalRequiredNotifications = await _notificationService
          .getApprovalRequiredNotifications(perPage: 5);
      print('\n✅ APPROBATIONS REQUISES:');
      print('   Nombre: ${approvalRequiredNotifications['data'].length}');

      // Notifications d'alerte système
      final systemAlertNotifications =
          await _notificationService.getSystemAlertNotifications(perPage: 5);
      print('\n🚨 ALERTES SYSTÈME:');
      print('   Nombre: ${systemAlertNotifications['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par type: $e');
    }
  }

  /// Exemple d'obtention des notifications récentes
  Future<void> getRecentNotificationsExample() async {
    try {
      print('🕐 Récupération des notifications récentes (24h)...');

      final recentNotifications =
          await _notificationService.getRecentNotifications(perPage: 10);

      print('✅ Notifications récentes récupérées avec succès !');
      print('   Période: 24 dernières heures');
      print('   Nombre: ${recentNotifications['recent_count']}');

      print('\n🕐 NOTIFICATIONS RÉCENTES:');
      for (final notification in recentNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Date: ${notification['created_at']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications récentes: $e');
    }
  }

  /// Exemple d'obtention des notifications urgentes
  Future<void> getUrgentNotificationsExample() async {
    try {
      print('🚨 Récupération des notifications urgentes...');

      final urgentNotifications =
          await _notificationService.getUrgentNotifications(perPage: 10);

      print('✅ Notifications urgentes récupérées avec succès !');
      print('   Priorité: Élevée');
      print('   Nombre: ${urgentNotifications['urgent_count']}');

      print('\n🚨 NOTIFICATIONS URGENTES:');
      for (final notification in urgentNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Priorité: Élevée');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications urgentes: $e');
    }
  }

  /// Exemple d'obtention des notifications par priorité
  Future<void> getNotificationsByPriorityExample() async {
    try {
      print('⭐ Récupération des notifications par priorité...');

      // Notifications haute priorité
      final highPriorityNotifications =
          await _notificationService.getNotificationsByPriority(
        priority: 'high',
        perPage: 5,
      );
      print('\n🔴 HAUTE PRIORITÉ:');
      print('   Nombre: ${highPriorityNotifications['priority_count']}');

      // Notifications priorité moyenne
      final mediumPriorityNotifications =
          await _notificationService.getNotificationsByPriority(
        priority: 'medium',
        perPage: 5,
      );
      print('\n🟡 PRIORITÉ MOYENNE:');
      print('   Nombre: ${mediumPriorityNotifications['priority_count']}');

      // Notifications priorité basse
      final lowPriorityNotifications =
          await _notificationService.getNotificationsByPriority(
        priority: 'low',
        perPage: 5,
      );
      print('\n🟢 PRIORITÉ BASSE:');
      print('   Nombre: ${lowPriorityNotifications['priority_count']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération par priorité: $e');
    }
  }

  /// Exemple d'obtention des notifications système
  Future<void> getSystemNotificationsExample() async {
    try {
      print('🖥️ Récupération des notifications système...');

      final systemNotifications =
          await _notificationService.getSystemNotifications(perPage: 10);

      print('✅ Notifications système récupérées avec succès !');
      print('   Type: Système');
      print('   Nombre: ${systemNotifications['system_count']}');

      print('\n🖥️ NOTIFICATIONS SYSTÈME:');
      for (final notification in systemNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Message: ${notification['message']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications système: $e');
    }
  }

  /// Exemple d'obtention des notifications nécessitant une action
  Future<void> getActionRequiredNotificationsExample() async {
    try {
      print('⚡ Récupération des notifications nécessitant une action...');

      final actionNotifications = await _notificationService
          .getActionRequiredNotifications(perPage: 10);

      print('✅ Notifications d\'action récupérées avec succès !');
      print('   Type: Action requise');
      print('   Nombre: ${actionNotifications['action_required_count']}');

      print('\n⚡ NOTIFICATIONS D\'ACTION:');
      for (final notification in actionNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Action requise: Oui');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications d\'action: $e');
    }
  }

  /// Exemple d'obtention des notifications d'information
  Future<void> getInfoNotificationsExample() async {
    try {
      print('ℹ️ Récupération des notifications d\'information...');

      final infoNotifications =
          await _notificationService.getInfoNotifications(perPage: 10);

      print('✅ Notifications d\'information récupérées avec succès !');
      print('   Type: Information');
      print('   Nombre: ${infoNotifications['info_count']}');

      print('\nℹ️ NOTIFICATIONS D\'INFORMATION:');
      for (final notification in infoNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Lecture seule: Oui');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des notifications d\'information: $e');
    }
  }

  /// Exemple d'obtention des notifications par période
  Future<void> getNotificationsByPeriodExample() async {
    try {
      print('📅 Récupération des notifications par période...');

      final startDate = DateTime.now().subtract(Duration(days: 7));
      final endDate = DateTime.now();

      final periodNotifications =
          await _notificationService.getNotificationsByPeriod(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Notifications de la période récupérées avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre: ${periodNotifications['period_count']}');

      print('\n📅 NOTIFICATIONS DE LA PÉRIODE:');
      for (final notification in periodNotifications['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Date: ${notification['created_at']}');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des notifications de la période: $e');
    }
  }

  /// Exemple de recherche dans les notifications
  Future<void> searchNotificationsExample() async {
    try {
      print('🔍 Recherche dans les notifications...');

      final searchResults =
          await _notificationService.searchNotifications('projet', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: projet');
      print('   Résultats trouvés: ${searchResults['results_count']}');

      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final notification in searchResults['data']) {
        print('   • ${notification['title']}');
        print('     Type: ${notification['type']}');
        print('     Message: ${notification['message']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des types de notifications
  Future<void> getNotificationTypesExample() async {
    try {
      print('🏷️ Récupération des types de notifications...');

      final types = await _notificationService.getNotificationTypes();

      print('✅ Types de notifications récupérés avec succès !');

      print('\n🏷️ TYPES DE NOTIFICATIONS:');
      final typesData = types['data'] as Map<String, dynamic>;
      for (final entry in typesData.entries) {
        print('   • ${entry.key}: ${entry.value}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des types: $e');
    }
  }

  /// Exemple d'obtention des préférences de notifications
  Future<void> getNotificationPreferencesExample() async {
    try {
      print('⚙️ Récupération des préférences de notifications...');

      final preferences =
          await _notificationService.getNotificationPreferences();

      print('✅ Préférences de notifications récupérées avec succès !');

      print('\n⚙️ PRÉFÉRENCES:');
      final prefsData = preferences['data'];
      print('   Email: ${prefsData['email'] ? 'Activé' : 'Désactivé'}');
      print('   Push: ${prefsData['push'] ? 'Activé' : 'Désactivé'}');
      print('   SMS: ${prefsData['sms'] ? 'Activé' : 'Désactivé'}');

      print('\n🏷️ PRÉFÉRENCES PAR TYPE:');
      final typesPrefs = prefsData['types'] as Map<String, dynamic>;
      for (final entry in typesPrefs.entries) {
        print('   • ${entry.key}: ${entry.value ? 'Activé' : 'Désactivé'}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des préférences: $e');
    }
  }

  /// Exemple de mise à jour des préférences de notifications
  Future<void> updateNotificationPreferencesExample() async {
    try {
      print('⚙️ Mise à jour des préférences de notifications...');

      final updatedPreferences =
          await _notificationService.updateNotificationPreferences(
        email: true,
        push: true,
        sms: false,
        types: {
          'task_assigned': true,
          'project_update': true,
          'deadline_reminder': true,
          'budget_alert': true,
          'status_change': true,
          'comment_added': false,
          'file_uploaded': false,
          'approval_required': true,
          'system_alert': true,
        },
      );

      print('✅ Préférences de notifications mises à jour avec succès !');
      print('   Message: ${updatedPreferences['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour des préférences: $e');
    }
  }

  /// Exemple d'envoi d'une notification de test
  Future<void> sendTestNotificationExample() async {
    try {
      print('🧪 Envoi d\'une notification de test...');

      final testNotification =
          await _notificationService.sendTestNotification();

      print('✅ Notification de test envoyée avec succès !');
      print('   Titre: ${testNotification['data']['title']}');
      print('   Message: ${testNotification['data']['message']}');
      print('   Type: ${testNotification['data']['type']}');
      print('   Statut: ${testNotification['data']['status']}');
      print('   Message: ${testNotification['message']}');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de test: $e');
    }
  }

  /// Exemple d'obtention des statistiques des notifications
  Future<void> getNotificationStatsExample() async {
    try {
      print('📊 Récupération des statistiques des notifications...');

      final stats = await _notificationService.getNotificationStats();

      print('✅ Statistiques des notifications récupérées avec succès !');

      print('\n📈 STATISTIQUES GÉNÉRALES:');
      print('   Total: ${stats['data']['total']}');
      print('   Non lues: ${stats['data']['unread']}');
      print('   Lues: ${stats['data']['read']}');
      print('   Archivées: ${stats['data']['archived']}');

      print('\n🏷️ RÉPARTITION PAR TYPE:');
      final byType = stats['data']['by_type'] as Map<String, dynamic>;
      for (final entry in byType.entries) {
        print('   • ${entry.key}: ${entry.value}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de marquage d'une notification comme lue
  Future<void> markAsReadExample() async {
    try {
      print('✅ Marquage d\'une notification comme lue...');

      final result = await _notificationService.markAsRead(1);

      print('✅ Notification marquée comme lue avec succès !');
      print('   Message: ${result['message']}');
      print('   Titre: ${result['data']['title']}');
      print('   Statut: ${result['data']['status']}');
    } catch (e) {
      print('❌ Erreur lors du marquage comme lue: $e');
    }
  }

  /// Exemple de marquage de toutes les notifications comme lues
  Future<void> markAllAsReadExample() async {
    try {
      print('✅ Marquage de toutes les notifications comme lues...');

      final result = await _notificationService.markAllAsRead();

      print('✅ Toutes les notifications marquées comme lues avec succès !');
      print('   Message: ${result['message']}');
    } catch (e) {
      print('❌ Erreur lors du marquage de toutes comme lues: $e');
    }
  }

  /// Exemple d'archivage d'une notification
  Future<void> archiveNotificationExample() async {
    try {
      print('📁 Archivage d\'une notification...');

      final result = await _notificationService.archiveNotification(1);

      print('✅ Notification archivée avec succès !');
      print('   Message: ${result['message']}');
      print('   Titre: ${result['data']['title']}');
      print('   Statut: ${result['data']['status']}');
    } catch (e) {
      print('❌ Erreur lors de l\'archivage: $e');
    }
  }

  /// Exemple de suppression d'une notification
  Future<void> deleteNotificationExample() async {
    try {
      print('🗑️ Suppression d\'une notification...');

      final result = await _notificationService.deleteNotification(1);

      print('✅ Notification supprimée avec succès !');
      print('   Message: ${result['message']}');
    } catch (e) {
      print('❌ Erreur lors de la suppression: $e');
    }
  }

  /// Exemple de vérification des préférences
  Future<void> checkPreferencesExample() async {
    try {
      print('🔍 Vérification des préférences de notifications...');

      // Vérifier si l'utilisateur a des notifications non lues
      final hasUnread = await _notificationService.hasUnreadNotifications();
      print('   A des notifications non lues: ${hasUnread ? 'Oui' : 'Non'}');

      // Obtenir le nombre total de notifications
      final totalCount = await _notificationService.getTotalNotificationCount();
      print('   Nombre total de notifications: $totalCount');

      // Obtenir le nombre par type
      final countByType =
          await _notificationService.getNotificationCountByType();
      print('   Nombre par type: $countByType');

      // Vérifier les préférences par type
      final taskAssignedEnabled =
          await _notificationService.isNotificationTypeEnabled('task_assigned');
      print(
          '   Notifications de tâches assignées: ${taskAssignedEnabled ? 'Activé' : 'Désactivé'}');

      // Vérifier les préférences de canal
      final emailEnabled =
          await _notificationService.isEmailNotificationsEnabled();
      print('   Notifications email: ${emailEnabled ? 'Activé' : 'Désactivé'}');

      final pushEnabled =
          await _notificationService.isPushNotificationsEnabled();
      print('   Notifications push: ${pushEnabled ? 'Activé' : 'Désactivé'}');

      final smsEnabled = await _notificationService.isSmsNotificationsEnabled();
      print('   Notifications SMS: ${smsEnabled ? 'Activé' : 'Désactivé'}');
    } catch (e) {
      print('❌ Erreur lors de la vérification des préférences: $e');
    }
  }

  /// Exemple complet d'utilisation du service notification
  Future<void> completeNotificationWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE NOTIFICATION ===\n');

      // 1. Obtenir toutes les notifications
      await getAllNotificationsExample();
      print('');

      // 2. Obtenir le nombre de notifications non lues
      await getUnreadCountExample();
      print('');

      // 3. Filtrer par statut
      await getNotificationsByStatusExample();
      print('');

      // 4. Filtrer par type
      await getNotificationsByTypeExample();
      print('');

      // 5. Obtenir les notifications récentes
      await getRecentNotificationsExample();
      print('');

      // 6. Obtenir les notifications urgentes
      await getUrgentNotificationsExample();
      print('');

      // 7. Obtenir par priorité
      await getNotificationsByPriorityExample();
      print('');

      // 8. Obtenir les notifications système
      await getSystemNotificationsExample();
      print('');

      // 9. Obtenir les notifications d'action
      await getActionRequiredNotificationsExample();
      print('');

      // 10. Obtenir les notifications d'information
      await getInfoNotificationsExample();
      print('');

      // 11. Obtenir par période
      await getNotificationsByPeriodExample();
      print('');

      // 12. Rechercher dans les notifications
      await searchNotificationsExample();
      print('');

      // 13. Obtenir les types de notifications
      await getNotificationTypesExample();
      print('');

      // 14. Obtenir les préférences
      await getNotificationPreferencesExample();
      print('');

      // 15. Mettre à jour les préférences
      await updateNotificationPreferencesExample();
      print('');

      // 16. Envoyer une notification de test
      await sendTestNotificationExample();
      print('');

      // 17. Obtenir les statistiques
      await getNotificationStatsExample();
      print('');

      // 18. Marquer comme lue
      await markAsReadExample();
      print('');

      // 19. Marquer toutes comme lues
      await markAllAsReadExample();
      print('');

      // 20. Archiver une notification
      await archiveNotificationExample();
      print('');

      // 21. Supprimer une notification
      await deleteNotificationExample();
      print('');

      // 22. Vérifier les préférences
      await checkPreferencesExample();
      print('');

      print('✅ Workflow du service notification terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service notification: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un centre de notifications
      print('🔔 CENTRE DE NOTIFICATIONS:');

      // Récupérer le nombre de notifications non lues
      final unreadCount = await _notificationService.getUnreadCount();
      print('📊 RÉSUMÉ:');
      print(
          '   Notifications non lues: ${unreadCount['data']['unread_count']}');

      // Récupérer les notifications récentes
      final recentNotifications =
          await _notificationService.getRecentNotifications(perPage: 5);
      print('\n🕐 RÉCENTES:');
      print(
          '   Notifications récentes: ${recentNotifications['recent_count']}');

      // Récupérer les notifications urgentes
      final urgentNotifications =
          await _notificationService.getUrgentNotifications(perPage: 5);
      print('\n🚨 URGENTES:');
      print(
          '   Notifications urgentes: ${urgentNotifications['urgent_count']}');

      // Récupérer les statistiques
      final stats = await _notificationService.getNotificationStats();
      print('\n📈 STATISTIQUES:');
      print('   Total: ${stats['data']['total']}');
      print('   Non lues: ${stats['data']['unread']}');
      print('   Lues: ${stats['data']['read']}');
      print('   Archivées: ${stats['data']['archived']}');

      // Vérifier les préférences
      final emailEnabled =
          await _notificationService.isEmailNotificationsEnabled();
      final pushEnabled =
          await _notificationService.isPushNotificationsEnabled();
      print('\n⚙️ PRÉFÉRENCES:');
      print('   Email: ${emailEnabled ? 'Activé' : 'Désactivé'}');
      print('   Push: ${pushEnabled ? 'Activé' : 'Désactivé'}');
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service notification
void main() async {
  final notificationExample = NotificationExample();

  // Exécuter le workflow complet
  await notificationExample.completeNotificationWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await notificationExample.uiExample();
}

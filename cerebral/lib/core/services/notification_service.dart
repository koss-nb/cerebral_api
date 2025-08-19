import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir toutes les notifications de l'utilisateur connecté avec filtres et pagination
  Future<Map<String, dynamic>> getNotifications({
    String? status,
    String? type,
    int? perPage = 15,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (type != null) {
        queryParams['type'] = type;
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/notifications$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le nombre de notifications non lues
  Future<Map<String, dynamic>> getUnreadCount() async {
    try {
      return await _apiService.get('/notifications/unread-count');
    } catch (e) {
      rethrow;
    }
  }

  // Marquer une notification comme lue
  Future<Map<String, dynamic>> markAsRead(int notificationId) async {
    try {
      return await _apiService.put('/notifications/$notificationId/mark-as-read', {});
    } catch (e) {
      rethrow;
    }
  }

  // Marquer toutes les notifications comme lues
  Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      return await _apiService.put('/notifications/mark-all-as-read', {});
    } catch (e) {
      rethrow;
    }
  }

  // Archiver une notification
  Future<Map<String, dynamic>> archiveNotification(int notificationId) async {
    try {
      return await _apiService.put('/notifications/$notificationId/archive', {});
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer une notification
  Future<Map<String, dynamic>> deleteNotification(int notificationId) async {
    try {
      return await _apiService.delete('/notifications/$notificationId');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les types de notifications disponibles
  Future<Map<String, dynamic>> getNotificationTypes() async {
    try {
      return await _apiService.get('/notifications/types');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les préférences de notifications de l'utilisateur
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    try {
      return await _apiService.get('/notifications/preferences');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour les préférences de notifications
  Future<Map<String, dynamic>> updateNotificationPreferences({
    bool? email,
    bool? push,
    bool? sms,
    Map<String, bool>? types,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (email != null) {
        data['email'] = email;
      }
      
      if (push != null) {
        data['push'] = push;
      }
      
      if (sms != null) {
        data['sms'] = sms;
      }
      
      if (types != null) {
        data['types'] = types;
      }

      return await _apiService.put('/notifications/preferences', data);
    } catch (e) {
      rethrow;
    }
  }

  // Envoyer une notification de test
  Future<Map<String, dynamic>> sendTestNotification() async {
    try {
      return await _apiService.post('/notifications/send-test', {});
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des notifications
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      return await _apiService.get('/notifications/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les notifications

  // Obtenir les notifications non lues
  Future<Map<String, dynamic>> getUnreadNotifications({int? perPage}) async {
    return await getNotifications(status: 'unread', perPage: perPage);
  }

  // Obtenir les notifications lues
  Future<Map<String, dynamic>> getReadNotifications({int? perPage}) async {
    return await getNotifications(status: 'read', perPage: perPage);
  }

  // Obtenir les notifications archivées
  Future<Map<String, dynamic>> getArchivedNotifications({int? perPage}) async {
    return await getNotifications(status: 'archived', perPage: perPage);
  }

  // Obtenir les notifications par type spécifique
  Future<Map<String, dynamic>> getNotificationsByType(String type, {int? perPage}) async {
    return await getNotifications(type: type, perPage: perPage);
  }

  // Obtenir les notifications de tâches assignées
  Future<Map<String, dynamic>> getTaskAssignedNotifications({int? perPage}) async {
    return await getNotifications(type: 'task_assigned', perPage: perPage);
  }

  // Obtenir les notifications de mise à jour de projet
  Future<Map<String, dynamic>> getProjectUpdateNotifications({int? perPage}) async {
    return await getNotifications(type: 'project_update', perPage: perPage);
  }

  // Obtenir les notifications de rappel de deadline
  Future<Map<String, dynamic>> getDeadlineReminderNotifications({int? perPage}) async {
    return await getNotifications(type: 'deadline_reminder', perPage: perPage);
  }

  // Obtenir les notifications d'alerte budget
  Future<Map<String, dynamic>> getBudgetAlertNotifications({int? perPage}) async {
    return await getNotifications(type: 'budget_alert', perPage: perPage);
  }

  // Obtenir les notifications de changement de statut
  Future<Map<String, dynamic>> getStatusChangeNotifications({int? perPage}) async {
    return await getNotifications(type: 'status_change', perPage: perPage);
  }

  // Obtenir les notifications de commentaires ajoutés
  Future<Map<String, dynamic>> getCommentAddedNotifications({int? perPage}) async {
    return await getNotifications(type: 'comment_added', perPage: perPage);
  }

  // Obtenir les notifications de fichiers téléchargés
  Future<Map<String, dynamic>> getFileUploadedNotifications({int? perPage}) async {
    return await getNotifications(type: 'file_uploaded', perPage: perPage);
  }

  // Obtenir les notifications d'approbation requise
  Future<Map<String, dynamic>> getApprovalRequiredNotifications({int? perPage}) async {
    return await getNotifications(type: 'approval_required', perPage: perPage);
  }

  // Obtenir les notifications d'alerte système
  Future<Map<String, dynamic>> getSystemAlertNotifications({int? perPage}) async {
    return await getNotifications(type: 'system_alert', perPage: perPage);
  }

  // Obtenir les notifications récentes (dernières 24h)
  Future<Map<String, dynamic>> getRecentNotifications({int? perPage}) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        final now = DateTime.now();
        final yesterday = now.subtract(Duration(hours: 24));
        
        final recentNotifications = notifications.where((notification) {
          final createdAt = DateTime.parse(notification['created_at']);
          return createdAt.isAfter(yesterday);
        }).toList();

        return {
          'success': true,
          'data': recentNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': recentNotifications.length,
            'total': recentNotifications.length,
          },
          'recent_count': recentNotifications.length,
          'time_period': '24h',
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications urgentes (non lues + deadline proche)
  Future<Map<String, dynamic>> getUrgentNotifications({int? perPage}) async {
    try {
      final unreadNotifications = await getUnreadNotifications(perPage: perPage);
      
      if (unreadNotifications['success'] == true && unreadNotifications['data'] != null) {
        final notifications = unreadNotifications['data'] as List;
        
        final urgentNotifications = notifications.where((notification) {
          final type = notification['type'];
          final isUrgentType = type == 'deadline_reminder' || 
                              type == 'budget_alert' || 
                              type == 'approval_required' ||
                              type == 'system_alert';
          
          // Vérifier si c'est une notification de deadline proche
          if (type == 'deadline_reminder' && notification['data'] != null) {
            final data = notification['data'];
            if (data['deadline'] != null) {
              final deadline = DateTime.parse(data['deadline']);
              final now = DateTime.now();
              final daysUntilDeadline = deadline.difference(now).inDays;
              return daysUntilDeadline <= 3; // Deadline dans les 3 prochains jours
            }
          }
          
          return isUrgentType;
        }).toList();

        return {
          'success': true,
          'data': urgentNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': urgentNotifications.length,
            'total': urgentNotifications.length,
          },
          'urgent_count': urgentNotifications.length,
          'priority_level': 'high',
        };
      }
      
      return unreadNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications par période
  Future<Map<String, dynamic>> getNotificationsByPeriod({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
    int? perPage,
  }) async {
    try {
      final allNotifications = await getNotifications(
        status: status,
        type: type,
        perPage: perPage,
      );
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        
        final periodNotifications = notifications.where((notification) {
          final createdAt = DateTime.parse(notification['created_at']);
          
          if (startDate != null && createdAt.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && createdAt.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': periodNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': periodNotifications.length,
            'total': periodNotifications.length,
          },
          'period_count': periodNotifications.length,
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher dans les notifications
  Future<Map<String, dynamic>> searchNotifications(String searchQuery, {int? perPage}) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        final query = searchQuery.toLowerCase();
        
        final searchResults = notifications.where((notification) {
          final title = notification['title']?.toString().toLowerCase() ?? '';
          final message = notification['message']?.toString().toLowerCase() ?? '';
          final type = notification['type']?.toString().toLowerCase() ?? '';
          
          return title.contains(query) || 
                 message.contains(query) || 
                 type.contains(query);
        }).toList();

        return {
          'success': true,
          'data': searchResults,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': searchResults.length,
            'total': searchResults.length,
          },
          'search_query': searchQuery,
          'results_count': searchResults.length,
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications par priorité
  Future<Map<String, dynamic>> getNotificationsByPriority({
    String priority = 'high',
    int? perPage,
  }) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        
        final priorityNotifications = notifications.where((notification) {
          final type = notification['type'];
          
          switch (priority) {
            case 'high':
              return type == 'deadline_reminder' || 
                     type == 'budget_alert' || 
                     type == 'approval_required' ||
                     type == 'system_alert';
            case 'medium':
              return type == 'task_assigned' || 
                     type == 'project_update' || 
                     type == 'status_change';
            case 'low':
              return type == 'comment_added' || 
                     type == 'file_uploaded';
            default:
              return true;
          }
        }).toList();

        return {
          'success': true,
          'data': priorityNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': priorityNotifications.length,
            'total': priorityNotifications.length,
          },
          'priority': priority,
          'priority_count': priorityNotifications.length,
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications non assignées (système)
  Future<Map<String, dynamic>> getSystemNotifications({int? perPage}) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        
        final systemNotifications = notifications.where((notification) {
          final type = notification['type'];
          return type == 'system_alert' || 
                 type == 'budget_alert' ||
                 type == 'deadline_reminder';
        }).toList();

        return {
          'success': true,
          'data': systemNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': systemNotifications.length,
            'total': systemNotifications.length,
          },
          'system_count': systemNotifications.length,
          'notification_type': 'system',
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications d'action (nécessitant une action)
  Future<Map<String, dynamic>> getActionRequiredNotifications({int? perPage}) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        
        final actionNotifications = notifications.where((notification) {
          final type = notification['type'];
          return type == 'approval_required' || 
                 type == 'task_assigned' ||
                 type == 'deadline_reminder';
        }).toList();

        return {
          'success': true,
          'data': actionNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': actionNotifications.length,
            'total': actionNotifications.length,
          },
          'action_required_count': actionNotifications.length,
          'notification_type': 'action_required',
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les notifications d'information (lecture seule)
  Future<Map<String, dynamic>> getInfoNotifications({int? perPage}) async {
    try {
      final allNotifications = await getNotifications(perPage: perPage);
      
      if (allNotifications['success'] == true && allNotifications['data'] != null) {
        final notifications = allNotifications['data'] as List;
        
        final infoNotifications = notifications.where((notification) {
          final type = notification['type'];
          return type == 'project_update' || 
                 type == 'status_change' ||
                 type == 'comment_added' ||
                 type == 'file_uploaded';
        }).toList();

        return {
          'success': true,
          'data': infoNotifications,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': infoNotifications.length,
            'total': infoNotifications.length,
          },
          'info_count': infoNotifications.length,
          'notification_type': 'information',
        };
      }
      
      return allNotifications;
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si l'utilisateur a des notifications non lues
  Future<bool> hasUnreadNotifications() async {
    try {
      final unreadCount = await getUnreadCount();
      
      if (unreadCount['success'] == true) {
        final count = unreadCount['data']['unread_count'] ?? 0;
        return count > 0;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le nombre total de notifications
  Future<int> getTotalNotificationCount() async {
    try {
      final stats = await getNotificationStats();
      
      if (stats['success'] == true) {
        return stats['data']['total'] ?? 0;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de notifications par type
  Future<Map<String, int>> getNotificationCountByType() async {
    try {
      final stats = await getNotificationStats();
      
      if (stats['success'] == true) {
        final byType = stats['data']['by_type'] ?? {};
        return Map<String, int>.from(byType);
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  // Vérifier les préférences de notifications par type
  Future<bool> isNotificationTypeEnabled(String type) async {
    try {
      final preferences = await getNotificationPreferences();
      
      if (preferences['success'] == true) {
        final types = preferences['data']['types'] ?? {};
        return types[type] ?? false;
      }
      
      return true; // Par défaut activé si pas de préférences
    } catch (e) {
      return true;
    }
  }

  // Vérifier si les notifications email sont activées
  Future<bool> isEmailNotificationsEnabled() async {
    try {
      final preferences = await getNotificationPreferences();
      
      if (preferences['success'] == true) {
        return preferences['data']['email'] ?? true;
      }
      
      return true; // Par défaut activé
    } catch (e) {
      return true;
    }
  }

  // Vérifier si les notifications push sont activées
  Future<bool> isPushNotificationsEnabled() async {
    try {
      final preferences = await getNotificationPreferences();
      
      if (preferences['success'] == true) {
        return preferences['data']['push'] ?? true;
      }
      
      return true; // Par défaut activé
    } catch (e) {
      return true;
    }
  }

  // Vérifier si les notifications SMS sont activées
  Future<bool> isSmsNotificationsEnabled() async {
    try {
      final preferences = await getNotificationPreferences();
      
      if (preferences['success'] == true) {
        return preferences['data']['sms'] ?? false;
      }
      
      return false; // Par défaut désactivé
    } catch (e) {
      return false;
    }
  }
}

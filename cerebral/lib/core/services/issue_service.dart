import 'api_service.dart';

class IssueService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous les problèmes avec filtres et pagination
  Future<Map<String, dynamic>> getIssues({
    String? status,
    String? priority,
    String? type,
    int? projectId,
    int? perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (priority != null) {
        queryParams['priority'] = priority;
      }
      
      if (type != null) {
        queryParams['type'] = type;
      }
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/issues$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Signaler un nouveau problème
  Future<Map<String, dynamic>> reportIssue({
    required String title,
    required String description,
    required String priority,
    required String type,
    int? projectId,
    int? taskId,
    String? location,
    int? assignedTo,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description,
        'priority': priority,
        'type': type,
      };

      if (projectId != null) {
        data['project_id'] = projectId;
      }
      
      if (taskId != null) {
        data['task_id'] = taskId;
      }
      
      if (location != null) {
        data['location'] = location;
      }
      
      if (assignedTo != null) {
        data['assigned_to'] = assignedTo;
      }

      return await _apiService.post('/issues', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un problème spécifique
  Future<Map<String, dynamic>> getIssue(int issueId) async {
    try {
      return await _apiService.get('/issues/$issueId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un problème
  Future<Map<String, dynamic>> updateIssue(
    int issueId, {
    String? title,
    String? description,
    String? priority,
    String? type,
    String? status,
    int? projectId,
    int? taskId,
    String? location,
    int? assignedTo,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (title != null) {
        data['title'] = title;
      }
      
      if (description != null) {
        data['description'] = description;
      }
      
      if (priority != null) {
        data['priority'] = priority;
      }
      
      if (type != null) {
        data['type'] = type;
      }
      
      if (status != null) {
        data['status'] = status;
      }
      
      if (projectId != null) {
        data['project_id'] = projectId;
      }
      
      if (taskId != null) {
        data['task_id'] = taskId;
      }
      
      if (location != null) {
        data['location'] = location;
      }
      
      if (assignedTo != null) {
        data['assigned_to'] = assignedTo;
      }

      return await _apiService.put('/issues/$issueId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un problème
  Future<Map<String, dynamic>> deleteIssue(int issueId) async {
    try {
      return await _apiService.delete('/issues/$issueId');
    } catch (e) {
      rethrow;
    }
  }

  // Résoudre un problème
  Future<Map<String, dynamic>> resolveIssue(
    int issueId, {
    String? resolutionNotes,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (resolutionNotes != null) {
        data['resolution_notes'] = resolutionNotes;
      }

      return await _apiService.post('/issues/$issueId/resolve', data);
    } catch (e) {
      rethrow;
    }
  }

  // Assigner un problème
  Future<Map<String, dynamic>> assignIssue(
    int issueId, {
    required int assignedTo,
  }) async {
    try {
      final data = <String, dynamic>{
        'assigned_to': assignedTo,
      };

      return await _apiService.post('/issues/$issueId/assign', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes critiques
  Future<Map<String, dynamic>> getCriticalIssues() async {
    try {
      return await _apiService.get('/issues/critical');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes assignés à l'utilisateur connecté
  Future<Map<String, dynamic>> getMyAssignedIssues() async {
    try {
      return await _apiService.get('/issues/my-assigned');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les problèmes

  // Obtenir les problèmes par statut
  Future<Map<String, dynamic>> getIssuesByStatus(String status, {int? perPage}) async {
    return await getIssues(status: status, perPage: perPage);
  }

  // Obtenir les problèmes par priorité
  Future<Map<String, dynamic>> getIssuesByPriority(String priority, {int? perPage}) async {
    return await getIssues(priority: priority, perPage: perPage);
  }

  // Obtenir les problèmes par type
  Future<Map<String, dynamic>> getIssuesByType(String type, {int? perPage}) async {
    return await getIssues(type: type, perPage: perPage);
  }

  // Obtenir les problèmes d'un projet spécifique
  Future<Map<String, dynamic>> getIssuesByProject(int projectId, {int? perPage}) async {
    return await getIssues(projectId: projectId, perPage: perPage);
  }

  // Obtenir les problèmes ouverts
  Future<Map<String, dynamic>> getOpenIssues({int? perPage}) async {
    return await getIssues(status: 'open', perPage: perPage);
  }

  // Obtenir les problèmes en cours
  Future<Map<String, dynamic>> getInProgressIssues({int? perPage}) async {
    return await getIssues(status: 'in_progress', perPage: perPage);
  }

  // Obtenir les problèmes résolus
  Future<Map<String, dynamic>> getResolvedIssues({int? perPage}) async {
    return await getIssues(status: 'resolved', perPage: perPage);
  }

  // Obtenir les problèmes fermés
  Future<Map<String, dynamic>> getClosedIssues({int? perPage}) async {
    return await getIssues(status: 'closed', perPage: perPage);
  }

  // Obtenir les problèmes de priorité faible
  Future<Map<String, dynamic>> getLowPriorityIssues({int? perPage}) async {
    return await getIssues(priority: 'low', perPage: perPage);
  }

  // Obtenir les problèmes de priorité moyenne
  Future<Map<String, dynamic>> getMediumPriorityIssues({int? perPage}) async {
    return await getIssues(priority: 'medium', perPage: perPage);
  }

  // Obtenir les problèmes de priorité élevée
  Future<Map<String, dynamic>> getHighPriorityIssues({int? perPage}) async {
    return await getIssues(priority: 'high', perPage: perPage);
  }

  // Obtenir les problèmes de priorité critique
  Future<Map<String, dynamic>> getCriticalPriorityIssues({int? perPage}) async {
    return await getIssues(priority: 'critical', perPage: perPage);
  }

  // Obtenir les problèmes de sécurité
  Future<Map<String, dynamic>> getSafetyIssues({int? perPage}) async {
    return await getIssues(type: 'safety', perPage: perPage);
  }

  // Obtenir les problèmes de qualité
  Future<Map<String, dynamic>> getQualityIssues({int? perPage}) async {
    return await getIssues(type: 'quality', perPage: perPage);
  }

  // Obtenir les problèmes logistiques
  Future<Map<String, dynamic>> getLogisticsIssues({int? perPage}) async {
    return await getIssues(type: 'logistics', perPage: perPage);
  }

  // Obtenir les problèmes techniques
  Future<Map<String, dynamic>> getTechnicalIssues({int? perPage}) async {
    return await getIssues(type: 'technical', perPage: perPage);
  }

  // Obtenir les autres types de problèmes
  Future<Map<String, dynamic>> getOtherIssues({int? perPage}) async {
    return await getIssues(type: 'other', perPage: perPage);
  }

  // Obtenir les problèmes urgents (critiques + haute priorité)
  Future<Map<String, dynamic>> getUrgentIssues({int? perPage}) async {
    try {
      final criticalIssues = await getCriticalIssues();
      final highPriorityIssues = await getHighPriorityIssues(perPage: perPage);
      
      if (criticalIssues['success'] == true && highPriorityIssues['success'] == true) {
        final critical = criticalIssues['data'] as List;
        final high = highPriorityIssues['data']['data'] as List;
        
        // Combiner et dédupliquer par ID
        final allIssues = <Map<String, dynamic>>[];
        final seenIds = <int>{};
        
        for (final issue in critical) {
          if (!seenIds.contains(issue['id'])) {
            allIssues.add(issue);
            seenIds.add(issue['id']);
          }
        }
        
        for (final issue in high) {
          if (!seenIds.contains(issue['id'])) {
            allIssues.add(issue);
            seenIds.add(issue['id']);
          }
        }
        
        // Trier par priorité puis par date de signalement
        allIssues.sort((a, b) {
          final priorityOrder = {'critical': 4, 'high': 3, 'medium': 2, 'low': 1};
          final priorityA = priorityOrder[a['priority']] ?? 0;
          final priorityB = priorityOrder[b['priority']] ?? 0;
          
          if (priorityA != priorityB) {
            return priorityB.compareTo(priorityA);
          }
          
          final dateA = DateTime.parse(a['reported_at']);
          final dateB = DateTime.parse(b['reported_at']);
          return dateB.compareTo(dateA);
        });

        return {
          'success': true,
          'data': {
            'data': allIssues,
            'total': allIssues.length,
            'urgent_count': allIssues.length,
            'critical_count': critical.length,
            'high_priority_count': high.length,
          }
        };
      }
      
      return criticalIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes non assignés
  Future<Map<String, dynamic>> getUnassignedIssues({int? perPage}) async {
    try {
      final allIssues = await getIssues(perPage: perPage);
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        
        final unassignedIssues = issues.where((issue) {
          return issue['assigned_to'] == null;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': unassignedIssues,
            'total': unassignedIssues.length,
            'unassigned_count': unassignedIssues.length,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes récents (7 derniers jours)
  Future<Map<String, dynamic>> getRecentIssues({int? perPage}) async {
    try {
      final allIssues = await getIssues(perPage: perPage);
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        final weekAgo = DateTime.now().subtract(Duration(days: 7));
        
        final recentIssues = issues.where((issue) {
          final reportedAt = DateTime.parse(issue['reported_at']);
          return reportedAt.isAfter(weekAgo);
        }).toList();

        return {
          'success': true,
          'data': {
            'data': recentIssues,
            'total': recentIssues.length,
            'recent_count': recentIssues.length,
            'days_ago': 7,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes en retard (plus de 7 jours)
  Future<Map<String, dynamic>> getOverdueIssues({int? perPage}) async {
    try {
      final allIssues = await getIssues(perPage: perPage);
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        final weekAgo = DateTime.now().subtract(Duration(days: 7));
        
        final overdueIssues = issues.where((issue) {
          final reportedAt = DateTime.parse(issue['reported_at']);
          final status = issue['status'];
          return reportedAt.isBefore(weekAgo) && 
                 status != 'resolved' && 
                 status != 'closed';
        }).toList();

        return {
          'success': true,
          'data': {
            'data': overdueIssues,
            'total': overdueIssues.length,
            'overdue_count': overdueIssues.length,
            'days_threshold': 7,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des problèmes par titre ou description
  Future<Map<String, dynamic>> searchIssues(String searchQuery, {int? perPage}) async {
    try {
      final allIssues = await getIssues(perPage: perPage);
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        final query = searchQuery.toLowerCase();
        
        final searchResults = issues.where((issue) {
          final title = issue['title']?.toString().toLowerCase() ?? '';
          final description = issue['description']?.toString().toLowerCase() ?? '';
          final location = issue['location']?.toString().toLowerCase() ?? '';
          
          return title.contains(query) || 
                 description.contains(query) || 
                 location.contains(query);
        }).toList();

        return {
          'success': true,
          'data': {
            'data': searchResults,
            'total': searchResults.length,
            'search_query': searchQuery,
            'results_count': searchResults.length,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des problèmes
  Future<Map<String, dynamic>> getIssueStats() async {
    try {
      final allIssues = await getIssues(perPage: 1000); // Récupérer toutes pour les stats
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        
        int open = 0;
        int inProgress = 0;
        int resolved = 0;
        int closed = 0;
        int low = 0;
        int medium = 0;
        int high = 0;
        int critical = 0;
        int safety = 0;
        int quality = 0;
        int logistics = 0;
        int technical = 0;
        int other = 0;
        int assigned = 0;
        int unassigned = 0;
        int urgent = 0;
        
        for (final issue in issues) {
          final status = issue['status'];
          final priority = issue['priority'];
          final type = issue['type'];
          final assignedTo = issue['assigned_to'];
          
          // Compter par statut
          switch (status) {
            case 'open':
              open++;
              break;
            case 'in_progress':
              inProgress++;
              break;
            case 'resolved':
              resolved++;
              break;
            case 'closed':
              closed++;
              break;
          }
          
          // Compter par priorité
          switch (priority) {
            case 'low':
              low++;
              break;
            case 'medium':
              medium++;
              break;
            case 'high':
              high++;
              urgent++;
              break;
            case 'critical':
              critical++;
              urgent++;
              break;
          }
          
          // Compter par type
          switch (type) {
            case 'safety':
              safety++;
              break;
            case 'quality':
              quality++;
              break;
            case 'logistics':
              logistics++;
              break;
            case 'technical':
              technical++;
              break;
            case 'other':
              other++;
              break;
          }
          
          // Compter assignés/non assignés
          if (assignedTo != null) {
            assigned++;
          } else {
            unassigned++;
          }
        }

        return {
          'success': true,
          'data': {
            'total': issues.length,
            'by_status': {
              'open': open,
              'in_progress': inProgress,
              'resolved': resolved,
              'closed': closed,
            },
            'by_priority': {
              'low': low,
              'medium': medium,
              'high': high,
              'critical': critical,
            },
            'by_type': {
              'safety': safety,
              'quality': quality,
              'logistics': logistics,
              'technical': technical,
              'other': other,
            },
            'assigned': assigned,
            'unassigned': unassigned,
            'urgent': urgent,
            'resolution_rate': issues.isNotEmpty ? (resolved / issues.length * 100).roundToDouble() : 0.0,
            'assignment_rate': issues.isNotEmpty ? (assigned / issues.length * 100).roundToDouble() : 0.0,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les problèmes par période
  Future<Map<String, dynamic>> getIssuesByPeriod({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allIssues = await getIssues(perPage: perPage);
      
      if (allIssues['success'] == true && allIssues['data']['data'] != null) {
        final issues = allIssues['data']['data'] as List;
        
        final periodIssues = issues.where((issue) {
          final reportedAt = DateTime.parse(issue['reported_at']);
          
          if (startDate != null && reportedAt.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && reportedAt.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': periodIssues,
            'total': periodIssues.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'period_count': periodIssues.length,
          }
        };
      }
      
      return allIssues;
    } catch (e) {
      rethrow;
    }
  }
}

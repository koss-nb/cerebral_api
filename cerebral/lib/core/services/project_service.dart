import 'api_service.dart';

class ProjectService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous les projets avec filtres, recherche, tri et pagination
  Future<Map<String, dynamic>> getProjects({
    String? status,
    String? type,
    String? priority,
    int? managerId,
    String? searchQuery,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
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
      
      if (priority != null) {
        queryParams['priority'] = priority;
      }
      
      if (managerId != null) {
        queryParams['manager_id'] = managerId.toString();
      }
      
      if (searchQuery != null) {
        queryParams['search'] = searchQuery;
      }
      
      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }
      
      if (sortOrder != null) {
        queryParams['sort_order'] = sortOrder;
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/projects$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer un nouveau projet
  Future<Map<String, dynamic>> createProject({
    required String name,
    required String type,
    required String status,
    required String priority,
    required String clientName,
    required String clientEmail,
    required String location,
    required int managerId,
    String? description,
    double? budget,
    String? currency,
    String? clientPhone,
    DateTime? startDate,
    DateTime? endDate,
    double? progress,
    List<int>? teamMembers,
    List<String>? tags,
    List<String>? attachments,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'type': type,
        'status': status,
        'priority': priority,
        'client_name': clientName,
        'client_email': clientEmail,
        'location': location,
        'manager_id': managerId,
      };

      if (description != null) {
        data['description'] = description;
      }
      
      if (budget != null) {
        data['budget'] = budget;
      }
      
      if (currency != null) {
        data['currency'] = currency;
      }
      
      if (clientPhone != null) {
        data['client_phone'] = clientPhone;
      }
      
      if (startDate != null) {
        data['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        data['end_date'] = endDate.toIso8601String();
      }
      
      if (progress != null) {
        data['progress'] = progress;
      }
      
      if (teamMembers != null) {
        data['team_members'] = teamMembers;
      }
      
      if (tags != null) {
        data['tags'] = tags;
      }
      
      if (attachments != null) {
        data['attachments'] = attachments;
      }

      return await _apiService.post('/projects', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un projet spécifique
  Future<Map<String, dynamic>> getProjectById(int projectId) async {
    try {
      return await _apiService.get('/projects/$projectId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un projet
  Future<Map<String, dynamic>> updateProject(
    int projectId, {
    String? name,
    String? description,
    String? type,
    String? status,
    double? budget,
    String? currency,
    String? location,
    int? managerId,
    DateTime? startDate,
    DateTime? endDate,
    double? progress,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) {
        data['name'] = name;
      }
      
      if (description != null) {
        data['description'] = description;
      }
      
      if (type != null) {
        data['type'] = type;
      }
      
      if (status != null) {
        data['status'] = status;
      }
      
      if (budget != null) {
        data['budget'] = budget;
      }
      
      if (currency != null) {
        data['currency'] = currency;
      }
      
      if (location != null) {
        data['location'] = location;
      }
      
      if (managerId != null) {
        data['manager_id'] = managerId;
      }
      
      if (startDate != null) {
        data['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        data['end_date'] = endDate.toIso8601String();
      }
      
      if (progress != null) {
        data['progress'] = progress;
      }

      return await _apiService.put('/projects/$projectId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un projet
  Future<Map<String, dynamic>> deleteProject(int projectId) async {
    try {
      return await _apiService.delete('/projects/$projectId');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques d'un projet
  Future<Map<String, dynamic>> getProjectStats(int projectId) async {
    try {
      return await _apiService.get('/projects/$projectId/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le progrès d'un projet
  Future<Map<String, dynamic>> updateProjectProgress(
    int projectId, {
    required String status,
    required double progress,
  }) async {
    try {
      final data = <String, dynamic>{
        'status': status,
        'progress': progress,
      };

      return await _apiService.put('/projects/$projectId/progress', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets de l'utilisateur connecté selon son rôle
  Future<Map<String, dynamic>> getMyProjects({int? perPage = 15}) async {
    try {
      final queryParams = <String, String>{};
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/projects/my$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les projets

  // Obtenir les projets par statut
  Future<Map<String, dynamic>> getProjectsByStatus(String status, {int? perPage}) async {
    return await getProjects(status: status, perPage: perPage);
  }

  // Obtenir les projets par type
  Future<Map<String, dynamic>> getProjectsByType(String type, {int? perPage}) async {
    return await getProjects(type: type, perPage: perPage);
  }

  // Obtenir les projets par priorité
  Future<Map<String, dynamic>> getProjectsByPriority(String priority, {int? perPage}) async {
    return await getProjects(priority: priority, perPage: perPage);
  }

  // Obtenir les projets par manager
  Future<Map<String, dynamic>> getProjectsByManager(int managerId, {int? perPage}) async {
    return await getProjects(managerId: managerId, perPage: perPage);
  }

  // Rechercher des projets
  Future<Map<String, dynamic>> searchProjects(String searchQuery, {int? perPage}) async {
    return await getProjects(searchQuery: searchQuery, perPage: perPage);
  }

  // Obtenir les projets en planification
  Future<Map<String, dynamic>> getPlanningProjects({int? perPage}) async {
    return await getProjects(status: 'planning', perPage: perPage);
  }

  // Obtenir les projets en cours
  Future<Map<String, dynamic>> getInProgressProjects({int? perPage}) async {
    return await getProjects(status: 'in_progress', perPage: perPage);
  }

  // Obtenir les projets en attente
  Future<Map<String, dynamic>> getOnHoldProjects({int? perPage}) async {
    return await getProjects(status: 'on_hold', perPage: perPage);
  }

  // Obtenir les projets terminés
  Future<Map<String, dynamic>> getCompletedProjects({int? perPage}) async {
    return await getProjects(status: 'completed', perPage: perPage);
  }

  // Obtenir les projets annulés
  Future<Map<String, dynamic>> getCancelledProjects({int? perPage}) async {
    return await getProjects(status: 'cancelled', perPage: perPage);
  }

  // Obtenir les projets résidentiels
  Future<Map<String, dynamic>> getResidentialProjects({int? perPage}) async {
    return await getProjects(type: 'residential', perPage: perPage);
  }

  // Obtenir les projets commerciaux
  Future<Map<String, dynamic>> getCommercialProjects({int? perPage}) async {
    return await getProjects(type: 'commercial', perPage: perPage);
  }

  // Obtenir les projets industriels
  Future<Map<String, dynamic>> getIndustrialProjects({int? perPage}) async {
    return await getProjects(type: 'industrial', perPage: perPage);
  }

  // Obtenir les projets de priorité basse
  Future<Map<String, dynamic>> getLowPriorityProjects({int? perPage}) async {
    return await getProjects(priority: 'low', perPage: perPage);
  }

  // Obtenir les projets de priorité moyenne
  Future<Map<String, dynamic>> getMediumPriorityProjects({int? perPage}) async {
    return await getProjects(priority: 'medium', perPage: perPage);
  }

  // Obtenir les projets de priorité haute
  Future<Map<String, dynamic>> getHighPriorityProjects({int? perPage}) async {
    return await getProjects(priority: 'high', perPage: perPage);
  }

  // Obtenir les projets de priorité critique
  Future<Map<String, dynamic>> getCriticalPriorityProjects({int? perPage}) async {
    return await getProjects(priority: 'critical', perPage: perPage);
  }

  // Obtenir les projets par gamme de budget
  Future<Map<String, dynamic>> getProjectsByBudgetRange({
    double? minBudget,
    double? maxBudget,
    int? perPage,
  }) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final budgetRangeProjects = projects.where((project) {
          final budget = project['budget'] ?? 0.0;
          
          if (minBudget != null && budget < minBudget) {
            return false;
          }
          
          if (maxBudget != null && budget > maxBudget) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': budgetRangeProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': budgetRangeProjects.length,
            'total': budgetRangeProjects.length,
            'min_budget': minBudget,
            'max_budget': maxBudget,
            'budget_range_count': budgetRangeProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par gamme de progrès
  Future<Map<String, dynamic>> getProjectsByProgressRange({
    double? minProgress,
    double? maxProgress,
    int? perPage,
  }) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final progressRangeProjects = projects.where((project) {
          final progress = project['progress'] ?? 0.0;
          
          if (minProgress != null && progress < minProgress) {
            return false;
          }
          
          if (maxProgress != null && progress > maxProgress) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': progressRangeProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': progressRangeProjects.length,
            'total': progressRangeProjects.length,
            'min_progress': minProgress,
            'max_progress': maxProgress,
            'progress_range_count': progressRangeProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par période
  Future<Map<String, dynamic>> getProjectsByPeriod({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final periodProjects = projects.where((project) {
          final projectStartDate = project['start_date'];
          final projectEndDate = project['end_date'];
          
          if (startDate != null && projectStartDate != null) {
            final start = DateTime.parse(projectStartDate);
            if (start.isBefore(startDate)) {
              return false;
            }
          }
          
          if (endDate != null && projectEndDate != null) {
            final end = DateTime.parse(projectEndDate);
            if (end.isAfter(endDate)) {
              return false;
            }
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': periodProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': periodProjects.length,
            'total': periodProjects.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'period_count': periodProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par localisation
  Future<Map<String, dynamic>> getProjectsByLocation(String location, {int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final locationProjects = projects.where((project) {
          final projectLocation = project['location']?.toString().toLowerCase() ?? '';
          return projectLocation.contains(location.toLowerCase());
        }).toList();

        return {
          'success': true,
          'data': locationProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': locationProjects.length,
            'total': locationProjects.length,
            'location': location,
            'location_count': locationProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par client
  Future<Map<String, dynamic>> getProjectsByClient(String clientName, {int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final clientProjects = projects.where((project) {
          final projectClientName = project['client_name']?.toString().toLowerCase() ?? '';
          return projectClientName.contains(clientName.toLowerCase());
        }).toList();

        return {
          'success': true,
          'data': clientProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': clientProjects.length,
            'total': clientProjects.length,
            'client_name': clientName,
            'client_count': clientProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par tags
  Future<Map<String, dynamic>> getProjectsByTags(List<String> tags, {int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final tagsProjects = projects.where((project) {
          final projectTags = project['tags'] ?? [];
          
          for (final tag in tags) {
            if (!projectTags.contains(tag)) {
              return false;
            }
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': tagsProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': tagsProjects.length,
            'total': tagsProjects.length,
            'required_tags': tags,
            'tags_match_count': tagsProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets en retard
  Future<Map<String, dynamic>> getOverdueProjects({int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final overdueProjects = projects.where((project) {
          final endDate = project['end_date'];
          if (endDate == null) return false;
          
          final end = DateTime.parse(endDate);
          final now = DateTime.now();
          return end.isBefore(now) && project['status'] != 'completed';
        }).toList();

        return {
          'success': true,
          'data': overdueProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': overdueProjects.length,
            'total': overdueProjects.length,
            'overdue_count': overdueProjects.length,
            'status': 'overdue',
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets à venir
  Future<Map<String, dynamic>> getUpcomingProjects({int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final upcomingProjects = projects.where((project) {
          final startDate = project['start_date'];
          if (startDate == null) return false;
          
          final start = DateTime.parse(startDate);
          final now = DateTime.now();
          final daysUntilStart = start.difference(now).inDays;
          return daysUntilStart >= 0 && daysUntilStart <= 30;
        }).toList();

        return {
          'success': true,
          'data': upcomingProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': upcomingProjects.length,
            'total': upcomingProjects.length,
            'upcoming_count': upcomingProjects.length,
            'status': 'upcoming',
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets récents
  Future<Map<String, dynamic>> getRecentProjects({int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final now = DateTime.now();
        final lastMonth = now.subtract(Duration(days: 30));
        
        final recentProjects = projects.where((project) {
          final createdAt = project['created_at'];
          if (createdAt == null) return false;
          
          final created = DateTime.parse(createdAt);
          return created.isAfter(lastMonth);
        }).toList();

        return {
          'success': true,
          'data': recentProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': recentProjects.length,
            'total': recentProjects.length,
            'recent_count': recentProjects.length,
            'time_period': '30_days',
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par équipe
  Future<Map<String, dynamic>> getProjectsByTeamMember(int teamMemberId, {int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final teamProjects = projects.where((project) {
          final teamMembers = project['team_members'] ?? [];
          return teamMembers.contains(teamMemberId);
        }).toList();

        return {
          'success': true,
          'data': teamProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': teamProjects.length,
            'total': teamProjects.length,
            'team_member_id': teamMemberId,
            'team_projects_count': teamProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les projets par devise
  Future<Map<String, dynamic>> getProjectsByCurrency(String currency, {int? perPage}) async {
    try {
      final allProjects = await getProjects(perPage: perPage);
      
      if (allProjects['success'] == true && allProjects['data'] != null) {
        final projects = allProjects['data'] as List;
        
        final currencyProjects = projects.where((project) {
          final projectCurrency = project['currency'] ?? 'EUR';
          return projectCurrency.toUpperCase() == currency.toUpperCase();
        }).toList();

        return {
          'success': true,
          'data': currencyProjects,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': currencyProjects.length,
            'total': currencyProjects.length,
            'currency': currency.toUpperCase(),
            'currency_count': currencyProjects.length,
          },
        };
      }
      
      return allProjects;
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si un projet peut être supprimé
  Future<bool> canDeleteProject(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        final tasksCount = data['tasks']?.length ?? 0;
        final budgetsCount = data['budgets']?.length ?? 0;
        
        // Un projet peut être supprimé s'il n'a pas de tâches ni de budgets
        return tasksCount == 0 && budgetsCount == 0;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le nombre de tâches d'un projet
  Future<int> getProjectTasksCount(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['tasks']?.length ?? 0;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de budgets d'un projet
  Future<int> getProjectBudgetsCount(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['budgets']?.length ?? 0;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nom du projet
  Future<String> getProjectName(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['name'] ?? '';
      }
      
      return '';
    } catch (e) {
      return '';
    }
  }

  // Obtenir le type du projet
  Future<String?> getProjectType(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['type'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le statut du projet
  Future<String?> getProjectStatus(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['status'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la priorité du projet
  Future<String?> getProjectPriority(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['priority'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le budget du projet
  Future<double?> getProjectBudget(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['budget']?.toDouble();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la devise du projet
  Future<String?> getProjectCurrency(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['currency'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le nom du client du projet
  Future<String?> getProjectClientName(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['client_name'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'email du client du projet
  Future<String?> getProjectClientEmail(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['client_email'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la localisation du projet
  Future<String?> getProjectLocation(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['location'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le manager du projet
  Future<Map<String, dynamic>?> getProjectManager(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return data['manager'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les tâches du projet
  Future<List<Map<String, dynamic>>> getProjectTasks(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return List<Map<String, dynamic>>.from(data['tasks'] ?? []);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les budgets du projet
  Future<List<Map<String, dynamic>>> getProjectBudgets(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        return List<Map<String, dynamic>>.from(data['budgets'] ?? []);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les membres de l'équipe du projet
  Future<List<int>> getProjectTeamMembers(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        final teamMembers = data['team_members'] ?? [];
        return List<int>.from(teamMembers);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les tags du projet
  Future<List<String>> getProjectTags(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        final tags = data['tags'] ?? [];
        return List<String>.from(tags);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les pièces jointes du projet
  Future<List<String>> getProjectAttachments(int projectId) async {
    try {
      final project = await getProjectById(projectId);
      
      if (project['success'] == true) {
        final data = project['data'];
        final attachments = data['attachments'] ?? [];
        return List<String>.from(attachments);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }
}

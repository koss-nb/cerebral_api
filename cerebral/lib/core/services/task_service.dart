import 'api_service.dart';

class TaskService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir toutes les tâches avec filtres, recherche, tri et pagination
  Future<Map<String, dynamic>> getTasks({
    String? status,
    String? priority,
    int? projectId,
    int? assignedTo,
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
      
      if (priority != null) {
        queryParams['priority'] = priority;
      }
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (assignedTo != null) {
        queryParams['assigned_to'] = assignedTo.toString();
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

      return await _apiService.get('/tasks$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer une nouvelle tâche
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    required int projectId,
    required String status,
    required String priority,
    required DateTime dueDate,
    int? assignedTo,
    int? createdBy,
    int? estimatedHours,
    int? actualHours,
    String? notes,
    List<String>? attachments,
    Map<String, dynamic>? customFields,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description,
        'project_id': projectId,
        'status': status,
        'priority': priority,
        'due_date': dueDate.toIso8601String(),
      };

      if (assignedTo != null) {
        data['assigned_to'] = assignedTo;
      }
      
      if (createdBy != null) {
        data['created_by'] = createdBy;
      }
      
      if (estimatedHours != null) {
        data['estimated_hours'] = estimatedHours;
      }
      
      if (actualHours != null) {
        data['actual_hours'] = actualHours;
      }
      
      if (notes != null) {
        data['notes'] = notes;
      }
      
      if (attachments != null) {
        data['attachments'] = attachments;
      }
      
      if (customFields != null) {
        data['custom_fields'] = customFields;
      }

      return await _apiService.post('/tasks', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir une tâche spécifique
  Future<Map<String, dynamic>> getTaskById(int taskId) async {
    try {
      return await _apiService.get('/tasks/$taskId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une tâche
  Future<Map<String, dynamic>> updateTask(
    int taskId, {
    String? title,
    String? description,
    int? projectId,
    String? status,
    String? priority,
    DateTime? dueDate,
    int? assignedTo,
    int? estimatedHours,
    int? actualHours,
    String? notes,
    List<String>? attachments,
    Map<String, dynamic>? customFields,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (title != null) {
        data['title'] = title;
      }
      
      if (description != null) {
        data['description'] = description;
      }
      
      if (projectId != null) {
        data['project_id'] = projectId;
      }
      
      if (status != null) {
        data['status'] = status;
      }
      
      if (priority != null) {
        data['priority'] = priority;
      }
      
      if (dueDate != null) {
        data['due_date'] = dueDate.toIso8601String();
      }
      
      if (assignedTo != null) {
        data['assigned_to'] = assignedTo;
      }
      
      if (estimatedHours != null) {
        data['estimated_hours'] = estimatedHours;
      }
      
      if (actualHours != null) {
        data['actual_hours'] = actualHours;
      }
      
      if (notes != null) {
        data['notes'] = notes;
      }
      
      if (attachments != null) {
        data['attachments'] = attachments;
      }
      
      if (customFields != null) {
        data['custom_fields'] = customFields;
      }

      return await _apiService.put('/tasks/$taskId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer une tâche
  Future<Map<String, dynamic>> deleteTask(int taskId) async {
    try {
      return await _apiService.delete('/tasks/$taskId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le statut d'une tâche
  Future<Map<String, dynamic>> updateTaskStatus(
    int taskId, {
    required String status,
    double? progress,
  }) async {
    try {
      final data = <String, dynamic>{
        'status': status,
      };

      if (progress != null) {
        data['progress'] = progress;
      }

      return await _apiService.put('/tasks/$taskId/status', data);
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour la progression d'une tâche
  Future<Map<String, dynamic>> updateTaskProgress(
    int taskId, {
    required double progress,
  }) async {
    try {
      final data = <String, dynamic>{
        'progress': progress,
      };

      return await _apiService.put('/tasks/$taskId/progress', data);
    } catch (e) {
      rethrow;
    }
  }

  // Assigner une tâche à un utilisateur
  Future<Map<String, dynamic>> assignTask(
    int taskId, {
    required int assignedTo,
    String? assignmentNotes,
  }) async {
    try {
      final data = <String, dynamic>{
        'assigned_to': assignedTo,
      };

      if (assignmentNotes != null) {
        data['assignment_notes'] = assignmentNotes;
      }

      return await _apiService.put('/tasks/$taskId/assign', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir mes tâches (assignées à l'utilisateur connecté)
  Future<Map<String, dynamic>> getMyTasks({
    String? status,
    String? priority,
    int? perPage = 15,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (priority != null) {
        queryParams['priority'] = priority;
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/tasks/my$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches en retard
  Future<Map<String, dynamic>> getOverdueTasks({int? perPage = 15}) async {
    try {
      final queryParams = <String, String>{};
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/tasks/overdue$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les tâches

  // Obtenir les tâches par statut
  Future<Map<String, dynamic>> getTasksByStatus(String status, {int? perPage}) async {
    return await getTasks(status: status, perPage: perPage);
  }

  // Obtenir les tâches par priorité
  Future<Map<String, dynamic>> getTasksByPriority(String priority, {int? perPage}) async {
    return await getTasks(priority: priority, perPage: perPage);
  }

  // Obtenir les tâches par projet
  Future<Map<String, dynamic>> getTasksByProject(int projectId, {int? perPage}) async {
    return await getTasks(projectId: projectId, perPage: perPage);
  }

  // Obtenir les tâches assignées à un utilisateur
  Future<Map<String, dynamic>> getTasksByUser(int userId, {int? perPage}) async {
    return await getTasks(assignedTo: userId, perPage: perPage);
  }

  // Rechercher des tâches
  Future<Map<String, dynamic>> searchTasks(String searchQuery, {int? perPage}) async {
    return await getTasks(searchQuery: searchQuery, perPage: perPage);
  }

  // Obtenir les tâches en attente
  Future<Map<String, dynamic>> getPendingTasks({int? perPage}) async {
    return await getTasks(status: 'pending', perPage: perPage);
  }

  // Obtenir les tâches en cours
  Future<Map<String, dynamic>> getInProgressTasks({int? perPage}) async {
    return await getTasks(status: 'in_progress', perPage: perPage);
  }

  // Obtenir les tâches en révision
  Future<Map<String, dynamic>> getReviewTasks({int? perPage}) async {
    return await getTasks(status: 'review', perPage: perPage);
  }

  // Obtenir les tâches terminées
  Future<Map<String, dynamic>> getCompletedTasks({int? perPage}) async {
    return await getTasks(status: 'completed', perPage: perPage);
  }

  // Obtenir les tâches annulées
  Future<Map<String, dynamic>> getCancelledTasks({int? perPage}) async {
    return await getTasks(status: 'cancelled', perPage: perPage);
  }

  // Obtenir les tâches de priorité basse
  Future<Map<String, dynamic>> getLowPriorityTasks({int? perPage}) async {
    return await getTasks(priority: 'low', perPage: perPage);
  }

  // Obtenir les tâches de priorité moyenne
  Future<Map<String, dynamic>> getMediumPriorityTasks({int? perPage}) async {
    return await getTasks(priority: 'medium', perPage: perPage);
  }

  // Obtenir les tâches de priorité haute
  Future<Map<String, dynamic>> getHighPriorityTasks({int? perPage}) async {
    return await getTasks(priority: 'high', perPage: perPage);
  }

  // Obtenir les tâches de priorité critique
  Future<Map<String, dynamic>> getCriticalPriorityTasks({int? perPage}) async {
    return await getTasks(priority: 'critical', perPage: perPage);
  }

  // Obtenir les tâches par gamme de progression
  Future<Map<String, dynamic>> getTasksByProgressRange({
    double? minProgress,
    double? maxProgress,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final progressRangeTasks = tasks.where((task) {
          final progress = task['progress'] ?? 0.0;
          
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
          'data': progressRangeTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': progressRangeTasks.length,
            'total': progressRangeTasks.length,
            'min_progress': minProgress,
            'max_progress': maxProgress,
            'progress_range_count': progressRangeTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par gamme d'heures estimées
  Future<Map<String, dynamic>> getTasksByEstimatedHoursRange({
    int? minHours,
    int? maxHours,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final hoursRangeTasks = tasks.where((task) {
          final estimatedHours = task['estimated_hours'] ?? 0;
          
          if (minHours != null && estimatedHours < minHours) {
            return false;
          }
          
          if (maxHours != null && estimatedHours > maxHours) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': hoursRangeTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': hoursRangeTasks.length,
            'total': hoursRangeTasks.length,
            'min_hours': minHours,
            'max_hours': maxHours,
            'hours_range_count': hoursRangeTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par gamme d'heures réelles
  Future<Map<String, dynamic>> getTasksByActualHoursRange({
    int? minHours,
    int? maxHours,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final hoursRangeTasks = tasks.where((task) {
          final actualHours = task['actual_hours'] ?? 0;
          
          if (minHours != null && actualHours < minHours) {
            return false;
          }
          
          if (maxHours != null && actualHours > maxHours) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': hoursRangeTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': hoursRangeTasks.length,
            'total': hoursRangeTasks.length,
            'min_hours': minHours,
            'max_hours': maxHours,
            'hours_range_count': hoursRangeTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par période d'échéance
  Future<Map<String, dynamic>> getTasksByDueDateRange({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final dueDateRangeTasks = tasks.where((task) {
          final dueDate = task['due_date'];
          if (dueDate == null) return false;
          
          final due = DateTime.parse(dueDate);
          
          if (startDate != null && due.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && due.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': dueDateRangeTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': dueDateRangeTasks.length,
            'total': dueDateRangeTasks.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'due_date_range_count': dueDateRangeTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par période de création
  Future<Map<String, dynamic>> getTasksByCreationDateRange({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final creationDateRangeTasks = tasks.where((task) {
          final createdAt = task['created_at'];
          if (createdAt == null) return false;
          
          final created = DateTime.parse(createdAt);
          
          if (startDate != null && created.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && created.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': creationDateRangeTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': creationDateRangeTasks.length,
            'total': creationDateRangeTasks.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'creation_date_range_count': creationDateRangeTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par efficacité
  Future<Map<String, dynamic>> getTasksByEfficiency({
    double? minEfficiency,
    double? maxEfficiency,
    int? perPage,
  }) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final efficiencyTasks = tasks.where((task) {
          final estimatedHours = task['estimated_hours'] ?? 0;
          final actualHours = task['actual_hours'] ?? 0;
          
          if (estimatedHours == 0) return false;
          
          final efficiency = ((estimatedHours - actualHours) / estimatedHours) * 100;
          
          if (minEfficiency != null && efficiency < minEfficiency) {
            return false;
          }
          
          if (maxEfficiency != null && efficiency > maxEfficiency) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': efficiencyTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': efficiencyTasks.length,
            'total': efficiencyTasks.length,
            'min_efficiency': minEfficiency,
            'max_efficiency': maxEfficiency,
            'efficiency_range_count': efficiencyTasks.length,
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches récentes
  Future<Map<String, dynamic>> getRecentTasks({int? perPage}) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final now = DateTime.now();
        final lastWeek = now.subtract(Duration(days: 7));
        
        final recentTasks = tasks.where((task) {
          final createdAt = task['created_at'];
          if (createdAt == null) return false;
          
          final created = DateTime.parse(createdAt);
          return created.isAfter(lastWeek);
        }).toList();

        return {
          'success': true,
          'data': recentTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': recentTasks.length,
            'total': recentTasks.length,
            'recent_count': recentTasks.length,
            'time_period': '7_days',
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches à venir
  Future<Map<String, dynamic>> getUpcomingTasks({int? perPage}) async {
    try {
      final allTasks = await getTasks(perPage: perPage);
      
      if (allTasks['success'] == true && allTasks['data'] != null) {
        final tasks = allTasks['data'] as List;
        
        final now = DateTime.now();
        final nextWeek = now.add(Duration(days: 7));
        
        final upcomingTasks = tasks.where((task) {
          final dueDate = task['due_date'];
          if (dueDate == null) return false;
          
          final due = DateTime.parse(dueDate);
          return due.isAfter(now) && due.isBefore(nextWeek);
        }).toList();

        return {
          'success': true,
          'data': upcomingTasks,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': upcomingTasks.length,
            'total': upcomingTasks.length,
            'upcoming_count': upcomingTasks.length,
            'time_period': 'next_7_days',
          },
        };
      }
      
      return allTasks;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les tâches par projet et statut
  Future<Map<String, dynamic>> getTasksByProjectAndStatus({
    required int projectId,
    required String status,
    int? perPage,
  }) async {
    return await getTasks(
      projectId: projectId,
      status: status,
      perPage: perPage,
    );
  }

  // Obtenir les tâches par projet et priorité
  Future<Map<String, dynamic>> getTasksByProjectAndPriority({
    required int projectId,
    required String priority,
    int? perPage,
  }) async {
    return await getTasks(
      projectId: projectId,
      priority: priority,
      perPage: perPage,
    );
  }

  // Obtenir les tâches par utilisateur et statut
  Future<Map<String, dynamic>> getTasksByUserAndStatus({
    required int userId,
    required String status,
    int? perPage,
  }) async {
    return await getTasks(
      assignedTo: userId,
      status: status,
      perPage: perPage,
    );
  }

  // Obtenir les tâches par utilisateur et priorité
  Future<Map<String, dynamic>> getTasksByUserAndPriority({
    required int userId,
    required String priority,
    int? perPage,
  }) async {
    return await getTasks(
      assignedTo: userId,
      priority: priority,
      perPage: perPage,
    );
  }

  // Vérifier si une tâche peut être supprimée
  Future<bool> canDeleteTask(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        final status = data['status'];
        
        // Une tâche peut être supprimée si elle n'est pas terminée
        return status != 'completed';
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le titre de la tâche
  Future<String> getTaskTitle(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['title'] ?? '';
      }
      
      return '';
    } catch (e) {
      return '';
    }
  }

  // Obtenir le statut de la tâche
  Future<String?> getTaskStatus(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['status'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la priorité de la tâche
  Future<String?> getTaskPriority(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['priority'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la progression de la tâche
  Future<double?> getTaskProgress(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['progress']?.toDouble();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la date d'échéance de la tâche
  Future<DateTime?> getTaskDueDate(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        final dueDate = data['due_date'];
        if (dueDate != null) {
          return DateTime.parse(dueDate);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le projet de la tâche
  Future<Map<String, dynamic>?> getTaskProject(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['project'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'utilisateur assigné à la tâche
  Future<Map<String, dynamic>?> getTaskAssignedTo(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['assigned_to'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'utilisateur qui a créé la tâche
  Future<Map<String, dynamic>?> getTaskCreatedBy(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['created_by'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les heures estimées de la tâche
  Future<int?> getTaskEstimatedHours(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['estimated_hours'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les heures réelles de la tâche
  Future<int?> getTaskActualHours(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['actual_hours'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'efficacité de la tâche
  Future<double?> getTaskEfficiency(int taskId) async {
    try {
      final estimatedHours = await getTaskEstimatedHours(taskId);
      final actualHours = await getTaskActualHours(taskId);
      
      if (estimatedHours != null && actualHours != null && estimatedHours > 0) {
        return ((estimatedHours - actualHours) / estimatedHours) * 100;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les notes de la tâche
  Future<String?> getTaskNotes(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        return data['notes'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les pièces jointes de la tâche
  Future<List<String>> getTaskAttachments(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        final attachments = data['attachments'] ?? [];
        return List<String>.from(attachments);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les champs personnalisés de la tâche
  Future<Map<String, dynamic>> getTaskCustomFields(int taskId) async {
    try {
      final task = await getTaskById(taskId);
      
      if (task['success'] == true) {
        final data = task['data'];
        final customFields = data['custom_fields'] ?? {};
        return Map<String, dynamic>.from(customFields);
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  // Vérifier si une tâche est en retard
  Future<bool> isTaskOverdue(int taskId) async {
    try {
      final dueDate = await getTaskDueDate(taskId);
      final status = await getTaskStatus(taskId);
      
      if (dueDate != null && status != 'completed') {
        final now = DateTime.now();
        return dueDate.isBefore(now);
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le nombre de jours de retard d'une tâche
  Future<int?> getTaskOverdueDays(int taskId) async {
    try {
      final dueDate = await getTaskDueDate(taskId);
      final status = await getTaskStatus(taskId);
      
      if (dueDate != null && status != 'completed') {
        final now = DateTime.now();
        if (dueDate.isBefore(now)) {
          return now.difference(dueDate).inDays;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le nombre de jours restants pour une tâche
  Future<int?> getTaskRemainingDays(int taskId) async {
    try {
      final dueDate = await getTaskDueDate(taskId);
      final status = await getTaskStatus(taskId);
      
      if (dueDate != null && status != 'completed') {
        final now = DateTime.now();
        if (dueDate.isAfter(now)) {
          return dueDate.difference(now).inDays;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

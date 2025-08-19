import 'api_service.dart';

class WorkflowService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous les workflows avec filtres et pagination
  Future<Map<String, dynamic>> getWorkflows({
    String? type,
    String? status,
    bool? isActive,
    String? search,
    int? perPage = 15,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (type != null) {
        queryParams['type'] = type;
      }

      if (status != null) {
        queryParams['status'] = status;
      }

      if (isActive != null) {
        queryParams['is_active'] = isActive.toString();
      }

      if (search != null) {
        queryParams['search'] = search;
      }

      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/workflows$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer un nouveau workflow
  Future<Map<String, dynamic>> createWorkflow({
    required String name,
    String? description,
    required String type,
    required String status,
    required List<Map<String, dynamic>> steps,
    List<Map<String, dynamic>>? conditions,
    required int createdBy,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'type': type,
        'status': status,
        'steps': steps,
        'created_by': createdBy,
      };

      if (description != null) {
        data['description'] = description;
      }

      if (conditions != null) {
        data['conditions'] = conditions;
      }

      if (isActive != null) {
        data['is_active'] = isActive;
      }

      return await _apiService.post('/workflows', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un workflow spécifique
  Future<Map<String, dynamic>> getWorkflow(int workflowId) async {
    try {
      return await _apiService.get('/workflows/$workflowId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un workflow
  Future<Map<String, dynamic>> updateWorkflow({
    required int workflowId,
    String? name,
    String? description,
    String? type,
    String? status,
    List<Map<String, dynamic>>? steps,
    List<Map<String, dynamic>>? conditions,
    bool? isActive,
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

      if (steps != null) {
        data['steps'] = steps;
      }

      if (conditions != null) {
        data['conditions'] = conditions;
      }

      if (isActive != null) {
        data['is_active'] = isActive;
      }

      return await _apiService.put('/workflows/$workflowId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un workflow
  Future<Map<String, dynamic>> deleteWorkflow(int workflowId) async {
    try {
      return await _apiService.delete('/workflows/$workflowId');
    } catch (e) {
      rethrow;
    }
  }

  // Activer un workflow
  Future<Map<String, dynamic>> activateWorkflow(int workflowId) async {
    try {
      return await _apiService.post('/workflows/$workflowId/activate', {});
    } catch (e) {
      rethrow;
    }
  }

  // Désactiver un workflow
  Future<Map<String, dynamic>> deactivateWorkflow(int workflowId) async {
    try {
      return await _apiService.post('/workflows/$workflowId/deactivate', {});
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les étapes d'un workflow
  Future<Map<String, dynamic>> getWorkflowSteps(int workflowId) async {
    try {
      return await _apiService.get('/workflows/$workflowId/steps');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour les étapes d'un workflow
  Future<Map<String, dynamic>> updateWorkflowSteps({
    required int workflowId,
    required List<Map<String, dynamic>> steps,
  }) async {
    try {
      final data = <String, dynamic>{
        'steps': steps,
      };

      return await _apiService.put('/workflows/$workflowId/steps', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les types de workflow
  Future<Map<String, dynamic>> getWorkflowTypes() async {
    try {
      return await _apiService.get('/workflows/types');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des workflows
  Future<Map<String, dynamic>> getWorkflowStats() async {
    try {
      return await _apiService.get('/workflows/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Cloner un workflow
  Future<Map<String, dynamic>> cloneWorkflow(int workflowId) async {
    try {
      return await _apiService.post('/workflows/$workflowId/clone', {});
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les workflows

  // Obtenir les workflows par type
  Future<Map<String, dynamic>> getWorkflowsByType(String type,
      {int? perPage}) async {
    try {
      return await getWorkflows(type: type, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows par statut
  Future<Map<String, dynamic>> getWorkflowsByStatus(String status,
      {int? perPage}) async {
    try {
      return await getWorkflows(status: status, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows actifs
  Future<Map<String, dynamic>> getActiveWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(isActive: true, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows inactifs
  Future<Map<String, dynamic>> getInactiveWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(isActive: false, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows en brouillon
  Future<Map<String, dynamic>> getDraftWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(status: 'draft', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows d'approbation
  Future<Map<String, dynamic>> getApprovalWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(type: 'approval', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows de révision
  Future<Map<String, dynamic>> getReviewWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(type: 'review', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows de validation
  Future<Map<String, dynamic>> getValidationWorkflows({int? perPage}) async {
    try {
      return await getWorkflows(type: 'validation', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des workflows
  Future<Map<String, dynamic>> searchWorkflows(String searchTerm,
      {int? perPage}) async {
    try {
      return await getWorkflows(search: searchTerm, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour analyser les workflows

  // Vérifier si un workflow peut être supprimé
  Future<bool> canDeleteWorkflow(int workflowId) async {
    try {
      // Cette méthode pourrait vérifier les dépendances
      // Pour l'instant, on retourne true par défaut
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le nom d'un workflow
  Future<String?> getWorkflowName(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['name'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le type d'un workflow
  Future<String?> getWorkflowType(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['type'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le statut d'un workflow
  Future<String?> getWorkflowStatus(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['status'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si un workflow est actif
  Future<bool> isWorkflowActive(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['is_active'] == true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le créateur d'un workflow
  Future<Map<String, dynamic>?> getWorkflowCreator(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['creator'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les étapes d'un workflow
  Future<List<Map<String, dynamic>>?> getWorkflowStepsList(
      int workflowId) async {
    try {
      final steps = await getWorkflowSteps(workflowId);

      if (steps['success'] == true) {
        return List<Map<String, dynamic>>.from(steps['data']['steps'] ?? []);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les conditions d'un workflow
  Future<List<Map<String, dynamic>>?> getWorkflowConditions(
      int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return List<Map<String, dynamic>>.from(
            workflow['data']['conditions'] ?? []);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la description d'un workflow
  Future<String?> getWorkflowDescription(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        return workflow['data']['description'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le nombre total d'étapes d'un workflow
  Future<int?> getWorkflowStepsCount(int workflowId) async {
    try {
      final steps = await getWorkflowSteps(workflowId);

      if (steps['success'] == true) {
        return (steps['data']['steps'] as List?)?.length ?? 0;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si un workflow a des étapes
  Future<bool> hasWorkflowSteps(int workflowId) async {
    try {
      final stepsCount = await getWorkflowStepsCount(workflowId);
      return stepsCount != null && stepsCount > 0;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un workflow a des conditions
  Future<bool> hasWorkflowConditions(int workflowId) async {
    try {
      final conditions = await getWorkflowConditions(workflowId);
      return conditions != null && conditions.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Obtenir les statistiques détaillées des workflows
  Future<Map<String, dynamic>> getDetailedWorkflowStats() async {
    try {
      final stats = await getWorkflowStats();

      if (stats['success'] == true) {
        final data = stats['data'];

        // Calculer des statistiques supplémentaires
        final totalWorkflows = data['total_workflows'] ?? 0;
        final activeWorkflows = data['active_workflows'] ?? 0;
        final draftWorkflows = data['draft_workflows'] ?? 0;
        final inactiveWorkflows = data['inactive_workflows'] ?? 0;

        final additionalStats = {
          'total_workflows': totalWorkflows,
          'active_workflows': activeWorkflows,
          'draft_workflows': draftWorkflows,
          'inactive_workflows': inactiveWorkflows,
          'by_type': data['by_type'] ?? {},
          'active_percentage': totalWorkflows > 0
              ? (activeWorkflows / totalWorkflows * 100).toStringAsFixed(2)
              : '0.00',
          'draft_percentage': totalWorkflows > 0
              ? (draftWorkflows / totalWorkflows * 100).toStringAsFixed(2)
              : '0.00',
          'inactive_percentage': totalWorkflows > 0
              ? (inactiveWorkflows / totalWorkflows * 100).toStringAsFixed(2)
              : '0.00',
        };

        return {
          'success': true,
          'data': additionalStats,
        };
      }

      return stats;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows par créateur
  Future<Map<String, dynamic>> getWorkflowsByCreator(int creatorId,
      {int? perPage}) async {
    try {
      // Cette méthode nécessiterait un endpoint spécifique dans l'API
      // Pour l'instant, on récupère tous les workflows et on filtre côté client
      final allWorkflows = await getWorkflows(perPage: 1000);

      if (allWorkflows['success'] == true) {
        final workflows = allWorkflows['data'] as List;
        final filteredWorkflows =
            workflows.where((w) => w['created_by'] == creatorId).toList();

        return {
          'success': true,
          'data': filteredWorkflows,
          'pagination': {
            'current_page': 1,
            'last_page': 1,
            'per_page': filteredWorkflows.length,
            'total': filteredWorkflows.length,
          },
        };
      }

      return allWorkflows;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows récents
  Future<Map<String, dynamic>> getRecentWorkflows({int? perPage = 10}) async {
    try {
      final workflows = await getWorkflows(perPage: perPage);

      if (workflows['success'] == true) {
        final data = workflows['data'] as List;

        // Trier par date de création (plus récent en premier)
        data.sort((a, b) {
          final aDate = DateTime.tryParse(a['created_at'] ?? '');
          final bDate = DateTime.tryParse(b['created_at'] ?? '');

          if (aDate == null || bDate == null) return 0;
          return bDate.compareTo(aDate);
        });

        return {
          'success': true,
          'data': data,
          'pagination': workflows['pagination'],
          'meta': {
            'recent_count': data.length,
          },
        };
      }

      return workflows;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les workflows populaires (par nombre d'utilisations)
  Future<Map<String, dynamic>> getPopularWorkflows({int? perPage = 10}) async {
    try {
      // Cette méthode nécessiterait un endpoint spécifique dans l'API
      // Pour l'instant, on retourne les workflows actifs
      return await getActiveWorkflows(perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si un workflow peut être activé
  Future<bool> canActivateWorkflow(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        final status = workflow['data']['status'];
        return status == 'draft' || status == 'inactive';
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un workflow peut être désactivé
  Future<bool> canDeactivateWorkflow(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        final status = workflow['data']['status'];
        return status == 'active';
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un workflow peut être cloné
  Future<bool> canCloneWorkflow(int workflowId) async {
    try {
      // Tous les workflows peuvent être clonés
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le résumé d'un workflow
  Future<Map<String, dynamic>?> getWorkflowSummary(int workflowId) async {
    try {
      final workflow = await getWorkflow(workflowId);

      if (workflow['success'] == true) {
        final data = workflow['data'];

        return {
          'id': data['id'],
          'name': data['name'],
          'type': data['type'],
          'status': data['status'],
          'is_active': data['is_active'],
          'description': data['description'],
          'steps_count': (data['steps'] as List?)?.length ?? 0,
          'has_conditions': (data['conditions'] as List?)?.isNotEmpty ?? false,
          'creator_name': data['creator']?['name'] ?? 'Créateur inconnu',
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le résumé de tous les workflows
  Future<List<Map<String, dynamic>>> getAllWorkflowSummaries(
      {int? perPage}) async {
    try {
      final workflows = await getWorkflows(perPage: perPage);

      if (workflows['success'] == true) {
        final data = workflows['data'] as List;

        return data
            .map((workflow) => {
                  'id': workflow['id'],
                  'name': workflow['name'],
                  'type': workflow['type'],
                  'status': workflow['status'],
                  'is_active': workflow['is_active'],
                  'description': workflow['description'],
                  'steps_count': (workflow['steps'] as List?)?.length ?? 0,
                  'has_conditions':
                      (workflow['conditions'] as List?)?.isNotEmpty ?? false,
                  'creator_name':
                      workflow['creator']?['name'] ?? 'Créateur inconnu',
                  'created_at': workflow['created_at'],
                  'updated_at': workflow['updated_at'],
                })
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}

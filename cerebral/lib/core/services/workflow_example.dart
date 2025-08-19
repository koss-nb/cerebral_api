import 'workflow_service.dart';

/// Exemple d'utilisation complète du service de workflow
/// Basé sur le WorkflowController Laravel avec toutes les fonctionnalités avancées
class WorkflowExample {
  final WorkflowService _workflowService = WorkflowService();

  /// Exemple de création d'un workflow
  Future<void> createWorkflowExample() async {
    try {
      print('🚀 Création d\'un nouveau workflow...');

      final workflow = await _workflowService.createWorkflow(
        name: 'Workflow d\'approbation des projets',
        description:
            'Processus d\'approbation en 3 étapes pour les projets de construction',
        type: 'approval',
        status: 'draft',
        steps: [
          {
            'name': 'Soumission initiale',
            'order': 1,
            'assigned_role': 'project_manager',
            'description':
                'Le chef de projet soumet le projet pour approbation',
          },
          {
            'name': 'Révision technique',
            'order': 2,
            'assigned_role': 'technical_lead',
            'description': 'L\'équipe technique examine la faisabilité',
          },
          {
            'name': 'Approbation finale',
            'order': 3,
            'assigned_role': 'director',
            'description': 'Le directeur donne l\'approbation finale',
          },
        ],
        conditions: [
          {
            'step': 2,
            'condition': 'budget > 100000',
            'action': 'require_additional_review',
          },
        ],
        createdBy: 1,
        isActive: false,
      );

      print('✅ Workflow créé avec succès !');
      print('   ID: ${workflow['data']['id']}');
      print('   Nom: ${workflow['data']['name']}');
      print('   Type: ${workflow['data']['type']}');
      print('   Statut: ${workflow['data']['status']}');
      print('   Étapes: ${(workflow['data']['steps'] as List).length}');
      print(
          '   Conditions: ${(workflow['data']['conditions'] as List).length}');
      print(
          '   Créateur: ${workflow['data']['creator']?['name'] ?? 'Non défini'}');
      print('   Message: ${workflow['message']}');
    } catch (e) {
      print('❌ Erreur lors de la création du workflow: $e');
    }
  }

  /// Exemple de récupération de tous les workflows
  Future<void> getWorkflowsExample() async {
    try {
      print('📋 Récupération de tous les workflows...');

      final workflows = await _workflowService.getWorkflows(perPage: 10);

      print('✅ Workflows récupérés avec succès !');
      print('   Total: ${workflows['pagination']['total'] ?? 0}');
      print(
          '   Page actuelle: ${workflows['pagination']['current_page'] ?? 1}');
      print('   Par page: ${workflows['pagination']['per_page'] ?? 15}');

      print('\n📋 WORKFLOWS:');
      for (final workflow in workflows['data']) {
        print('   • ${workflow['name']}');
        print('     Type: ${workflow['type']}');
        print('     Statut: ${workflow['status']}');
        print('     Actif: ${workflow['is_active'] ? 'Oui' : 'Non'}');
        print('     Étapes: ${(workflow['steps'] as List?)?.length ?? 0}');
        print('     Créateur: ${workflow['creator']?['name'] ?? 'Non défini'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des workflows: $e');
    }
  }

  /// Exemple de récupération d'un workflow spécifique
  Future<void> getWorkflowExample() async {
    try {
      print('🔍 Récupération d\'un workflow spécifique...');

      final workflow = await _workflowService.getWorkflow(1);

      print('✅ Workflow récupéré avec succès !');
      print('   ID: ${workflow['data']['id']}');
      print('   Nom: ${workflow['data']['name']}');
      print('   Description: ${workflow['data']['description'] ?? 'Aucune'}');
      print('   Type: ${workflow['data']['type']}');
      print('   Statut: ${workflow['data']['status']}');
      print('   Actif: ${workflow['data']['is_active'] ? 'Oui' : 'Non'}');
      print(
          '   Créateur: ${workflow['data']['creator']?['name'] ?? 'Non défini'}');
      print('   Créé le: ${workflow['data']['created_at']}');
      print('   Modifié le: ${workflow['data']['updated_at']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération du workflow: $e');
    }
  }

  /// Exemple de filtrage des workflows par type
  Future<void> getWorkflowsByTypeExample() async {
    try {
      print('🏷️ Récupération des workflows par type...');

      // Workflows d'approbation
      final approvalWorkflows =
          await _workflowService.getApprovalWorkflows(perPage: 5);
      print('\n✅ Workflows d\'approbation récupérés avec succès !');
      print('   Nombre: ${approvalWorkflows['data'].length}');

      // Workflows de révision
      final reviewWorkflows =
          await _workflowService.getReviewWorkflows(perPage: 5);
      print('\n✅ Workflows de révision récupérés avec succès !');
      print('   Nombre: ${reviewWorkflows['data'].length}');

      // Workflows de validation
      final validationWorkflows =
          await _workflowService.getValidationWorkflows(perPage: 5);
      print('\n✅ Workflows de validation récupérés avec succès !');
      print('   Nombre: ${validationWorkflows['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par type: $e');
    }
  }

  /// Exemple de filtrage des workflows par statut
  Future<void> getWorkflowsByStatusExample() async {
    try {
      print('📊 Récupération des workflows par statut...');

      // Workflows actifs
      final activeWorkflows =
          await _workflowService.getActiveWorkflows(perPage: 5);
      print('\n✅ Workflows actifs récupérés avec succès !');
      print('   Nombre: ${activeWorkflows['data'].length}');

      // Workflows inactifs
      final inactiveWorkflows =
          await _workflowService.getInactiveWorkflows(perPage: 5);
      print('\n✅ Workflows inactifs récupérés avec succès !');
      print('   Nombre: ${inactiveWorkflows['data'].length}');

      // Workflows en brouillon
      final draftWorkflows =
          await _workflowService.getDraftWorkflows(perPage: 5);
      print('\n✅ Workflows en brouillon récupérés avec succès !');
      print('   Nombre: ${draftWorkflows['data'].length}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple de recherche de workflows
  Future<void> searchWorkflowsExample() async {
    try {
      print('🔍 Recherche de workflows...');

      final searchResults =
          await _workflowService.searchWorkflows('approbation', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: approbation');
      print('   Résultats trouvés: ${searchResults['data'].length}');

      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final workflow in searchResults['data']) {
        print('   • ${workflow['name']}');
        print('     Type: ${workflow['type']}');
        print('     Statut: ${workflow['status']}');
        print('     Actif: ${workflow['is_active'] ? 'Oui' : 'Non'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple de récupération des types de workflow
  Future<void> getWorkflowTypesExample() async {
    try {
      print('🏷️ Récupération des types de workflow...');

      final types = await _workflowService.getWorkflowTypes();

      print('✅ Types de workflow récupérés avec succès !');

      print('\n🏷️ TYPES DISPONIBLES:');
      for (final entry in types['data'].entries) {
        print('   • ${entry.key}: ${entry.value}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des types: $e');
    }
  }

  /// Exemple de récupération des statistiques des workflows
  Future<void> getWorkflowStatsExample() async {
    try {
      print('📊 Récupération des statistiques des workflows...');

      final stats = await _workflowService.getWorkflowStats();

      print('✅ Statistiques récupérées avec succès !');

      print('\n📊 STATISTIQUES GLOBALES:');
      print('   Total des workflows: ${stats['data']['total_workflows']}');
      print('   Workflows actifs: ${stats['data']['active_workflows']}');
      print('   Workflows en brouillon: ${stats['data']['draft_workflows']}');
      print('   Workflows inactifs: ${stats['data']['inactive_workflows']}');

      print('\n📊 RÉPARTITION PAR TYPE:');
      final byType = stats['data']['by_type'];
      print('   Approbation: ${byType['approval']}');
      print('   Révision: ${byType['review']}');
      print('   Validation: ${byType['validation']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de récupération des étapes d'un workflow
  Future<void> getWorkflowStepsExample() async {
    try {
      print('📋 Récupération des étapes d\'un workflow...');

      final steps = await _workflowService.getWorkflowSteps(1);

      print('✅ Étapes du workflow récupérées avec succès !');
      print('   ID Workflow: ${steps['data']['workflow_id']}');
      print('   Nom Workflow: ${steps['data']['workflow_name']}');
      print('   Nombre d\'étapes: ${(steps['data']['steps'] as List).length}');

      print('\n📋 ÉTAPES:');
      for (final step in steps['data']['steps']) {
        print('   • ${step['name']}');
        print('     Ordre: ${step['order']}');
        print('     Rôle assigné: ${step['assigned_role']}');
        print('     Description: ${step['description'] ?? 'Aucune'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des étapes: $e');
    }
  }

  /// Exemple de mise à jour des étapes d'un workflow
  Future<void> updateWorkflowStepsExample() async {
    try {
      print('✏️ Mise à jour des étapes d\'un workflow...');

      final updatedSteps = await _workflowService.updateWorkflowSteps(
        workflowId: 1,
        steps: [
          {
            'name': 'Soumission initiale',
            'order': 1,
            'assigned_role': 'project_manager',
            'description':
                'Le chef de projet soumet le projet pour approbation',
            'estimated_duration': '2 jours',
          },
          {
            'name': 'Révision technique approfondie',
            'order': 2,
            'assigned_role': 'technical_lead',
            'description':
                'L\'équipe technique examine la faisabilité en détail',
            'estimated_duration': '5 jours',
          },
          {
            'name': 'Validation budgétaire',
            'order': 3,
            'assigned_role': 'finance_manager',
            'description': 'Le responsable financier valide le budget',
            'estimated_duration': '3 jours',
          },
          {
            'name': 'Approbation finale',
            'order': 4,
            'assigned_role': 'director',
            'description': 'Le directeur donne l\'approbation finale',
            'estimated_duration': '1 jour',
          },
        ],
      );

      print('✅ Étapes du workflow mises à jour avec succès !');
      print('   Nombre d\'étapes: ${(updatedSteps['data'] as List).length}');
      print('   Message: ${updatedSteps['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour des étapes: $e');
    }
  }

  /// Exemple d'activation d'un workflow
  Future<void> activateWorkflowExample() async {
    try {
      print('✅ Activation d\'un workflow...');

      // Vérifier si le workflow peut être activé
      final canActivate = await _workflowService.canActivateWorkflow(1);

      if (canActivate) {
        final activatedWorkflow = await _workflowService.activateWorkflow(1);

        print('✅ Workflow activé avec succès !');
        print('   ID: ${activatedWorkflow['data']['id']}');
        print('   Nom: ${activatedWorkflow['data']['name']}');
        print('   Nouveau statut: ${activatedWorkflow['data']['status']}');
        print('   Actif: ${activatedWorkflow['data']['is_active']}');
        print('   Message: ${activatedWorkflow['message']}');
      } else {
        print('❌ Impossible d\'activer le workflow');
        print(
            '   Raison: Le workflow est déjà actif ou ne peut pas être activé');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'activation: $e');
    }
  }

  /// Exemple de désactivation d'un workflow
  Future<void> deactivateWorkflowExample() async {
    try {
      print('❌ Désactivation d\'un workflow...');

      // Vérifier si le workflow peut être désactivé
      final canDeactivate = await _workflowService.canDeactivateWorkflow(1);

      if (canDeactivate) {
        final deactivatedWorkflow =
            await _workflowService.deactivateWorkflow(1);

        print('✅ Workflow désactivé avec succès !');
        print('   ID: ${deactivatedWorkflow['data']['id']}');
        print('   Nom: ${deactivatedWorkflow['data']['name']}');
        print('   Nouveau statut: ${deactivatedWorkflow['data']['status']}');
        print('   Actif: ${deactivatedWorkflow['data']['is_active']}');
        print('   Message: ${deactivatedWorkflow['message']}');
      } else {
        print('❌ Impossible de désactiver le workflow');
        print(
            '   Raison: Le workflow n\'est pas actif ou ne peut pas être désactivé');
      }
    } catch (e) {
      print('❌ Erreur lors de la désactivation: $e');
    }
  }

  /// Exemple de clonage d'un workflow
  Future<void> cloneWorkflowExample() async {
    try {
      print('📋 Clonage d\'un workflow...');

      // Vérifier si le workflow peut être cloné
      final canClone = await _workflowService.canCloneWorkflow(1);

      if (canClone) {
        final clonedWorkflow = await _workflowService.cloneWorkflow(1);

        print('✅ Workflow cloné avec succès !');
        print('   ID original: 1');
        print('   ID cloné: ${clonedWorkflow['data']['id']}');
        print('   Nom: ${clonedWorkflow['data']['name']}');
        print('   Statut: ${clonedWorkflow['data']['status']}');
        print('   Actif: ${clonedWorkflow['data']['is_active']}');
        print(
            '   Créateur: ${clonedWorkflow['data']['creator']?['name'] ?? 'Non défini'}');
        print('   Message: ${clonedWorkflow['message']}');
      } else {
        print('❌ Impossible de cloner le workflow');
        print('   Raison: Le workflow ne peut pas être cloné');
      }
    } catch (e) {
      print('❌ Erreur lors du clonage: $e');
    }
  }

  /// Exemple de mise à jour d'un workflow
  Future<void> updateWorkflowExample() async {
    try {
      print('✏️ Mise à jour d\'un workflow...');

      final updatedWorkflow = await _workflowService.updateWorkflow(
        workflowId: 1,
        name: 'Workflow d\'approbation des projets - Version 2.0',
        description:
            'Processus d\'approbation optimisé en 4 étapes avec validation budgétaire',
        status: 'active',
        isActive: true,
      );

      print('✅ Workflow mis à jour avec succès !');
      print('   ID: ${updatedWorkflow['data']['id']}');
      print('   Nouveau nom: ${updatedWorkflow['data']['name']}');
      print(
          '   Nouvelle description: ${updatedWorkflow['data']['description']}');
      print('   Nouveau statut: ${updatedWorkflow['data']['status']}');
      print('   Actif: ${updatedWorkflow['data']['is_active']}');
      print('   Message: ${updatedWorkflow['message']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour: $e');
    }
  }

  /// Exemple de suppression d'un workflow
  Future<void> deleteWorkflowExample() async {
    try {
      print('🗑️ Suppression d\'un workflow...');

      // Vérifier si le workflow peut être supprimé
      final canDelete = await _workflowService.canDeleteWorkflow(2);

      if (canDelete) {
        final result = await _workflowService.deleteWorkflow(2);

        print('✅ Workflow supprimé avec succès !');
        print('   ID: 2');
        print('   Message: ${result['message']}');
      } else {
        print('❌ Impossible de supprimer le workflow');
        print(
            '   Raison: Le workflow a des dépendances ou ne peut pas être supprimé');
      }
    } catch (e) {
      print('❌ Erreur lors de la suppression: $e');
    }
  }

  /// Exemple d'utilisation des méthodes utilitaires
  Future<void> utilityMethodsExample() async {
    try {
      print('🔧 Utilisation des méthodes utilitaires...');

      final workflowId = 1;

      // Obtenir le nom du workflow
      final name = await _workflowService.getWorkflowName(workflowId);
      print('   Nom: $name');

      // Obtenir le type du workflow
      final type = await _workflowService.getWorkflowType(workflowId);
      print('   Type: $type');

      // Obtenir le statut du workflow
      final status = await _workflowService.getWorkflowStatus(workflowId);
      print('   Statut: $status');

      // Vérifier si le workflow est actif
      final isActive = await _workflowService.isWorkflowActive(workflowId);
      print('   Actif: ${isActive ? 'Oui' : 'Non'}');

      // Obtenir le créateur du workflow
      final creator = await _workflowService.getWorkflowCreator(workflowId);
      print('   Créateur: ${creator?['name'] ?? 'Non défini'}');

      // Obtenir la description du workflow
      final description =
          await _workflowService.getWorkflowDescription(workflowId);
      print('   Description: ${description ?? 'Aucune'}');

      // Obtenir le nombre d'étapes
      final stepsCount =
          await _workflowService.getWorkflowStepsCount(workflowId);
      print('   Nombre d\'étapes: $stepsCount');

      // Vérifier si le workflow a des étapes
      final hasSteps = await _workflowService.hasWorkflowSteps(workflowId);
      print('   A des étapes: ${hasSteps ? 'Oui' : 'Non'}');

      // Vérifier si le workflow a des conditions
      final hasConditions =
          await _workflowService.hasWorkflowConditions(workflowId);
      print('   A des conditions: ${hasConditions ? 'Oui' : 'Non'}');
    } catch (e) {
      print('❌ Erreur lors de l\'utilisation des méthodes utilitaires: $e');
    }
  }

  /// Exemple de récupération des workflows récents
  Future<void> getRecentWorkflowsExample() async {
    try {
      print('🕐 Récupération des workflows récents...');

      final recentWorkflows =
          await _workflowService.getRecentWorkflows(perPage: 5);

      print('✅ Workflows récents récupérés avec succès !');
      print('   Nombre: ${recentWorkflows['meta']['recent_count']}');

      print('\n🕐 WORKFLOWS RÉCENTS:');
      for (final workflow in recentWorkflows['data']) {
        print('   • ${workflow['name']}');
        print('     Type: ${workflow['type']}');
        print('     Statut: ${workflow['status']}');
        print('     Créé le: ${workflow['created_at']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des workflows récents: $e');
    }
  }

  /// Exemple de récupération des résumés de workflows
  Future<void> getWorkflowSummariesExample() async {
    try {
      print('📋 Récupération des résumés de workflows...');

      // Résumé d'un workflow spécifique
      final summary = await _workflowService.getWorkflowSummary(1);
      if (summary != null) {
        print('\n✅ Résumé du workflow récupéré avec succès !');
        print('   ID: ${summary['id']}');
        print('   Nom: ${summary['name']}');
        print('   Type: ${summary['type']}');
        print('   Statut: ${summary['status']}');
        print('   Actif: ${summary['is_active'] ? 'Oui' : 'Non'}');
        print('   Nombre d\'étapes: ${summary['steps_count']}');
        print(
            '   A des conditions: ${summary['has_conditions'] ? 'Oui' : 'Non'}');
        print('   Créateur: ${summary['creator_name']}');
        print('   Créé le: ${summary['created_at']}');
      }

      // Résumés de tous les workflows
      final allSummaries =
          await _workflowService.getAllWorkflowSummaries(perPage: 10);
      print('\n✅ Résumés de tous les workflows récupérés avec succès !');
      print('   Nombre: ${allSummaries.length}');

      print('\n📋 RÉSUMÉS:');
      for (final summary in allSummaries) {
        print('   • ${summary['name']}');
        print('     Type: ${summary['type']}');
        print('     Statut: ${summary['status']}');
        print('     Étapes: ${summary['steps_count']}');
        print('     Créateur: ${summary['creator_name']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des résumés: $e');
    }
  }

  /// Exemple de récupération des statistiques détaillées
  Future<void> getDetailedStatsExample() async {
    try {
      print('📊 Récupération des statistiques détaillées...');

      final detailedStats = await _workflowService.getDetailedWorkflowStats();

      print('✅ Statistiques détaillées récupérées avec succès !');

      print('\n📊 STATISTIQUES DÉTAILLÉES:');
      print(
          '   Total des workflows: ${detailedStats['data']['total_workflows']}');
      print(
          '   Workflows actifs: ${detailedStats['data']['active_workflows']}');
      print(
          '   Workflows en brouillon: ${detailedStats['data']['draft_workflows']}');
      print(
          '   Workflows inactifs: ${detailedStats['data']['inactive_workflows']}');
      print(
          '   Pourcentage actifs: ${detailedStats['data']['active_percentage']}%');
      print(
          '   Pourcentage brouillons: ${detailedStats['data']['draft_percentage']}%');
      print(
          '   Pourcentage inactifs: ${detailedStats['data']['inactive_percentage']}%');

      print('\n📊 RÉPARTITION PAR TYPE:');
      final byType = detailedStats['data']['by_type'];
      print('   Approbation: ${byType['approval']}');
      print('   Révision: ${byType['review']}');
      print('   Validation: ${byType['validation']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques détaillées: $e');
    }
  }

  /// Exemple complet d'utilisation du service de workflow
  Future<void> completeWorkflowWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE DE WORKFLOW ===');
  print('');

      // 1. Récupérer les types de workflow
      await getWorkflowTypesExample();
      print('');

      // 2. Créer un nouveau workflow
      await createWorkflowExample();
      print('');

      // 3. Récupérer tous les workflows
      await getWorkflowsExample();
      print('');

      // 4. Récupérer un workflow spécifique
      await getWorkflowExample();
      print('');

      // 5. Filtrer par type
      await getWorkflowsByTypeExample();
      print('');

      // 6. Filtrer par statut
      await getWorkflowsByStatusExample();
      print('');

      // 7. Rechercher des workflows
      await searchWorkflowsExample();
      print('');

      // 8. Récupérer les statistiques
      await getWorkflowStatsExample();
      print('');

      // 9. Récupérer les étapes d'un workflow
      await getWorkflowStepsExample();
      print('');

      // 10. Mettre à jour les étapes
      await updateWorkflowStepsExample();
      print('');

      // 11. Activer le workflow
      await activateWorkflowExample();
      print('');

      // 12. Mettre à jour le workflow
      await updateWorkflowExample();
      print('');

      // 13. Cloner le workflow
      await cloneWorkflowExample();
      print('');

      // 14. Désactiver le workflow
      await deactivateWorkflowExample();
      print('');

      // 15. Utiliser les méthodes utilitaires
      await utilityMethodsExample();
      print('');

      // 16. Récupérer les workflows récents
      await getRecentWorkflowsExample();
      print('');

      // 17. Récupérer les résumés
      await getWorkflowSummariesExample();
      print('');

      // 18. Récupérer les statistiques détaillées
      await getDetailedStatsExample();
      print('');

      // 19. Supprimer un workflow
      await deleteWorkflowExample();
      print('');

      print('✅ Workflow du service de workflow terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service de workflow: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de workflows
      print('🚀 TABLEAU DE BORD DES WORKFLOWS:');

      // Récupérer les statistiques globales
      final stats = await _workflowService.getWorkflowStats();
      print('📊 STATISTIQUES GLOBALES:');
      print('   Total des workflows: ${stats['data']['total_workflows']}');
      print('   Workflows actifs: ${stats['data']['active_workflows']}');
      print('   Workflows en brouillon: ${stats['data']['draft_workflows']}');
      print('   Workflows inactifs: ${stats['data']['inactive_workflows']}');

      // Récupérer les workflows par type
      final approvalWorkflows =
          await _workflowService.getApprovalWorkflows(perPage: 5);
      print('\n✅ WORKFLOWS D\'APPROBATION:');
      print('   Workflows d\'approbation: ${approvalWorkflows['data'].length}');

      final reviewWorkflows =
          await _workflowService.getReviewWorkflows(perPage: 5);
      print('\n👀 WORKFLOWS DE RÉVISION:');
      print('   Workflows de révision: ${reviewWorkflows['data'].length}');

      final validationWorkflows =
          await _workflowService.getValidationWorkflows(perPage: 5);
      print('\n🔍 WORKFLOWS DE VALIDATION:');
      print(
          '   Workflows de validation: ${validationWorkflows['data'].length}');

      // Récupérer les workflows récents
      final recentWorkflows =
          await _workflowService.getRecentWorkflows(perPage: 5);
      print('\n🕐 WORKFLOWS RÉCENTS:');
      print('   Workflows récents: ${recentWorkflows['meta']['recent_count']}');
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service de workflow
void main() async {
  final workflowExample = WorkflowExample();

  // Exécuter le workflow complet
  await workflowExample.completeWorkflowWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await workflowExample.uiExample();
}

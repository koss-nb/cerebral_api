import 'issue_service.dart';

/// Exemple d'utilisation complète du service issue
/// Basé sur le IssueController Laravel avec toutes les fonctionnalités avancées
class IssueExample {
  final IssueService _issueService = IssueService();

  /// Exemple de signalement d'un problème
  Future<void> reportIssueExample() async {
    try {
      print('🚨 Signalement d\'un nouveau problème...');
      
      final issue = await _issueService.reportIssue(
        title: 'Fuite d\'eau dans la salle de bain',
        description: 'Fuite d\'eau importante sous le lavabo de la salle de bain principale. L\'eau s\'infiltre dans le plafond du niveau inférieur.',
        priority: 'high',
        type: 'safety',
        projectId: 1,
        location: 'Villa A3 - Salle de bain principale - Niveau 2',
        assignedTo: 5, // ID de l'utilisateur assigné
      );

      print('✅ Problème signalé avec succès !');
      print('   Titre: ${issue['data']['title']}');
      print('   Priorité: ${issue['data']['priority']}');
      print('   Type: ${issue['data']['type']}');
      print('   Statut: ${issue['data']['status']}');
      print('   Localisation: ${issue['data']['location']}');
      print('   Signalé par: ${issue['data']['reported_by']}');
      print('   Date de signalement: ${issue['data']['reported_at']}');

    } catch (e) {
      print('❌ Erreur lors du signalement du problème: $e');
    }
  }

  /// Exemple d'obtention de tous les problèmes
  Future<void> getAllIssuesExample() async {
    try {
      print('📋 Récupération de tous les problèmes...');
      
      final issues = await _issueService.getIssues(perPage: 10);

      print('✅ Problèmes récupérés avec succès !');
      print('   Total: ${issues['data']['total']} problèmes');
      print('   Page actuelle: ${issues['data']['current_page']}');
      print('   Par page: ${issues['data']['per_page']}');
      
      print('\n🚨 PROBLÈMES:');
      for (final issue in issues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('     Projet: ${issue['project']?['name'] ?? 'Non assigné'}');
        print('     Assigné à: ${issue['assigned_to'] != null ? 'Oui' : 'Non'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes: $e');
    }
  }

  /// Exemple de filtrage des problèmes par statut
  Future<void> getIssuesByStatusExample() async {
    try {
      print('🔍 Récupération des problèmes par statut...');
      
      // Problèmes ouverts
      final openIssues = await _issueService.getOpenIssues(perPage: 5);
      print('\n🔓 PROBLÈMES OUVERTS:');
      print('   Nombre: ${openIssues['data']['total']}');
      
      // Problèmes en cours
      final inProgressIssues = await _issueService.getInProgressIssues(perPage: 5);
      print('\n🔄 PROBLÈMES EN COURS:');
      print('   Nombre: ${inProgressIssues['data']['total']}');
      
      // Problèmes résolus
      final resolvedIssues = await _issueService.getResolvedIssues(perPage: 5);
      print('\n✅ PROBLÈMES RÉSOLUS:');
      print('   Nombre: ${resolvedIssues['data']['total']}');
      
      // Problèmes fermés
      final closedIssues = await _issueService.getClosedIssues(perPage: 5);
      print('\n🔒 PROBLÈMES FERMÉS:');
      print('   Nombre: ${closedIssues['data']['total']}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple de filtrage des problèmes par priorité
  Future<void> getIssuesByPriorityExample() async {
    try {
      print('🎯 Récupération des problèmes par priorité...');
      
      // Problèmes de priorité faible
      final lowPriorityIssues = await _issueService.getLowPriorityIssues(perPage: 5);
      print('\n🟢 PROBLÈMES PRIORITÉ FAIBLE:');
      print('   Nombre: ${lowPriorityIssues['data']['total']}');
      
      // Problèmes de priorité moyenne
      final mediumPriorityIssues = await _issueService.getMediumPriorityIssues(perPage: 5);
      print('\n🟡 PROBLÈMES PRIORITÉ MOYENNE:');
      print('   Nombre: ${mediumPriorityIssues['data']['total']}');
      
      // Problèmes de priorité élevée
      final highPriorityIssues = await _issueService.getHighPriorityIssues(perPage: 5);
      print('\n🟠 PROBLÈMES PRIORITÉ ÉLEVÉE:');
      print('   Nombre: ${highPriorityIssues['data']['total']}');
      
      // Problèmes de priorité critique
      final criticalPriorityIssues = await _issueService.getCriticalPriorityIssues(perPage: 5);
      print('\n🔴 PROBLÈMES PRIORITÉ CRITIQUE:');
      print('   Nombre: ${criticalPriorityIssues['data']['total']}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par priorité: $e');
    }
  }

  /// Exemple de filtrage des problèmes par type
  Future<void> getIssuesByTypeExample() async {
    try {
      print('🏷️ Récupération des problèmes par type...');
      
      // Problèmes de sécurité
      final safetyIssues = await _issueService.getSafetyIssues(perPage: 5);
      print('\n🛡️ PROBLÈMES DE SÉCURITÉ:');
      print('   Nombre: ${safetyIssues['data']['total']}');
      
      // Problèmes de qualité
      final qualityIssues = await _issueService.getQualityIssues(perPage: 5);
      print('\n⭐ PROBLÈMES DE QUALITÉ:');
      print('   Nombre: ${qualityIssues['data']['total']}');
      
      // Problèmes logistiques
      final logisticsIssues = await _issueService.getLogisticsIssues(perPage: 5);
      print('\n🚚 PROBLÈMES LOGISTIQUES:');
      print('   Nombre: ${logisticsIssues['data']['total']}');
      
      // Problèmes techniques
      final technicalIssues = await _issueService.getTechnicalIssues(perPage: 5);
      print('\n🔧 PROBLÈMES TECHNIQUES:');
      print('   Nombre: ${technicalIssues['data']['total']}');
      
      // Autres types de problèmes
      final otherIssues = await _issueService.getOtherIssues(perPage: 5);
      print('\n📝 AUTRES TYPES DE PROBLÈMES:');
      print('   Nombre: ${otherIssues['data']['total']}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par type: $e');
    }
  }

  /// Exemple d'obtention des problèmes d'un projet spécifique
  Future<void> getIssuesByProjectExample() async {
    try {
      print('🏗️ Récupération des problèmes d\'un projet spécifique...');
      
      final projectIssues = await _issueService.getIssuesByProject(1, perPage: 10);

      print('✅ Problèmes du projet récupérés avec succès !');
      print('   Projet ID: 1');
      print('   Nombre de problèmes: ${projectIssues['data']['total']}');
      
      print('\n🚨 PROBLÈMES DU PROJET:');
      for (final issue in projectIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes du projet: $e');
    }
  }

  /// Exemple d'obtention des problèmes critiques
  Future<void> getCriticalIssuesExample() async {
    try {
      print('🚨 Récupération des problèmes critiques...');
      
      final criticalIssues = await _issueService.getCriticalIssues();

      print('✅ Problèmes critiques récupérés avec succès !');
      print('   Nombre: ${criticalIssues['data'].length}');
      
      print('\n🔴 PROBLÈMES CRITIQUES:');
      for (final issue in criticalIssues['data']) {
        print('   • ${issue['title']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('     Projet: ${issue['project']?['name'] ?? 'Non assigné'}');
        print('     Assigné à: ${issue['assigned_to'] != null ? 'Oui' : 'Non'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes critiques: $e');
    }
  }

  /// Exemple d'obtention des problèmes assignés à l'utilisateur connecté
  Future<void> getMyAssignedIssuesExample() async {
    try {
      print('👤 Récupération des problèmes assignés à l\'utilisateur connecté...');
      
      final myIssues = await _issueService.getMyAssignedIssues();

      print('✅ Problèmes assignés récupérés avec succès !');
      print('   Nombre: ${myIssues['data'].length}');
      
      print('\n📋 MES PROBLÈMES ASSIGNÉS:');
      for (final issue in myIssues['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('     Projet: ${issue['project']?['name'] ?? 'Non assigné'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes assignés: $e');
    }
  }

  /// Exemple d'obtention des problèmes urgents
  Future<void> getUrgentIssuesExample() async {
    try {
      print('⚡ Récupération des problèmes urgents...');
      
      final urgentIssues = await _issueService.getUrgentIssues(perPage: 10);

      print('✅ Problèmes urgents récupérés avec succès !');
      print('   Nombre total: ${urgentIssues['data']['urgent_count']}');
      print('   Critiques: ${urgentIssues['data']['critical_count']}');
      print('   Haute priorité: ${urgentIssues['data']['high_priority_count']}');
      
      print('\n⚡ PROBLÈMES URGENTS:');
      for (final issue in urgentIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes urgents: $e');
    }
  }

  /// Exemple d'obtention des problèmes non assignés
  Future<void> getUnassignedIssuesExample() async {
    try {
      print('❓ Récupération des problèmes non assignés...');
      
      final unassignedIssues = await _issueService.getUnassignedIssues(perPage: 10);

      print('✅ Problèmes non assignés récupérés avec succès !');
      print('   Nombre: ${unassignedIssues['data']['unassigned_count']}');
      
      print('\n❓ PROBLÈMES NON ASSIGNÉS:');
      for (final issue in unassignedIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes non assignés: $e');
    }
  }

  /// Exemple d'obtention des problèmes récents
  Future<void> getRecentIssuesExample() async {
    try {
      print('📅 Récupération des problèmes récents...');
      
      final recentIssues = await _issueService.getRecentIssues(perPage: 10);

      print('✅ Problèmes récents récupérés avec succès !');
      print('   Nombre: ${recentIssues['data']['recent_count']}');
      print('   Période: ${recentIssues['data']['days_ago']} derniers jours');
      
      print('\n📅 PROBLÈMES RÉCENTS:');
      for (final issue in recentIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Date de signalement: ${issue['reported_at']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes récents: $e');
    }
  }

  /// Exemple d'obtention des problèmes en retard
  Future<void> getOverdueIssuesExample() async {
    try {
      print('⚠️ Récupération des problèmes en retard...');
      
      final overdueIssues = await _issueService.getOverdueIssues(perPage: 10);

      print('✅ Problèmes en retard récupérés avec succès !');
      print('   Nombre: ${overdueIssues['data']['overdue_count']}');
      print('   Seuil: ${overdueIssues['data']['days_threshold']} jours');
      
      print('\n⚠️ PROBLÈMES EN RETARD:');
      for (final issue in overdueIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Date de signalement: ${issue['reported_at']}');
        print('     Retard: ${DateTime.now().difference(DateTime.parse(issue['reported_at'])).inDays} jours');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes en retard: $e');
    }
  }

  /// Exemple d'obtention des statistiques des problèmes
  Future<void> getIssueStatsExample() async {
    try {
      print('📊 Récupération des statistiques des problèmes...');
      
      final stats = await _issueService.getIssueStats();

      print('✅ Statistiques des problèmes récupérées avec succès !');
      
      print('\n📈 STATISTIQUES GÉNÉRALES:');
      print('   Total des problèmes: ${stats['data']['total']}');
      print('   Taux de résolution: ${stats['data']['resolution_rate']}%');
      print('   Taux d\'assignation: ${stats['data']['assignment_rate']}%');
      
      print('\n📊 RÉPARTITION PAR STATUT:');
      final byStatus = stats['data']['by_status'];
      print('   Ouverts: ${byStatus['open']}');
      print('   En cours: ${byStatus['in_progress']}');
      print('   Résolus: ${byStatus['resolved']}');
      print('   Fermés: ${byStatus['closed']}');
      
      print('\n🎯 RÉPARTITION PAR PRIORITÉ:');
      final byPriority = stats['data']['by_priority'];
      print('   Faible: ${byPriority['low']}');
      print('   Moyenne: ${byPriority['medium']}');
      print('   Élevée: ${byPriority['high']}');
      print('   Critique: ${byPriority['critical']}');
      
      print('\n🏷️ RÉPARTITION PAR TYPE:');
      final byType = stats['data']['by_type'];
      print('   Sécurité: ${byType['safety']}');
      print('   Qualité: ${byType['quality']}');
      print('   Logistique: ${byType['logistics']}');
      print('   Technique: ${byType['technical']}');
      print('   Autre: ${byType['other']}');
      
      print('\n👥 ASSIGNATION:');
      print('   Assignés: ${stats['data']['assigned']}');
      print('   Non assignés: ${stats['data']['unassigned']}');
      print('   Urgents: ${stats['data']['urgent']}');

    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de recherche de problèmes
  Future<void> searchIssuesExample() async {
    try {
      print('🔍 Recherche de problèmes...');
      
      final searchResults = await _issueService.searchIssues('fuite', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: fuite');
      print('   Résultats trouvés: ${searchResults['data']['results_count']}');
      
      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final issue in searchResults['data']['data']) {
        print('   • ${issue['title']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('     Statut: ${issue['status']}');
        print('     Localisation: ${issue['location'] ?? 'Non spécifiée'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des problèmes par période
  Future<void> getIssuesByPeriodExample() async {
    try {
      print('📅 Récupération des problèmes par période...');
      
      final startDate = DateTime.now().subtract(Duration(days: 30));
      final endDate = DateTime.now();
      
      final periodIssues = await _issueService.getIssuesByPeriod(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Problèmes de la période récupérés avec succès !');
      print('   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de problèmes: ${periodIssues['data']['period_count']}');
      
      print('\n📅 PROBLÈMES DE LA PÉRIODE:');
      for (final issue in periodIssues['data']['data']) {
        print('   • ${issue['title']}');
        print('     Date de signalement: ${issue['reported_at']}');
        print('     Priorité: ${issue['priority']}');
        print('     Type: ${issue['type']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des problèmes de la période: $e');
    }
  }

  /// Exemple de mise à jour d'un problème
  Future<void> updateIssueExample() async {
    try {
      print('✏️ Mise à jour d\'un problème...');
      
      final updatedIssue = await _issueService.updateIssue(
        1, // ID du problème
        title: 'Fuite d\'eau dans la salle de bain - Mise à jour',
        description: 'Fuite d\'eau importante sous le lavabo de la salle de bain principale. L\'eau s\'infiltre dans le plafond du niveau inférieur. Intervention urgente requise.',
        priority: 'critical',
        status: 'in_progress',
        location: 'Villa A3 - Salle de bain principale - Niveau 2 - Urgent',
      );

      print('✅ Problème mis à jour avec succès !');
      print('   Titre: ${updatedIssue['data']['title']}');
      print('   Priorité: ${updatedIssue['data']['priority']}');
      print('   Statut: ${updatedIssue['data']['status']}');
      print('   Localisation: ${updatedIssue['data']['location']}');
      print('   Message: ${updatedIssue['message']}');

    } catch (e) {
      print('❌ Erreur lors de la mise à jour du problème: $e');
    }
  }

  /// Exemple d'assignation d'un problème
  Future<void> assignIssueExample() async {
    try {
      print('👤 Assignation d\'un problème...');
      
      final assignedIssue = await _issueService.assignIssue(
        1, // ID du problème
        assignedTo: 8, // ID de l'utilisateur assigné
      );

      print('✅ Problème assigné avec succès !');
      print('   Titre: ${assignedIssue['data']['title']}');
      print('   Assigné à: ${assignedIssue['data']['assigned_to']}');
      print('   Statut: ${assignedIssue['data']['status']}');
      print('   Message: ${assignedIssue['message']}');

    } catch (e) {
      print('❌ Erreur lors de l\'assignation du problème: $e');
    }
  }

  /// Exemple de résolution d'un problème
  Future<void> resolveIssueExample() async {
    try {
      print('✅ Résolution d\'un problème...');
      
      final resolvedIssue = await _issueService.resolveIssue(
        1, // ID du problème
        resolutionNotes: 'Problème résolu en remplaçant le joint du lavabo et en réparant la fuite. Le plafond a été séché et repeint. Plus de fuite détectée.',
      );

      print('✅ Problème résolu avec succès !');
      print('   Titre: ${resolvedIssue['data']['title']}');
      print('   Statut: ${resolvedIssue['data']['status']}');
      print('   Notes de résolution: ${resolvedIssue['data']['resolution_notes'] ?? 'Aucune'}');
      print('   Message: ${resolvedIssue['message']}');

    } catch (e) {
      print('❌ Erreur lors de la résolution du problème: $e');
    }
  }

  /// Exemple de suppression d'un problème
  Future<void> deleteIssueExample() async {
    try {
      print('🗑️ Suppression d\'un problème...');
      
      final result = await _issueService.deleteIssue(1);

      print('✅ Problème supprimé avec succès !');
      print('   Message: ${result['message']}');

    } catch (e) {
      print('❌ Erreur lors de la suppression du problème: $e');
    }
  }

  /// Exemple complet d'utilisation du service issue
  Future<void> completeIssueWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE ISSUE ===\n');

      // 1. Signaler un nouveau problème
      await reportIssueExample();
      print('');

      // 2. Obtenir tous les problèmes
      await getAllIssuesExample();
      print('');

      // 3. Filtrer par statut
      await getIssuesByStatusExample();
      print('');

      // 4. Filtrer par priorité
      await getIssuesByPriorityExample();
      print('');

      // 5. Filtrer par type
      await getIssuesByTypeExample();
      print('');

      // 6. Obtenir les problèmes d'un projet
      await getIssuesByProjectExample();
      print('');

      // 7. Obtenir les problèmes critiques
      await getCriticalIssuesExample();
      print('');

      // 8. Obtenir les problèmes assignés à l'utilisateur
      await getMyAssignedIssuesExample();
      print('');

      // 9. Obtenir les problèmes urgents
      await getUrgentIssuesExample();
      print('');

      // 10. Obtenir les problèmes non assignés
      await getUnassignedIssuesExample();
      print('');

      // 11. Obtenir les problèmes récents
      await getRecentIssuesExample();
      print('');

      // 12. Obtenir les problèmes en retard
      await getOverdueIssuesExample();
      print('');

      // 13. Obtenir les statistiques
      await getIssueStatsExample();
      print('');

      // 14. Rechercher des problèmes
      await searchIssuesExample();
      print('');

      // 15. Obtenir les problèmes par période
      await getIssuesByPeriodExample();
      print('');

      // 16. Mettre à jour un problème
      await updateIssueExample();
      print('');

      // 17. Assigner un problème
      await assignIssueExample();
      print('');

      // 18. Résoudre un problème
      await resolveIssueExample();
      print('');

      // 19. Supprimer un problème
      await deleteIssueExample();
      print('');

      print('✅ Workflow du service issue terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du service issue: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord des problèmes
      print('🚨 TABLEAU DE BORD DES PROBLÈMES:');
      
      // Récupérer les statistiques
      final stats = await _issueService.getIssueStats();
      print('📊 STATISTIQUES:');
      print('   Total: ${stats['data']['total']} problèmes');
      print('   Taux de résolution: ${stats['data']['resolution_rate']}%');
      print('   Urgents: ${stats['data']['urgent']}');
      
      // Récupérer les problèmes critiques
      final criticalIssues = await _issueService.getCriticalIssues();
      print('\n🔴 CRITIQUES:');
      print('   Problèmes critiques: ${criticalIssues['data'].length}');
      
      // Récupérer les problèmes non assignés
      final unassignedIssues = await _issueService.getUnassignedIssues(perPage: 5);
      print('\n❓ NON ASSIGNÉS:');
      print('   Problèmes non assignés: ${unassignedIssues['data']['unassigned_count']}');
      
      // Récupérer les problèmes en retard
      final overdueIssues = await _issueService.getOverdueIssues(perPage: 5);
      print('\n⚠️ EN RETARD:');
      print('   Problèmes en retard: ${overdueIssues['data']['overdue_count']}');
      
      // Récupérer les problèmes assignés à l'utilisateur
      final myIssues = await _issueService.getMyAssignedIssues();
      print('\n👤 MES PROBLÈMES:');
      print('   Problèmes assignés: ${myIssues['data'].length}');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service issue
void main() async {
  final issueExample = IssueExample();
  
  // Exécuter le workflow complet
  await issueExample.completeIssueWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await issueExample.uiExample();
}

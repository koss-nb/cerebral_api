import 'delivery_service.dart';

/// Exemple d'utilisation complète du service delivery
/// Basé sur le DeliveryController Laravel avec toutes les fonctionnalités avancées
class DeliveryExample {
  final DeliveryService _deliveryService = DeliveryService();

  /// Exemple de création d'une livraison
  Future<void> createDeliveryExample() async {
    try {
      print('📦 Création d\'une nouvelle livraison...');

      final delivery = await _deliveryService.createDelivery(
        title: 'Livraison ciment pour Villa A3',
        description: 'Livraison de ciment et matériaux de construction',
        projectId: 1,
        supplier: 'Fournisseur BTP Pro',
        supplierContact: 'contact@btppro.fr',
        expectedDate: DateTime.now().add(Duration(days: 3)),
        notes: 'Livraison prévue le matin, prévoir équipe de réception',
        materials: [
          {
            'material_id': 1,
            'quantity': 50.0,
            'notes': 'Sacs de ciment 25kg',
          },
          {
            'material_id': 2,
            'quantity': 100.0,
            'notes': 'Briques creuses',
          },
        ],
      );

      print('✅ Livraison créée avec succès !');
      print('   Référence: ${delivery['data']['reference']}');
      print('   Titre: ${delivery['data']['title']}');
      print('   Fournisseur: ${delivery['data']['supplier']}');
      print('   Date prévue: ${delivery['data']['expected_date']}');
      print('   Statut: ${delivery['data']['status']}');
    } catch (e) {
      print('❌ Erreur lors de la création de la livraison: $e');
    }
  }

  /// Exemple d'obtention de toutes les livraisons
  Future<void> getAllDeliveriesExample() async {
    try {
      print('📋 Récupération de toutes les livraisons...');

      final deliveries = await _deliveryService.getDeliveries(perPage: 10);

      print('✅ Livraisons récupérées avec succès !');
      print('   Total: ${deliveries['data']['total']} livraisons');
      print('   Page actuelle: ${deliveries['data']['current_page']}');
      print('   Par page: ${deliveries['data']['per_page']}');

      print('\n📦 LIVRAISONS:');
      for (final delivery in deliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Référence: ${delivery['reference']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Projet: ${delivery['project']?['name'] ?? 'Non assigné'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons: $e');
    }
  }

  /// Exemple de filtrage des livraisons par statut
  Future<void> getDeliveriesByStatusExample() async {
    try {
      print('🔍 Récupération des livraisons par statut...');

      // Livraisons en attente
      final pendingDeliveries =
          await _deliveryService.getPendingDeliveries(perPage: 5);
      print('\n⏳ LIVRAISONS EN ATTENTE:');
      print('   Nombre: ${pendingDeliveries['data']['total']}');

      // Livraisons confirmées
      final confirmedDeliveries =
          await _deliveryService.getConfirmedDeliveries(perPage: 5);
      print('\n✅ LIVRAISONS CONFIRMÉES:');
      print('   Nombre: ${confirmedDeliveries['data']['total']}');

      // Livraisons en transit
      final inTransitDeliveries =
          await _deliveryService.getInTransitDeliveries(perPage: 5);
      print('\n🚚 LIVRAISONS EN TRANSIT:');
      print('   Nombre: ${inTransitDeliveries['data']['total']}');

      // Livraisons livrées
      final deliveredDeliveries =
          await _deliveryService.getDeliveredDeliveries(perPage: 5);
      print('\n📦 LIVRAISONS LIVRÉES:');
      print('   Nombre: ${deliveredDeliveries['data']['total']}');

      // Livraisons annulées
      final cancelledDeliveries =
          await _deliveryService.getCancelledDeliveries(perPage: 5);
      print('\n❌ LIVRAISONS ANNULEES:');
      print('   Nombre: ${cancelledDeliveries['data']['total']}');
    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple d'obtention des livraisons d'un projet spécifique
  Future<void> getDeliveriesByProjectExample() async {
    try {
      print('🏗️ Récupération des livraisons d\'un projet spécifique...');

      final projectDeliveries =
          await _deliveryService.getDeliveriesByProject(1, perPage: 10);

      print('✅ Livraisons du projet récupérées avec succès !');
      print('   Projet ID: 1');
      print('   Nombre de livraisons: ${projectDeliveries['data']['total']}');

      print('\n📦 LIVRAISONS DU PROJET:');
      for (final delivery in projectDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Statut: ${delivery['status']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons du projet: $e');
    }
  }

  /// Exemple d'obtention des livraisons à venir
  Future<void> getUpcomingDeliveriesExample() async {
    try {
      print('📅 Récupération des livraisons à venir...');

      final upcomingDeliveries = await _deliveryService.getUpcomingDeliveries();

      print('✅ Livraisons à venir récupérées avec succès !');
      print('   Nombre: ${upcomingDeliveries['data'].length}');

      print('\n🚚 LIVRAISONS À VENIR:');
      for (final delivery in upcomingDeliveries['data']) {
        print('   • ${delivery['title']}');
        print('     Statut: ${delivery['status']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('     Projet: ${delivery['project']?['name'] ?? 'Non assigné'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons à venir: $e');
    }
  }

  /// Exemple d'obtention des livraisons en retard
  Future<void> getOverdueDeliveriesExample() async {
    try {
      print('⚠️ Récupération des livraisons en retard...');

      final overdueDeliveries =
          await _deliveryService.getOverdueDeliveries(perPage: 10);

      print('✅ Livraisons en retard récupérées avec succès !');
      print('   Nombre: ${overdueDeliveries['data']['overdue_count']}');

      print('\n🚨 LIVRAISONS EN RETARD:');
      for (final delivery in overdueDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Référence: ${delivery['reference']}');
        print('     Statut: ${delivery['status']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print(
            '     Retard: ${DateTime.now().difference(DateTime.parse(delivery['expected_date'])).inDays} jours');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons en retard: $e');
    }
  }

  /// Exemple d'obtention des livraisons du jour
  Future<void> getTodayDeliveriesExample() async {
    try {
      print('📅 Récupération des livraisons du jour...');

      final todayDeliveries =
          await _deliveryService.getTodayDeliveries(perPage: 10);

      print('✅ Livraisons du jour récupérées avec succès !');
      print('   Nombre: ${todayDeliveries['data']['today_count']}');

      print('\n📦 LIVRAISONS DU JOUR:');
      for (final delivery in todayDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('     Projet: ${delivery['project']?['name'] ?? 'Non assigné'}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons du jour: $e');
    }
  }

  /// Exemple d'obtention des livraisons de la semaine
  Future<void> getWeekDeliveriesExample() async {
    try {
      print('📅 Récupération des livraisons de la semaine...');

      final weekDeliveries =
          await _deliveryService.getWeekDeliveries(perPage: 10);

      print('✅ Livraisons de la semaine récupérées avec succès !');
      print('   Nombre: ${weekDeliveries['data']['week_count']}');

      print('\n📅 LIVRAISONS DE LA SEMAINE:');
      for (final delivery in weekDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des livraisons de la semaine: $e');
    }
  }

  /// Exemple d'obtention des livraisons du mois
  Future<void> getMonthDeliveriesExample() async {
    try {
      print('📅 Récupération des livraisons du mois...');

      final monthDeliveries =
          await _deliveryService.getMonthDeliveries(perPage: 10);

      print('✅ Livraisons du mois récupérées avec succès !');
      print('   Nombre: ${monthDeliveries['data']['month_count']}');

      print('\n📅 LIVRAISONS DU MOIS:');
      for (final delivery in monthDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livraisons du mois: $e');
    }
  }

  /// Exemple d'obtention des statistiques des livraisons
  Future<void> getDeliveryStatsExample() async {
    try {
      print('📊 Récupération des statistiques des livraisons...');

      final stats = await _deliveryService.getDeliveryStats();

      print('✅ Statistiques des livraisons récupérées avec succès !');

      print('\n📈 STATISTIQUES GÉNÉRALES:');
      print('   Total des livraisons: ${stats['data']['total']}');
      print('   Taux de livraison: ${stats['data']['delivery_rate']}%');
      print('   Taux de retard: ${stats['data']['overdue_rate']}%');

      print('\n📊 RÉPARTITION PAR STATUT:');
      final byStatus = stats['data']['by_status'];
      print('   En attente: ${byStatus['pending']}');
      print('   Confirmées: ${byStatus['confirmed']}');
      print('   En transit: ${byStatus['in_transit']}');
      print('   Livrées: ${byStatus['delivered']}');
      print('   Annulées: ${byStatus['cancelled']}');

      print('\n⏰ LIVRAISONS TEMPORELLES:');
      print('   En retard: ${stats['data']['overdue']}');
      print('   Aujourd\'hui: ${stats['data']['today']}');
      print('   Cette semaine: ${stats['data']['this_week']}');
      print('   Ce mois: ${stats['data']['this_month']}');
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de recherche de livraisons
  Future<void> searchDeliveriesExample() async {
    try {
      print('🔍 Recherche de livraisons...');

      final searchResults =
          await _deliveryService.searchDeliveries('ciment', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: ciment');
      print('   Résultats trouvés: ${searchResults['data']['results_count']}');

      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final delivery in searchResults['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Référence: ${delivery['reference']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('');
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des livraisons par fournisseur
  Future<void> getDeliveriesBySupplierExample() async {
    try {
      print('🏪 Récupération des livraisons par fournisseur...');

      final supplierDeliveries = await _deliveryService
          .getDeliveriesBySupplier('Fournisseur BTP Pro', perPage: 10);

      print('✅ Livraisons du fournisseur récupérées avec succès !');
      print('   Fournisseur: Fournisseur BTP Pro');
      print(
          '   Nombre de livraisons: ${supplierDeliveries['data']['supplier_count']}');

      print('\n📦 LIVRAISONS DU FOURNISSEUR:');
      for (final delivery in supplierDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Statut: ${delivery['status']}');
        print('     Projet: ${delivery['project']?['name'] ?? 'Non assigné'}');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des livraisons du fournisseur: $e');
    }
  }

  /// Exemple d'obtention des livraisons par période
  Future<void> getDeliveriesByPeriodExample() async {
    try {
      print('📅 Récupération des livraisons par période...');

      final startDate = DateTime.now();
      final endDate = DateTime.now().add(Duration(days: 30));

      final periodDeliveries = await _deliveryService.getDeliveriesByPeriod(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Livraisons de la période récupérées avec succès !');
      print(
          '   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print(
          '   Nombre de livraisons: ${periodDeliveries['data']['period_count']}');

      print('\n📅 LIVRAISONS DE LA PÉRIODE:');
      for (final delivery in periodDeliveries['data']['data']) {
        print('   • ${delivery['title']}');
        print('     Date prévue: ${delivery['expected_date']}');
        print('     Statut: ${delivery['status']}');
        print('     Fournisseur: ${delivery['supplier']}');
        print('');
      }
    } catch (e) {
      print(
          '❌ Erreur lors de la récupération des livraisons de la période: $e');
    }
  }

  /// Exemple de mise à jour d'une livraison
  Future<void> updateDeliveryExample() async {
    try {
      print('✏️ Mise à jour d\'une livraison...');

      final updatedDelivery = await _deliveryService.updateDelivery(
        1, // ID de la livraison
        title: 'Livraison ciment modifiée pour Villa A3',
        expectedDate: DateTime.now().add(Duration(days: 5)),
        status: 'confirmed',
        notes: 'Date modifiée suite à la demande du client',
      );

      print('✅ Livraison mise à jour avec succès !');
      print('   Titre: ${updatedDelivery['data']['title']}');
      print('   Date prévue: ${updatedDelivery['data']['expected_date']}');
      print('   Statut: ${updatedDelivery['data']['status']}');
      print('   Notes: ${updatedDelivery['data']['notes']}');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour de la livraison: $e');
    }
  }

  /// Exemple de confirmation d'une livraison
  Future<void> confirmDeliveryExample() async {
    try {
      print('✅ Confirmation d\'une livraison...');

      final confirmedDelivery = await _deliveryService.confirmDelivery(1);

      print('✅ Livraison confirmée avec succès !');
      print('   Titre: ${confirmedDelivery['data']['title']}');
      print('   Statut: ${confirmedDelivery['data']['status']}');
      print('   Message: ${confirmedDelivery['message']}');
    } catch (e) {
      print('❌ Erreur lors de la confirmation de la livraison: $e');
    }
  }

  /// Exemple de réception d'une livraison
  Future<void> receiveDeliveryExample() async {
    try {
      print('📦 Réception d\'une livraison...');

      final receivedDelivery = await _deliveryService.receiveDelivery(
        1, // ID de la livraison
        receivedMaterials: [
          {
            'material_id': 1,
            'received_quantity': 48.0, // 2 sacs manquants
            'notes': 'Réception partielle - 2 sacs manquants',
          },
          {
            'material_id': 2,
            'received_quantity': 100.0,
            'notes': 'Réception complète',
          },
        ],
      );

      print('✅ Livraison réceptionnée avec succès !');
      print('   Titre: ${receivedDelivery['data']['title']}');
      print('   Statut: ${receivedDelivery['data']['status']}');
      print('   Message: ${receivedDelivery['message']}');
    } catch (e) {
      print('❌ Erreur lors de la réception de la livraison: $e');
    }
  }

  /// Exemple de suppression d'une livraison
  Future<void> deleteDeliveryExample() async {
    try {
      print('🗑️ Suppression d\'une livraison...');

      final result = await _deliveryService.deleteDelivery(1);

      print('✅ Livraison supprimée avec succès !');
      print('   Message: ${result['message']}');
    } catch (e) {
      print('❌ Erreur lors de la suppression de la livraison: $e');
    }
  }

  /// Exemple complet d'utilisation du service delivery
  Future<void> completeDeliveryWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE DELIVERY ===\n');

      // 1. Créer une nouvelle livraison
      await createDeliveryExample();
      print('');

      // 2. Obtenir toutes les livraisons
      await getAllDeliveriesExample();
      print('');

      // 3. Filtrer par statut
      await getDeliveriesByStatusExample();
      print('');

      // 4. Obtenir les livraisons d'un projet
      await getDeliveriesByProjectExample();
      print('');

      // 5. Obtenir les livraisons à venir
      await getUpcomingDeliveriesExample();
      print('');

      // 6. Obtenir les livraisons en retard
      await getOverdueDeliveriesExample();
      print('');

      // 7. Obtenir les livraisons du jour
      await getTodayDeliveriesExample();
      print('');

      // 8. Obtenir les livraisons de la semaine
      await getWeekDeliveriesExample();
      print('');

      // 9. Obtenir les livraisons du mois
      await getMonthDeliveriesExample();
      print('');

      // 10. Obtenir les statistiques
      await getDeliveryStatsExample();
      print('');

      // 11. Rechercher des livraisons
      await searchDeliveriesExample();
      print('');

      // 12. Obtenir les livraisons par fournisseur
      await getDeliveriesBySupplierExample();
      print('');

      // 13. Obtenir les livraisons par période
      await getDeliveriesByPeriodExample();
      print('');

      // 14. Mettre à jour une livraison
      await updateDeliveryExample();
      print('');

      // 15. Confirmer une livraison
      await confirmDeliveryExample();
      print('');

      // 16. Réceptionner une livraison
      await receiveDeliveryExample();
      print('');

      // 17. Supprimer une livraison
      await deleteDeliveryExample();
      print('');

      print('✅ Workflow du service delivery terminé avec succès !');
    } catch (e) {
      print('❌ Erreur dans le workflow du service delivery: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord des livraisons
      print('📦 TABLEAU DE BORD DES LIVRAISONS:');

      // Récupérer les statistiques
      final stats = await _deliveryService.getDeliveryStats();
      print('📊 STATISTIQUES:');
      print('   Total: ${stats['data']['total']} livraisons');
      print('   Taux de livraison: ${stats['data']['delivery_rate']}%');
      print('   En retard: ${stats['data']['overdue']}');

      // Récupérer les livraisons du jour
      final todayDeliveries =
          await _deliveryService.getTodayDeliveries(perPage: 5);
      print('\n📅 AUJOURD\'HUI:');
      print('   Livraisons prévues: ${todayDeliveries['data']['today_count']}');

      // Récupérer les livraisons en retard
      final overdueDeliveries =
          await _deliveryService.getOverdueDeliveries(perPage: 5);
      print('\n⚠️ EN RETARD:');
      print(
          '   Livraisons en retard: ${overdueDeliveries['data']['overdue_count']}');

      // Récupérer les livraisons à venir
      final upcomingDeliveries = await _deliveryService.getUpcomingDeliveries();
      print('\n🚚 À VENIR:');
      print('   Livraisons à venir: ${upcomingDeliveries['data'].length}');
    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service delivery
void main() async {
  final deliveryExample = DeliveryExample();

  // Exécuter le workflow complet
  await deliveryExample.completeDeliveryWorkflow();

  print('\n' + '=' * 50);

  // Exemple d'interface utilisateur
  await deliveryExample.uiExample();
}

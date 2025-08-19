import 'material_service.dart';

/// Exemple d'utilisation complète du service material
/// Basé sur le MaterialController Laravel avec toutes les fonctionnalités avancées
class MaterialExample {
  final MaterialService _materialService = MaterialService();

  /// Exemple de création d'un matériau
  Future<void> createMaterialExample() async {
    try {
      print('🏗️ Création d\'un nouveau matériau...');
      
      final material = await _materialService.createMaterial(
        name: 'Ciment Portland',
        description: 'Ciment Portland de haute qualité pour construction',
        category: 'construction',
        unit: 'sac',
        currentStock: 100.0,
        minStock: 20.0,
        maxStock: 200.0,
        unitPrice: 15.50,
        supplier: 'Fournisseur BTP Pro',
        supplierContact: 'contact@btppro.fr',
        location: 'Entrepôt A - Zone Construction',
      );

      print('✅ Matériau créé avec succès !');
      print('   Nom: ${material['data']['name']}');
      print('   Catégorie: ${material['data']['category']}');
      print('   Unité: ${material['data']['unit']}');
      print('   Stock actuel: ${material['data']['current_stock']}');
      print('   Stock minimum: ${material['data']['min_stock']}');
      print('   Prix unitaire: ${material['data']['unit_price']}€');
      print('   Fournisseur: ${material['data']['supplier']}');
      print('   Localisation: ${material['data']['location']}');

    } catch (e) {
      print('❌ Erreur lors de la création du matériau: $e');
    }
  }

  /// Exemple d'obtention de tous les matériaux
  Future<void> getAllMaterialsExample() async {
    try {
      print('📋 Récupération de tous les matériaux...');
      
      final materials = await _materialService.getMaterials(perPage: 10);

      print('✅ Matériaux récupérés avec succès !');
      print('   Total: ${materials['data']['total']} matériaux');
      print('   Page actuelle: ${materials['data']['current_page']}');
      print('   Par page: ${materials['data']['per_page']}');
      
      print('\n🏗️ MATÉRIAUX:');
      for (final material in materials['data']['data']) {
        print('   • ${material['name']}');
        print('     Catégorie: ${material['category']}');
        print('     Unité: ${material['unit']}');
        print('     Stock: ${material['current_stock']} / ${material['min_stock']}');
        print('     Prix: ${material['unit_price'] ?? 'Non défini'}€');
        print('     Statut: ${material['status'] ?? 'Non défini'}');
        print('     Fournisseur: ${material['supplier'] ?? 'Non défini'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux: $e');
    }
  }

  /// Exemple de filtrage des matériaux par catégorie
  Future<void> getMaterialsByCategoryExample() async {
    try {
      print('🏷️ Récupération des matériaux par catégorie...');
      
      // Matériaux de construction
      final constructionMaterials = await _materialService.getConstructionMaterials(perPage: 5);
      print('\n🏗️ MATÉRIAUX DE CONSTRUCTION:');
      print('   Nombre: ${constructionMaterials['data']['total']}');
      
      // Matériaux électriques
      final electricalMaterials = await _materialService.getElectricalMaterials(perPage: 5);
      print('\n⚡ MATÉRIAUX ÉLECTRIQUES:');
      print('   Nombre: ${electricalMaterials['data']['total']}');
      
      // Matériaux de plomberie
      final plumbingMaterials = await _materialService.getPlumbingMaterials(perPage: 5);
      print('\n🚰 MATÉRIAUX DE PLOMBERIE:');
      print('   Nombre: ${plumbingMaterials['data']['total']}');
      
      // Matériaux de finition
      final finishingMaterials = await _materialService.getFinishingMaterials(perPage: 5);
      print('\n✨ MATÉRIAUX DE FINITION:');
      print('   Nombre: ${finishingMaterials['data']['total']}');
      
      // Matériaux d'outillage
      final toolMaterials = await _materialService.getToolMaterials(perPage: 5);
      print('\n🔧 MATÉRIAUX D\'OUTILLAGE:');
      print('   Nombre: ${toolMaterials['data']['total']}');
      
      // Matériaux de sécurité
      final safetyMaterials = await _materialService.getSafetyMaterials(perPage: 5);
      print('\n🛡️ MATÉRIAUX DE SÉCURITÉ:');
      print('   Nombre: ${safetyMaterials['data']['total']}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par catégorie: $e');
    }
  }

  /// Exemple de filtrage des matériaux par statut
  Future<void> getMaterialsByStatusExample() async {
    try {
      print('📊 Récupération des matériaux par statut...');
      
      // Matériaux en rupture de stock
      final outOfStockMaterials = await _materialService.getOutOfStockMaterials(perPage: 5);
      print('\n❌ MATÉRIAUX EN RUPTURE DE STOCK:');
      print('   Nombre: ${outOfStockMaterials['data']['total']}');
      
      // Matériaux en stock faible
      final lowStockMaterials = await _materialService.getLowStockStatusMaterials(perPage: 5);
      print('\n⚠️ MATÉRIAUX EN STOCK FAIBLE:');
      print('   Nombre: ${lowStockMaterials['data']['total']}');
      
      // Matériaux en stock normal
      final normalStockMaterials = await _materialService.getNormalStockMaterials(perPage: 5);
      print('\n✅ MATÉRIAUX EN STOCK NORMAL:');
      print('   Nombre: ${normalStockMaterials['data']['total']}');
      
      // Matériaux en stock élevé
      final highStockMaterials = await _materialService.getHighStockMaterials(perPage: 5);
      print('\n📈 MATÉRIAUX EN STOCK ÉLEVÉ:');
      print('   Nombre: ${highStockMaterials['data']['total']}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par statut: $e');
    }
  }

  /// Exemple d'obtention des matériaux en stock faible
  Future<void> getLowStockMaterialsExample() async {
    try {
      print('⚠️ Récupération des matériaux en stock faible...');
      
      final lowStockMaterials = await _materialService.getLowStockMaterials();

      print('✅ Matériaux en stock faible récupérés avec succès !');
      print('   Nombre: ${lowStockMaterials['data'].length}');
      
      print('\n⚠️ MATÉRIAUX EN STOCK FAIBLE:');
      for (final material in lowStockMaterials['data']) {
        print('   • ${material['name']}');
        print('     Catégorie: ${material['category']}');
        print('     Stock actuel: ${material['current_stock']}');
        print('     Stock minimum: ${material['min_stock']}');
        print('     Unité: ${material['unit']}');
        print('     Statut: ${material['status']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux en stock faible: $e');
    }
  }

  /// Exemple d'obtention des matériaux par fournisseur
  Future<void> getMaterialsBySupplierExample() async {
    try {
      print('🏪 Récupération des matériaux par fournisseur...');
      
      final supplierMaterials = await _materialService.getMaterialsBySupplier('Fournisseur BTP Pro', perPage: 10);

      print('✅ Matériaux du fournisseur récupérés avec succès !');
      print('   Fournisseur: Fournisseur BTP Pro');
      print('   Nombre de matériaux: ${supplierMaterials['data']['supplier_count']}');
      
      print('\n🏪 MATÉRIAUX DU FOURNISSEUR:');
      for (final material in supplierMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Catégorie: ${material['category']}');
        print('     Stock: ${material['current_stock']}');
        print('     Prix: ${material['unit_price'] ?? 'Non défini'}€');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux du fournisseur: $e');
    }
  }

  /// Exemple d'obtention des matériaux par localisation
  Future<void> getMaterialsByLocationExample() async {
    try {
      print('📍 Récupération des matériaux par localisation...');
      
      final locationMaterials = await _materialService.getMaterialsByLocation('Entrepôt A', perPage: 10);

      print('✅ Matériaux de la localisation récupérés avec succès !');
      print('   Localisation: Entrepôt A');
      print('   Nombre de matériaux: ${locationMaterials['data']['location_count']}');
      
      print('\n📍 MATÉRIAUX DE LA LOCALISATION:');
      for (final material in locationMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Catégorie: ${material['category']}');
        print('     Stock: ${material['current_stock']}');
        print('     Fournisseur: ${material['supplier'] ?? 'Non défini'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux de la localisation: $e');
    }
  }

  /// Exemple d'obtention des matériaux par gamme de prix
  Future<void> getMaterialsByPriceRangeExample() async {
    try {
      print('💰 Récupération des matériaux par gamme de prix...');
      
      final priceRangeMaterials = await _materialService.getMaterialsByPriceRange(
        minPrice: 10.0,
        maxPrice: 50.0,
        perPage: 10,
      );

      print('✅ Matériaux de la gamme de prix récupérés avec succès !');
      print('   Gamme: 10€ à 50€');
      print('   Nombre de matériaux: ${priceRangeMaterials['data']['price_range_count']}');
      
      print('\n💰 MATÉRIAUX DE LA GAMME DE PRIX:');
      for (final material in priceRangeMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Prix: ${material['unit_price'] ?? 'Non défini'}€');
        print('     Catégorie: ${material['category']}');
        print('     Stock: ${material['current_stock']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux par gamme de prix: $e');
    }
  }

  /// Exemple d'obtention des matériaux par gamme de stock
  Future<void> getMaterialsByStockRangeExample() async {
    try {
      print('📦 Récupération des matériaux par gamme de stock...');
      
      final stockRangeMaterials = await _materialService.getMaterialsByStockRange(
        minStock: 50.0,
        maxStock: 200.0,
        perPage: 10,
      );

      print('✅ Matériaux de la gamme de stock récupérés avec succès !');
      print('   Gamme: 50 à 200 unités');
      print('   Nombre de matériaux: ${stockRangeMaterials['data']['stock_range_count']}');
      
      print('\n📦 MATÉRIAUX DE LA GAMME DE STOCK:');
      for (final material in stockRangeMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Stock: ${material['current_stock']}');
        print('     Catégorie: ${material['category']}');
        print('     Unité: ${material['unit']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux par gamme de stock: $e');
    }
  }

  /// Exemple de recherche de matériaux
  Future<void> searchMaterialsExample() async {
    try {
      print('🔍 Recherche de matériaux...');
      
      final searchResults = await _materialService.searchMaterials('ciment', perPage: 10);

      print('✅ Recherche terminée avec succès !');
      print('   Terme recherché: ciment');
      print('   Résultats trouvés: ${searchResults['data']['results_count']}');
      
      print('\n🔍 RÉSULTATS DE LA RECHERCHE:');
      for (final material in searchResults['data']['data']) {
        print('   • ${material['name']}');
        print('     Catégorie: ${material['category']}');
        print('     Stock: ${material['current_stock']}');
        print('     Prix: ${material['unit_price'] ?? 'Non défini'}€');
        print('     Fournisseur: ${material['supplier'] ?? 'Non défini'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple d'obtention des statistiques des matériaux
  Future<void> getMaterialStatsExample() async {
    try {
      print('📊 Récupération des statistiques des matériaux...');
      
      final stats = await _materialService.getMaterialStats();

      print('✅ Statistiques des matériaux récupérées avec succès !');
      
      print('\n📈 STATISTIQUES GÉNÉRALES:');
      print('   Total des matériaux: ${stats['data']['total_materials']}');
      print('   Valeur totale du stock: ${stats['data']['total_value']}€');
      print('   Stock total: ${stats['data']['total_stock']} unités');
      print('   Prix unitaire moyen: ${stats['data']['average_unit_price']}€');
      print('   Pourcentage de stock faible: ${stats['data']['low_stock_percentage']}%');
      
      print('\n📊 RÉPARTITION PAR STATUT:');
      final byStatus = stats['data']['by_status'];
      print('   Stock faible: ${byStatus['low_stock']}');
      print('   Rupture de stock: ${byStatus['out_of_stock']}');
      print('   Stock normal: ${byStatus['normal']}');
      print('   Stock élevé: ${byStatus['high_stock']}');
      
      print('\n🏷️ RÉPARTITION PAR CATÉGORIE:');
      final byCategory = stats['data']['by_category'];
      for (final entry in byCategory.entries) {
        print('   ${entry.key}: ${entry.value} matériaux');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple d'obtention des matériaux nécessitant une commande
  Future<void> getMaterialsNeedingOrderExample() async {
    try {
      print('📋 Récupération des matériaux nécessitant une commande...');
      
      final needOrderMaterials = await _materialService.getMaterialsNeedingOrder(perPage: 10);

      print('✅ Matériaux nécessitant une commande récupérés avec succès !');
      print('   Nombre: ${needOrderMaterials['data']['need_order_count']}');
      
      print('\n📋 MATÉRIAUX À COMMANDER:');
      for (final material in needOrderMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Stock actuel: ${material['current_stock']}');
        print('     Stock minimum: ${material['min_stock']}');
        print('     Stock maximum: ${material['max_stock'] ?? 'Non défini'}');
        print('     Catégorie: ${material['category']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux à commander: $e');
    }
  }

  /// Exemple d'obtention des matériaux par période de création
  Future<void> getMaterialsByCreationPeriodExample() async {
    try {
      print('📅 Récupération des matériaux par période de création...');
      
      final startDate = DateTime.now().subtract(Duration(days: 30));
      final endDate = DateTime.now();
      
      final periodMaterials = await _materialService.getMaterialsByCreationPeriod(
        startDate: startDate,
        endDate: endDate,
        perPage: 10,
      );

      print('✅ Matériaux de la période récupérés avec succès !');
      print('   Période: ${startDate.toIso8601String()} à ${endDate.toIso8601String()}');
      print('   Nombre de matériaux: ${periodMaterials['data']['period_count']}');
      
      print('\n📅 MATÉRIAUX DE LA PÉRIODE:');
      for (final material in periodMaterials['data']['data']) {
        print('   • ${material['name']}');
        print('     Date de création: ${material['created_at']}');
        print('     Catégorie: ${material['category']}');
        print('     Créé par: ${material['created_by']?['name'] ?? 'Système'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des matériaux de la période: $e');
    }
  }

  /// Exemple de mise à jour d'un matériau
  Future<void> updateMaterialExample() async {
    try {
      print('✏️ Mise à jour d\'un matériau...');
      
      final updatedMaterial = await _materialService.updateMaterial(
        1, // ID du matériau
        name: 'Ciment Portland Premium',
        currentStock: 150.0,
        unitPrice: 16.00,
        description: 'Ciment Portland de haute qualité pour construction - Mise à jour',
      );

      print('✅ Matériau mis à jour avec succès !');
      print('   Nom: ${updatedMaterial['data']['name']}');
      print('   Stock actuel: ${updatedMaterial['data']['current_stock']}');
      print('   Prix unitaire: ${updatedMaterial['data']['unit_price']}€');
      print('   Description: ${updatedMaterial['data']['description']}');
      print('   Message: ${updatedMaterial['message']}');

    } catch (e) {
      print('❌ Erreur lors de la mise à jour du matériau: $e');
    }
  }

  /// Exemple de mise à jour du stock d'un matériau
  Future<void> updateMaterialStockExample() async {
    try {
      print('📦 Mise à jour du stock d\'un matériau...');
      
      final updatedMaterial = await _materialService.updateMaterialStock(
        1, // ID du matériau
        quantity: 25.0,
        operation: 'add', // 'add' ou 'subtract'
      );

      print('✅ Stock du matériau mis à jour avec succès !');
      print('   Nom: ${updatedMaterial['data']['name']}');
      print('   Stock actuel: ${updatedMaterial['data']['current_stock']}');
      print('   Opération: Ajout de 25 unités');
      print('   Message: ${updatedMaterial['message']}');

    } catch (e) {
      print('❌ Erreur lors de la mise à jour du stock: $e');
    }
  }

  /// Exemple d'ajout de stock
  Future<void> addStockExample() async {
    try {
      print('➕ Ajout de stock à un matériau...');
      
      final updatedMaterial = await _materialService.addStock(1, 30.0);

      print('✅ Stock ajouté avec succès !');
      print('   Nom: ${updatedMaterial['data']['name']}');
      print('   Stock actuel: ${updatedMaterial['data']['current_stock']}');
      print('   Ajout: +30 unités');
      print('   Message: ${updatedMaterial['message']}');

    } catch (e) {
      print('❌ Erreur lors de l\'ajout de stock: $e');
    }
  }

  /// Exemple de retrait de stock
  Future<void> subtractStockExample() async {
    try {
      print('➖ Retrait de stock d\'un matériau...');
      
      final updatedMaterial = await _materialService.subtractStock(1, 15.0);

      print('✅ Stock retiré avec succès !');
      print('   Nom: ${updatedMaterial['data']['name']}');
      print('   Stock actuel: ${updatedMaterial['data']['current_stock']}');
      print('   Retrait: -15 unités');
      print('   Message: ${updatedMaterial['message']}');

    } catch (e) {
      print('❌ Erreur lors du retrait de stock: $e');
    }
  }

  /// Exemple de vérification du statut du stock
  Future<void> checkStockStatusExample() async {
    try {
      print('🔍 Vérification du statut du stock...');
      
      final materialId = 1;
      
      // Vérifier si en stock faible
      final isLowStock = await _materialService.isLowStock(materialId);
      print('   En stock faible: ${isLowStock ? 'Oui' : 'Non'}');
      
      // Vérifier si en rupture de stock
      final isOutOfStock = await _materialService.isOutOfStock(materialId);
      print('   En rupture de stock: ${isOutOfStock ? 'Oui' : 'Non'}');
      
      // Calculer la valeur du stock
      final stockValue = await _materialService.getMaterialStockValue(materialId);
      print('   Valeur du stock: ${stockValue}€');

    } catch (e) {
      print('❌ Erreur lors de la vérification du statut: $e');
    }
  }

  /// Exemple de suppression d'un matériau
  Future<void> deleteMaterialExample() async {
    try {
      print('🗑️ Suppression d\'un matériau...');
      
      final result = await _materialService.deleteMaterial(1);

      print('✅ Matériau supprimé avec succès !');
      print('   Message: ${result['message']}');

    } catch (e) {
      print('❌ Erreur lors de la suppression du matériau: $e');
    }
  }

  /// Exemple complet d'utilisation du service material
  Future<void> completeMaterialWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE MATERIAL ===\n');

      // 1. Créer un nouveau matériau
      await createMaterialExample();
      print('');

      // 2. Obtenir tous les matériaux
      await getAllMaterialsExample();
      print('');

      // 3. Filtrer par catégorie
      await getMaterialsByCategoryExample();
      print('');

      // 4. Filtrer par statut
      await getMaterialsByStatusExample();
      print('');

      // 5. Obtenir les matériaux en stock faible
      await getLowStockMaterialsExample();
      print('');

      // 6. Obtenir les matériaux par fournisseur
      await getMaterialsBySupplierExample();
      print('');

      // 7. Obtenir les matériaux par localisation
      await getMaterialsByLocationExample();
      print('');

      // 8. Obtenir les matériaux par gamme de prix
      await getMaterialsByPriceRangeExample();
      print('');

      // 9. Obtenir les matériaux par gamme de stock
      await getMaterialsByStockRangeExample();
      print('');

      // 10. Rechercher des matériaux
      await searchMaterialsExample();
      print('');

      // 11. Obtenir les statistiques
      await getMaterialStatsExample();
      print('');

      // 12. Obtenir les matériaux à commander
      await getMaterialsNeedingOrderExample();
      print('');

      // 13. Obtenir les matériaux par période
      await getMaterialsByCreationPeriodExample();
      print('');

      // 14. Mettre à jour un matériau
      await updateMaterialExample();
      print('');

      // 15. Mettre à jour le stock
      await updateMaterialStockExample();
      print('');

      // 16. Ajouter du stock
      await addStockExample();
      print('');

      // 17. Retirer du stock
      await subtractStockExample();
      print('');

      // 18. Vérifier le statut du stock
      await checkStockStatusExample();
      print('');

      // 19. Supprimer un matériau
      await deleteMaterialExample();
      print('');

      print('✅ Workflow du service material terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du service material: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord des matériaux
      print('🏗️ TABLEAU DE BORD DES MATÉRIAUX:');
      
      // Récupérer les statistiques
      final stats = await _materialService.getMaterialStats();
      print('📊 STATISTIQUES:');
      print('   Total: ${stats['data']['total_materials']} matériaux');
      print('   Valeur totale: ${stats['data']['total_value']}€');
      print('   Stock faible: ${stats['data']['low_stock_percentage']}%');
      
      // Récupérer les matériaux en stock faible
      final lowStockMaterials = await _materialService.getLowStockMaterials();
      print('\n⚠️ STOCK FAIBLE:');
      print('   Matériaux en stock faible: ${lowStockMaterials['data'].length}');
      
      // Récupérer les matériaux à commander
      final needOrderMaterials = await _materialService.getMaterialsNeedingOrder(perPage: 5);
      print('\n📋 À COMMANDER:');
      print('   Matériaux à commander: ${needOrderMaterials['data']['need_order_count']}');
      
      // Récupérer les matériaux par catégorie
      final constructionMaterials = await _materialService.getConstructionMaterials(perPage: 5);
      print('\n🏗️ CONSTRUCTION:');
      print('   Matériaux de construction: ${constructionMaterials['data']['total']}');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service material
void main() async {
  final materialExample = MaterialExample();
  
  // Exécuter le workflow complet
  await materialExample.completeMaterialWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await materialExample.uiExample();
}

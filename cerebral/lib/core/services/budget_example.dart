import 'budget_service.dart';

/// Exemple d'utilisation complète du service budget
/// Basé sur le BudgetController Laravel avec toutes les fonctionnalités
class BudgetExample {
  final BudgetService _budgetService = BudgetService();

  /// Exemple de création d'un budget
  Future<void> createBudgetExample() async {
    try {
      print('🔄 Création d\'un nouveau budget...');
      
      final response = await _budgetService.createBudget(
        description: 'Budget construction Villa A3 - Phase 1',
        amount: 150000.0,
        type: 'expense',
        category: 'construction',
        fiscalYear: '2024',
        projectId: 1,
        currency: 'EUR',
        notes: 'Budget pour la première phase de construction',
        dueDate: DateTime.now().add(Duration(days: 90)),
        status: 'pending',
        isRecurring: false,
      );

      print('✅ Budget créé avec succès !');
      print('📋 Description: ${response['data']['description']}');
      print('💰 Montant: ${response['data']['amount']} ${response['data']['currency']}');
      print('📁 Catégorie: ${response['data']['category']}');
      print('📝 Message: ${response['message']}');

    } catch (e) {
      print('❌ Erreur lors de la création du budget: $e');
    }
  }

  /// Exemple de récupération des budgets avec filtres
  Future<void> getBudgetsWithFiltersExample() async {
    try {
      print('🔍 Récupération des budgets avec filtres...');
      
      final response = await _budgetService.getBudgets(
        status: 'pending',
        type: 'expense',
        category: 'construction',
        fiscalYear: '2024',
        projectId: 1,
        sortBy: 'amount',
        sortOrder: 'desc',
        perPage: 10,
      );

      print('✅ Budgets récupérés avec succès !');
      print('📊 Total: ${response['meta']['total']} budgets');
      print('📄 Page actuelle: ${response['meta']['current_page']}');
      print('📋 Budgets trouvés: ${response['data'].length}');

      // Afficher les premiers budgets
      for (int i = 0; i < response['data'].length && i < 3; i++) {
        final budget = response['data'][i];
        print('   ${i + 1}. ${budget['description']} - ${budget['amount']} ${budget['currency']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des budgets: $e');
    }
  }

  /// Exemple d'approbation d'un budget
  Future<void> approveBudgetExample() async {
    try {
      print('✅ Approbation d\'un budget...');
      
      final response = await _budgetService.approveBudget(1);

      print('✅ Budget approuvé avec succès !');
      print('📝 Message: ${response['message']}');
      print('📋 Description: ${response['data']['description']}');
      print('🔐 Approuvé par: ${response['data']['approved_by']?['name'] ?? 'N/A'}');

    } catch (e) {
      print('❌ Erreur lors de l\'approbation du budget: $e');
    }
  }

  /// Exemple de récupération des statistiques
  Future<void> getBudgetStatsExample() async {
    try {
      print('📊 Récupération des statistiques des budgets...');
      
      final response = await _budgetService.getBudgetStats();

      print('✅ Statistiques récupérées avec succès !');
      print('📈 Total des budgets: ${response['data']['total']}');
      print('💰 Montant total: ${response['data']['total_amount']}');
      print('✅ Budgets approuvés: ${response['data']['approved']}');
      print('📋 Budgets exécutés: ${response['data']['executed']}');
      print('⏳ Budgets en attente: ${response['data']['pending']}');

      // Afficher les statistiques par type
      final byType = response['data']['by_type'] as List<dynamic>?;
      if (byType != null) {
        print('📊 Répartition par type:');
        for (final type in byType) {
          print('   ${type['type']}: ${type['count']} budgets - ${type['total_amount']}');
        }
      }

      // Afficher les statistiques par catégorie
      final byCategory = response['data']['by_category'] as List<dynamic>?;
      if (byCategory != null) {
        print('📁 Répartition par catégorie:');
        for (final category in byCategory) {
          print('   ${category['category']}: ${category['count']} budgets - ${category['total_amount']}');
        }
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple de récupération des catégories
  Future<void> getBudgetCategoriesExample() async {
    try {
      print('📁 Récupération des catégories de budgets...');
      
      final response = await _budgetService.getBudgetCategories();

      print('✅ Catégories récupérées avec succès !');
      print('📋 Catégories disponibles:');
      for (final category in response['data']) {
        print('   • $category');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des catégories: $e');
    }
  }

  /// Exemple de récupération des budgets par projet
  Future<void> getBudgetsByProjectExample() async {
    try {
      print('🏗️ Récupération des budgets du projet...');
      
      final response = await _budgetService.getBudgetsByProject(1);

      print('✅ Budgets du projet récupérés avec succès !');
      print('📋 Projet: ${response['data']['project']['name']}');
      print('📊 Statistiques du projet:');
      print('   Total des budgets: ${response['data']['stats']['total_budgets']}');
      print('   Montant total: ${response['data']['stats']['total_amount']}');
      print('   Montant approuvé: ${response['data']['stats']['approved_amount']}');
      print('   Montant exécuté: ${response['data']['stats']['executed_amount']}');

      print('📋 Budgets du projet:');
      for (final budget in response['data']['budgets']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']} - ${budget['status']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des budgets du projet: $e');
    }
  }

  /// Exemple d'export des budgets
  Future<void> exportBudgetsExample() async {
    try {
      print('📤 Export des budgets...');
      
      final response = await _budgetService.exportBudgets(format: 'csv');

      print('✅ Export généré avec succès !');
      print('📝 Message: ${response['message']}');
      print('📊 Format: ${response['data']['format']}');
      print('📈 Nombre de budgets: ${response['data']['count']}');
      print('💰 Montant total: ${response['data']['total_amount']}');

    } catch (e) {
      print('❌ Erreur lors de l\'export: $e');
    }
  }

  /// Exemple de recherche de budgets
  Future<void> searchBudgetsExample() async {
    try {
      print('🔍 Recherche de budgets...');
      
      final response = await _budgetService.searchBudgets('construction', perPage: 5);

      print('✅ Recherche effectuée avec succès !');
      print('🔍 Terme recherché: construction');
      print('📊 Résultats trouvés: ${response['meta']['total']}');
      print('📋 Budgets trouvés:');
      for (final budget in response['data']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la recherche: $e');
    }
  }

  /// Exemple de récupération des budgets par type
  Future<void> getBudgetsByTypeExample() async {
    try {
      print('📊 Récupération des budgets par type...');
      
      final response = await _budgetService.getBudgetsByType('expense', perPage: 10);

      print('✅ Budgets de type "expense" récupérés !');
      print('📊 Total: ${response['meta']['total']} budgets');
      print('📋 Budgets trouvés:');
      for (final budget in response['data']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']} - ${budget['category']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des budgets par type: $e');
    }
  }

  /// Exemple de récupération des budgets par année fiscale
  Future<void> getBudgetsByFiscalYearExample() async {
    try {
      print('📅 Récupération des budgets par année fiscale...');
      
      final response = await _budgetService.getBudgetsByFiscalYear('2024', perPage: 10);

      print('✅ Budgets de l\'année fiscale 2024 récupérés !');
      print('📊 Total: ${response['meta']['total']} budgets');
      print('📋 Budgets trouvés:');
      for (final budget in response['data']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']} - ${budget['type']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des budgets par année fiscale: $e');
    }
  }

  /// Exemple complet de gestion des budgets
  Future<void> completeBudgetWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DE GESTION DES BUDGETS ===\n');

      // 1. Créer un budget
      await createBudgetExample();
      print('');

      // 2. Récupérer les budgets avec filtres
      await getBudgetsWithFiltersExample();
      print('');

      // 3. Approuver un budget
      await approveBudgetExample();
      print('');

      // 4. Obtenir les statistiques
      await getBudgetStatsExample();
      print('');

      // 5. Obtenir les catégories
      await getBudgetCategoriesExample();
      print('');

      // 6. Obtenir les budgets par projet
      await getBudgetsByProjectExample();
      print('');

      // 7. Exporter les budgets
      await exportBudgetsExample();
      print('');

      // 8. Rechercher des budgets
      await searchBudgetsExample();
      print('');

      // 9. Obtenir les budgets par type
      await getBudgetsByTypeExample();
      print('');

      // 10. Obtenir les budgets par année fiscale
      await getBudgetsByFiscalYearExample();
      print('');

      print('✅ Workflow de gestion des budgets terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow de gestion des budgets: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord des budgets
      print('📊 Tableau de bord des budgets:');
      
      // Récupérer les statistiques
      final stats = await _budgetService.getBudgetStats();
      print('💰 Montant total: ${stats['data']['total_amount']}');
      print('✅ Budgets approuvés: ${stats['data']['approved']}');
      print('⏳ Budgets en attente: ${stats['data']['pending']}');

      // Récupérer les budgets en attente d'approbation
      final pendingBudgets = await _budgetService.getPendingBudgets(perPage: 5);
      print('\n⏳ Budgets en attente d\'approbation:');
      for (final budget in pendingBudgets['data']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']}');
      }

      // Récupérer les budgets récents
      final recentBudgets = await _budgetService.getBudgets(
        sortBy: 'created_at',
        sortOrder: 'desc',
        perPage: 5,
      );
      print('\n🕒 Budgets récents:');
      for (final budget in recentBudgets['data']) {
        print('   • ${budget['description']} - ${budget['amount']} ${budget['currency']} - ${budget['status']}');
      }

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service budget
void main() async {
  final budgetExample = BudgetExample();
  
  // Exécuter le workflow complet
  await budgetExample.completeBudgetWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await budgetExample.uiExample();
}

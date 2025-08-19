import 'api_service.dart';

class BudgetService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous les budgets avec filtres, recherche et pagination
  Future<Map<String, dynamic>> getBudgets({
    String? status,
    String? type,
    String? category,
    String? fiscalYear,
    int? projectId,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;
      if (category != null) queryParams['category'] = category;
      if (fiscalYear != null) queryParams['fiscal_year'] = fiscalYear;
      if (projectId != null) queryParams['project_id'] = projectId.toString();
      if (search != null) queryParams['search'] = search;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer un nouveau budget
  Future<Map<String, dynamic>> createBudget({
    required String description,
    required double amount,
    required String type,
    required String category,
    String? fiscalYear,
    int? projectId,
    String? currency,
    String? notes,
    DateTime? dueDate,
    String? status,
    bool? isRecurring,
    String? recurrenceType,
    int? recurrenceInterval,
  }) async {
    try {
      final data = <String, dynamic>{
        'description': description,
        'amount': amount,
        'type': type,
        'category': category,
      };

      if (fiscalYear != null) data['fiscal_year'] = fiscalYear;
      if (projectId != null) data['project_id'] = projectId;
      if (currency != null) data['currency'] = currency;
      if (notes != null) data['notes'] = notes;
      if (dueDate != null) data['due_date'] = dueDate.toIso8601String();
      if (status != null) data['status'] = status;
      if (isRecurring != null) data['is_recurring'] = isRecurring;
      if (recurrenceType != null) data['recurrence_type'] = recurrenceType;
      if (recurrenceInterval != null) data['recurrence_interval'] = recurrenceInterval;

      return await _apiService.post('/budgets', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un budget spécifique
  Future<Map<String, dynamic>> getBudget(int budgetId) async {
    try {
      return await _apiService.get('/budgets/$budgetId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un budget
  Future<Map<String, dynamic>> updateBudget(
    int budgetId, {
    String? description,
    double? amount,
    String? type,
    String? category,
    String? fiscalYear,
    int? projectId,
    String? currency,
    String? notes,
    DateTime? dueDate,
    String? status,
    bool? isRecurring,
    String? recurrenceType,
    int? recurrenceInterval,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (description != null) data['description'] = description;
      if (amount != null) data['amount'] = amount;
      if (type != null) data['type'] = type;
      if (category != null) data['category'] = category;
      if (fiscalYear != null) data['fiscal_year'] = fiscalYear;
      if (projectId != null) data['project_id'] = projectId;
      if (currency != null) data['currency'] = currency;
      if (notes != null) data['notes'] = notes;
      if (dueDate != null) data['due_date'] = dueDate.toIso8601String();
      if (status != null) data['status'] = status;
      if (isRecurring != null) data['is_recurring'] = isRecurring;
      if (recurrenceType != null) data['recurrence_type'] = recurrenceType;
      if (recurrenceInterval != null) data['recurrence_interval'] = recurrenceInterval;

      return await _apiService.put('/budgets/$budgetId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un budget
  Future<Map<String, dynamic>> deleteBudget(int budgetId) async {
    try {
      return await _apiService.delete('/budgets/$budgetId');
    } catch (e) {
      rethrow;
    }
  }

  // Approuver un budget
  Future<Map<String, dynamic>> approveBudget(int budgetId) async {
    try {
      return await _apiService.post('/budgets/$budgetId/approve', {});
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des budgets
  Future<Map<String, dynamic>> getBudgetStats() async {
    try {
      return await _apiService.get('/budgets/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les catégories de budgets
  Future<Map<String, dynamic>> getBudgetCategories() async {
    try {
      return await _apiService.get('/budgets/categories');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets d'un projet spécifique
  Future<Map<String, dynamic>> getBudgetsByProject(int projectId) async {
    try {
      return await _apiService.get('/budgets/project/$projectId');
    } catch (e) {
      rethrow;
    }
  }

  // Exporter les budgets
  Future<Map<String, dynamic>> exportBudgets({
    required String format, // csv, json, xml
  }) async {
    try {
      return await _apiService.post('/budgets/export', {
        'format': format,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets en attente d'approbation
  Future<Map<String, dynamic>> getPendingBudgets({
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': 'pending',
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets approuvés
  Future<Map<String, dynamic>> getApprovedBudgets({
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': 'approved',
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets par type
  Future<Map<String, dynamic>> getBudgetsByType(String type, {
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'type': type,
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets par catégorie
  Future<Map<String, dynamic>> getBudgetsByCategory(String category, {
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'category': category,
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des budgets
  Future<Map<String, dynamic>> searchBudgets(String searchQuery, {
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'search': searchQuery,
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les budgets par année fiscale
  Future<Map<String, dynamic>> getBudgetsByFiscalYear(String fiscalYear, {
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        'fiscal_year': fiscalYear,
      };
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
          : '';

      return await _apiService.get('/budgets$queryString');
    } catch (e) {
      rethrow;
    }
  }
}

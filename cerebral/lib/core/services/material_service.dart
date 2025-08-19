import 'api_service.dart';

class MaterialService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous les matériaux avec filtres et pagination
  Future<Map<String, dynamic>> getMaterials({
    String? category,
    String? status,
    int? perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (category != null) {
        queryParams['category'] = category;
      }
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/materials$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer un nouveau matériau
  Future<Map<String, dynamic>> createMaterial({
    required String name,
    String? description,
    required String category,
    required String unit,
    required double currentStock,
    required double minStock,
    double? maxStock,
    double? unitPrice,
    String? supplier,
    String? supplierContact,
    String? location,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'category': category,
        'unit': unit,
        'current_stock': currentStock,
        'min_stock': minStock,
      };

      if (description != null) {
        data['description'] = description;
      }
      
      if (maxStock != null) {
        data['max_stock'] = maxStock;
      }
      
      if (unitPrice != null) {
        data['unit_price'] = unitPrice;
      }
      
      if (supplier != null) {
        data['supplier'] = supplier;
      }
      
      if (supplierContact != null) {
        data['supplier_contact'] = supplierContact;
      }
      
      if (location != null) {
        data['location'] = location;
      }

      return await _apiService.post('/materials', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un matériau spécifique
  Future<Map<String, dynamic>> getMaterial(int materialId) async {
    try {
      return await _apiService.get('/materials/$materialId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un matériau
  Future<Map<String, dynamic>> updateMaterial(
    int materialId, {
    String? name,
    String? description,
    String? category,
    String? unit,
    double? currentStock,
    double? minStock,
    double? maxStock,
    double? unitPrice,
    String? supplier,
    String? supplierContact,
    String? location,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) {
        data['name'] = name;
      }
      
      if (description != null) {
        data['description'] = description;
      }
      
      if (category != null) {
        data['category'] = category;
      }
      
      if (unit != null) {
        data['unit'] = unit;
      }
      
      if (currentStock != null) {
        data['current_stock'] = currentStock;
      }
      
      if (minStock != null) {
        data['min_stock'] = minStock;
      }
      
      if (maxStock != null) {
        data['max_stock'] = maxStock;
      }
      
      if (unitPrice != null) {
        data['unit_price'] = unitPrice;
      }
      
      if (supplier != null) {
        data['supplier'] = supplier;
      }
      
      if (supplierContact != null) {
        data['supplier_contact'] = supplierContact;
      }
      
      if (location != null) {
        data['location'] = location;
      }

      return await _apiService.put('/materials/$materialId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un matériau
  Future<Map<String, dynamic>> deleteMaterial(int materialId) async {
    try {
      return await _apiService.delete('/materials/$materialId');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux en stock faible
  Future<Map<String, dynamic>> getLowStockMaterials() async {
    try {
      return await _apiService.get('/materials/low-stock');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le stock d'un matériau
  Future<Map<String, dynamic>> updateMaterialStock(
    int materialId, {
    required double quantity,
    required String operation, // 'add' ou 'subtract'
  }) async {
    try {
      final data = <String, dynamic>{
        'quantity': quantity,
        'operation': operation,
      };

      return await _apiService.post('/materials/$materialId/update-stock', data);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les matériaux

  // Obtenir les matériaux par catégorie
  Future<Map<String, dynamic>> getMaterialsByCategory(String category, {int? perPage}) async {
    return await getMaterials(category: category, perPage: perPage);
  }

  // Obtenir les matériaux par statut
  Future<Map<String, dynamic>> getMaterialsByStatus(String status, {int? perPage}) async {
    return await getMaterials(status: status, perPage: perPage);
  }

  // Obtenir les matériaux en rupture de stock
  Future<Map<String, dynamic>> getOutOfStockMaterials({int? perPage}) async {
    return await getMaterials(status: 'out_of_stock', perPage: perPage);
  }

  // Obtenir les matériaux en stock faible
  Future<Map<String, dynamic>> getLowStockStatusMaterials({int? perPage}) async {
    return await getMaterials(status: 'low_stock', perPage: perPage);
  }

  // Obtenir les matériaux en stock normal
  Future<Map<String, dynamic>> getNormalStockMaterials({int? perPage}) async {
    return await getMaterials(status: 'normal', perPage: perPage);
  }

  // Obtenir les matériaux en stock élevé
  Future<Map<String, dynamic>> getHighStockMaterials({int? perPage}) async {
    return await getMaterials(status: 'high_stock', perPage: perPage);
  }

  // Obtenir les matériaux de construction
  Future<Map<String, dynamic>> getConstructionMaterials({int? perPage}) async {
    return await getMaterials(category: 'construction', perPage: perPage);
  }

  // Obtenir les matériaux électriques
  Future<Map<String, dynamic>> getElectricalMaterials({int? perPage}) async {
    return await getMaterials(category: 'electrical', perPage: perPage);
  }

  // Obtenir les matériaux de plomberie
  Future<Map<String, dynamic>> getPlumbingMaterials({int? perPage}) async {
    return await getMaterials(category: 'plumbing', perPage: perPage);
  }

  // Obtenir les matériaux de finition
  Future<Map<String, dynamic>> getFinishingMaterials({int? perPage}) async {
    return await getMaterials(category: 'finishing', perPage: perPage);
  }

  // Obtenir les matériaux d'outillage
  Future<Map<String, dynamic>> getToolMaterials({int? perPage}) async {
    return await getMaterials(category: 'tools', perPage: perPage);
  }

  // Obtenir les matériaux de sécurité
  Future<Map<String, dynamic>> getSafetyMaterials({int? perPage}) async {
    return await getMaterials(category: 'safety', perPage: perPage);
  }

  // Obtenir les matériaux par fournisseur
  Future<Map<String, dynamic>> getMaterialsBySupplier(String supplier, {int? perPage}) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        final supplierMaterials = materials.where((material) {
          return material['supplier']?.toString().toLowerCase() == supplier.toLowerCase();
        }).toList();

        return {
          'success': true,
          'data': {
            'data': supplierMaterials,
            'total': supplierMaterials.length,
            'supplier': supplier,
            'supplier_count': supplierMaterials.length,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux par localisation
  Future<Map<String, dynamic>> getMaterialsByLocation(String location, {int? perPage}) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        final locationMaterials = materials.where((material) {
          return material['location']?.toString().toLowerCase() == location.toLowerCase();
        }).toList();

        return {
          'success': true,
          'data': {
            'data': locationMaterials,
            'total': locationMaterials.length,
            'location': location,
            'location_count': locationMaterials.length,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux par gamme de prix
  Future<Map<String, dynamic>> getMaterialsByPriceRange({
    double? minPrice,
    double? maxPrice,
    int? perPage,
  }) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        final priceRangeMaterials = materials.where((material) {
          final unitPrice = material['unit_price'] ?? 0.0;
          
          if (minPrice != null && unitPrice < minPrice) {
            return false;
          }
          
          if (maxPrice != null && unitPrice > maxPrice) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': priceRangeMaterials,
            'total': priceRangeMaterials.length,
            'min_price': minPrice,
            'max_price': maxPrice,
            'price_range_count': priceRangeMaterials.length,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux par gamme de stock
  Future<Map<String, dynamic>> getMaterialsByStockRange({
    double? minStock,
    double? maxStock,
    int? perPage,
  }) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        final stockRangeMaterials = materials.where((material) {
          final currentStock = material['current_stock'] ?? 0.0;
          
          if (minStock != null && currentStock < minStock) {
            return false;
          }
          
          if (maxStock != null && currentStock > maxStock) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': stockRangeMaterials,
            'total': stockRangeMaterials.length,
            'min_stock': minStock,
            'max_stock': maxStock,
            'stock_range_count': stockRangeMaterials.length,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des matériaux par nom ou description
  Future<Map<String, dynamic>> searchMaterials(String searchQuery, {int? perPage}) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        final query = searchQuery.toLowerCase();
        
        final searchResults = materials.where((material) {
          final name = material['name']?.toString().toLowerCase() ?? '';
          final description = material['description']?.toString().toLowerCase() ?? '';
          final category = material['category']?.toString().toLowerCase() ?? '';
          final supplier = material['supplier']?.toString().toLowerCase() ?? '';
          
          return name.contains(query) || 
                 description.contains(query) || 
                 category.contains(query) || 
                 supplier.contains(query);
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
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des matériaux
  Future<Map<String, dynamic>> getMaterialStats() async {
    try {
      final allMaterials = await getMaterials(perPage: 1000); // Récupérer toutes pour les stats
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        int total = 0;
        int lowStock = 0;
        int outOfStock = 0;
        int normalStock = 0;
        int highStock = 0;
        double totalValue = 0.0;
        double totalStock = 0.0;
        
        Map<String, int> categoryCount = {};
        Map<String, double> categoryValue = {};
        Map<String, double> categoryStock = {};
        
        for (final material in materials) {
          total++;
          
          final status = material['status'];
          final currentStock = material['current_stock'] ?? 0.0;
          final unitPrice = material['unit_price'] ?? 0.0;
          final category = material['category'] ?? 'unknown';
          
          // Compter par statut
          switch (status) {
            case 'low_stock':
              lowStock++;
              break;
            case 'out_of_stock':
              outOfStock++;
              break;
            case 'normal':
              normalStock++;
              break;
            case 'high_stock':
              highStock++;
              break;
          }
          
          // Calculer les valeurs totales
          totalValue += currentStock * unitPrice;
          totalStock += currentStock;
          
          // Compter par catégorie
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
          categoryValue[category] = (categoryValue[category] ?? 0.0) + (currentStock * unitPrice);
          categoryStock[category] = (categoryStock[category] ?? 0.0) + currentStock;
        }

        return {
          'success': true,
          'data': {
            'total_materials': total,
            'by_status': {
              'low_stock': lowStock,
              'out_of_stock': outOfStock,
              'normal': normalStock,
              'high_stock': highStock,
            },
            'by_category': categoryCount,
            'total_value': totalValue,
            'total_stock': totalStock,
            'average_unit_price': total > 0 ? totalValue / totalStock : 0.0,
            'category_values': categoryValue,
            'category_stocks': categoryStock,
            'low_stock_percentage': total > 0 ? ((lowStock + outOfStock) / total * 100).roundToDouble() : 0.0,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux nécessitant une commande
  Future<Map<String, dynamic>> getMaterialsNeedingOrder({int? perPage}) async {
    try {
      final lowStockMaterials = await getLowStockMaterials();
      
      if (lowStockMaterials['success'] == true) {
        final materials = lowStockMaterials['data'] as List;
        
        final needOrderMaterials = materials.where((material) {
          final currentStock = material['current_stock'] ?? 0.0;
          final minStock = material['min_stock'] ?? 0.0;
          final maxStock = material['max_stock'];
          
          // Si pas de stock max défini, commander quand en dessous du min
          if (maxStock == null) {
            return currentStock <= minStock;
          }
          
          // Sinon, commander quand en dessous du min ou proche du max
          return currentStock <= minStock || currentStock <= (maxStock * 0.2);
        }).toList();

        return {
          'success': true,
          'data': {
            'data': needOrderMaterials,
            'total': needOrderMaterials.length,
            'need_order_count': needOrderMaterials.length,
          }
        };
      }
      
      return lowStockMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les matériaux par période de création
  Future<Map<String, dynamic>> getMaterialsByCreationPeriod({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allMaterials = await getMaterials(perPage: perPage);
      
      if (allMaterials['success'] == true && allMaterials['data']['data'] != null) {
        final materials = allMaterials['data']['data'] as List;
        
        final periodMaterials = materials.where((material) {
          final createdAt = DateTime.parse(material['created_at']);
          
          if (startDate != null && createdAt.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && createdAt.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': periodMaterials,
            'total': periodMaterials.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'period_count': periodMaterials.length,
          }
        };
      }
      
      return allMaterials;
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter du stock à un matériau
  Future<Map<String, dynamic>> addStock(int materialId, double quantity) async {
    return await updateMaterialStock(materialId, quantity: quantity, operation: 'add');
  }

  // Retirer du stock d'un matériau
  Future<Map<String, dynamic>> subtractStock(int materialId, double quantity) async {
    return await updateMaterialStock(materialId, quantity: quantity, operation: 'subtract');
  }

  // Vérifier si un matériau est en stock faible
  Future<bool> isLowStock(int materialId) async {
    try {
      final material = await getMaterial(materialId);
      
      if (material['success'] == true) {
        final data = material['data'];
        final currentStock = data['current_stock'] ?? 0.0;
        final minStock = data['min_stock'] ?? 0.0;
        
        return currentStock <= minStock;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un matériau est en rupture de stock
  Future<bool> isOutOfStock(int materialId) async {
    try {
      final material = await getMaterial(materialId);
      
      if (material['success'] == true) {
        final data = material['data'];
        final currentStock = data['current_stock'] ?? 0.0;
        
        return currentStock <= 0;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Calculer la valeur totale du stock d'un matériau
  Future<double> getMaterialStockValue(int materialId) async {
    try {
      final material = await getMaterial(materialId);
      
      if (material['success'] == true) {
        final data = material['data'];
        final currentStock = data['current_stock'] ?? 0.0;
        final unitPrice = data['unit_price'] ?? 0.0;
        
        return currentStock * unitPrice;
      }
      
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

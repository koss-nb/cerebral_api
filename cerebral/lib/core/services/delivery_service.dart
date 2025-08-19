import 'api_service.dart';

class DeliveryService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir toutes les livraisons avec filtres et pagination
  Future<Map<String, dynamic>> getDeliveries({
    String? status,
    int? projectId,
    int? perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/deliveries$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer une nouvelle livraison
  Future<Map<String, dynamic>> createDelivery({
    required String title,
    String? description,
    int? projectId,
    required String supplier,
    String? supplierContact,
    required DateTime expectedDate,
    String? notes,
    List<Map<String, dynamic>>? materials,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'supplier': supplier,
        'expected_date': expectedDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      };

      if (description != null) {
        data['description'] = description;
      }
      
      if (projectId != null) {
        data['project_id'] = projectId;
      }
      
      if (supplierContact != null) {
        data['supplier_contact'] = supplierContact;
      }
      
      if (notes != null) {
        data['notes'] = notes;
      }
      
      if (materials != null) {
        data['materials'] = materials;
      }

      return await _apiService.post('/deliveries', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir une livraison spécifique
  Future<Map<String, dynamic>> getDelivery(int deliveryId) async {
    try {
      return await _apiService.get('/deliveries/$deliveryId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une livraison
  Future<Map<String, dynamic>> updateDelivery(
    int deliveryId, {
    String? title,
    String? description,
    int? projectId,
    String? supplier,
    String? supplierContact,
    DateTime? expectedDate,
    String? status,
    String? notes,
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
      
      if (supplier != null) {
        data['supplier'] = supplier;
      }
      
      if (supplierContact != null) {
        data['supplier_contact'] = supplierContact;
      }
      
      if (expectedDate != null) {
        data['expected_date'] = expectedDate.toIso8601String().split('T')[0];
      }
      
      if (status != null) {
        data['status'] = status;
      }
      
      if (notes != null) {
        data['notes'] = notes;
      }

      return await _apiService.put('/deliveries/$deliveryId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer une livraison
  Future<Map<String, dynamic>> deleteDelivery(int deliveryId) async {
    try {
      return await _apiService.delete('/deliveries/$deliveryId');
    } catch (e) {
      rethrow;
    }
  }

  // Réceptionner une livraison
  Future<Map<String, dynamic>> receiveDelivery(
    int deliveryId, {
    required List<Map<String, dynamic>> receivedMaterials,
  }) async {
    try {
      final data = <String, dynamic>{
        'received_materials': receivedMaterials,
      };

      return await _apiService.post('/deliveries/$deliveryId/receive', data);
    } catch (e) {
      rethrow;
    }
  }

  // Confirmer une livraison
  Future<Map<String, dynamic>> confirmDelivery(int deliveryId) async {
    try {
      return await _apiService.post('/deliveries/$deliveryId/confirm', {});
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons à venir
  Future<Map<String, dynamic>> getUpcomingDeliveries() async {
    try {
      return await _apiService.get('/deliveries/upcoming');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les livraisons

  // Obtenir les livraisons en attente
  Future<Map<String, dynamic>> getPendingDeliveries({int? perPage}) async {
    return await getDeliveries(status: 'pending', perPage: perPage);
  }

  // Obtenir les livraisons confirmées
  Future<Map<String, dynamic>> getConfirmedDeliveries({int? perPage}) async {
    return await getDeliveries(status: 'confirmed', perPage: perPage);
  }

  // Obtenir les livraisons en transit
  Future<Map<String, dynamic>> getInTransitDeliveries({int? perPage}) async {
    return await getDeliveries(status: 'in_transit', perPage: perPage);
  }

  // Obtenir les livraisons livrées
  Future<Map<String, dynamic>> getDeliveredDeliveries({int? perPage}) async {
    return await getDeliveries(status: 'delivered', perPage: perPage);
  }

  // Obtenir les livraisons annulées
  Future<Map<String, dynamic>> getCancelledDeliveries({int? perPage}) async {
    return await getDeliveries(status: 'cancelled', perPage: perPage);
  }

  // Obtenir les livraisons d'un projet spécifique
  Future<Map<String, dynamic>> getDeliveriesByProject(int projectId, {int? perPage}) async {
    return await getDeliveries(projectId: projectId, perPage: perPage);
  }

  // Obtenir les livraisons en retard (date prévue dépassée)
  Future<Map<String, dynamic>> getOverdueDeliveries({int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final now = DateTime.now();
        
        final overdueDeliveries = deliveries.where((delivery) {
          final expectedDate = DateTime.parse(delivery['expected_date']);
          final status = delivery['status'];
          return expectedDate.isBefore(now) && 
                 status != 'delivered' && 
                 status != 'cancelled';
        }).toList();

        return {
          'success': true,
          'data': {
            'data': overdueDeliveries,
            'total': overdueDeliveries.length,
            'overdue_count': overdueDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons du jour
  Future<Map<String, dynamic>> getTodayDeliveries({int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final today = DateTime.now();
        final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        
        final todayDeliveries = deliveries.where((delivery) {
          return delivery['expected_date'] == todayString;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': todayDeliveries,
            'total': todayDeliveries.length,
            'today_count': todayDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons de la semaine
  Future<Map<String, dynamic>> getWeekDeliveries({int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final now = DateTime.now();
        final weekFromNow = now.add(Duration(days: 7));
        
        final weekDeliveries = deliveries.where((delivery) {
          final expectedDate = DateTime.parse(delivery['expected_date']);
          return expectedDate.isAfter(now) && expectedDate.isBefore(weekFromNow);
        }).toList();

        return {
          'success': true,
          'data': {
            'data': weekDeliveries,
            'total': weekDeliveries.length,
            'week_count': weekDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons du mois
  Future<Map<String, dynamic>> getMonthDeliveries({int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final now = DateTime.now();
        final monthFromNow = DateTime(now.year, now.month + 1, now.day);
        
        final monthDeliveries = deliveries.where((delivery) {
          final expectedDate = DateTime.parse(delivery['expected_date']);
          return expectedDate.isAfter(now) && expectedDate.isBefore(monthFromNow);
        }).toList();

        return {
          'success': true,
          'data': {
            'data': monthDeliveries,
            'total': monthDeliveries.length,
            'month_count': monthDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des livraisons
  Future<Map<String, dynamic>> getDeliveryStats() async {
    try {
      final allDeliveries = await getDeliveries(perPage: 1000); // Récupérer toutes pour les stats
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final now = DateTime.now();
        
        int pending = 0;
        int confirmed = 0;
        int inTransit = 0;
        int delivered = 0;
        int cancelled = 0;
        int overdue = 0;
        int today = 0;
        int thisWeek = 0;
        int thisMonth = 0;
        
        for (final delivery in deliveries) {
          final status = delivery['status'];
          final expectedDate = DateTime.parse(delivery['expected_date']);
          
          // Compter par statut
          switch (status) {
            case 'pending':
              pending++;
              break;
            case 'confirmed':
              confirmed++;
              break;
            case 'in_transit':
              inTransit++;
              break;
            case 'delivered':
              delivered++;
              break;
            case 'cancelled':
              cancelled++;
              break;
          }
          
          // Compter les livraisons en retard
          if (expectedDate.isBefore(now) && status != 'delivered' && status != 'cancelled') {
            overdue++;
          }
          
          // Compter les livraisons du jour
          if (expectedDate.year == now.year && 
              expectedDate.month == now.month && 
              expectedDate.day == now.day) {
            today++;
          }
          
          // Compter les livraisons de la semaine
          final weekFromNow = now.add(Duration(days: 7));
          if (expectedDate.isAfter(now) && expectedDate.isBefore(weekFromNow)) {
            thisWeek++;
          }
          
          // Compter les livraisons du mois
          final monthFromNow = DateTime(now.year, now.month + 1, now.day);
          if (expectedDate.isAfter(now) && expectedDate.isBefore(monthFromNow)) {
            thisMonth++;
          }
        }

        return {
          'success': true,
          'data': {
            'total': deliveries.length,
            'by_status': {
              'pending': pending,
              'confirmed': confirmed,
              'in_transit': inTransit,
              'delivered': delivered,
              'cancelled': cancelled,
            },
            'overdue': overdue,
            'today': today,
            'this_week': thisWeek,
            'this_month': thisMonth,
            'delivery_rate': deliveries.isNotEmpty ? (delivered / deliveries.length * 100).roundToDouble() : 0.0,
            'overdue_rate': deliveries.isNotEmpty ? (overdue / deliveries.length * 100).roundToDouble() : 0.0,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des livraisons par titre ou description
  Future<Map<String, dynamic>> searchDeliveries(String searchQuery, {int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        final query = searchQuery.toLowerCase();
        
        final searchResults = deliveries.where((delivery) {
          final title = delivery['title']?.toString().toLowerCase() ?? '';
          final description = delivery['description']?.toString().toLowerCase() ?? '';
          final supplier = delivery['supplier']?.toString().toLowerCase() ?? '';
          
          return title.contains(query) || 
                 description.contains(query) || 
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
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons par fournisseur
  Future<Map<String, dynamic>> getDeliveriesBySupplier(String supplier, {int? perPage}) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        
        final supplierDeliveries = deliveries.where((delivery) {
          return delivery['supplier']?.toString().toLowerCase() == supplier.toLowerCase();
        }).toList();

        return {
          'success': true,
          'data': {
            'data': supplierDeliveries,
            'total': supplierDeliveries.length,
            'supplier': supplier,
            'supplier_count': supplierDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les livraisons par période
  Future<Map<String, dynamic>> getDeliveriesByPeriod({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allDeliveries = await getDeliveries(perPage: perPage);
      
      if (allDeliveries['success'] == true && allDeliveries['data']['data'] != null) {
        final deliveries = allDeliveries['data']['data'] as List;
        
        final periodDeliveries = deliveries.where((delivery) {
          final expectedDate = DateTime.parse(delivery['expected_date']);
          
          if (startDate != null && expectedDate.isBefore(startDate)) {
            return false;
          }
          
          if (endDate != null && expectedDate.isAfter(endDate)) {
            return false;
          }
          
          return true;
        }).toList();

        return {
          'success': true,
          'data': {
            'data': periodDeliveries,
            'total': periodDeliveries.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'period_count': periodDeliveries.length,
          }
        };
      }
      
      return allDeliveries;
    } catch (e) {
      rethrow;
    }
  }
}

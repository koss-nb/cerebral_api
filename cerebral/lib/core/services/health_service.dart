import 'api_service.dart';

class HealthService {
  final ApiService _apiService = ApiService.instance;

  // Vérifier la santé de l'API
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      return await _apiService.get('/health');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour analyser la santé

  // Vérifier si l'API est en bonne santé
  Future<bool> isHealthy() async {
    try {
      final health = await checkHealth();
      return health['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  // Vérifier si l'API est en mauvaise santé
  Future<bool> isUnhealthy() async {
    try {
      final health = await checkHealth();
      return health['status'] == 'unhealthy';
    } catch (e) {
      return true; // Si on ne peut pas vérifier, on considère comme malsain
    }
  }

  // Obtenir le statut de la base de données
  Future<Map<String, dynamic>?> getDatabaseStatus() async {
    try {
      final health = await checkHealth();
      
      if (health['database'] != null) {
        return Map<String, dynamic>.from(health['database']);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si la base de données est connectée
  Future<bool> isDatabaseConnected() async {
    try {
      final dbStatus = await getDatabaseStatus();
      return dbStatus?['status'] == 'healthy' && dbStatus?['connection'] == 'connected';
    } catch (e) {
      return false;
    }
  }

  // Obtenir le temps de réponse de la base de données
  Future<double?> getDatabaseQueryTime() async {
    try {
      final dbStatus = await getDatabaseStatus();
      return dbStatus?['query_time_ms']?.toDouble();
    } catch (e) {
      return null;
    }
  }

  // Obtenir le statut du cache
  Future<Map<String, dynamic>?> getCacheStatus() async {
    try {
      final health = await checkHealth();
      
      if (health['cache'] != null) {
        return Map<String, dynamic>.from(health['cache']);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si le cache fonctionne
  Future<bool> isCacheWorking() async {
    try {
      final cacheStatus = await getCacheStatus();
      return cacheStatus?['status'] == 'healthy' && cacheStatus?['test'] == 'passed';
    } catch (e) {
      return false;
    }
  }

  // Obtenir le driver du cache
  Future<String?> getCacheDriver() async {
    try {
      final cacheStatus = await getCacheStatus();
      return cacheStatus?['driver'];
    } catch (e) {
      return null;
    }
  }

  // Obtenir le statut du stockage
  Future<Map<String, dynamic>?> getStorageStatus() async {
    try {
      final health = await checkHealth();
      
      if (health['storage'] != null) {
        return Map<String, dynamic>.from(health['storage']);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si le stockage est accessible en écriture
  Future<bool> isStorageWritable() async {
    try {
      final storageStatus = await getStorageStatus();
      return storageStatus?['status'] == 'healthy' && storageStatus?['writable'] == 'yes';
    } catch (e) {
      return false;
    }
  }

  // Obtenir le driver du stockage
  Future<String?> getStorageDriver() async {
    try {
      final storageStatus = await getStorageStatus();
      return storageStatus?['driver'];
    } catch (e) {
      return null;
    }
  }

  // Obtenir la version de l'API
  Future<String?> getApiVersion() async {
    try {
      final health = await checkHealth();
      return health['version'];
    } catch (e) {
      return null;
    }
  }

  // Obtenir le timestamp de la vérification
  Future<String?> getHealthTimestamp() async {
    try {
      final health = await checkHealth();
      return health['timestamp'];
    } catch (e) {
      return null;
    }
  }

  // Obtenir un résumé de la santé
  Future<Map<String, dynamic>?> getHealthSummary() async {
    try {
      final health = await checkHealth();
      
      return {
        'overall_status': health['status'],
        'timestamp': health['timestamp'],
        'version': health['version'],
        'database': {
          'status': health['database']?['status'],
          'connected': health['database']?['connection'] == 'connected',
          'query_time_ms': health['database']?['query_time_ms'],
        },
        'cache': {
          'status': health['database']?['status'],
          'working': health['cache']?['test'] == 'passed',
          'driver': health['cache']?['driver'],
        },
        'storage': {
          'status': health['storage']?['status'],
          'writable': health['storage']?['writable'] == 'yes',
          'driver': health['storage']?['driver'],
        },
      };
    } catch (e) {
      return null;
    }
  }

  // Vérifier la connectivité générale
  Future<bool> checkConnectivity() async {
    try {
      await checkHealth();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir les erreurs de santé
  Future<List<String>> getHealthErrors() async {
    try {
      final health = await checkHealth();
      final errors = <String>[];
      
      // Vérifier la base de données
      if (health['database']?['status'] == 'error') {
        errors.add('Base de données: ${health['database']['error']}');
      }
      
      // Vérifier le cache
      if (health['cache']?['status'] == 'error') {
        errors.add('Cache: ${health['cache']['error']}');
      }
      
      // Vérifier le stockage
      if (health['storage']?['status'] == 'error') {
        errors.add('Stockage: ${health['storage']['error']}');
      }
      
      return errors;
    } catch (e) {
      return ['Impossible de vérifier la santé de l\'API: $e'];
    }
  }

  // Vérifier si tous les services sont opérationnels
  Future<bool> areAllServicesOperational() async {
    try {
      final health = await checkHealth();
      
      return health['database']?['status'] == 'healthy' &&
             health['cache']?['status'] == 'healthy' &&
             health['storage']?['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  // Obtenir le statut détaillé de chaque service
  Future<Map<String, Map<String, dynamic>>> getDetailedServiceStatus() async {
    try {
      final health = await checkHealth();
      
      return {
        'database': Map<String, dynamic>.from(health['database'] ?? {}),
        'cache': Map<String, dynamic>.from(health['cache'] ?? {}),
        'storage': Map<String, dynamic>.from(health['storage'] ?? {}),
      };
    } catch (e) {
      return {};
    }
  }

  // Vérifier la performance de l'API
  Future<Map<String, dynamic>?> getPerformanceMetrics() async {
    try {
      final health = await checkHealth();
      
      return {
        'database_query_time_ms': health['database']?['query_time_ms'],
        'response_time_ms': null, // Non disponible dans le contrôleur actuel
        'timestamp': health['timestamp'],
      };
    } catch (e) {
      return null;
    }
  }

  // Vérifier la santé en temps réel (avec timeout)
  Future<Map<String, dynamic>> checkHealthWithTimeout({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      // Implémenter un timeout personnalisé si nécessaire
      return await checkHealth();
    } catch (e) {
      return {
        'status': 'timeout',
        'error': 'Vérification de santé expirée après ${timeout.inSeconds} secondes',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Vérifier la santé de services spécifiques
  Future<Map<String, bool>> checkSpecificServices({List<String> services = const ['database', 'cache', 'storage']}) async {
    try {
      final health = await checkHealth();
      final results = <String, bool>{};
      
      for (final service in services) {
        if (health[service] != null) {
          results[service] = health[service]['status'] == 'healthy';
        } else {
          results[service] = false;
        }
      }
      
      return results;
    } catch (e) {
      return Map.fromEntries(services.map((s) => MapEntry(s, false)));
    }
  }

  // Obtenir un rapport de santé complet
  Future<Map<String, dynamic>> getCompleteHealthReport() async {
    try {
      final health = await checkHealth();
      final errors = await getHealthErrors();
      final allServicesOperational = await areAllServicesOperational();
      final performanceMetrics = await getPerformanceMetrics();
      
      return {
        'summary': {
          'overall_status': health['status'],
          'all_services_operational': allServicesOperational,
          'total_errors': errors.length,
          'timestamp': health['timestamp'],
          'version': health['version'],
        },
        'services': await getDetailedServiceStatus(),
        'errors': errors,
        'performance': performanceMetrics,
        'recommendations': _generateRecommendations(health, errors),
      };
    } catch (e) {
      return {
        'summary': {
          'overall_status': 'unknown',
          'all_services_operational': false,
          'total_errors': 1,
          'timestamp': DateTime.now().toIso8601String(),
          'version': 'unknown',
        },
        'services': {},
        'errors': ['Impossible de générer le rapport: $e'],
        'performance': null,
        'recommendations': ['Vérifier la connectivité réseau et l\'état du serveur'],
      };
    }
  }

  // Générer des recommandations basées sur l'état de santé
  List<String> _generateRecommendations(Map<String, dynamic> health, List<String> errors) {
    final recommendations = <String>[];
    
    if (errors.isNotEmpty) {
      recommendations.add('Résoudre les erreurs identifiées avant de continuer');
    }
    
    if (health['database']?['status'] == 'error') {
      recommendations.add('Vérifier la connexion à la base de données et les permissions');
    }
    
    if (health['cache']?['status'] == 'error') {
      recommendations.add('Vérifier la configuration du cache et l\'espace disque');
    }
    
    if (health['storage']?['status'] == 'error') {
      recommendations.add('Vérifier les permissions d\'écriture du stockage');
    }
    
    if (health['database']?['query_time_ms'] != null && 
        health['database']['query_time_ms'] > 100) {
      recommendations.add('Optimiser les requêtes de base de données (temps de réponse élevé)');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Tous les services fonctionnent correctement');
    }
    
    return recommendations;
  }
}

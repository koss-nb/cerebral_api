import 'health_service.dart';

/// Exemple d'utilisation du service de santé
/// Basé sur le HealthController Laravel
class HealthExample {
  final HealthService _healthService = HealthService();

  /// Exemple de vérification de la santé de l'API
  Future<void> checkHealthExample() async {
    try {
      print('🏥 Vérification de la santé de l\'API...');
      
      final health = await _healthService.checkHealth();

      print('✅ Vérification de santé terminée !');
      print('   Statut global: ${health['status']}');
      print('   Timestamp: ${health['timestamp']}');
      print('   Version: ${health['version']}');
      
      print('\n🏥 BASE DE DONNÉES:');
      print('   Statut: ${health['database']['status']}');
      print('   Connexion: ${health['database']['connection']}');
      if (health['database']['query_time_ms'] != null) {
        print('   Temps de requête: ${health['database']['query_time_ms']} ms');
      }
      
      print('\n🏥 CACHE:');
      print('   Statut: ${health['cache']['status']}');
      print('   Driver: ${health['cache']['driver']}');
      print('   Test: ${health['cache']['test']}');
      
      print('\n🏥 STOCKAGE:');
      print('   Statut: ${health['storage']['status']}');
      print('   Driver: ${health['storage']['driver']}');
      print('   Accessible en écriture: ${health['storage']['writable']}');

    } catch (e) {
      print('❌ Erreur lors de la vérification de santé: $e');
    }
  }

  /// Exemple de vérification du statut global
  Future<void> checkOverallStatusExample() async {
    try {
      print('🔍 Vérification du statut global...');
      
      final isHealthy = await _healthService.isHealthy();
      final isUnhealthy = await _healthService.isUnhealthy();
      
      print('✅ Statut global vérifié !');
      print('   API en bonne santé: ${isHealthy ? 'Oui' : 'Non'}');
      print('   API en mauvaise santé: ${isUnhealthy ? 'Oui' : 'Non'}');
      
      if (isHealthy) {
        print('   🟢 L\'API fonctionne correctement');
      } else if (isUnhealthy) {
        print('   🔴 L\'API a des problèmes');
      } else {
        print('   🟡 Impossible de déterminer le statut');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification du statut: $e');
    }
  }

  /// Exemple de vérification de la base de données
  Future<void> checkDatabaseExample() async {
    try {
      print('🗄️ Vérification de la base de données...');
      
      final dbStatus = await _healthService.getDatabaseStatus();
      final isConnected = await _healthService.isDatabaseConnected();
      final queryTime = await _healthService.getDatabaseQueryTime();
      
      print('✅ Base de données vérifiée !');
      
      if (dbStatus != null) {
        print('   Statut: ${dbStatus['status']}');
        print('   Connexion: ${dbStatus['connection']}');
        if (dbStatus['query_time_ms'] != null) {
          print('   Temps de requête: ${dbStatus['query_time_ms']} ms');
        }
      }
      
      print('   Connectée: ${isConnected ? 'Oui' : 'Non'}');
      
      if (queryTime != null) {
        print('   Temps de réponse: ${queryTime.toStringAsFixed(2)} ms');
        
        if (queryTime < 50) {
          print('   🟢 Performance excellente');
        } else if (queryTime < 100) {
          print('   🟡 Performance correcte');
        } else {
          print('   🔴 Performance lente - optimisation recommandée');
        }
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification de la base de données: $e');
    }
  }

  /// Exemple de vérification du cache
  Future<void> checkCacheExample() async {
    try {
      print('💾 Vérification du cache...');
      
      final cacheStatus = await _healthService.getCacheStatus();
      final isWorking = await _healthService.isCacheWorking();
      final driver = await _healthService.getCacheDriver();
      
      print('✅ Cache vérifié !');
      
      if (cacheStatus != null) {
        print('   Statut: ${cacheStatus['status']}');
        print('   Driver: ${cacheStatus['driver']}');
        print('   Test: ${cacheStatus['test']}');
      }
      
      print('   Fonctionne: ${isWorking ? 'Oui' : 'Non'}');
      print('   Driver: $driver');
      
      if (isWorking) {
        print('   🟢 Le cache fonctionne correctement');
      } else {
        print('   🔴 Le cache a des problèmes');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification du cache: $e');
    }
  }

  /// Exemple de vérification du stockage
  Future<void> checkStorageExample() async {
    try {
      print('💿 Vérification du stockage...');
      
      final storageStatus = await _healthService.getStorageStatus();
      final isWritable = await _healthService.isStorageWritable();
      final driver = await _healthService.getStorageDriver();
      
      print('✅ Stockage vérifié !');
      
      if (storageStatus != null) {
        print('   Statut: ${storageStatus['status']}');
        print('   Driver: ${storageStatus['driver']}');
        print('   Accessible en écriture: ${storageStatus['writable']}');
      }
      
      print('   Accessible en écriture: ${isWritable ? 'Oui' : 'Non'}');
      print('   Driver: $driver');
      
      if (isWritable) {
        print('   🟢 Le stockage est accessible en écriture');
      } else {
        print('   🔴 Le stockage n\'est pas accessible en écriture');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification du stockage: $e');
    }
  }

  /// Exemple de récupération des informations de l'API
  Future<void> getApiInfoExample() async {
    try {
      print('ℹ️ Récupération des informations de l\'API...');
      
      final version = await _healthService.getApiVersion();
      final timestamp = await _healthService.getHealthTimestamp();
      
      print('✅ Informations de l\'API récupérées !');
      print('   Version: $version');
      print('   Timestamp: $timestamp');

    } catch (e) {
      print('❌ Erreur lors de la récupération des informations: $e');
    }
  }

  /// Exemple de récupération du résumé de santé
  Future<void> getHealthSummaryExample() async {
    try {
      print('📋 Récupération du résumé de santé...');
      
      final summary = await _healthService.getHealthSummary();

      print('✅ Résumé de santé récupéré !');
      
      if (summary != null) {
        print('   Statut global: ${summary['overall_status']}');
        print('   Timestamp: ${summary['timestamp']}');
        print('   Version: ${summary['version']}');
        
        print('\n📋 BASE DE DONNÉES:');
        print('   Statut: ${summary['database']['status']}');
        print('   Connectée: ${summary['database']['connected'] ? 'Oui' : 'Non'}');
        if (summary['database']['query_time_ms'] != null) {
          print('   Temps de requête: ${summary['database']['query_time_ms']} ms');
        }
        
        print('\n📋 CACHE:');
        print('   Statut: ${summary['cache']['status']}');
        print('   Fonctionne: ${summary['cache']['working'] ? 'Oui' : 'Non'}');
        print('   Driver: ${summary['cache']['driver']}');
        
        print('\n📋 STOCKAGE:');
        print('   Statut: ${summary['storage']['status']}');
        print('   Accessible en écriture: ${summary['storage']['writable'] ? 'Oui' : 'Non'}');
        print('   Driver: ${summary['storage']['driver']}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération du résumé: $e');
    }
  }

  /// Exemple de vérification de la connectivité
  Future<void> checkConnectivityExample() async {
    try {
      print('🌐 Vérification de la connectivité...');
      
      final isConnected = await _healthService.checkConnectivity();
      
      print('✅ Connectivité vérifiée !');
      print('   Connecté à l\'API: ${isConnected ? 'Oui' : 'Non'}');
      
      if (isConnected) {
        print('   🟢 La connexion à l\'API fonctionne');
      } else {
        print('   🔴 Impossible de se connecter à l\'API');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification de la connectivité: $e');
    }
  }

  /// Exemple de récupération des erreurs de santé
  Future<void> getHealthErrorsExample() async {
    try {
      print('⚠️ Récupération des erreurs de santé...');
      
      final errors = await _healthService.getHealthErrors();
      
      print('✅ Erreurs de santé récupérées !');
      print('   Nombre d\'erreurs: ${errors.length}');
      
      if (errors.isNotEmpty) {
        print('\n⚠️ ERREURS DÉTECTÉES:');
        for (final error in errors) {
          print('   • $error');
        }
      } else {
        print('   🟢 Aucune erreur détectée');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des erreurs: $e');
    }
  }

  /// Exemple de vérification de tous les services
  Future<void> checkAllServicesExample() async {
    try {
      print('🔧 Vérification de tous les services...');
      
      final allOperational = await _healthService.areAllServicesOperational();
      final serviceStatus = await _healthService.getDetailedServiceStatus();
      
      print('✅ Tous les services vérifiés !');
      print('   Tous opérationnels: ${allOperational ? 'Oui' : 'Non'}');
      
      print('\n🔧 STATUT DÉTAILLÉ DES SERVICES:');
      for (final entry in serviceStatus.entries) {
        final service = entry.key;
        final status = entry.value;
        
        print('   $service:');
        print('     Statut: ${status['status']}');
        
        if (service == 'database') {
          print('     Connexion: ${status['connection']}');
          if (status['query_time_ms'] != null) {
            print('     Temps de requête: ${status['query_time_ms']} ms');
          }
        } else if (service == 'cache') {
          print('     Driver: ${status['driver']}');
          print('     Test: ${status['test']}');
        } else if (service == 'storage') {
          print('     Driver: ${status['driver']}');
          print('     Accessible en écriture: ${status['writable']}');
        }
        
        if (status['error'] != null) {
          print('     Erreur: ${status['error']}');
        }
        print('');
      }
      
      if (allOperational) {
        print('   🟢 Tous les services fonctionnent correctement');
      } else {
        print('   🔴 Certains services ont des problèmes');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification des services: $e');
    }
  }

  /// Exemple de récupération des métriques de performance
  Future<void> getPerformanceMetricsExample() async {
    try {
      print('⚡ Récupération des métriques de performance...');
      
      final metrics = await _healthService.getPerformanceMetrics();
      
      print('✅ Métriques de performance récupérées !');
      
      if (metrics != null) {
        print('   Temps de requête DB: ${metrics['database_query_time_ms']} ms');
        print('   Temps de réponse API: ${metrics['response_time_ms'] ?? 'Non disponible'} ms');
        print('   Timestamp: ${metrics['timestamp']}');
        
        final dbTime = metrics['database_query_time_ms'];
        if (dbTime != null) {
          if (dbTime < 50) {
            print('   🟢 Performance de la base de données excellente');
          } else if (dbTime < 100) {
            print('   🟡 Performance de la base de données correcte');
          } else {
            print('   🔴 Performance de la base de données lente');
          }
        }
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des métriques: $e');
    }
  }

  /// Exemple de vérification de services spécifiques
  Future<void> checkSpecificServicesExample() async {
    try {
      print('🎯 Vérification de services spécifiques...');
      
      final results = await _healthService.checkSpecificServices(
        services: ['database', 'cache'],
      );
      
      print('✅ Services spécifiques vérifiés !');
      
      for (final entry in results.entries) {
        final service = entry.key;
        final isHealthy = entry.value;
        
        print('   $service: ${isHealthy ? '🟢 Sain' : '🔴 Problème'}');
      }

    } catch (e) {
      print('❌ Erreur lors de la vérification des services spécifiques: $e');
    }
  }

  /// Exemple de rapport de santé complet
  Future<void> getCompleteHealthReportExample() async {
    try {
      print('📊 Génération du rapport de santé complet...');
      
      final report = await _healthService.getCompleteHealthReport();
      
      print('✅ Rapport de santé complet généré !');
      
      print('\n📊 RÉSUMÉ:');
      final summary = report['summary'];
      print('   Statut global: ${summary['overall_status']}');
      print('   Tous les services opérationnels: ${summary['all_services_operational'] ? 'Oui' : 'Non'}');
      print('   Total d\'erreurs: ${summary['total_errors']}');
      print('   Timestamp: ${summary['timestamp']}');
      print('   Version: ${summary['version']}');
      
      print('\n📊 SERVICES:');
      final services = report['services'];
      for (final entry in services.entries) {
        final service = entry.key;
        final status = entry.value;
        print('   $service: ${status['status']}');
      }
      
      print('\n📊 ERREURS:');
      final errors = report['errors'];
      if (errors.isNotEmpty) {
        for (final error in errors) {
          print('   • $error');
        }
      } else {
        print('   Aucune erreur');
      }
      
      print('\n📊 PERFORMANCE:');
      final performance = report['performance'];
      if (performance != null) {
        print('   Temps de requête DB: ${performance['database_query_time_ms']} ms');
        print('   Timestamp: ${performance['timestamp']}');
      }
      
      print('\n📊 RECOMMANDATIONS:');
      final recommendations = report['recommendations'];
      for (final recommendation in recommendations) {
        print('   • $recommendation');
      }

    } catch (e) {
      print('❌ Erreur lors de la génération du rapport: $e');
    }
  }

  /// Exemple complet d'utilisation du service de santé
  Future<void> completeHealthWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE DE SANTÉ ===\n');

      // 1. Vérification de santé complète
      await checkHealthExample();
      print('');

      // 2. Vérification du statut global
      await checkOverallStatusExample();
      print('');

      // 3. Vérification de la base de données
      await checkDatabaseExample();
      print('');

      // 4. Vérification du cache
      await checkCacheExample();
      print('');

      // 5. Vérification du stockage
      await checkStorageExample();
      print('');

      // 6. Récupération des informations de l'API
      await getApiInfoExample();
      print('');

      // 7. Récupération du résumé de santé
      await getHealthSummaryExample();
      print('');

      // 8. Vérification de la connectivité
      await checkConnectivityExample();
      print('');

      // 9. Récupération des erreurs
      await getHealthErrorsExample();
      print('');

      // 10. Vérification de tous les services
      await checkAllServicesExample();
      print('');

      // 11. Récupération des métriques de performance
      await getPerformanceMetricsExample();
      print('');

      // 12. Vérification de services spécifiques
      await checkSpecificServicesExample();
      print('');

      // 13. Rapport de santé complet
      await getCompleteHealthReportExample();
      print('');

      print('✅ Workflow du service de santé terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du service de santé: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler un tableau de bord de monitoring
      print('🏥 TABLEAU DE BORD DE MONITORING:');
      
      // Vérification rapide de la santé
      final isHealthy = await _healthService.isHealthy();
      print('📊 STATUT GLOBAL:');
      print('   API: ${isHealthy ? '🟢 Opérationnelle' : '🔴 Problèmes détectés'}');
      
      // Vérification des services
      final allOperational = await _healthService.areAllServicesOperational();
      print('\n🔧 SERVICES:');
      print('   Tous opérationnels: ${allOperational ? '🟢 Oui' : '🔴 Non'}');
      
      // Métriques de performance
      final performance = await _healthService.getPerformanceMetrics();
      if (performance != null) {
        print('\n⚡ PERFORMANCE:');
        print('   Temps de réponse DB: ${performance['database_query_time_ms']} ms');
      }
      
      // Erreurs actuelles
      final errors = await _healthService.getHealthErrors();
      print('\n⚠️ ERREURS:');
      print('   Nombre d\'erreurs: ${errors.length}');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service de santé
void main() async {
  final healthExample = HealthExample();
  
  // Exécuter le workflow complet
  await healthExample.completeHealthWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await healthExample.uiExample();
}

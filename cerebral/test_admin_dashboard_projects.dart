import 'package:flutter/material.dart';
import 'lib/core/services/dashboard_service.dart';

void main() async {
  // Test du chargement des projets dans le tableau de bord admin
  await testAdminDashboardProjects();
}

Future<void> testAdminDashboardProjects() async {
  try {
    print('=== Test du tableau de bord admin - Projets ===');

    final dashboardService = DashboardService();

    // 1. Test de récupération des statistiques générales
    print('\n1. 📊 Récupération des statistiques générales...');
    try {
      final stats = await dashboardService.getStats();
      print('✅ Statistiques récupérées: ${stats.length} éléments');
      print('Clés disponibles: ${stats.keys.toList()}');
    } catch (e) {
      print('⚠️ Statistiques non disponibles: $e');
    }

    // 2. Test de récupération des projets
    print('\n2. 📋 Récupération des projets...');
    try {
      final projectsData = await dashboardService.getProjects();
      print(
          '✅ Données des projets récupérées: ${projectsData.length} éléments');

      // Extraire la liste des projets
      List<dynamic> projects = [];
      if (projectsData['data'] != null) {
        projects = List<dynamic>.from(projectsData['data']);
      } else if (projectsData['projects'] != null) {
        projects = List<dynamic>.from(projectsData['projects']);
      }

      print('📊 Nombre de projets: ${projects.length}');

      if (projects.isNotEmpty) {
        print('\n3. 🔍 Détails des projets:');
        for (int i = 0; i < projects.length && i < 3; i++) {
          final project = projects[i];
          print('   Projet ${i + 1}:');
          print('     - Nom: ${project['name'] ?? 'N/A'}');
          print('     - Type: ${project['type'] ?? 'N/A'}');
          print('     - Statut: ${project['status'] ?? 'N/A'}');
          print('     - Progression: ${project['progress'] ?? 0}%');
          print(
              '     - Budget: ${project['budget'] ?? 'N/A'} ${project['currency'] ?? 'EUR'}');
          print('     - Localisation: ${project['location'] ?? 'N/A'}');
        }

        // 4. Calculs des statistiques
        print('\n4. 🧮 Calculs des statistiques:');

        // Nombre de projets par statut
        final statusCounts = <String, int>{};
        for (final project in projects) {
          final status = project['status']?.toString() ?? 'unknown';
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }
        print('   Répartition par statut: $statusCounts');

        // Budget total
        double totalBudget = 0.0;
        for (final project in projects) {
          if (project['budget'] != null) {
            totalBudget += (project['budget'] is int)
                ? (project['budget'] as int).toDouble()
                : (project['budget'] is double)
                    ? project['budget']
                    : double.tryParse(project['budget'].toString()) ?? 0.0;
          }
        }
        print('   Budget total: ${totalBudget.toStringAsFixed(0)}€');

        // Progression moyenne
        double totalProgress = 0.0;
        int projectsWithProgress = 0;
        for (final project in projects) {
          if (project['progress'] != null) {
            totalProgress += (project['progress'] is int)
                ? (project['progress'] as int).toDouble()
                : (project['progress'] is double)
                    ? project['progress']
                    : double.tryParse(project['progress'].toString()) ?? 0.0;
            projectsWithProgress++;
          }
        }
        if (projectsWithProgress > 0) {
          final avgProgress = totalProgress / projectsWithProgress;
          print('   Progression moyenne: ${avgProgress.toStringAsFixed(1)}%');
        }
      } else {
        print('⚠️ Aucun projet trouvé');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des projets: $e');
    }

    print('\n🎉 Test terminé avec succès!');
  } catch (e) {
    print('❌ Erreur lors du test: $e');

    // Afficher plus de détails sur l'erreur
    if (e.toString().contains('404')) {
      print('🔍 Erreur 404 - Endpoint non trouvé');
    } else if (e.toString().contains('500')) {
      print('🔍 Erreur 500 - Erreur serveur');
    } else if (e.toString().contains('timeout')) {
      print('🔍 Timeout - Serveur trop lent');
    }
  }
}

// Test des endpoints disponibles
void printAvailableEndpoints() {
  print('\n=== Endpoints disponibles ===');
  print('/dashboard/stats - Statistiques générales');
  print('/dashboard/projects - Données des projets');
  print('/dashboard/tasks - Données des tâches');
  print('/dashboard/personnel - Données du personnel');
  print('/dashboard/budgets - Données des budgets');
  print('/dashboard/workflows - Données des workflows');
  print('/dashboard/notifications - Notifications');
  print('/dashboard/alerts - Alertes et avertissements');
}

import 'package:flutter/material.dart';
import 'lib/core/services/project_service.dart';

void main() async {
  // Test des fonctionnalités de gestion des projets
  await testProjectManagementFeatures();
}

Future<void> testProjectManagementFeatures() async {
  try {
    print('=== Test des fonctionnalités de gestion des projets ===');
    
    final projectService = ProjectService();
    
    // 1. Test de récupération des projets
    print('\n1. 📋 Récupération des projets...');
    final projectsData = await projectService.getProjects();
    
    // Extraire la liste des projets de la réponse
    List<dynamic> projects = [];
    if (projectsData['data'] != null) {
      projects = List<dynamic>.from(projectsData['data']);
    } else if (projectsData['projects'] != null) {
      projects = List<dynamic>.from(projectsData['projects']);
    }
    
    print('✅ Projets récupérés: ${projects.length} projets');
    
    if (projects.isNotEmpty) {
      final firstProject = projects.first;
      final projectId = firstProject['id'];
      
      print('\n2. 🔍 Détails du premier projet...');
      print('ID: $projectId');
      print('Nom: ${firstProject['name']}');
      print('Type: ${firstProject['type']}');
      print('Statut: ${firstProject['status']}');
      print('Budget: ${firstProject['budget']} ${firstProject['currency']}');
      
      // 3. Test de mise à jour du projet
      print('\n3. ✏️ Test de mise à jour du projet...');
      final updatedProject = await projectService.updateProject(
        projectId,
        name: '${firstProject['name']} (Modifié)',
        description: 'Projet modifié pour test',
        progress: 25.0,
      );
      
      print('✅ Projet mis à jour avec succès!');
      print('Nouveau nom: ${updatedProject['name']}');
      print('Nouvelle progression: ${updatedProject['progress']}%');
      
      // 4. Test de récupération des statistiques
      print('\n4. 📊 Récupération des statistiques...');
      try {
        final stats = await projectService.getProjectStats(projectId);
        print('✅ Statistiques récupérées: $stats');
      } catch (e) {
        print('⚠️ Statistiques non disponibles: $e');
      }
      
      // 5. Test de mise à jour du progrès
      print('\n5. 📈 Mise à jour du progrès...');
      final progressUpdate = await projectService.updateProjectProgress(
        projectId,
        status: 'in_progress',
        progress: 50.0,
      );
      
      print('✅ Progrès mis à jour: ${progressUpdate['progress']}%');
      print('Nouveau statut: ${progressUpdate['status']}');
      
    } else {
      print('⚠️ Aucun projet trouvé pour les tests');
    }
    
    print('\n🎉 Tous les tests sont terminés avec succès!');
    
  } catch (e) {
    print('❌ Erreur lors des tests: $e');
    
    // Afficher plus de détails sur l'erreur
    if (e.toString().contains('404')) {
      print('🔍 Erreur 404 - Ressource non trouvée');
    } else if (e.toString().contains('422')) {
      print('🔍 Erreur 422 - Validation échouée');
    } else if (e.toString().contains('500')) {
      print('🔍 Erreur 500 - Erreur serveur');
    }
  }
}

// Test des valeurs valides pour les mises à jour
void printValidUpdateValues() {
  print('\n=== Valeurs valides pour les mises à jour ===');
  print('Types de projet: residential, commercial, industrial');
  print('Statuts: planning, in_progress, on_hold, completed, cancelled');
  print('Progression: 0.0 à 100.0');
  print('Budget: nombre positif');
}

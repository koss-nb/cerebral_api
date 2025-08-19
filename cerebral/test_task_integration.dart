import 'package:flutter/material.dart';
import 'lib/core/services/task_service.dart';
import 'lib/core/services/project_service.dart';

void main() async {
  // Test de l'intégration des tâches
  await testTaskIntegration();
}

Future<void> testTaskIntegration() async {
  try {
    print('=== Test de l\'intégration des tâches ===');
    
    final taskService = TaskService();
    final projectService = ProjectService();
    
    // 1. Test de récupération des projets
    print('\n1. 📋 Récupération des projets...');
    try {
      final projectsData = await projectService.getProjects();
      print('✅ Projets récupérés: ${projectsData.length} éléments');
      
      List<dynamic> projects = [];
      if (projectsData['data'] != null) {
        projects = List<dynamic>.from(projectsData['data']);
      } else if (projectsData['projects'] != null) {
        projects = List<dynamic>.from(projectsData['projects']);
      }
      
      print('📊 Nombre de projets: ${projects.length}');
      if (projects.isNotEmpty) {
        print('🔍 Premier projet: ${projects.first['name']}');
      }
    } catch (e) {
      print('❌ Erreur projets: $e');
    }
    
    // 2. Test de récupération des tâches
    print('\n2. 📝 Récupération des tâches...');
    try {
      final tasksData = await taskService.getTasks();
      print('✅ Tâches récupérées: ${tasksData.length} éléments');
      
      List<dynamic> tasks = [];
      if (tasksData['data'] != null) {
        tasks = List<dynamic>.from(tasksData['data']);
      } else if (tasksData['tasks'] != null) {
        tasks = List<dynamic>.from(tasksData['tasks']);
      }
      
      print('📊 Nombre de tâches: ${tasks.length}');
      if (tasks.isNotEmpty) {
        print('🔍 Première tâche: ${tasks.first['title']}');
        print('   - Projet ID: ${tasks.first['project_id']}');
        print('   - Statut: ${tasks.first['status']}');
        print('   - Priorité: ${tasks.first['priority']}');
        print('   - Date d\'échéance: ${tasks.first['due_date']}');
      }
    } catch (e) {
      print('❌ Erreur tâches: $e');
    }
    
    // 3. Test de création d'une tâche
    print('\n3. ✏️ Test de création de tâche...');
    try {
      final newTask = await taskService.createTask(
        title: 'Tâche de test API',
        description: 'Tâche créée pour tester l\'API',
        projectId: 1, // Assurez-vous que ce projet existe
        status: 'pending',
        priority: 'normal',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        estimatedHours: 8,
        notes: 'Tâche de test',
      );
      
      print('✅ Tâche créée avec succès!');
      print('   - ID: ${newTask['id']}');
      print('   - Titre: ${newTask['title']}');
      print('   - Statut: ${newTask['status']}');
      
    } catch (e) {
      print('❌ Erreur création: $e');
    }
    
    // 4. Test des filtres
    print('\n4. 🔍 Test des filtres...');
    try {
      final pendingTasks = await taskService.getTasks(status: 'pending');
      final highPriorityTasks = await taskService.getTasks(priority: 'high');
      
      print('✅ Filtres testés:');
      print('   - Tâches en attente: ${pendingTasks.length}');
      print('   - Tâches haute priorité: ${highPriorityTasks.length}');
      
    } catch (e) {
      print('❌ Erreur filtres: $e');
    }
    
    print('\n🎉 Test d\'intégration terminé!');
    
  } catch (e) {
    print('❌ Erreur générale: $e');
  }
}

// Test des structures de données attendues
void printExpectedDataStructures() {
  print('\n=== Structures de données attendues ===');
  
  print('\n📋 Projets:');
  print('GET /projects');
  print('{');
  print('  "data": [');
  print('    {');
  print('      "id": 1,');
  print('      "name": "Nom du projet",');
  print('      "type": "residential",');
  print('      "status": "in_progress"');
  print('    }');
  print('  ]');
  print('}');
  
  print('\n📝 Tâches:');
  print('GET /tasks');
  print('{');
  print('  "data": [');
  print('    {');
  print('      "id": 1,');
  print('      "title": "Titre de la tâche",');
  print('      "description": "Description",');
  print('      "project_id": 1,');
  print('      "status": "pending",');
  print('      "priority": "normal",');
  print('      "due_date": "2024-01-01T00:00:00.000Z",');
  print('      "assigned_to": 1,');
  print('      "estimated_hours": 8');
  print('    }');
  print('  ]');
  print('}');
}

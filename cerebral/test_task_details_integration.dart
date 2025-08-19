import 'package:flutter/material.dart';
import 'lib/core/services/task_service.dart';
import 'lib/core/services/project_service.dart';

void main() async {
  // Test de l'intégration de la page de détails des tâches
  await testTaskDetailsIntegration();
}

Future<void> testTaskDetailsIntegration() async {
  try {
    print('=== Test de l\'intégration de la page de détails des tâches ===');
    
    final taskService = TaskService();
    final projectService = ProjectService();
    
    // 1. Test de récupération d'une tâche spécifique
    print('\n1. 📝 Récupération d\'une tâche spécifique...');
    try {
      final taskData = await taskService.getTaskById(1); // Assurez-vous que cette tâche existe
      print('✅ Tâche récupérée: ${taskData.length} éléments');
      
      print('🔍 Détails de la tâche:');
      print('   - ID: ${taskData['id']}');
      print('   - Titre: ${taskData['title']}');
      print('   - Description: ${taskData['description']}');
      print('   - Statut: ${taskData['status']}');
      print('   - Priorité: ${taskData['priority']}');
      print('   - Projet ID: ${taskData['project_id']}');
      print('   - Assigné à: ${taskData['assigned_to']}');
      print('   - Date d\'échéance: ${taskData['due_date']}');
      print('   - Heures estimées: ${taskData['estimated_hours']}');
      print('   - Notes: ${taskData['notes']}');
      
    } catch (e) {
      print('❌ Erreur récupération tâche: $e');
    }
    
    // 2. Test de récupération du projet associé
    print('\n2. 📋 Récupération du projet associé...');
    try {
      final projectData = await projectService.getProjectById(1); // Assurez-vous que ce projet existe
      print('✅ Projet récupéré: ${projectData.length} éléments');
      
      print('🔍 Détails du projet:');
      print('   - ID: ${projectData['id']}');
      print('   - Nom: ${projectData['name']}');
      print('   - Type: ${projectData['type']}');
      print('   - Statut: ${projectData['status']}');
      print('   - Budget: ${projectData['budget']}');
      
    } catch (e) {
      print('❌ Erreur récupération projet: $e');
    }
    
    // 3. Test de mise à jour du statut d'une tâche
    print('\n3. ✏️ Test de mise à jour du statut...');
    try {
      final updatedTask = await taskService.updateTask(
        1, // ID de la tâche
        status: 'in_progress',
        notes: 'Statut mis à jour via test',
      );
      
      print('✅ Tâche mise à jour avec succès!');
      print('   - Nouveau statut: ${updatedTask['status']}');
      print('   - Notes: ${updatedTask['notes']}');
      
    } catch (e) {
      print('❌ Erreur mise à jour: $e');
    }
    
    // 4. Test des structures de données attendues
    print('\n4. 📊 Structures de données attendues...');
    printExpectedDataStructures();
    
    print('\n🎉 Test d\'intégration terminé!');
    
  } catch (e) {
    print('❌ Erreur générale: $e');
  }
}

// Test des structures de données attendues
void printExpectedDataStructures() {
  print('\n=== Structures de données attendues ===');
  
  print('\n📝 Tâche (GET /tasks/{id}):');
  print('{');
  print('  "id": 1,');
  print('  "title": "Titre de la tâche",');
  print('  "description": "Description détaillée",');
  print('  "project_id": 1,');
  print('  "status": "pending",');
  print('  "priority": "high",');
  print('  "due_date": "2024-01-15T00:00:00.000Z",');
  print('  "assigned_to": 1,');
  print('  "estimated_hours": 8,');
  print('  "actual_hours": 6,');
  print('  "notes": "Notes additionnelles",');
  print('  "created_at": "2024-01-01T00:00:00.000Z",');
  print('  "updated_at": "2024-01-10T00:00:00.000Z"');
  print('}');
  
  print('\n📋 Projet (GET /projects/{id}):');
  print('{');
  print('  "id": 1,');
  print('  "name": "Nom du projet",');
  print('  "type": "residential",');
  print('  "status": "in_progress",');
  print('  "budget": 50000,');
  print('  "start_date": "2024-01-01T00:00:00.000Z",');
  print('  "end_date": "2024-12-31T00:00:00.000Z"');
  print('}');
  
  print('\n✏️ Mise à jour tâche (PUT /tasks/{id}):');
  print('{');
  print('  "status": "in_progress",');
  print('  "notes": "Nouvelles notes"');
  print('}');
}

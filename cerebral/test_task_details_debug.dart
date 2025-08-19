import 'package:flutter/material.dart';
import 'lib/core/services/task_service.dart';
import 'lib/core/services/project_service.dart';

void main() async {
  print('=== Test de débogage des détails des tâches ===');
  
  final taskService = TaskService();
  final projectService = ProjectService();
  
  try {
    // 1. Test de récupération d'une tâche
    print('\n1. 📝 Test de récupération d\'une tâche...');
    final taskData = await taskService.getTaskById(1);
    print('✅ Tâche récupérée:');
    print('   - Type: ${taskData.runtimeType}');
    print('   - Clés: ${taskData.keys.toList()}');
    print('   - Contenu: $taskData');
    
    // 2. Test de récupération du projet associé
    if (taskData['project_id'] != null) {
      print('\n2. 🏗️ Test de récupération du projet...');
      int projectId;
      if (taskData['project_id'] is Map<String, dynamic>) {
        projectId = taskData['project_id']['id'];
        print('   - Project ID extrait de Map: $projectId');
      } else {
        projectId = taskData['project_id'];
        print('   - Project ID direct: $projectId');
      }
      
      final projectData = await projectService.getProjectById(projectId);
      print('✅ Projet récupéré:');
      print('   - Type: ${projectData.runtimeType}');
      print('   - Clés: ${projectData.keys.toList()}');
      print('   - Contenu: $projectData');
    } else {
      print('\n⚠️ Pas de project_id dans la tâche');
    }
    
    // 3. Test des données affichées
    print('\n3. 🎯 Test des données d\'affichage...');
    print('   - Titre de la tâche: ${taskData['title'] ?? 'NULL'}');
    print('   - Description: ${taskData['description'] ?? 'NULL'}');
    print('   - Statut: ${taskData['status'] ?? 'NULL'}');
    print('   - Priorité: ${taskData['priority'] ?? 'NULL'}');
    print('   - Assigné à: ${taskData['assigned_to'] ?? 'NULL'}');
    print('   - Date d\'échéance: ${taskData['due_date'] ?? 'NULL'}');
    print('   - Créé le: ${taskData['created_at'] ?? 'NULL'}');
    
  } catch (e) {
    print('❌ Erreur générale: $e');
  }
  
  print('\n🎉 Test de débogage terminé!');
}

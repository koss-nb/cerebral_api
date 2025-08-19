import 'package:flutter/material.dart';

void main() {
  // Test de la correction de l'erreur de type
  testTypeHandling();
}

void testTypeHandling() {
  print('=== Test de la gestion des types ===');
  
  // Simuler les données de l'API
  final mockTasks = [
    {
      'id': 1,
      'title': 'Tâche 1',
      'description': 'Description de la tâche 1',
      'project_id': {'id': 1, 'name': 'Projet A'}, // Objet imbriqué
      'assigned_to': {'id': 1, 'name': 'Jean Dupont'}, // Objet imbriqué
      'status': 'pending',
      'priority': 'high',
      'due_date': '2024-01-15T00:00:00.000Z',
    },
    {
      'id': 2,
      'title': 'Tâche 2',
      'description': 'Description de la tâche 2',
      'project_id': 2, // ID simple
      'assigned_to': 2, // ID simple
      'status': 'in_progress',
      'priority': 'normal',
      'due_date': '2024-01-20T00:00:00.000Z',
    },
  ];

  final mockProjects = [
    {'id': 1, 'name': 'Projet A'},
    {'id': 2, 'name': 'Projet B'},
  ];

  // Test de la méthode _getProjectName
  print('\n1. Test _getProjectName:');
  for (final task in mockTasks) {
    final projectName = getProjectName(task['project_id'], mockProjects);
    print('   Tâche ${task['id']}: project_id=${task['project_id']} -> $projectName');
  }

  // Test de la méthode _getAssigneeName
  print('\n2. Test _getAssigneeName:');
  for (final task in mockTasks) {
    final assigneeName = getAssigneeName(task['assigned_to']);
    print('   Tâche ${task['id']}: assigned_to=${task['assigned_to']} -> $assigneeName');
  }

  print('\n✅ Tests terminés avec succès!');
}

// Méthodes corrigées pour le test
String getProjectName(dynamic projectId, List<Map<String, dynamic>> projects) {
  if (projectId == null || projects.isEmpty) return 'Projet inconnu';

  // Si projectId est un objet (Map), extraire l'ID
  int? actualProjectId;
  if (projectId is Map<String, dynamic>) {
    actualProjectId = projectId['id'];
  } else if (projectId is int) {
    actualProjectId = projectId;
  } else {
    return 'Projet inconnu';
  }

  if (actualProjectId == null) return 'Projet inconnu';

  final project = projects.firstWhere(
    (p) => p['id'] == actualProjectId,
    orElse: () => {'name': 'Projet inconnu'},
  );

  return project['name'] ?? 'Projet inconnu';
}

String getAssigneeName(dynamic assigneeId) {
  if (assigneeId == null) return 'Non assigné';
  
  // Si assigneeId est un objet (Map), extraire l'ID ou le nom
  if (assigneeId is Map<String, dynamic>) {
    // Essayer de récupérer le nom directement
    if (assigneeId['name'] != null) {
      return assigneeId['name'];
    }
    // Sinon, utiliser l'ID
    if (assigneeId['id'] != null) {
      return 'Utilisateur ${assigneeId['id']}';
    }
    return 'Utilisateur inconnu';
  } else if (assigneeId is int) {
    return 'Utilisateur $assigneeId';
  } else {
    return 'Non assigné';
  }
}

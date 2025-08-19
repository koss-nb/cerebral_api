import 'package:flutter/material.dart';
import 'lib/core/services/project_service.dart';
import 'lib/core/services/auth_service.dart';

void main() async {
  // Test de création de projet avec les corrections
  await testProjectCreationFixed();
}

Future<void> testProjectCreationFixed() async {
  try {
    print('=== Test de création de projet (CORRIGÉ) ===');
    
    final projectService = ProjectService();
    final authService = AuthService();
    
    // Test de création de projet avec les bonnes valeurs
    final projectData = await projectService.createProject(
      name: 'Projet Test API Corrigé',
      type: 'residential', // Valeur valide selon l'API
      status: 'planning', // Valeur valide selon l'API
      priority: 'medium', // Valeur valide selon l'API
      clientName: 'Client Test',
      clientEmail: 'client@test.com',
      location: 'Paris, France',
      managerId: 1,
      description: 'Projet de test avec les bonnes valeurs',
      budget: 500000.0,
      currency: 'EUR',
      progress: 0.0,
      tags: ['nouveau projet'], // Tags valides
    );
    
    print('✅ Projet créé avec succès!');
    print('ID du projet: ${projectData['id']}');
    print('Nom: ${projectData['name']}');
    print('Statut: ${projectData['status']}');
    print('Type: ${projectData['type']}');
    
  } catch (e) {
    print('❌ Erreur lors du test: $e');
    
    // Afficher plus de détails sur l'erreur
    if (e.toString().contains('422')) {
      print('🔍 Erreur 422 - Validation échouée');
      print('Vérifiez que toutes les valeurs correspondent aux règles de validation de l\'API');
    }
  }
}

// Test des valeurs valides selon l'API
void printValidValues() {
  print('\n=== Valeurs valides selon l\'API ===');
  print('Types de projet: residential, commercial, industrial');
  print('Statuts: planning, in_progress, on_hold, completed, cancelled');
  print('Priorités: low, medium, high, critical');
  print('Tags: doivent être des chaînes de caractères');
}

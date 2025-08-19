import 'package:flutter/material.dart';
import 'lib/core/services/project_service.dart';
import 'lib/core/services/auth_service.dart';

void main() async {
  // Test de création de projet
  await testProjectCreation();
}

Future<void> testProjectCreation() async {
  try {
    print('=== Test de création de projet ===');
    
    final projectService = ProjectService();
    final authService = AuthService();
    
    // Test de connexion (si nécessaire)
    // final user = await authService.login('email@test.com', 'password');
    // print('Utilisateur connecté: ${user != null ? 'Oui' : 'Non'}');
    
    // Test de création de projet
    final projectData = await projectService.createProject(
      name: 'Projet Test API',
      type: 'residential',
      status: 'pending',
      priority: 'medium',
      clientName: 'Client Test',
      clientEmail: 'client@test.com',
      location: 'Paris, France',
      managerId: 1,
      description: 'Projet de test pour vérifier l\'API',
      budget: 500000.0,
      currency: 'EUR',
      progress: 0.0,
    );
    
    print('Projet créé avec succès!');
    print('ID du projet: ${projectData['id']}');
    print('Nom: ${projectData['name']}');
    print('Statut: ${projectData['status']}');
    
  } catch (e) {
    print('Erreur lors du test: $e');
  }
}

import 'package:flutter/material.dart';
import 'lib/core/services/dashboard_service.dart';

void main() async {
  print('=== Test simple de l\'API Dashboard ===');
  
  try {
    final dashboardService = DashboardService();
    
    print('\n1. 🔍 Test de l\'endpoint /dashboard/projects');
    try {
      final projectsData = await dashboardService.getProjects();
      print('✅ Réponse reçue: ${projectsData.length} éléments');
      print('📋 Contenu: $projectsData');
      
      // Vérifier la structure
      if (projectsData.containsKey('data')) {
        print('✅ Clé "data" trouvée');
        final projects = projectsData['data'];
        if (projects is List) {
          print('✅ "data" est une liste avec ${projects.length} éléments');
          if (projects.isNotEmpty) {
            print('📊 Premier projet: ${projects.first}');
          }
        } else {
          print('⚠️ "data" n\'est pas une liste: ${projects.runtimeType}');
        }
      } else if (projectsData.containsKey('projects')) {
        print('✅ Clé "projects" trouvée');
        final projects = projectsData['projects'];
        if (projects is List) {
          print('✅ "projects" est une liste avec ${projects.length} éléments');
          if (projects.isNotEmpty) {
            print('📊 Premier projet: ${projects.first}');
          }
        } else {
          print('⚠️ "projects" n\'est pas une liste: ${projects.runtimeType}');
        }
      } else {
        print('❌ Aucune clé de projets trouvée');
        print('🔍 Clés disponibles: ${projectsData.keys.toList()}');
      }
      
    } catch (e) {
      print('❌ Erreur API: $e');
    }
    
    print('\n2. 🔍 Test de l\'endpoint /dashboard/stats');
    try {
      final statsData = await dashboardService.getStats();
      print('✅ Réponse reçue: ${statsData.length} éléments');
      print('🔍 Clés disponibles: ${statsData.keys.toList()}');
    } catch (e) {
      print('❌ Erreur API: $e');
    }
    
  } catch (e) {
    print('❌ Erreur générale: $e');
  }
  
  print('\n�� Test terminé');
}

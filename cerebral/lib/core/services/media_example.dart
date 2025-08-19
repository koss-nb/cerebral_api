import 'dart:io';
import 'media_service.dart';

/// Exemple d'utilisation du service de média
/// Basé sur le MediaController Laravel
class MediaExample {
  final MediaService _mediaService = MediaService();

  /// Exemple d'upload de média
  Future<void> uploadMediaExample() async {
    try {
      print('📁 Upload de média...');
      
      // Créer un fichier temporaire pour l'exemple
      final tempFile = File('/tmp/example_image.jpg');
      if (!await tempFile.exists()) {
        print('   Création d\'un fichier temporaire pour l\'exemple...');
        await tempFile.writeAsBytes(List.filled(1024, 0)); // 1KB de données
      }
      
      final media = await _mediaService.uploadMedia(
        file: tempFile,
        mediableType: 'App\\Models\\Task',
        mediableId: 1,
        title: 'Image de validation de tâche',
        description: 'Photo montrant l\'état d\'avancement de la tâche',
        category: 'validation',
      );

      print('✅ Média uploadé avec succès !');
      print('   ID: ${media['data']['id']}');
      print('   Titre: ${media['data']['title']}');
      print('   Type: ${media['data']['type']}');
      print('   Catégorie: ${media['data']['category']}');
      print('   Taille: ${media['data']['file_size']} bytes');
      print('   Extension: ${media['data']['extension']}');
      print('   URL: ${media['data']['url']}');
      print('   Uploadé par: ${media['data']['uploaded_by']?['name'] ?? 'Non défini'}');
      print('   Message: ${media['message']}');

    } catch (e) {
      print('❌ Erreur lors de l\'upload: $e');
    }
  }

  /// Exemple de récupération de tous les médias
  Future<void> getMediaExample() async {
    try {
      print('📋 Récupération de tous les médias...');
      
      final media = await _mediaService.getMedia(perPage: 10);

      print('✅ Médias récupérés avec succès !');
      print('   Total: ${media['data']['total'] ?? 0}');
      print('   Page actuelle: ${media['data']['current_page'] ?? 1}');
      print('   Par page: ${media['data']['per_page'] ?? 20}');
      
      print('\n📋 MÉDIAS:');
      for (final item in media['data']['data']) {
        print('   • ${item['title']}');
        print('     Type: ${item['type']}');
        print('     Catégorie: ${item['category'] ?? 'Aucune'}');
        print('     Taille: ${item['file_size']} bytes');
        print('     Extension: ${item['extension']}');
        print('     Uploadé par: ${item['uploaded_by']?['name'] ?? 'Non défini'}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des médias: $e');
    }
  }

  /// Exemple de récupération d'un média spécifique
  Future<void> getMediaByIdExample() async {
    try {
      print('🔍 Récupération d\'un média spécifique...');
      
      final media = await _mediaService.getMediaById(1);

      print('✅ Média récupéré avec succès !');
      print('   ID: ${media['data']['id']}');
      print('   Titre: ${media['data']['title']}');
      print('   Description: ${media['data']['description'] ?? 'Aucune'}');
      print('   Type: ${media['data']['type']}');
      print('   Catégorie: ${media['data']['category'] ?? 'Aucune'}');
      print('   URL: ${media['data']['url']}');
      print('   Taille: ${media['data']['file_size']} bytes');
      print('   Extension: ${media['data']['extension']}');
      print('   Type MIME: ${media['data']['mime_type']}');
      print('   Nom original: ${media['data']['original_name']}');
      print('   Uploadé par: ${media['data']['uploaded_by']?['name'] ?? 'Non défini'}');
      print('   Créé le: ${media['data']['created_at']}');
      print('   Modifié le: ${media['data']['updated_at']}');

    } catch (e) {
      print('❌ Erreur lors de la récupération du média: $e');
    }
  }

  /// Exemple de filtrage des médias par type
  Future<void> getMediaByTypeExample() async {
    try {
      print('🏷️ Récupération des médias par type...');
      
      // Images
      final images = await _mediaService.getImages(perPage: 5);
      print('\n✅ Images récupérées avec succès !');
      print('   Nombre: ${images['data']['data'].length}');
      
      // Vidéos
      final videos = await _mediaService.getVideos(perPage: 5);
      print('\n✅ Vidéos récupérées avec succès !');
      print('   Nombre: ${videos['data']['data'].length}');
      
      // Audios
      final audios = await _mediaService.getAudios(perPage: 5);
      print('\n✅ Audios récupérés avec succès !');
      print('   Nombre: ${audios['data']['data'].length}');
      
      // Documents
      final documents = await _mediaService.getDocuments(perPage: 5);
      print('\n✅ Documents récupérés avec succès !');
      print('   Nombre: ${documents['data']['data'].length}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par type: $e');
    }
  }

  /// Exemple de filtrage des médias par catégorie
  Future<void> getMediaByCategoryExample() async {
    try {
      print('📂 Récupération des médias par catégorie...');
      
      final validationMedia = await _mediaService.getMediaByCategory('validation', perPage: 5);
      print('\n✅ Médias de validation récupérés avec succès !');
      print('   Nombre: ${validationMedia['data']['data'].length}');
      
      final documentationMedia = await _mediaService.getMediaByCategory('documentation', perPage: 5);
      print('\n✅ Médias de documentation récupérés avec succès !');
      print('   Nombre: ${documentationMedia['data']['data'].length}');

    } catch (e) {
      print('❌ Erreur lors du filtrage par catégorie: $e');
    }
  }

  /// Exemple de récupération des médias d'une tâche
  Future<void> getTaskMediaExample() async {
    try {
      print('📋 Récupération des médias d\'une tâche...');
      
      final taskMedia = await _mediaService.getTaskMedia(1);

      print('✅ Médias de la tâche récupérés avec succès !');
      print('   Nombre: ${taskMedia['data'].length}');
      
      print('\n📋 MÉDIAS DE LA TÂCHE:');
      for (final item in taskMedia['data']) {
        print('   • ${item['title']}');
        print('     Type: ${item['type']}');
        print('     Catégorie: ${item['category'] ?? 'Aucune'}');
        print('     Taille: ${item['file_size']} bytes');
        print('     Extension: ${item['extension']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des médias de la tâche: $e');
    }
  }

  /// Exemple de récupération des médias d'un projet
  Future<void> getProjectMediaExample() async {
    try {
      print('📋 Récupération des médias d\'un projet...');
      
      final projectMedia = await _mediaService.getProjectMedia(1);

      print('✅ Médias du projet récupérés avec succès !');
      print('   Nombre: ${projectMedia['data'].length}');
      
      print('\n📋 MÉDIAS DU PROJET:');
      for (final item in projectMedia['data']) {
        print('   • ${item['title']}');
        print('     Type: ${item['type']}');
        print('     Catégorie: ${item['category'] ?? 'Aucune'}');
        print('     Taille: ${item['file_size']} bytes');
        print('     Extension: ${item['extension']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des médias du projet: $e');
    }
  }

  /// Exemple de mise à jour d'un média
  Future<void> updateMediaExample() async {
    try {
      print('✏️ Mise à jour d\'un média...');
      
      final updatedMedia = await _mediaService.updateMedia(
        mediaId: 1,
        title: 'Image de validation mise à jour',
        description: 'Description mise à jour de l\'image de validation',
        category: 'validation_updated',
      );

      print('✅ Média mis à jour avec succès !');
      print('   ID: ${updatedMedia['data']['id']}');
      print('   Nouveau titre: ${updatedMedia['data']['title']}');
      print('   Nouvelle description: ${updatedMedia['data']['description']}');
      print('   Nouvelle catégorie: ${updatedMedia['data']['category']}');
      print('   Message: ${updatedMedia['message']}');

    } catch (e) {
      print('❌ Erreur lors de la mise à jour: $e');
    }
  }

  /// Exemple de suppression d'un média
  Future<void> deleteMediaExample() async {
    try {
      print('🗑️ Suppression d\'un média...');
      
      // Vérifier si le média peut être supprimé
      final canDelete = await _mediaService.canDeleteMedia(2);
      
      if (canDelete) {
        final result = await _mediaService.deleteMedia(2);

        print('✅ Média supprimé avec succès !');
        print('   ID: 2');
        print('   Message: ${result['message']}');
      } else {
        print('❌ Impossible de supprimer le média');
        print('   Raison: Le média ne peut pas être supprimé');
      }

    } catch (e) {
      print('❌ Erreur lors de la suppression: $e');
    }
  }

  /// Exemple d'utilisation des méthodes utilitaires
  Future<void> utilityMethodsExample() async {
    try {
      print('🔧 Utilisation des méthodes utilitaires...');
      
      final mediaId = 1;
      
      // Obtenir le titre du média
      final title = await _mediaService.getMediaTitle(mediaId);
      print('   Titre: $title');
      
      // Obtenir la description du média
      final description = await _mediaService.getMediaDescription(mediaId);
      print('   Description: $description');
      
      // Obtenir la catégorie du média
      final category = await _mediaService.getMediaCategory(mediaId);
      print('   Catégorie: $category');
      
      // Obtenir le type du média
      final type = await _mediaService.getMediaType(mediaId);
      print('   Type: $type');
      
      // Obtenir l'URL du média
      final url = await _mediaService.getMediaUrl(mediaId);
      print('   URL: $url');
      
      // Obtenir la taille du fichier
      final fileSize = await _mediaService.getMediaFileSize(mediaId);
      print('   Taille: $fileSize bytes');
      
      // Obtenir l'extension
      final extension = await _mediaService.getMediaExtension(mediaId);
      print('   Extension: $extension');
      
      // Obtenir le type MIME
      final mimeType = await _mediaService.getMediaMimeType(mediaId);
      print('   Type MIME: $mimeType');
      
      // Obtenir le nom original
      final originalName = await _mediaService.getMediaOriginalName(mediaId);
      print('   Nom original: $originalName');
      
      // Obtenir l'uploader
      final uploader = await _mediaService.getMediaUploader(mediaId);
      print('   Uploader: ${uploader?['name'] ?? 'Non défini'}');
      
      // Obtenir le modèle parent
      final parentModel = await _mediaService.getMediaParentModel(mediaId);
      print('   Modèle parent: ${parentModel?['type']} (ID: ${parentModel?['id']})');
      
      // Obtenir les dates
      final createdAt = await _mediaService.getMediaCreatedAt(mediaId);
      print('   Créé le: $createdAt');
      
      final updatedAt = await _mediaService.getMediaUpdatedAt(mediaId);
      print('   Modifié le: $updatedAt');
      
      // Vérifier le type de média
      final isImage = await _mediaService.isImage(mediaId);
      print('   Est une image: ${isImage ? 'Oui' : 'Non'}');
      
      final isVideo = await _mediaService.isVideo(mediaId);
      print('   Est une vidéo: ${isVideo ? 'Oui' : 'Non'}');
      
      final isAudio = await _mediaService.isAudio(mediaId);
      print('   Est un audio: ${isAudio ? 'Oui' : 'Non'}');
      
      final isDocument = await _mediaService.isDocument(mediaId);
      print('   Est un document: ${isDocument ? 'Oui' : 'Non'}');

    } catch (e) {
      print('❌ Erreur lors de l\'utilisation des méthodes utilitaires: $e');
    }
  }

  /// Exemple de récupération des médias récents
  Future<void> getRecentMediaExample() async {
    try {
      print('🕐 Récupération des médias récents...');
      
      final recentMedia = await _mediaService.getRecentMedia(perPage: 5);

      print('✅ Médias récents récupérés avec succès !');
      print('   Nombre: ${recentMedia['meta']['recent_count']}');
      
      print('\n🕐 MÉDIAS RÉCENTS:');
      for (final item in recentMedia['data']['data']) {
        print('   • ${item['title']}');
        print('     Type: ${item['type']}');
        print('     Catégorie: ${item['category'] ?? 'Aucune'}');
        print('     Créé le: ${item['created_at']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des médias récents: $e');
    }
  }

  /// Exemple de récupération des résumés de médias
  Future<void> getMediaSummariesExample() async {
    try {
      print('📋 Récupération des résumés de médias...');
      
      // Résumé d'un média spécifique
      final summary = await _mediaService.getMediaSummary(1);
      if (summary != null) {
        print('\n✅ Résumé du média récupéré avec succès !');
        print('   ID: ${summary['id']}');
        print('   Titre: ${summary['title']}');
        print('   Type: ${summary['type']}');
        print('   Catégorie: ${summary['category']}');
        print('   URL: ${summary['url']}');
        print('   Taille: ${summary['file_size']} bytes');
        print('   Extension: ${summary['extension']}');
        print('   Uploader: ${summary['uploader_name']}');
        print('   Modèle parent: ${summary['parent_model']['type']} (ID: ${summary['parent_model']['id']})');
        print('   Créé le: ${summary['created_at']}');
      }
      
      // Résumés de tous les médias
      final allSummaries = await _mediaService.getAllMediaSummaries(perPage: 10);
      print('\n✅ Résumés de tous les médias récupérés avec succès !');
      print('   Nombre: ${allSummaries.length}');
      
      print('\n📋 RÉSUMÉS:');
      for (final summary in allSummaries) {
        print('   • ${summary['title']}');
        print('     Type: ${summary['type']}');
        print('     Catégorie: ${summary['category']}');
        print('     Taille: ${summary['file_size']} bytes');
        print('     Extension: ${summary['extension']}');
        print('     Uploader: ${summary['uploader_name']}');
        print('');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des résumés: $e');
    }
  }

  /// Exemple de récupération des statistiques des médias
  Future<void> getMediaStatsExample() async {
    try {
      print('📊 Récupération des statistiques des médias...');
      
      final stats = await _mediaService.getMediaStats();

      print('✅ Statistiques récupérées avec succès !');
      
      print('\n📊 STATISTIQUES GLOBALES:');
      print('   Total des médias: ${stats['data']['total_media']}');
      print('   Taille totale: ${stats['data']['total_size']} bytes');
      print('   Taille moyenne: ${stats['data']['average_size'].toStringAsFixed(2)} bytes');
      
      print('\n📊 RÉPARTITION PAR TYPE:');
      final byType = stats['data']['by_type'];
      print('   Images: ${byType['image']}');
      print('   Vidéos: ${byType['video']}');
      print('   Audios: ${byType['audio']}');
      print('   Documents: ${byType['document']}');
      
      print('\n📊 RÉPARTITION PAR CATÉGORIE:');
      final byCategory = stats['data']['by_category'];
      for (final entry in byCategory.entries) {
        print('   ${entry.key}: ${entry.value}');
      }

    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
    }
  }

  /// Exemple complet d'utilisation du service de média
  Future<void> completeMediaWorkflow() async {
    try {
      print('🚀 === WORKFLOW COMPLET DU SERVICE DE MÉDIA ===\n');

      // 1. Récupérer tous les médias
      await getMediaExample();
      print('');

      // 2. Récupérer un média spécifique
      await getMediaByIdExample();
      print('');

      // 3. Filtrer par type
      await getMediaByTypeExample();
      print('');

      // 4. Filtrer par catégorie
      await getMediaByCategoryExample();
      print('');

      // 5. Récupérer les médias d'une tâche
      await getTaskMediaExample();
      print('');

      // 6. Récupérer les médias d'un projet
      await getProjectMediaExample();
      print('');

      // 7. Mettre à jour un média
      await updateMediaExample();
      print('');

      // 8. Utiliser les méthodes utilitaires
      await utilityMethodsExample();
      print('');

      // 9. Récupérer les médias récents
      await getRecentMediaExample();
      print('');

      // 10. Récupérer les résumés
      await getMediaSummariesExample();
      print('');

      // 11. Récupérer les statistiques
      await getMediaStatsExample();
      print('');

      // 12. Supprimer un média
      await deleteMediaExample();
      print('');

      print('✅ Workflow du service de média terminé avec succès !');

    } catch (e) {
      print('❌ Erreur dans le workflow du service de média: $e');
    }
  }

  /// Exemple d'utilisation dans une interface utilisateur
  Future<void> uiExample() async {
    try {
      print('🖥️ === EXEMPLE D\'INTERFACE UTILISATEUR ===\n');

      // Simuler une galerie de médias
      print('🖼️ GALERIE DE MÉDIAS:');
      
      // Récupérer les statistiques globales
      final stats = await _mediaService.getMediaStats();
      print('📊 STATISTIQUES GLOBALES:');
      print('   Total des médias: ${stats['data']['total_media']}');
      print('   Taille totale: ${(stats['data']['total_size'] / 1024 / 1024).toStringAsFixed(2)} MB');
      
      // Récupérer les médias par type
      final images = await _mediaService.getImages(perPage: 5);
      print('\n🖼️ IMAGES:');
      print('   Images disponibles: ${images['data']['data'].length}');
      
      final videos = await _mediaService.getVideos(perPage: 5);
      print('\n🎥 VIDÉOS:');
      print('   Vidéos disponibles: ${videos['data']['data'].length}');
      
      final documents = await _mediaService.getDocuments(perPage: 5);
      print('\n📄 DOCUMENTS:');
      print('   Documents disponibles: ${documents['data']['data'].length}');
      
      // Récupérer les médias récents
      final recentMedia = await _mediaService.getRecentMedia(perPage: 5);
      print('\n🕐 MÉDIAS RÉCENTS:');
      print('   Médias récents: ${recentMedia['meta']['recent_count']}');

    } catch (e) {
      print('❌ Erreur dans l\'exemple d\'interface: $e');
    }
  }
}

/// Fonction principale pour tester le service de média
void main() async {
  final mediaExample = MediaExample();
  
  // Exécuter le workflow complet
  await mediaExample.completeMediaWorkflow();
  
  print('\n' + '=' * 50);
  
  // Exemple d'interface utilisateur
  await mediaExample.uiExample();
}

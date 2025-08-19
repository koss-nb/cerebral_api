import 'dart:io';
import 'api_service.dart';

class MediaService {
  final ApiService _apiService = ApiService.instance;

  // Upload de fichier
  Future<Map<String, dynamic>> uploadMedia({
    required File file,
    required String mediableType,
    required int mediableId,
    String? title,
    String? description,
    String? category,
  }) async {
    try {
      // Créer la requête multipart
      final request = await _apiService.createMultipartRequest(
        '/media/upload',
        {
          'mediable_type': mediableType,
          'mediable_id': mediableId.toString(),
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (category != null) 'category': category,
        },
        {'file': file},
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Map<String, dynamic>.from(
          _apiService.parseJsonResponse(responseData),
        );
      } else {
        throw Exception('Erreur lors de l\'upload: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les médias avec filtres
  Future<Map<String, dynamic>> getMedia({
    String? type,
    String? category,
    String? mediableType,
    int? mediableId,
    int? perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (type != null) {
        queryParams['type'] = type;
      }

      if (category != null) {
        queryParams['category'] = category;
      }

      if (mediableType != null) {
        queryParams['mediable_type'] = mediableType;
      }

      if (mediableId != null) {
        queryParams['mediable_id'] = mediableId.toString();
      }

      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/media$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un média spécifique
  Future<Map<String, dynamic>> getMediaById(int mediaId) async {
    try {
      return await _apiService.get('/media/$mediaId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un média
  Future<Map<String, dynamic>> updateMedia({
    required int mediaId,
    String? title,
    String? description,
    String? category,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (title != null) {
        data['title'] = title;
      }

      if (description != null) {
        data['description'] = description;
      }

      if (category != null) {
        data['category'] = category;
      }

      return await _apiService.put('/media/$mediaId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un média
  Future<Map<String, dynamic>> deleteMedia(int mediaId) async {
    try {
      return await _apiService.delete('/media/$mediaId');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias d'une tâche
  Future<Map<String, dynamic>> getTaskMedia(int taskId) async {
    try {
      return await _apiService.get('/media/task/$taskId');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias d'un projet
  Future<Map<String, dynamic>> getProjectMedia(int projectId) async {
    try {
      return await _apiService.get('/media/project/$projectId');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer les médias

  // Obtenir les médias par type
  Future<Map<String, dynamic>> getMediaByType(String type,
      {int? perPage}) async {
    try {
      return await getMedia(type: type, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias par catégorie
  Future<Map<String, dynamic>> getMediaByCategory(String category,
      {int? perPage}) async {
    try {
      return await getMedia(category: category, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias d'un modèle spécifique
  Future<Map<String, dynamic>> getMediaByModel({
    required String modelType,
    required int modelId,
    int? perPage,
  }) async {
    try {
      return await getMedia(
        mediableType: modelType,
        mediableId: modelId,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les images
  Future<Map<String, dynamic>> getImages({int? perPage}) async {
    try {
      return await getMediaByType('image', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les vidéos
  Future<Map<String, dynamic>> getVideos({int? perPage}) async {
    try {
      return await getMediaByType('video', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les audios
  Future<Map<String, dynamic>> getAudios({int? perPage}) async {
    try {
      return await getMediaByType('audio', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les documents
  Future<Map<String, dynamic>> getDocuments({int? perPage}) async {
    try {
      return await getMediaByType('document', perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour analyser les médias

  // Vérifier si un média peut être supprimé
  Future<bool> canDeleteMedia(int mediaId) async {
    try {
      // Cette méthode pourrait vérifier les permissions
      // Pour l'instant, on retourne true par défaut
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le titre d'un média
  Future<String?> getMediaTitle(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['title'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la description d'un média
  Future<String?> getMediaDescription(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['description'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la catégorie d'un média
  Future<String?> getMediaCategory(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['category'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le type d'un média
  Future<String?> getMediaType(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['type'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'URL d'un média
  Future<String?> getMediaUrl(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['url'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le chemin du fichier d'un média
  Future<String?> getMediaFilePath(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['file_path'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la taille d'un fichier média
  Future<int?> getMediaFileSize(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['file_size'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'extension d'un fichier média
  Future<String?> getMediaExtension(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['extension'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le type MIME d'un média
  Future<String?> getMediaMimeType(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['mime_type'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le nom original d'un fichier média
  Future<String?> getMediaOriginalName(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['original_name'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'utilisateur qui a uploadé le média
  Future<Map<String, dynamic>?> getMediaUploader(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['uploaded_by'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le modèle parent d'un média
  Future<Map<String, dynamic>?> getMediaParentModel(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return {
          'type': media['data']['mediable_type'],
          'id': media['data']['mediable_id'],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la date de création d'un média
  Future<String?> getMediaCreatedAt(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['created_at'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la date de modification d'un média
  Future<String?> getMediaUpdatedAt(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        return media['data']['updated_at'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si un média est une image
  Future<bool> isImage(int mediaId) async {
    try {
      final type = await getMediaType(mediaId);
      return type == 'image';
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un média est une vidéo
  Future<bool> isVideo(int mediaId) async {
    try {
      final type = await getMediaType(mediaId);
      return type == 'video';
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un média est un audio
  Future<bool> isAudio(int mediaId) async {
    try {
      final type = await getMediaType(mediaId);
      return type == 'audio';
    } catch (e) {
      return false;
    }
  }

  // Vérifier si un média est un document
  Future<bool> isDocument(int mediaId) async {
    try {
      final type = await getMediaType(mediaId);
      return type == 'document';
    } catch (e) {
      return false;
    }
  }

  // Obtenir le résumé d'un média
  Future<Map<String, dynamic>?> getMediaSummary(int mediaId) async {
    try {
      final media = await getMediaById(mediaId);

      if (media['success'] == true) {
        final data = media['data'];

        return {
          'id': data['id'],
          'title': data['title'],
          'description': data['description'],
          'type': data['type'],
          'category': data['category'],
          'url': data['url'],
          'file_size': data['file_size'],
          'extension': data['extension'],
          'original_name': data['original_name'],
          'uploader_name':
              data['uploaded_by']?['name'] ?? 'Utilisateur inconnu',
          'parent_model': {
            'type': data['mediable_type'],
            'id': data['mediable_id'],
          },
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les résumés de tous les médias
  Future<List<Map<String, dynamic>>> getAllMediaSummaries(
      {int? perPage}) async {
    try {
      final media = await getMedia(perPage: perPage);

      if (media['success'] == true) {
        final data = media['data']['data'] as List;

        return data
            .map((media) => {
                  'id': media['id'],
                  'title': media['title'],
                  'description': media['description'],
                  'type': media['type'],
                  'category': media['category'],
                  'url': media['url'],
                  'file_size': media['file_size'],
                  'extension': media['extension'],
                  'original_name': media['original_name'],
                  'uploader_name':
                      media['uploaded_by']?['name'] ?? 'Utilisateur inconnu',
                  'parent_model': {
                    'type': media['mediable_type'],
                    'id': media['mediable_id'],
                  },
                  'created_at': media['created_at'],
                  'updated_at': media['updated_at'],
                })
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les médias récents
  Future<Map<String, dynamic>> getRecentMedia({int? perPage = 10}) async {
    try {
      final media = await getMedia(perPage: perPage);

      if (media['success'] == true) {
        final data = media['data']['data'] as List;

        // Trier par date de création (plus récent en premier)
        data.sort((a, b) {
          final aDate = DateTime.tryParse(a['created_at'] ?? '');
          final bDate = DateTime.tryParse(b['created_at'] ?? '');

          if (aDate == null || bDate == null) return 0;
          return bDate.compareTo(aDate);
        });

        return {
          'success': true,
          'data': {
            'data': data,
            'pagination': media['data']['pagination'],
          },
          'meta': {
            'recent_count': data.length,
          },
        };
      }

      return media;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias par taille de fichier
  Future<Map<String, dynamic>> getMediaByFileSize({
    int? minSize,
    int? maxSize,
    int? perPage,
  }) async {
    try {
      // Cette méthode nécessiterait un endpoint spécifique dans l'API
      // Pour l'instant, on récupère tous les médias et on filtre côté client
      final allMedia = await getMedia(perPage: 1000);

      if (allMedia['success'] == true) {
        final media = allMedia['data']['data'] as List;
        List filteredMedia = media;

        if (minSize != null) {
          filteredMedia =
              filteredMedia.where((m) => m['file_size'] >= minSize).toList();
        }

        if (maxSize != null) {
          filteredMedia =
              filteredMedia.where((m) => m['file_size'] <= maxSize).toList();
        }

        return {
          'success': true,
          'data': {
            'data': filteredMedia,
            'pagination': {
              'current_page': 1,
              'last_page': 1,
              'per_page': filteredMedia.length,
              'total': filteredMedia.length,
            },
          },
        };
      }

      return allMedia;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les médias par extension
  Future<Map<String, dynamic>> getMediaByExtension(String extension,
      {int? perPage}) async {
    try {
      // Cette méthode nécessiterait un endpoint spécifique dans l'API
      // Pour l'instant, on récupère tous les médias et on filtre côté client
      final allMedia = await getMedia(perPage: 1000);

      if (allMedia['success'] == true) {
        final media = allMedia['data']['data'] as List;
        final filteredMedia =
            media.where((m) => m['extension'] == extension).toList();

        return {
          'success': true,
          'data': {
            'data': filteredMedia,
            'pagination': {
              'current_page': 1,
              'last_page': 1,
              'per_page': filteredMedia.length,
              'total': filteredMedia.length,
            },
          },
        };
      }

      return allMedia;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques des médias
  Future<Map<String, dynamic>> getMediaStats() async {
    try {
      // Cette méthode nécessiterait un endpoint spécifique dans l'API
      // Pour l'instant, on calcule les statistiques à partir de tous les médias
      final allMedia = await getMedia(perPage: 1000);

      if (allMedia['success'] == true) {
        final media = allMedia['data']['data'] as List;

        final stats = <String, dynamic>{
          'total_media': media.length,
          'by_type': <String, int>{
            'image': media.where((m) => m['type'] == 'image').length,
            'video': media.where((m) => m['type'] == 'video').length,
            'audio': media.where((m) => m['type'] == 'audio').length,
            'document': media.where((m) => m['type'] == 'document').length,
          },
          'total_size': media.fold<int>(
              0, (sum, m) => sum + (m['file_size'] as int? ?? 0)),
          'average_size': media.isNotEmpty
              ? (media.fold<int>(
                          0, (sum, m) => sum + (m['file_size'] as int? ?? 0)) /
                      media.length)
                  .round()
              : 0,
          'by_category': <String, int>{},
        };

        // Calculer les statistiques par catégorie
        for (final m in media) {
          final category = m['category'] ?? 'sans_categorie';
          final byCategory = stats['by_category'] as Map<String, int>;
          byCategory[category] = (byCategory[category] ?? 0) + 1;
        }

        return {
          'success': true,
          'data': stats,
        };
      }

      return allMedia;
    } catch (e) {
      rethrow;
    }
  }
}

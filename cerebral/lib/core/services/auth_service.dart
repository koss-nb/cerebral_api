import 'api_service.dart';
import '../config/api_config.dart';

class AuthService {
  final ApiService _apiService = ApiService.instance;

  // Inscription d'un nouvel utilisateur
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? companyName,
    String? companyType,
    bool? acceptTerms,
    bool? acceptNewsletter,
  }) async {
    try {
      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      };

      // Ajouter les paramètres optionnels s'ils sont fournis
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }
      if (companyName != null && companyName.isNotEmpty) {
        data['company_name'] = companyName;
      }
      if (companyType != null && companyType.isNotEmpty) {
        data['company_type'] = companyType;
      }
      if (acceptTerms != null) {
        data['accept_terms'] = acceptTerms;
      }
      if (acceptNewsletter != null) {
        data['accept_newsletter'] = acceptNewsletter;
      }

      print('🔍 Données d\'inscription: $data');
      print('🔍 URL de l\'API: ${ApiConfig.baseUrl}/register');
      print('🔍 Taille des données: ${data.toString().length} caractères');

      final response = await _apiService.post('/register', data);
      print('✅ Réponse API: $response');

      // Sauvegarder le token si l'inscription réussit
      if (response['token'] != null) {
        await _apiService.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      print('❌ Erreur inscription: $e');
      print('❌ Type d\'erreur: ${e.runtimeType}');
      print('❌ Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  // Connexion utilisateur
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/login', {
        'email': email,
        'password': password,
      });

      // Sauvegarder le token si la connexion réussit
      if (response['token'] != null) {
        await _apiService.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      // Essayer d'appeler l'API de déconnexion (optionnel)
      try {
        await _apiService.post('/logout', {});
      } catch (e) {
        // Si l'API n'est pas disponible, on continue quand même
        print('⚠️ API de déconnexion non disponible: $e');
      }

      // Supprimer le token après déconnexion
      await _apiService.removeToken();
      print('✅ Déconnexion réussie - Token supprimé');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      // Même en cas d'erreur, on supprime le token localement
      try {
        await _apiService.removeToken();
      } catch (e2) {
        print('❌ Erreur lors de la suppression du token: $e2');
      }
    }
  }

  // Obtenir l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      return await _apiService.get('/me');
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    return await _apiService.isAuthenticated();
  }

  // Obtenir le token
  Future<String?> getToken() async {
    return await _apiService.getToken();
  }

  // Vérifier les permissions de l'utilisateur
  Future<bool> hasPermission(String permission) async {
    try {
      final user = await getCurrentUser();
      final permissions = user['permissions'] as List<dynamic>?;

      if (permissions == null) return false;

      // Vérifier si l'utilisateur a la permission 'all' (admin)
      if (permissions.contains('all')) return true;

      // Vérifier la permission spécifique
      return permissions.contains(permission);
    } catch (e) {
      return false;
    }
  }

  // Vérifier si l'utilisateur a au moins une des permissions
  Future<bool> hasAnyPermission(List<String> permissions) async {
    try {
      final user = await getCurrentUser();
      final userPermissions = user['permissions'] as List<dynamic>?;

      if (userPermissions == null) return false;

      // Vérifier si l'utilisateur a la permission 'all' (admin)
      if (userPermissions.contains('all')) return true;

      // Vérifier si l'utilisateur a au moins une des permissions demandées
      for (final permission in permissions) {
        if (userPermissions.contains(permission)) return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le rôle de l'utilisateur connecté
  Future<String?> getUserRole() async {
    try {
      final user = await getCurrentUser();
      return user['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Vérifier si l'utilisateur a un rôle spécifique
  Future<bool> hasRole(String role) async {
    try {
      final userRole = await getUserRole();
      return userRole == role;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si l'utilisateur a au moins un des rôles
  Future<bool> hasAnyRole(List<String> roles) async {
    try {
      final userRole = await getUserRole();
      return userRole != null && roles.contains(userRole);
    } catch (e) {
      return false;
    }
  }

  // Rafraîchir le token (si nécessaire)
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      // Cette méthode peut être implémentée si ton API supporte le refresh de token
      // Pour l'instant, on retourne une erreur
      throw UnimplementedError(
          'Refresh token not implemented in this API version');
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si le token est expiré
  Future<bool> isTokenExpired() async {
    try {
      final token = await getToken();
      if (token == null) return true;

      // Vérifier la validité du token en appelant /me
      await getCurrentUser();
      return false;
    } catch (e) {
      return true;
    }
  }

  // Obtenir les informations de l'utilisateur sans token (pour vérification)
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      if (await isAuthenticated()) {
        return await getCurrentUser();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

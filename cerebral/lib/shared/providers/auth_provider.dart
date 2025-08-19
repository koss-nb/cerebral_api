import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService.instance;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Méthode de connexion
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔐 Tentative de connexion pour: $email');
      
      // Utiliser le service d'authentification pour se connecter à l'API
      final response = await _authService.login(email, password);
      
      if (response['user'] != null) {
        // Créer l'objet User à partir de la réponse de l'API
        _currentUser = User(
          id: response['user']['id'].toString(),
          email: response['user']['email'],
          firstName: response['user']['first_name'] ?? '',
          lastName: response['user']['last_name'] ?? '',
          role: response['user']['role'] ?? 'Utilisateur',
          permissions: _getPermissionsFromRole(response['user']['role']),
        );
        
        print('✅ Connexion réussie pour: ${_currentUser!.email}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Réponse invalide du serveur';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      _error = 'Erreur de connexion: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    try {
      await _authService.logout();
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      // Même en cas d'erreur, on déconnecte localement
      _currentUser = null;
      _error = null;
      notifyListeners();
    }
  }

  // Obtenir les permissions basées sur le rôle
  List<String> _getPermissionsFromRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
      case 'administrateur':
        return ['all'];
      case 'manager':
      case 'chef de projet':
        return ['projects', 'tasks', 'personnel', 'budget', 'reports'];
      case 'chef':
      case 'chef de chantier':
        return ['tasks', 'personnel', 'materials', 'time_tracking'];
      case 'technicien':
        return ['tasks', 'time_tracking', 'materials', 'issues'];
      case 'supervisor':
        return ['tasks', 'quality_checks', 'technical_review'];
      default:
        return ['tasks'];
    }
  }

  // Vérifier l'état d'authentification au démarrage
  Future<void> checkAuthStatus() async {
    try {
      final isAuthenticated = await _apiService.isAuthenticated();
      if (isAuthenticated) {
        // Récupérer les informations de l'utilisateur connecté
        final userData = await _authService.getCurrentUser();
        if (userData['user'] != null) {
          _currentUser = User(
            id: userData['user']['id'].toString(),
            email: userData['user']['email'],
            firstName: userData['user']['first_name'] ?? '',
            lastName: userData['user']['last_name'] ?? '',
            role: userData['user']['role'] ?? 'Utilisateur',
            permissions: _getPermissionsFromRole(userData['user']['role']),
          );
          print('✅ Utilisateur déjà connecté: ${_currentUser!.email}');
        }
      }
      notifyListeners();
    } catch (e) {
      print('❌ Erreur lors de la vérification de l\'authentification: $e');
      // En cas d'erreur, on supprime le token invalide
      await _apiService.removeToken();
      notifyListeners();
    }
  }

  // Méthode d'inscription
  Future<bool> register({
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        companyName: companyName,
        companyType: companyType,
        acceptTerms: acceptTerms,
        acceptNewsletter: acceptNewsletter,
      );

      if (response['user'] != null) {
        _currentUser = User(
          id: response['user']['id'].toString(),
          email: response['user']['email'],
          firstName: response['user']['first_name'] ?? '',
          lastName: response['user']['last_name'] ?? '',
          role: response['user']['role'] ?? 'Utilisateur',
          permissions: _getPermissionsFromRole(response['user']['role']),
        );
        
        print('✅ Inscription réussie pour: ${_currentUser!.email}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Erreur lors de l\'inscription';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Erreur d\'inscription: $e');
      _error = 'Erreur d\'inscription: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

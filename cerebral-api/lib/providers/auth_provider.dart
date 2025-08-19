import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  String? get token => _apiService.token;

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.login(email, password);
      _currentUser = response.user;
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _apiService.logout();
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      // Même en cas d'erreur, on déconnecte localement
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    }
  }

  // Vérifier la santé de l'API
  Future<bool> checkApiHealth() async {
    try {
      await _apiService.checkHealth();
      return true;
    } catch (e) {
      _setError('API non accessible: $e');
      notifyListeners();
      return false;
    }
  }

  // Méthodes privées
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }

  // Vérifier les permissions
  bool hasPermission(String permission) {
    if (_currentUser == null) return false;
    return _currentUser!.permissions.contains(permission) || 
           _currentUser!.permissions.contains('all');
  }

  bool hasRole(String role) {
    return _currentUser?.role == role;
  }

  bool isAdmin() => hasRole('admin');
  bool isManager() => hasRole('manager');
  bool isChef() => hasRole('chef');
  bool isTechnicien() => hasRole('technicien');
}

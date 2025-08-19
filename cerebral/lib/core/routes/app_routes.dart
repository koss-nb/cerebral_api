import 'package:flutter/material.dart';
import '../../pages/auth/connexion.dart';
import '../../pages/auth/inscription.dart';
import '../../pages/presentations/my_home_page.dart';
import '../../pages/presentations/site_manager_dashboard.dart';
import '../../pages/presentations/supervisor_dashboard.dart';
import '../../pages/presentations/technicien_dashboard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard = '/admin-dashboard';
  static const String managerDashboard = '/manager-dashboard';
  static const String supervisorDashboard = '/supervisor-dashboard';
  static const String technicienDashboard = '/technicien-dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const Connexion(),
      signup: (context) => const Inscription(),
      adminDashboard: (context) => const MyHomePage(),
      managerDashboard: (context) => const SiteManagerDashboard(),
      supervisorDashboard: (context) => const SupervisorDashboard(),
      technicienDashboard: (context) => const TechnicienDashboard(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Gestion des routes dynamiques si nécessaire
    return null;
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    // Redirection vers la page de connexion si la route n'existe pas
    return MaterialPageRoute(
      builder: (context) => const Connexion(),
    );
  }
}

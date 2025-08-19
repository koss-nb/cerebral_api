import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../shared/providers/auth_provider.dart';
import '../pages/auth/connexion.dart';
import '../pages/auth/inscription.dart';
import '../pages/presentations/my_home_page.dart';
import '../pages/presentations/site_manager_dashboard.dart';
import '../pages/presentations/technicien_dashboard.dart';
import '../pages/presentations/supervisor_dashboard.dart';
import '../pages/presentations/admin_home_dashboard.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/projects/pages/projects_page.dart';
import '../features/projects/pages/project_details_page.dart';
import '../features/tasks/pages/tasks_page.dart';
import '../features/tasks/pages/task_details_page.dart';
import '../features/personnel/pages/personnel_page.dart';
import '../features/budget/pages/budget_page.dart';
import '../features/workflow/pages/workflow_page.dart';
import '../features/reports/pages/reports_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/notifications/pages/notifications_page.dart';
import '../features/help/pages/help_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Si l'utilisateur n'est pas connecté et n'est pas sur la page de connexion
      if (!authProvider.isAuthenticated && state.uri.toString() != '/login') {
        return '/login';
      }

      // Si l'utilisateur est connecté et est sur la page de connexion
      if (authProvider.isAuthenticated && state.uri.toString() == '/login') {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      // Route de connexion
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Connexion(),
      ),

      // Route d'inscription
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const Inscription(),
      ),

      // Route racine - MyHomePage (Dashboard principal)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MyHomePage(),
      ),

      // Route Admin - MyHomePage avec toutes les fonctionnalités
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const MyHomePage(),
      ),

      // Routes spécifiques pour chaque type de dashboard
      GoRoute(
        path: '/site-manager-dashboard',
        name: 'site-manager-dashboard',
        builder: (context, state) => const SiteManagerDashboard(),
      ),

      GoRoute(
        path: '/technicien-dashboard',
        name: 'technicien-dashboard',
        builder: (context, state) => const TechnicienDashboard(),
      ),

      GoRoute(
        path: '/supervisor-dashboard',
        name: 'supervisor-dashboard',
        builder: (context, state) => const SupervisorDashboard(),
      ),

      GoRoute(
        path: '/admin-dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminHomeDashboard(),
      ),

      // Routes pour les autres rôles (sans ShellRoute)
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const SiteManagerDashboard(),
      ),

      GoRoute(
        path: '/projects/:id',
        name: 'project-details',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          return ProjectDetailsPage(projectId: projectId);
        },
      ),

      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TechnicienDashboard(),
      ),

      GoRoute(
        path: '/tasks/:id',
        name: 'task-details',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailsPage(taskId: taskId);
        },
      ),

      GoRoute(
        path: '/personnel',
        name: 'personnel',
        builder: (context, state) => const SupervisorDashboard(),
      ),

      GoRoute(
        path: '/budget',
        name: 'budget',
        builder: (context, state) => const BudgetPage(),
      ),

      GoRoute(
        path: '/workflows',
        name: 'workflows',
        builder: (context, state) => const WorkflowPage(),
      ),

      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsPage(),
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpPage(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

// Page d'erreur
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page non trouvée')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La page que vous recherchez n\'existe pas.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

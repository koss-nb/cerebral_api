class ApiConfig {
  // Base URL de l'API CEREBRAL
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Endpoints d'authentification
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  
  // Endpoints des projets
  static const String projects = '/projects';
  
  // Endpoints des tâches
  static const String tasks = '/tasks';
  
  // Endpoints du personnel
  static const String personnel = '/personnel';
  
  // Endpoints des budgets
  static const String budgets = '/budgets';
  
  // Endpoints des workflows
  static const String workflows = '/workflows';
  
  // Endpoints du dashboard
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardAlerts = '/dashboard/alerts';
  static const String dashboardBudgetAnalysis = '/dashboard/budget-analysis';
  static const String dashboardChartData = '/dashboard/chart-data';
  static const String dashboardProjectAnalytics = '/dashboard/project-analytics';
  static const String dashboardQuickActions = '/dashboard/quick-actions';
  static const String dashboardRealTimeUpdates = '/dashboard/real-time-updates';
  static const String dashboardTaskEfficiency = '/dashboard/task-efficiency';
  static const String dashboardWorkloadDistribution = '/dashboard/workload-distribution';
  
  // Endpoints des matériaux
  static const String materials = '/materials';
  
  // Endpoints des livraisons
  static const String deliveries = '/deliveries';
  
  // Endpoints des problèmes
  static const String issues = '/issues';
  
  // Endpoints du pointage
  static const String timeTracking = '/time-tracking';
  static const String clockIn = '/time-tracking/clock-in';
  static const String clockOut = '/time-tracking/clock-out';
  
  // Endpoints des médias
  static const String media = '/media';
  
  // Endpoints des notifications
  static const String notifications = '/notifications';
  
  // Endpoint de santé
  static const String health = '/health';
  
  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout de l'API
  static const Duration timeout = Duration(seconds: 30);
  
  // Pagination par défaut
  static const int defaultPageSize = 20;
  
  // Rôles utilisateur
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  static const String roleChef = 'chef';
  static const String roleTechnicien = 'technicien';
  static const String roleUser = 'user';
}

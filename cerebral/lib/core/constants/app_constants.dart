class AppConstants {
  // Informations de l'application
  static const String appName = 'CEREBRAL';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Gestion intelligente de projets immobiliers';
  
  // URLs et endpoints
  static const String baseUrl = 'https://api.cerebral.com';
  static const String apiVersion = '/v1';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheTimeout = Duration(hours: 1);
  static const int maxCacheSize = 100;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;
  
  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);
}

class AppRoutes {
  // Routes principales
  static const String home = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  
  // Routes d'authentification
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  
  // Routes des projets
  static const String projects = '/projects';
  static const String projectDetails = '/projects/:id';
  static const String createProject = '/projects/create';
  static const String editProject = '/projects/:id/edit';
  
  // Routes des tâches
  static const String tasks = '/tasks';
  static const String taskDetails = '/tasks/:id';
  static const String createTask = '/tasks/create';
  static const String editTask = '/tasks/:id/edit';
  
  // Routes du personnel
  static const String personnel = '/personnel';
  static const String personnelDetails = '/personnel/:id';
  static const String createPersonnel = '/personnel/create';
  static const String editPersonnel = '/personnel/:id/edit';
  
  // Routes du budget
  static const String budget = '/budget';
  static const String budgetDetails = '/budget/:id';
  static const String createBudget = '/budget/create';
  static const String editBudget = '/budget/:id/edit';
  
  // Routes des workflows
  static const String workflows = '/workflows';
  static const String workflowDetails = '/workflows/:id';
  static const String createWorkflow = '/workflows/create';
  static const String editWorkflow = '/workflows/:id/edit';
  
  // Routes des rapports
  static const String reports = '/reports';
  static const String reportDetails = '/reports/:id';
  static const String createReport = '/reports/create';
  static const String editReport = '/reports/:id/edit';
  
  // Routes des paramètres
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
}

class AppStorageKeys {
  // Clés de stockage local
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
  static const String userPreferences = 'user_preferences';
  static const String appSettings = 'app_settings';
  static const String lastSync = 'last_sync';
  static const String offlineData = 'offline_data';
}

class AppMessages {
  // Messages d'erreur
  static const String networkError = 'Erreur de connexion réseau';
  static const String serverError = 'Erreur du serveur';
  static const String unknownError = 'Une erreur inconnue s\'est produite';
  static const String validationError = 'Veuillez vérifier les informations saisies';
  static const String permissionDenied = 'Permission refusée';
  static const String sessionExpired = 'Session expirée, veuillez vous reconnecter';
  
  // Messages de succès
  static const String operationSuccess = 'Opération réussie';
  static const String dataSaved = 'Données sauvegardées';
  static const String dataDeleted = 'Données supprimées';
  static const String connectionSuccess = 'Connexion réussie';
  static const String logoutSuccess = 'Déconnexion réussie';
  
  // Messages d'information
  static const String loading = 'Chargement...';
  static const String noData = 'Aucune donnée disponible';
  static const String noInternet = 'Aucune connexion internet';
  static const String syncInProgress = 'Synchronisation en cours...';
  static const String syncComplete = 'Synchronisation terminée';
}

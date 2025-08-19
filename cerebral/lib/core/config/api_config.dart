class ApiConfig {
  // Configuration de l'API
  static const String baseUrl = 'https://cerebral.eveil-maturite.com/api';
  static const String version = 'v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Cerebral-App/1.0',
  };

  // Endpoints
  static const String healthEndpoint = '/health';
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String userEndpoint = '/me';

  // Dashboard endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardChartData = '/dashboard/chart-data';
  static const String dashboardAlerts = '/dashboard/alerts';

  // Projects endpoints
  static const String projects = '/projects';
  static const String myProjects = '/projects/my-projects';

  // Tasks endpoints
  static const String tasks = '/tasks';
  static const String myTasks = '/tasks/my-tasks';
  static const String overdueTasks = '/tasks/overdue-tasks';

  // Personnel endpoints
  static const String personnel = '/personnel';
  static const String personnelStats = '/personnel/stats';

  // Budget endpoints
  static const String budgets = '/budgets';
  static const String budgetStats = '/budgets/stats';

  // Workflow endpoints
  static const String workflows = '/workflows';
  static const String workflowTypes = '/workflows/types';

  // Reports endpoints
  static const String reports = '/reports';
  static const String dashboardReport = '/reports/dashboard';

  // Notifications endpoints
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';

  // Time tracking endpoints
  static const String timeTracking = '/time-tracking';
  static const String clockIn = '/time-tracking/clock-in';
  static const String clockOut = '/time-tracking/clock-out';

  // Materials endpoints
  static const String materials = '/materials';
  static const String lowStock = '/materials/low-stock';

  // Deliveries endpoints
  static const String deliveries = '/deliveries';
  static const String upcomingDeliveries = '/deliveries/upcoming';

  // Media endpoints
  static const String media = '/media';
  static const String uploadMedia = '/media/upload';

  // Issues endpoints
  static const String issues = '/issues';
  static const String criticalIssues = '/issues/critical';

  // Technicien endpoints
  static const String technicienDashboard = '/technicien/dashboard';
  static const String technicienStats = '/technicien/stats';
  static const String assignedTasks = '/technicien/assigned-tasks';
  static const String technicienPerformance = '/technicien/performance';
  static const String technicienAssignedProjects =
      '/technicien/assigned-projects';
  static const String technicienCompletedTasks = '/technicien/completed-tasks';
  static const String technicienCurrentTasks = '/technicien/current-tasks';
  static const String technicienUrgentTasks = '/technicien/urgent-tasks';
  static const String technicienClockIn = '/technicien/clock-in';
  static const String technicienClockOut = '/technicien/clock-out';
  static const String technicienTimeSheet = '/technicien/time-sheet';
  static const String technicienDocuments = '/technicien/documents';
  static const String technicienUploadDocument = '/technicien/documents/upload';

  // Manager endpoints
  static const String managerDashboard = '/manager/dashboard';
  static const String myTeam = '/manager/my-team';
  static const String teamPerformance = '/manager/team-performance';
  static const String managerTeamTasks = '/manager/team-tasks';
  static const String managerTeamWorkload = '/manager/team/workload';
  static const String managerManagedProjects = '/manager/my-managed-projects';
  static const String managerBudgets = '/manager/my-budgets';
  static const String managerTeamReports = '/manager/team-reports';
  static const String managerAssignTask = '/manager/team/assign-task';
  static const String managerReassignTask = '/manager/team/reassign-task';
  static const String managerApproveTask = '/manager/approve-task';
  static const String managerApproveBudget = '/manager/approve-budget';
  static const String managerApproveTimesheet = '/manager/approve-timesheet';
  static const String managerProductivityReport =
      '/manager/reports/productivity';
  static const String managerBudgetVarianceReport =
      '/manager/reports/budget-variance';
  static const String managerTimelineReport = '/manager/reports/timeline';

  // Supervisor endpoints
  static const String supervisorDashboard = '/supervisor/dashboard';
  static const String myTeams = '/supervisor/my-teams';
  static const String qualityChecks = '/supervisor/quality-checks';
  static const String supervisorSupervisedProjects =
      '/supervisor/supervised-projects';
  static const String supervisorSupervisionReports =
      '/supervisor/supervision-reports';
  static const String supervisorIncidents = '/supervisor/incidents';
  static const String supervisorTechnicalIssues =
      '/supervisor/technical-issues';
  static const String supervisorPendingApprovals =
      '/supervisor/pending-approvals';
  static const String supervisorApproveQualityCheck =
      '/supervisor/quality-checks';
  static const String supervisorResolveIncident =
      '/supervisor/incidents/resolve';
  static const String supervisorTechnicalReview =
      '/supervisor/technical-review';
  static const String supervisorEscalateIssue = '/supervisor/escalate-issue';
  static const String supervisorFinalApproval = '/supervisor/final-approval';
  static const String supervisorTechnicalPerformanceReport =
      '/supervisor/reports/technical-performance';
  static const String supervisorQualityMetricsReport =
      '/supervisor/reports/quality-metrics';
  static const String supervisorEscalationsReport =
      '/supervisor/reports/escalations';

  // Méthodes utilitaires
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  static String getVersionedUrl(String endpoint) {
    return '$baseUrl/$version$endpoint';
  }

  // Configuration pour différents environnements
  static const bool isDevelopment = true;
  static const bool enableLogging = true;
  static const bool enableDebugMode = true;

  // Messages d'erreur
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur du serveur';
  static const String authenticationErrorMessage = 'Erreur d\'authentification';
  static const String validationErrorMessage = 'Erreur de validation';
  static const String unknownErrorMessage = 'Erreur inconnue';
}

<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ProjectController;
use App\Http\Controllers\Api\TaskController;
use App\Http\Controllers\Api\PersonnelController;
use App\Http\Controllers\Api\BudgetController;
use App\Http\Controllers\Api\WorkflowController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\TimeTrackingController;
use App\Http\Controllers\Api\MaterialController;
use App\Http\Controllers\Api\DeliveryController;
use App\Http\Controllers\Api\MediaController;
use App\Http\Controllers\Api\IssueController;
use App\Http\Controllers\Api\TechnicienController;
use App\Http\Controllers\Api\ManagerController;
use App\Http\Controllers\Api\SupervisorController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/health', [App\Http\Controllers\Api\HealthController::class, 'check']);

// Protected routes
Route::middleware(['auth:sanctum', 'api.logging'])->group(function () {
    // Auth routes
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Dashboard
    Route::prefix('dashboard')->group(function () {
        Route::get('/stats', [DashboardController::class, 'stats']);
        Route::get('/chart-data', [DashboardController::class, 'chartData']);
        Route::get('/quick-actions', [DashboardController::class, 'quickActions']);
        Route::get('/real-time-updates', [DashboardController::class, 'realTimeUpdates']);
        Route::get('/alerts', [DashboardController::class, 'alerts']);
        Route::get('/workload-distribution', [DashboardController::class, 'workloadDistribution']);
        Route::get('/project-analytics', [DashboardController::class, 'projectAnalytics']);
        Route::get('/task-efficiency', [DashboardController::class, 'taskEfficiency']);
        Route::get('/budget-analysis', [DashboardController::class, 'budgetAnalysis']);
    });

    // Projects
    Route::prefix('projects')->group(function () {
        Route::get('/', [ProjectController::class, 'index']);
        Route::post('/', [ProjectController::class, 'store'])->middleware('role:admin,manager');
        Route::get('/my-projects', [ProjectController::class, 'myProjects']);
        Route::get('/{project}', [ProjectController::class, 'show']);
        Route::put('/{project}', [ProjectController::class, 'update'])->middleware('role:admin,manager');
        Route::delete('/{project}', [ProjectController::class, 'destroy'])->middleware('role:admin');
        Route::get('/{project}/stats', [ProjectController::class, 'stats']);
        Route::put('/{project}/progress', [ProjectController::class, 'updateProgress'])->middleware('role:admin,manager,chef');
    });

    // Tasks
    Route::prefix('tasks')->group(function () {
        Route::get('/', [TaskController::class, 'index']);
        Route::post('/', [TaskController::class, 'store'])->middleware('permission:tasks.write');
        Route::get('/my-tasks', [TaskController::class, 'myTasks']);
        Route::get('/overdue-tasks', [TaskController::class, 'overdueTasks']);
        Route::get('/{task}', [TaskController::class, 'show']);
        Route::put('/{task}', [TaskController::class, 'update'])->middleware('permission:tasks.write');
        Route::delete('/{task}', [TaskController::class, 'destroy'])->middleware('permission:tasks.write');
        Route::put('/{task}/status', [TaskController::class, 'updateStatus'])->middleware('permission:tasks.write');
        Route::put('/{task}/progress', [TaskController::class, 'updateProgress'])->middleware('permission:tasks.write');
        Route::put('/{task}/assign', [TaskController::class, 'assign'])->middleware('permission:tasks.write');
    });

    // Personnel
    Route::prefix('personnel')->group(function () {
        Route::get('/', [PersonnelController::class, 'index']);
        Route::post('/', [PersonnelController::class, 'store'])->middleware('role:admin,manager');
        Route::get('/stats', [PersonnelController::class, 'stats']);
        Route::get('/department/{department}', [PersonnelController::class, 'byDepartment']);
        Route::get('/{personnel}', [PersonnelController::class, 'show']);
        Route::put('/{personnel}', [PersonnelController::class, 'update'])->middleware('role:admin,manager');
        Route::delete('/{personnel}', [PersonnelController::class, 'destroy'])->middleware('role:admin');
        Route::put('/{personnel}/status', [PersonnelController::class, 'updateStatus'])->middleware('role:admin,manager');
        Route::get('/{personnel}/skills', [PersonnelController::class, 'skills']);
        Route::put('/{personnel}/skills', [PersonnelController::class, 'updateSkills'])->middleware('role:admin,manager');
    });

    // Budget
    Route::prefix('budgets')->group(function () {
        Route::get('/', [BudgetController::class, 'index']);
        Route::post('/', [BudgetController::class, 'store'])->middleware('role:admin,manager');
        Route::get('/stats', [BudgetController::class, 'stats']);
        Route::get('/categories', [BudgetController::class, 'categories']);
        Route::get('/export', [BudgetController::class, 'export'])->middleware('role:admin,manager');
        Route::get('/project/{projectId}', [BudgetController::class, 'byProject']);
        Route::get('/{budget}', [BudgetController::class, 'show']);
        Route::put('/{budget}', [BudgetController::class, 'update'])->middleware('role:admin,manager');
        Route::delete('/{budget}', [BudgetController::class, 'destroy'])->middleware('role:admin');
    });

    // Workflows
    Route::prefix('workflows')->group(function () {
        Route::get('/', [WorkflowController::class, 'index']);
        Route::post('/', [WorkflowController::class, 'store']);
        Route::get('/types', [WorkflowController::class, 'types']);
        Route::get('/stats', [WorkflowController::class, 'stats']);
        Route::get('/{workflow}', [WorkflowController::class, 'show']);
        Route::put('/{workflow}', [WorkflowController::class, 'update']);
        Route::delete('/{workflow}', [WorkflowController::class, 'destroy']);
        Route::put('/{workflow}/activate', [WorkflowController::class, 'activate']);
        Route::put('/{workflow}/deactivate', [WorkflowController::class, 'deactivate']);
        Route::get('/{workflow}/steps', [WorkflowController::class, 'steps']);
        Route::put('/{workflow}/steps', [WorkflowController::class, 'updateSteps']);
        Route::post('/{workflow}/clone', [WorkflowController::class, 'clone']);
    });

    // Reports
    Route::prefix('reports')->group(function () {
        Route::get('/dashboard', [ReportController::class, 'dashboard']);
        Route::get('/project-performance', [ReportController::class, 'projectPerformance']);
        Route::get('/task-efficiency', [ReportController::class, 'taskEfficiency']);
        Route::get('/budget-analysis', [ReportController::class, 'budgetAnalysis']);
        Route::get('/user-productivity', [ReportController::class, 'userProductivity']);
        Route::get('/export', [ReportController::class, 'export']);
    });

    // Notifications
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::get('/unread-count', [NotificationController::class, 'unreadCount']);
        Route::put('/mark-all-read', [NotificationController::class, 'markAllAsRead']);
        Route::get('/types', [NotificationController::class, 'types']);
        Route::get('/preferences', [NotificationController::class, 'preferences']);
        Route::put('/preferences', [NotificationController::class, 'updatePreferences']);
        Route::post('/send-test', [NotificationController::class, 'sendTest']);
        Route::get('/stats', [NotificationController::class, 'stats']);
        Route::put('/{notification}/read', [NotificationController::class, 'markAsRead']);
        Route::put('/{notification}/archive', [NotificationController::class, 'archive']);
        Route::delete('/{notification}', [NotificationController::class, 'destroy']);
    });

    // User profile
    Route::prefix('profile')->group(function () {
        Route::get('/', function () {
            return response()->json(Auth::user());
        });

        Route::put('/', function (Request $request) {
            return response()->json([
                'message' => 'Profile update endpoint - to be implemented',
                'user' => Auth::user()
            ]);
        });
    });

    // Time Tracking (Pointage)
    Route::prefix('time-tracking')->group(function () {
        Route::post('/clock-in', [TimeTrackingController::class, 'clockIn']);
        Route::post('/clock-out', [TimeTrackingController::class, 'clockOut']);
        Route::get('/history', [TimeTrackingController::class, 'history']);
        Route::get('/team-status', [TimeTrackingController::class, 'teamStatus']);
        Route::get('/current', [TimeTrackingController::class, 'current']);
    });

    // Materials (Matériaux)
    Route::prefix('materials')->group(function () {
        Route::get('/', [MaterialController::class, 'index']);
        Route::post('/', [MaterialController::class, 'store'])->middleware('role:admin,manager,chef');
        Route::get('/low-stock', [MaterialController::class, 'lowStock']);
        Route::get('/{material}', [MaterialController::class, 'show']);
        Route::put('/{material}', [MaterialController::class, 'update'])->middleware('role:admin,manager,chef');
        Route::delete('/{material}', [MaterialController::class, 'destroy'])->middleware('role:admin,manager');
        Route::post('/{material}/update-stock', [MaterialController::class, 'updateStock'])->middleware('role:admin,manager,chef');
    });

    // Deliveries (Livraisons)
    Route::prefix('deliveries')->group(function () {
        Route::get('/', [DeliveryController::class, 'index']);
        Route::post('/', [DeliveryController::class, 'store'])->middleware('role:admin,manager,chef');
        Route::get('/upcoming', [DeliveryController::class, 'upcoming']);
        Route::get('/{delivery}', [DeliveryController::class, 'show']);
        Route::put('/{delivery}', [DeliveryController::class, 'update'])->middleware('role:admin,manager,chef');
        Route::delete('/{delivery}', [DeliveryController::class, 'destroy'])->middleware('role:admin,manager');
        Route::post('/{delivery}/receive', [DeliveryController::class, 'receive'])->middleware('role:admin,manager,chef');
        Route::post('/{delivery}/confirm', [DeliveryController::class, 'confirm'])->middleware('role:admin,manager,chef');
    });

    // Media (Photos/Documents)
    Route::prefix('media')->group(function () {
        Route::post('/upload', [MediaController::class, 'upload']);
        Route::get('/', [MediaController::class, 'index']);
        Route::get('/task/{taskId}', [MediaController::class, 'taskMedia']);
        Route::get('/project/{projectId}', [MediaController::class, 'projectMedia']);
        Route::get('/{media}', [MediaController::class, 'show']);
        Route::put('/{media}', [MediaController::class, 'update'])->middleware('role:admin,manager,chef');
        Route::delete('/{media}', [MediaController::class, 'destroy'])->middleware('role:admin,manager,chef');
    });

    // Issues (Problèmes/Signalisations)
    Route::prefix('issues')->group(function () {
        Route::get('/', [IssueController::class, 'index']);
        Route::post('/', [IssueController::class, 'store']);
        Route::get('/critical', [IssueController::class, 'critical']);
        Route::get('/my-assigned', [IssueController::class, 'myAssigned']);
        Route::get('/{issue}', [IssueController::class, 'show']);
        Route::put('/{issue}', [IssueController::class, 'update'])->middleware('role:admin,manager,chef');
        Route::delete('/{issue}', [IssueController::class, 'destroy'])->middleware('role:admin,manager');
        Route::post('/{issue}/resolve', [IssueController::class, 'resolve'])->middleware('role:admin,manager,chef');
        Route::post('/{issue}/assign', [IssueController::class, 'assign'])->middleware('role:admin,manager,chef');
    });

    // Technicien APIs
    Route::prefix('technicien')->group(function () {
        Route::get('/dashboard', [TechnicienController::class, 'dashboard']);
        Route::get('/stats', [TechnicienController::class, 'stats']);
        Route::get('/assigned-tasks', [TechnicienController::class, 'assignedTasks']);
        Route::get('/assigned-projects', [TechnicienController::class, 'assignedProjects']);
        Route::get('/performance', [TechnicienController::class, 'performance']);
        Route::get('/completed-tasks', [TechnicienController::class, 'completedTasks']);
        Route::get('/current-tasks', [TechnicienController::class, 'currentTasks']);
        Route::get('/urgent-tasks', [TechnicienController::class, 'urgentTasks']);
        Route::post('/clock-in', [TechnicienController::class, 'clockIn']);
        Route::post('/clock-out', [TechnicienController::class, 'clockOut']);
        Route::get('/time-sheet', [TechnicienController::class, 'timeSheet']);
        Route::post('/tasks/{task}/complete', [TechnicienController::class, 'completeTask']);
        Route::post('/tasks/{task}/validate', [TechnicienController::class, 'validateTask']);
        Route::post('/tasks/{task}/report-issue', [TechnicienController::class, 'reportIssue']);
        Route::get('/documents', [TechnicienController::class, 'documents']);
        Route::post('/documents/upload', [TechnicienController::class, 'uploadDocument']);
        Route::get('/documents/{documentId}', [TechnicienController::class, 'downloadDocument']);
    });

    // Manager APIs
    Route::prefix('manager')->group(function () {
        Route::get('/dashboard', [ManagerController::class, 'dashboard']);
        Route::get('/my-team', [ManagerController::class, 'myTeam']);
        Route::get('/my-managed-projects', [ManagerController::class, 'myManagedProjects']);
        Route::get('/my-budgets', [ManagerController::class, 'myBudgets']);
        Route::get('/team-performance', [ManagerController::class, 'teamPerformance']);
        Route::get('/team-tasks', [ManagerController::class, 'teamTasks']);
        Route::get('/team-reports', [ManagerController::class, 'teamReports']);
        Route::post('/team/assign-task', [ManagerController::class, 'assignTask']);
        Route::put('/team/reassign-task', [ManagerController::class, 'reassignTask']);
        Route::get('/team/workload', [ManagerController::class, 'teamWorkload']);
        Route::post('/approve-task/{task}', [ManagerController::class, 'approveTask']);
        Route::post('/approve-budget/{budget}', [ManagerController::class, 'approveBudget']);
        Route::post('/approve-timesheet', [ManagerController::class, 'approveTimesheet']);
        Route::get('/reports/productivity', [ManagerController::class, 'productivityReport']);
        Route::get('/reports/budget-variance', [ManagerController::class, 'budgetVarianceReport']);
        Route::get('/reports/timeline', [ManagerController::class, 'timelineReport']);
    });

    // Supervisor APIs
    Route::prefix('supervisor')->group(function () {
        Route::get('/dashboard', [SupervisorController::class, 'dashboard']);
        Route::get('/my-teams', [SupervisorController::class, 'myTeams']);
        Route::get('/supervised-projects', [SupervisorController::class, 'supervisedProjects']);
        Route::get('/supervision-reports', [SupervisorController::class, 'supervisionReports']);
        Route::get('/quality-checks', [SupervisorController::class, 'qualityChecks']);
        Route::post('/quality-checks/{check}/approve', [SupervisorController::class, 'approveQualityCheck']);
        Route::get('/incidents', [SupervisorController::class, 'incidents']);
        Route::post('/incidents/resolve', [SupervisorController::class, 'resolveIncident']);
        Route::post('/technical-review/{task}', [SupervisorController::class, 'technicalReview']);
        Route::get('/technical-issues', [SupervisorController::class, 'technicalIssues']);
        Route::post('/escalate-issue', [SupervisorController::class, 'escalateIssue']);
        Route::post('/final-approval/{project}', [SupervisorController::class, 'finalApproval']);
        Route::get('/pending-approvals', [SupervisorController::class, 'pendingApprovals']);
        Route::get('/reports/technical-performance', [SupervisorController::class, 'technicalPerformanceReport']);
        Route::get('/reports/quality-metrics', [SupervisorController::class, 'qualityMetricsReport']);
        Route::get('/reports/escalations', [SupervisorController::class, 'escalationsReport']);
    });
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

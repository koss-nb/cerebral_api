<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Project;
use App\Models\Task;
use App\Models\Personnel;
use App\Models\Budget;
use App\Models\Workflow;
use App\Models\Notification;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class DashboardControllerTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $adminUser;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Créer un utilisateur normal
        $this->user = User::factory()->create([
            'role' => 'user',
            'permissions' => ['tasks.read', 'notifications.read']
        ]);

        // Créer un utilisateur admin
        $this->adminUser = User::factory()->create([
            'role' => 'admin',
            'permissions' => ['all']
        ]);

        // Créer des données de test
        $this->createTestData();
    }

    private function createTestData(): void
    {
        // Créer des projets
        $projects = Project::factory()->count(5)->create([
            'manager_id' => $this->adminUser->id,
            'status' => 'active'
        ]);

        // Créer des tâches
        foreach ($projects as $project) {
            Task::factory()->count(3)->create([
                'project_id' => $project->id,
                'assigned_to' => $this->user->id,
                'status' => 'in_progress'
            ]);
        }

        // Créer du personnel
        Personnel::factory()->count(3)->create([
            'status' => 'active',
            'department' => 'IT'
        ]);

        // Créer des budgets
        Budget::factory()->count(3)->create([
            'project_id' => $projects->first()->id,
            'status' => 'pending'
        ]);

        // Créer des workflows
        Workflow::factory()->count(2)->create([
            'status' => 'active',
            'is_active' => true
        ]);

        // Créer des notifications
        Notification::factory()->count(5)->create([
            'user_id' => $this->user->id,
            'status' => 'unread'
        ]);
    }

    /** @test */
    public function it_can_get_dashboard_stats()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'overview',
                    'projects',
                    'tasks',
                    'personnel',
                    'budgets',
                    'workflows',
                    'notifications',
                    'performance'
                ]
            ]);

        $this->assertTrue($response->json('success'));
        $this->assertGreaterThan(0, $response->json('data.overview.total_projects'));
    }

    /** @test */
    public function it_can_get_chart_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/chart-data');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'project_timeline',
                    'task_status_distribution',
                    'budget_trends',
                    'personnel_performance',
                    'monthly_activity'
                ]
            ]);

        $this->assertTrue($response->json('success'));
        $this->assertCount(12, $response->json('data.project_timeline'));
    }

    /** @test */
    public function it_can_get_quick_actions_for_user()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/quick-actions');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'title',
                        'description',
                        'icon',
                        'route',
                        'permission'
                    ]
                ]
            ]);

        $this->assertTrue($response->json('success'));
        
        // Vérifier que l'utilisateur normal a accès aux actions de base
        $actions = $response->json('data');
        $this->assertContains('view_my_tasks', collect($actions)->pluck('id'));
        $this->assertContains('view_notifications', collect($actions)->pluck('id'));
    }

    /** @test */
    public function it_can_get_quick_actions_for_admin()
    {
        $response = $this->actingAs($this->adminUser)
            ->getJson('/api/dashboard/quick-actions');

        $response->assertStatus(200);
        
        // Vérifier que l'admin a accès aux actions avancées
        $actions = $response->json('data');
        $this->assertContains('create_project', collect($actions)->pluck('id'));
        $this->assertContains('manage_personnel', collect($actions)->pluck('id'));
        $this->assertContains('system_reports', collect($actions)->pluck('id'));
    }

    /** @test */
    public function it_can_get_real_time_updates()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/real-time-updates');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'last_updated',
                    'active_users',
                    'recent_activities',
                    'system_alerts',
                    'performance_metrics'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_dashboard_alerts()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/alerts');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'alerts',
                    'total_alerts',
                    'critical_alerts',
                    'last_checked'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_workload_distribution()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/workload-distribution');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'low_workload',
                    'medium_workload',
                    'high_workload',
                    'overloaded',
                    'personnel'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_project_analytics()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/project-analytics');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'completion_trends',
                    'performance_by_manager',
                    'budget_variance',
                    'timeline_efficiency',
                    'quality_metrics'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_task_efficiency()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/task-efficiency');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'completion_time',
                    'priority_distribution',
                    'assignee_performance',
                    'project_task_ratio'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_budget_analysis()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/budget-analysis');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'spending_trends',
                    'category_analysis',
                    'approval_efficiency',
                    'forecasting'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_projects_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/projects');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'name',
                        'status',
                        'progress',
                        'manager',
                        'task_count',
                        'completed_tasks',
                        'overdue_tasks',
                        'start_date',
                        'end_date',
                        'budget',
                        'is_overdue'
                    ]
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_tasks_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/tasks');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'title',
                        'status',
                        'priority',
                        'progress',
                        'project',
                        'assigned_to',
                        'due_date',
                        'is_overdue',
                        'estimated_hours',
                        'actual_hours'
                    ]
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_personnel_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/personnel');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'name',
                        'position',
                        'department',
                        'hire_date',
                        'manager',
                        'active_tasks',
                        'completed_tasks',
                        'performance_rating',
                        'skills',
                        'utilization_rate'
                    ]
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_budgets_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/budgets');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'category',
                        'amount',
                        'type',
                        'status',
                        'project',
                        'approved_by',
                        'is_approved',
                        'is_executed',
                        'due_date',
                        'execution_rate'
                    ]
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_workflows_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/workflows');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'pending_approvals',
                    'active_workflows',
                    'completed_workflows',
                    'workflows'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_notifications_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/notifications');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'unread',
                    'total',
                    'recent'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_can_get_reports_dashboard_data()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/reports');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'project_reports',
                    'task_reports',
                    'budget_reports',
                    'personnel_reports'
                ]
            ]);

        $this->assertTrue($response->json('success'));
    }

    /** @test */
    public function it_requires_authentication_for_all_endpoints()
    {
        $endpoints = [
            '/api/dashboard/stats',
            '/api/dashboard/chart-data',
            '/api/dashboard/quick-actions',
            '/api/dashboard/real-time-updates',
            '/api/dashboard/alerts',
            '/api/dashboard/workload-distribution',
            '/api/dashboard/project-analytics',
            '/api/dashboard/task-efficiency',
            '/api/dashboard/budget-analysis',
        ];

        foreach ($endpoints as $endpoint) {
            $response = $this->getJson($endpoint);
            $response->assertStatus(401);
        }
    }

    /** @test */
    public function it_handles_empty_data_gracefully()
    {
        // Supprimer toutes les données
        Project::query()->delete();
        Task::query()->delete();
        Personnel::query()->delete();
        Budget::query()->delete();
        Workflow::query()->delete();
        Notification::query()->delete();

        $response = $this->actingAs($this->user)
            ->getJson('/api/dashboard/stats');

        $response->assertStatus(200);
        
        // Vérifier que les compteurs sont à 0
        $this->assertEquals(0, $response->json('data.overview.total_projects'));
        $this->assertEquals(0, $response->json('data.overview.total_tasks'));
    }
}

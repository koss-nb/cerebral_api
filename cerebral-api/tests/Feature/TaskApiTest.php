<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Project;
use App\Models\Task;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class TaskApiTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    private User $admin;
    private User $manager;
    private User $user;
    private Project $project;
    private string $token;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Créer les utilisateurs de test avec les bonnes permissions
        $this->admin = User::factory()->create([
            'role' => 'admin',
            'permissions' => ['all', 'tasks.write', 'projects.write', 'personnel.write', 'budgets.write']
        ]);
        $this->manager = User::factory()->create([
            'role' => 'manager',
            'permissions' => ['projects.read', 'projects.write', 'tasks.read', 'tasks.write', 'personnel.read']
        ]);
        $this->user = User::factory()->create([
            'role' => 'user',
            'permissions' => ['projects.read', 'tasks.read']
        ]);
        
        // Créer un projet de test
        $this->project = Project::factory()->create(['manager_id' => $this->manager->id]);
        
        // Se connecter en tant qu'admin
        $response = $this->postJson('/api/login', [
            'email' => $this->admin->email,
            'password' => 'password'
        ]);
        
        $this->token = $response->json('token');
    }

    /** @test */
    public function it_can_create_a_task_with_valid_data()
    {
        $taskData = [
            'title' => 'Développer interface utilisateur',
            'description' => 'Créer une interface moderne et responsive pour le dashboard utilisateur',
            'project_id' => $this->project->id,
            'assigned_to' => $this->user->id,
            'status' => 'pending',
            'priority' => 'high',
            'estimated_hours' => 16.0,
            'start_date' => now()->addDays(1)->format('Y-m-d'),
            'due_date' => now()->addDays(7)->format('Y-m-d'),
            'created_by' => $this->admin->id
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/tasks', $taskData);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'success',
                    'message',
                    'task' => [
                        'id',
                        'title',
                        'description',
                        'project_id',
                        'assigned_to',
                        'status',
                        'priority'
                    ]
                ]);

        $this->assertDatabaseHas('tasks', [
            'title' => 'Développer interface utilisateur',
            'project_id' => $this->project->id
        ]);
    }

    /** @test */
    public function it_validates_required_fields_when_creating_task()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/tasks', []);

        $response->assertStatus(422)
                ->assertJsonValidationErrors([
                    'title',
                    'description',
                    'project_id',
                    'assigned_to',
                    'status',
                    'priority',
                    'created_by'
                ]);
    }

    /** @test */
    public function it_validates_date_logic_when_creating_task()
    {
        $taskData = [
            'title' => 'Tâche test dates',
            'description' => 'Description de la tâche',
            'project_id' => $this->project->id,
            'assigned_to' => $this->user->id,
            'status' => 'pending',
            'priority' => 'medium',
            'start_date' => now()->addDays(7)->format('Y-m-d'),
            'due_date' => now()->addDays(1)->format('Y-m-d'), // Date d'échéance avant date de début
            'created_by' => $this->admin->id
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/tasks', $taskData);

        $response->assertStatus(422)
                ->assertJsonValidationErrors(['due_date']);
    }

    /** @test */
    public function it_can_list_all_tasks()
    {
        // Créer quelques tâches
        Task::factory()->count(5)->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data' => [
                        '*' => [
                            'id',
                            'title',
                            'description',
                            'status',
                            'priority',
                            'progress'
                        ]
                    ]
                ]);

        $this->assertGreaterThanOrEqual(5, $response->json('data'));
    }

    /** @test */
    public function it_can_show_a_specific_task()
    {
        $task = Task::factory()->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/tasks/{$task->id}");

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'data' => [
                        'id' => $task->id,
                        'title' => $task->title
                    ]
                ]);
    }

    /** @test */
    public function it_returns_404_for_nonexistent_task()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks/99999');

        $response->assertStatus(404);
    }

    /** @test */
    public function it_can_update_task_status()
    {
        $task = Task::factory()->create([
            'project_id' => $this->project->id,
            'status' => 'pending',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/tasks/{$task->id}/status", [
            'status' => 'in_progress',
            'progress' => 25
        ]);

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Tâche mise à jour avec succès'
                ]);

        $this->assertDatabaseHas('tasks', [
            'id' => $task->id,
            'status' => 'in_progress',
            'progress' => 25
        ]);
    }

    /** @test */
    public function it_can_delete_a_task()
    {
        $task = Task::factory()->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->deleteJson("/api/tasks/{$task->id}");

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Tâche supprimée avec succès'
                ]);

        $this->assertDatabaseMissing('tasks', ['id' => $task->id]);
    }

    /** @test */
    public function it_filters_tasks_by_status()
    {
        Task::factory()->create(['status' => 'pending', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['status' => 'in_progress', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['status' => 'completed', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks?status=pending');

        $response->assertStatus(200);
        
        $tasks = $response->json('data');
        foreach ($tasks as $task) {
            $this->assertEquals('pending', $task['status']);
        }
    }

    /** @test */
    public function it_filters_tasks_by_priority()
    {
        Task::factory()->create(['priority' => 'low', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['priority' => 'high', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['priority' => 'critical', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks?priority=high');

        $response->assertStatus(200);
        
        $tasks = $response->json('data');
        foreach ($tasks as $task) {
            $this->assertEquals('high', $task['priority']);
        }
    }

    /** @test */
    public function it_searches_tasks_by_title()
    {
        Task::factory()->create(['title' => 'Développer API REST', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['title' => 'Corriger bug connexion', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);
        Task::factory()->create(['title' => 'Tester fonctionnalités', 'project_id' => $this->project->id, 'created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks?search=API');

        $response->assertStatus(200);
        
        $tasks = $response->json('data');
        $this->assertGreaterThan(0, count($tasks));
        // Vérifier que la recherche fonctionne en cherchant dans le titre
        $found = false;
        foreach ($tasks as $task) {
            if (str_contains($task['title'], 'API')) {
                $found = true;
                break;
            }
        }
        $this->assertTrue($found, 'Aucune tâche contenant "API" dans le titre n\'a été trouvée');
    }

    /** @test */
    public function it_paginates_tasks_correctly()
    {
        Task::factory()->count(25)->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/tasks?per_page=10');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'data',
                    'meta' => [
                        'current_page',
                        'per_page',
                        'total',
                        'last_page'
                    ]
                ]);

        $meta = $response->json('meta');
        $this->assertEquals(10, $meta['per_page']);
        $this->assertEquals(25, $meta['total']);
        $this->assertEquals(3, $meta['last_page']);
    }

    /** @test */
    public function it_requires_authentication_for_protected_routes()
    {
        $task = Task::factory()->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        // Test sans token
        $response = $this->getJson('/api/tasks');
        $response->assertStatus(401);

        $response = $this->postJson('/api/tasks', []);
        $response->assertStatus(401);

        $response = $this->getJson("/api/tasks/{$task->id}");
        $response->assertStatus(401);
    }

    /** @test */
    public function it_enforces_permission_based_access_control()
    {
        // Créer un utilisateur sans permission d'écriture des tâches
        $userWithoutPermission = User::factory()->create([
            'role' => 'user',
            'permissions' => ['projects.read', 'tasks.read'] // Pas de tasks.write
        ]);

        // Se connecter en tant qu'utilisateur sans permission
        $userResponse = $this->postJson('/api/login', [
            'email' => $userWithoutPermission->email,
            'password' => 'password'
        ]);
        
        $userToken = $userResponse->json('token');

        // L'utilisateur sans permission ne peut pas créer de tâche
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $userToken,
            'Accept' => 'application/json'
        ])->postJson('/api/tasks', [
            'title' => 'Tâche test',
            'description' => 'Description de la tâche',
            'project_id' => $this->project->id,
            'assigned_to' => $userWithoutPermission->id,
            'status' => 'pending',
            'priority' => 'medium',
            'created_by' => $userWithoutPermission->id
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function it_handles_large_task_data_correctly()
    {
        $largeDescription = str_repeat('Description très détaillée de la tâche avec beaucoup de contenu technique. ', 20); // Réduit à ~1000 caractères
        
        $taskData = [
            'title' => 'Tâche avec description très longue',
            'description' => $largeDescription,
            'project_id' => $this->project->id,
            'assigned_to' => $this->user->id,
            'status' => 'pending',
            'priority' => 'critical',
            'estimated_hours' => 999.5,
            'start_date' => now()->addDays(1)->format('Y-m-d'),
            'due_date' => now()->addDays(365)->format('Y-m-d'),
            'created_by' => $this->admin->id
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/tasks', $taskData);

        $response->assertStatus(201);
        
        $this->assertDatabaseHas('tasks', [
            'title' => 'Tâche avec description très longue',
            'estimated_hours' => 999.5
        ]);
    }
}

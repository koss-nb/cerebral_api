<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Project;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class ProjectApiTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    private User $admin;
    private User $manager;
    private User $user;
    private string $token;

    protected function setUp(): void
    {
        parent::setUp();

        // Créer les utilisateurs de test
        $this->admin = User::factory()->create(['role' => 'admin']);
        $this->manager = User::factory()->create(['role' => 'manager']);
        $this->user = User::factory()->create(['role' => 'user']);

        // Se connecter en tant qu'admin
        $response = $this->postJson('/api/login', [
            'email' => $this->admin->email,
            'password' => 'password'
        ]);

        $this->token = $response->json('token');
    }

    /** @test */
    public function it_can_create_a_project_with_valid_data()
    {
        $projectData = [
            'name' => 'Projet Test API',
            'description' => 'Description détaillée du projet de test pour l\'API',
            'type' => 'commercial',
            'start_date' => now()->addDays(1)->format('Y-m-d'),
            'end_date' => now()->addDays(30)->format('Y-m-d'),
            'budget' => 50000.00,
            'status' => 'planning',
            'priority' => 'high',
            'client_name' => 'Client Test',
            'client_email' => 'client@test.com',
            'location' => 'Paris, France',
            'manager_id' => $this->manager->id
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/projects', $projectData);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'success',
                'message',
                'project' => [
                    'id',
                    'name',
                    'description',
                    'type',
                    'start_date',
                    'end_date',
                    'budget',
                    'status',
                    'priority',
                    'client_name',
                    'client_email',
                    'location',
                    'manager_id'
                ]
            ]);

        $this->assertDatabaseHas('projects', [
            'name' => 'Projet Test API',
            'client_email' => 'client@test.com'
        ]);
    }

    /** @test */
    public function it_validates_required_fields_when_creating_project()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/projects', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors([
                'name',
                'type',
                'status',
                'location',
                'manager_id'
            ]);
    }

    /** @test */
    public function it_validates_date_logic_when_creating_project()
    {
        $projectData = [
            'name' => 'Projet Test Dates',
            'description' => 'Description du projet',
            'type' => 'commercial',
            'start_date' => now()->addDays(30)->format('Y-m-d'),
            'end_date' => now()->addDays(1)->format('Y-m-d'), // Date de fin avant date de début
            'budget' => 10000.00,
            'status' => 'planning',
            'priority' => 'medium',
            'client_name' => 'Client Test',
            'client_email' => 'client@test.com',
            'location' => 'Lyon, France',
            'manager_id' => $this->manager->id
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/projects', $projectData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['end_date']);
    }

    /** @test */
    public function it_can_list_all_projects()
    {
        // Créer quelques projets
        Project::factory()->count(5)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'name',
                        'description',
                        'status',
                        'priority',
                        'progress'
                    ]
                ],
                'meta' => [
                    'current_page',
                    'per_page',
                    'total'
                ]
            ]);

        $this->assertGreaterThanOrEqual(5, $response->json('data'));
    }

    /** @test */
    public function it_can_show_a_specific_project()
    {
        $project = Project::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/projects/{$project->id}");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'id' => $project->id,
                    'name' => $project->name
                ]
            ]);
    }

    /** @test */
    public function it_returns_404_for_nonexistent_project()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects/99999');

        $response->assertStatus(404);
    }

    /** @test */
    public function it_can_update_project_status()
    {
        $project = Project::factory()->create(['status' => 'planning']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/projects/{$project->id}/progress", [
            'status' => 'in_progress',
            'progress' => 25
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Projet mis à jour avec succès'
            ]);

        $this->assertDatabaseHas('projects', [
            'id' => $project->id,
            'status' => 'in_progress',
            'progress' => 25
        ]);
    }

    /** @test */
    public function it_can_delete_a_project()
    {
        $project = Project::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->deleteJson("/api/projects/{$project->id}");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Projet supprimé avec succès'
            ]);

        $this->assertDatabaseMissing('projects', ['id' => $project->id]);
    }

    /** @test */
    public function it_filters_projects_by_status()
    {
        Project::factory()->create(['status' => 'planning']);
        Project::factory()->create(['status' => 'in_progress']);
        Project::factory()->create(['status' => 'completed']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects?status=planning');

        $response->assertStatus(200);

        $projects = $response->json('data');
        foreach ($projects as $project) {
            $this->assertEquals('planning', $project['status']);
        }
    }

    /** @test */
    public function it_filters_projects_by_priority()
    {
        Project::factory()->create(['priority' => 'low']);
        Project::factory()->create(['priority' => 'high']);
        Project::factory()->create(['priority' => 'critical']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects?priority=high');

        $response->assertStatus(200);

        $projects = $response->json('data');
        foreach ($projects as $project) {
            $this->assertEquals('high', $project['priority']);
        }
    }

    /** @test */
    public function it_searches_projects_by_name()
    {
        Project::factory()->create(['name' => 'Projet Marketing Digital']);
        Project::factory()->create(['name' => 'Projet E-commerce']);
        Project::factory()->create(['name' => 'Projet Mobile App']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects?search=Marketing');

        $response->assertStatus(200);

        $projects = $response->json('data');
        $this->assertGreaterThan(0, count($projects));
        $this->assertStringContainsString('Marketing', $projects[0]['name']);
    }

    /** @test */
    public function it_paginates_projects_correctly()
    {
        Project::factory()->count(25)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/projects?per_page=10');

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
        $project = Project::factory()->create();

        // Test sans token
        $response = $this->getJson('/api/projects');
        $response->assertStatus(401);

        $response = $this->postJson('/api/projects', []);
        $response->assertStatus(401);

        $response = $this->getJson("/api/projects/{$project->id}");
        $response->assertStatus(401);
    }

    /** @test */
    public function it_enforces_role_based_access_control()
    {
        // Se connecter en tant qu'utilisateur standard
        $userResponse = $this->postJson('/api/login', [
            'email' => $this->user->email,
            'password' => 'password'
        ]);

        $userToken = $userResponse->json('token');

        // L'utilisateur standard ne peut pas créer de projet
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $userToken,
            'Accept' => 'application/json'
        ])->postJson('/api/projects', [
            'name' => 'Projet Test',
            'description' => 'Description'
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function it_handles_large_project_data_correctly()
    {
        $largeDescription = str_repeat('Description très détaillée du projet avec beaucoup de contenu. ', 100);

        $projectData = [
            'name' => 'Projet avec description très longue',
            'description' => $largeDescription,
            'type' => 'commercial',
            'start_date' => now()->addDays(1)->format('Y-m-d'),
            'end_date' => now()->addDays(365)->format('Y-m-d'),
            'budget' => 999999999.99,
            'status' => 'planning',
            'priority' => 'critical',
            'client_name' => 'Client Entreprise',
            'client_email' => 'contact@entreprise.com',
            'location' => 'Siège social, 123 Rue de la Paix, 75001 Paris, France',
            'manager_id' => $this->manager->id,
            'tags' => ['urgent', 'stratégique', 'innovation', 'digital', 'transformation']
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/projects', $projectData);

        $response->assertStatus(201);

        $this->assertDatabaseHas('projects', [
            'name' => 'Projet avec description très longue',
            'budget' => 999999999.99
        ]);
    }
}

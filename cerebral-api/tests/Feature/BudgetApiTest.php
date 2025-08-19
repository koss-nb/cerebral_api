<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Project;
use App\Models\Budget;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class BudgetApiTest extends TestCase
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
            'permissions' => ['all', 'budgets.write', 'projects.write', 'tasks.write', 'personnel.write']
        ]);
        $this->manager = User::factory()->create([
            'role' => 'manager',
            'permissions' => ['projects.read', 'projects.write', 'budgets.read', 'budgets.write']
        ]);
        $this->user = User::factory()->create([
            'role' => 'user',
            'permissions' => ['projects.read', 'budgets.read']
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
    public function it_can_create_budget_with_valid_data()
    {
        $budgetData = [
            'project_id' => $this->project->id,
            'category' => 'Développement',
            'description' => 'Budget pour le développement de nouvelles fonctionnalités',
            'amount' => 50000.00,
            'currency' => 'EUR',
            'type' => 'expense',
            'status' => 'planned',
            'fiscal_year' => 2025,
            'period' => 'monthly',
            'start_date' => now()->format('Y-m-d'),
            'end_date' => now()->addMonths(6)->format('Y-m-d'),
            'payment_method' => 'Virement',
            'payment_terms' => '30 jours',
            'vendor_supplier' => 'Fournisseur Test',
            'risk_level' => 'medium',
            'created_by' => $this->admin->id,
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/budgets', $budgetData);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'success',
                    'message',
                    'data' => [
                        'id',
                        'basic_info',
                        'financial_details',
                        'timeline',
                        'status'
                    ]
                ]);

        $this->assertDatabaseHas('budgets', [
            'project_id' => $this->project->id,
            'category' => 'Développement',
            'amount' => 50000.00,
            'type' => 'expense'
        ]);
    }

    /** @test */
    public function it_validates_required_fields_when_creating_budget()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/budgets', []);

        $response->assertStatus(422)
                ->assertJsonValidationErrors([
                    'project_id',
                    'category',
                    'description',
                    'amount',
                    'type',
                    'status',
                    'fiscal_year',
                    'start_date',
                    'end_date',
                    'created_by'
                ]);
    }

    /** @test */
    public function it_can_list_all_budgets()
    {
        Budget::factory()->count(5)->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data',
                    'meta' => [
                        'current_page',
                        'last_page',
                        'per_page',
                        'total'
                    ]
                ]);

        $this->assertEquals(5, $response->json('meta.total'));
    }

    /** @test */
    public function it_can_show_specific_budget()
    {
        $budget = Budget::factory()->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/budgets/{$budget->id}");

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data' => [
                        'id',
                        'basic_info',
                        'financial_details',
                        'timeline',
                        'status'
                    ]
                ]);
    }

    /** @test */
    public function it_returns_404_for_nonexistent_budget()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets/99999');

        $response->assertStatus(404);
    }

    /** @test */
    public function it_can_update_budget()
    {
        $budget = Budget::factory()->create(['created_by' => $this->admin->id]);

        $updateData = [
            'amount' => 75000.00,
            'status' => 'approved',
            'risk_level' => 'high',
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/budgets/{$budget->id}", $updateData);

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Budget mis à jour avec succès'
                ]);

        $this->assertDatabaseHas('budgets', [
            'id' => $budget->id,
            'amount' => 75000.00,
            'status' => 'approved',
            'risk_level' => 'high'
        ]);
    }

    /** @test */
    public function it_can_delete_budget()
    {
        $budget = Budget::factory()->create([
            'created_by' => $this->admin->id,
            'is_approved' => false,
            'is_executed' => false
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->deleteJson("/api/budgets/{$budget->id}");

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Budget supprimé avec succès'
                ]);

        $this->assertDatabaseMissing('budgets', ['id' => $budget->id]);
    }

    /** @test */
    public function it_cannot_delete_approved_budget()
    {
        $budget = Budget::factory()->create([
            'created_by' => $this->admin->id,
            'is_approved' => true,
            'is_executed' => false
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->deleteJson("/api/budgets/{$budget->id}");

        $response->assertStatus(422)
                ->assertJson([
                    'success' => false,
                    'message' => 'Impossible de supprimer un budget approuvé ou exécuté'
                ]);

        $this->assertDatabaseHas('budgets', ['id' => $budget->id]);
    }

    /** @test */
    public function it_can_approve_budget()
    {
        $budget = Budget::factory()->create([
            'created_by' => $this->admin->id,
            'is_approved' => false
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson("/api/budgets/{$budget->id}/approve");

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Budget approuvé avec succès'
                ]);

        $this->assertDatabaseHas('budgets', [
            'id' => $budget->id,
            'is_approved' => true,
            'status' => 'approved'
        ]);
    }

    /** @test */
    public function it_cannot_approve_already_approved_budget()
    {
        $budget = Budget::factory()->create([
            'created_by' => $this->admin->id,
            'is_approved' => true
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson("/api/budgets/{$budget->id}/approve");

        $response->assertStatus(422)
                ->assertJson([
                    'success' => false,
                    'message' => 'Ce budget est déjà approuvé'
                ]);
    }

    /** @test */
    public function it_can_get_budget_statistics()
    {
        Budget::factory()->count(3)->create([
            'type' => 'expense',
            'amount' => 10000.00,
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->count(2)->create([
            'type' => 'income',
            'amount' => 15000.00,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets/stats');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data' => [
                        'total',
                        'total_amount',
                        'approved',
                        'executed',
                        'pending',
                        'by_type',
                        'by_category'
                    ]
                ]);

        $this->assertEquals(5, $response->json('data.total'));
        $this->assertEquals(60000.00, $response->json('data.total_amount'));
    }

    /** @test */
    public function it_can_get_budget_categories()
    {
        Budget::factory()->create([
            'category' => 'Développement',
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->create([
            'category' => 'Design',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets/categories');

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'data' => ['Développement', 'Design']
                ]);
    }

    /** @test */
    public function it_can_get_budgets_by_project()
    {
        Budget::factory()->count(3)->create([
            'project_id' => $this->project->id,
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/budgets/project/{$this->project->id}");

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data' => [
                        'project',
                        'budgets',
                        'stats'
                    ]
                ]);

        $this->assertEquals(3, $response->json('data.stats.total_budgets'));
    }

    /** @test */
    public function it_can_export_budgets()
    {
        Budget::factory()->count(5)->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/budgets/export', [
            'format' => 'json'
        ]);

        $response->assertStatus(200)
                ->assertJson([
                    'success' => true,
                    'message' => 'Export généré avec succès'
                ]);

        $this->assertEquals(5, $response->json('data.count'));
    }

    /** @test */
    public function it_filters_budgets_by_status()
    {
        Budget::factory()->count(3)->create([
            'status' => 'planned',
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->count(2)->create([
            'status' => 'approved',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets?status=planned');

        $response->assertStatus(200);
        $this->assertEquals(3, $response->json('meta.total'));
    }

    /** @test */
    public function it_filters_budgets_by_type()
    {
        Budget::factory()->count(4)->create([
            'type' => 'expense',
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->count(2)->create([
            'type' => 'income',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets?type=expense');

        $response->assertStatus(200);
        $this->assertEquals(4, $response->json('meta.total'));
    }

    /** @test */
    public function it_filters_budgets_by_category()
    {
        Budget::factory()->count(3)->create([
            'category' => 'Développement',
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->count(2)->create([
            'category' => 'Design',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets?category=Développement');

        $response->assertStatus(200);
        $this->assertEquals(3, $response->json('meta.total'));
    }

    /** @test */
    public function it_searches_budgets()
    {
        Budget::factory()->create([
            'description' => 'Budget développement API',
            'vendor_supplier' => 'Fournisseur API',
            'created_by' => $this->admin->id
        ]);

        Budget::factory()->create([
            'description' => 'Budget design interface',
            'vendor_supplier' => 'Designer UX',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets?search=API');

        $response->assertStatus(200);
        $this->assertEquals(1, $response->json('meta.total'));
    }

    /** @test */
    public function it_paginates_budgets_correctly()
    {
        Budget::factory()->count(25)->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/budgets?per_page=10');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data',
                    'meta' => [
                        'current_page',
                        'last_page',
                        'per_page',
                        'total'
                    ]
                ]);

        $this->assertEquals(10, $response->json('meta.per_page'));
        $this->assertEquals(25, $response->json('meta.total'));
        $this->assertEquals(3, $response->json('meta.last_page'));
    }

    /** @test */
    public function it_requires_authentication_for_protected_routes()
    {
        $response = $this->getJson('/api/budgets');

        $response->assertStatus(401);
    }

    /** @test */
    public function it_enforces_role_based_access_control()
    {
        // Se connecter en tant qu'utilisateur standard (pas de permission d'écriture)
        $userResponse = $this->postJson('/api/login', [
            'email' => $this->user->email,
            'password' => 'password'
        ]);
        
        $userToken = $userResponse->json('token');

        $budgetData = [
            'project_id' => $this->project->id,
            'category' => 'Test',
            'description' => 'Budget test',
            'amount' => 1000.00,
            'type' => 'expense',
            'status' => 'planned',
            'fiscal_year' => 2025,
            'start_date' => now()->format('Y-m-d'),
            'end_date' => now()->addMonth()->format('Y-m-d'),
            'created_by' => $this->user->id,
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $userToken,
            'Accept' => 'application/json'
        ])->postJson('/api/budgets', $budgetData);

        $response->assertStatus(403);
    }
}

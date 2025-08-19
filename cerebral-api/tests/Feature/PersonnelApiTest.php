<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Personnel;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class PersonnelApiTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    private User $admin;
    private User $manager;
    private User $user;
    private string $token;

    protected function setUp(): void
    {
        parent::setUp();

        // Créer les utilisateurs de test avec les bonnes permissions
        $this->admin = User::factory()->create([
            'role' => 'admin',
            'permissions' => ['all', 'personnel.write', 'projects.write', 'tasks.write', 'budgets.write']
        ]);
        $this->manager = User::factory()->create([
            'role' => 'manager',
            'permissions' => ['projects.read', 'projects.write', 'personnel.read', 'personnel.write']
        ]);
        $this->user = User::factory()->create([
            'role' => 'user',
            'permissions' => ['projects.read', 'personnel.read']
        ]);

        // Se connecter en tant qu'admin
        $response = $this->postJson('/api/login', [
            'email' => $this->admin->email,
            'password' => 'password'
        ]);

        $this->token = $response->json('token');
    }

    /** @test */
    public function it_can_create_personnel_with_valid_data()
    {
        $personnelData = [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean.dupont@cerebral.com',
            'phone' => '+33123456789',
            'position' => 'Développeur Full Stack',
            'department' => 'Développement',
            'hire_date' => now()->format('Y-m-d'),
            'salary' => 4500.00,
            'status' => 'active',
            'employee_id' => 'EMP1001',
            'contract_type' => 'full_time',
            'work_schedule' => '9h-18h',
            'overtime_eligible' => true,
            'remote_work_allowed' => true,
            'created_by' => $this->admin->id,
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/personnel', $personnelData);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    'id',
                    'personal_info',
                    'professional_info',
                    'status',
                    'compensation'
                ]
            ]);

        $this->assertDatabaseHas('personnels', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean.dupont@cerebral.com',
            'employee_id' => 'EMP1001'
        ]);
    }

    /** @test */
    public function it_validates_required_fields_when_creating_personnel()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->postJson('/api/personnel', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors([
                'first_name',
                'last_name',
                'email',
                'position',
                'department',
                'hire_date',
                'employee_id',
                'created_by'
            ]);
    }

    /** @test */
    public function it_can_list_all_personnel()
    {
        Personnel::factory()->count(5)->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel');

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
    public function it_can_show_specific_personnel()
    {
        $personnel = Personnel::factory()->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/personnel/{$personnel->id}");

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'id',
                    'personal_info',
                    'professional_info',
                    'status'
                ]
            ]);
    }

    /** @test */
    public function it_returns_404_for_nonexistent_personnel()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel/99999');

        $response->assertStatus(404);
    }

    /** @test */
    public function it_can_update_personnel()
    {
        $personnel = Personnel::factory()->create(['created_by' => $this->admin->id]);

        $updateData = [
            'position' => 'Senior Développeur Full Stack',
            'salary' => 5500.00,
            'status' => 'active',
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/personnel/{$personnel->id}", $updateData);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Personnel mis à jour avec succès'
            ]);

        $this->assertDatabaseHas('personnels', [
            'id' => $personnel->id,
            'position' => 'Senior Développeur Full Stack',
            'salary' => 5500.00
        ]);
    }

    /** @test */
    public function it_can_delete_personnel()
    {
        $personnel = Personnel::factory()->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->deleteJson("/api/personnel/{$personnel->id}");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Personnel supprimé avec succès'
            ]);

        $this->assertDatabaseMissing('personnels', ['id' => $personnel->id]);
    }

    /** @test */
    public function it_can_update_personnel_status()
    {
        $personnel = Personnel::factory()->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/personnel/{$personnel->id}/status", [
            'status' => 'on_leave'
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Statut du personnel mis à jour avec succès'
            ]);

        $this->assertDatabaseHas('personnels', [
            'id' => $personnel->id,
            'status' => 'on_leave'
        ]);
    }

    /** @test */
    public function it_can_update_personnel_skills()
    {
        $personnel = Personnel::factory()->create(['created_by' => $this->admin->id]);

        $skills = ['PHP', 'Laravel', 'JavaScript', 'Vue.js'];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->putJson("/api/personnel/{$personnel->id}/skills", [
            'skills' => $skills
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Compétences du personnel mises à jour avec succès'
            ]);

        $this->assertDatabaseHas('personnels', [
            'id' => $personnel->id,
            'skills' => json_encode($skills)
        ]);
    }

    /** @test */
    public function it_can_get_personnel_skills()
    {
        $personnel = Personnel::factory()->create([
            'created_by' => $this->admin->id,
            'skills' => ['PHP', 'Laravel'],
            'certifications' => ['AWS Certified'],
            'languages' => ['Français', 'Anglais']
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson("/api/personnel/{$personnel->id}/skills");

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'personnel_id',
                    'name',
                    'skills',
                    'certifications',
                    'languages'
                ]
            ]);
    }

    /** @test */
    public function it_can_get_personnel_by_department()
    {
        Personnel::factory()->count(3)->create([
            'department' => 'Développement',
            'status' => 'active',
            'created_by' => $this->admin->id
        ]);

        Personnel::factory()->count(2)->create([
            'department' => 'Design',
            'status' => 'active',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel/department/Développement');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'meta' => [
                    'department' => 'Développement',
                    'count' => 3
                ]
            ]);
    }

    /** @test */
    public function it_can_get_personnel_statistics()
    {
        Personnel::factory()->count(5)->create([
            'status' => 'active',
            'created_by' => $this->admin->id
        ]);

        Personnel::factory()->count(2)->create([
            'status' => 'inactive',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'total',
                    'active',
                    'inactive',
                    'on_leave',
                    'terminated',
                    'by_department',
                    'by_contract_type'
                ]
            ]);

        $this->assertEquals(7, $response->json('data.total'));
        $this->assertEquals(5, $response->json('data.active'));
        $this->assertEquals(2, $response->json('data.inactive'));
    }

    /** @test */
    public function it_can_get_personnel_hierarchy()
    {
        $manager = Personnel::factory()->create([
            'created_by' => $this->admin->id,
            'manager_id' => null
        ]);

        Personnel::factory()->count(3)->create([
            'created_by' => $this->admin->id,
            'manager_id' => $manager->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel/hierarchy');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    '*' => [
                        'id',
                        'name',
                        'position',
                        'department',
                        'subordinates'
                    ]
                ]
            ]);

        $this->assertEquals(1, count($response->json('data')));
        $this->assertEquals(3, count($response->json('data.0.subordinates')));
    }

    /** @test */
    public function it_filters_personnel_by_status()
    {
        Personnel::factory()->count(3)->create([
            'status' => 'active',
            'created_by' => $this->admin->id
        ]);

        Personnel::factory()->count(2)->create([
            'status' => 'inactive',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel?status=active');

        $response->assertStatus(200);
        $this->assertEquals(3, $response->json('meta.total'));
    }

    /** @test */
    public function it_filters_personnel_by_department()
    {
        Personnel::factory()->count(4)->create([
            'department' => 'Développement',
            'created_by' => $this->admin->id
        ]);

        Personnel::factory()->count(2)->create([
            'department' => 'Design',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel?department=Développement');

        $response->assertStatus(200);
        $this->assertEquals(4, $response->json('meta.total'));
    }

    /** @test */
    public function it_searches_personnel()
    {
        Personnel::factory()->create([
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'position' => 'Développeur',
            'created_by' => $this->admin->id
        ]);

        Personnel::factory()->create([
            'first_name' => 'Marie',
            'last_name' => 'Martin',
            'position' => 'Designer',
            'created_by' => $this->admin->id
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel?search=Jean');

        $response->assertStatus(200);
        $this->assertEquals(1, $response->json('meta.total'));
    }

    /** @test */
    public function it_paginates_personnel_correctly()
    {
        Personnel::factory()->count(25)->create(['created_by' => $this->admin->id]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
            'Accept' => 'application/json'
        ])->getJson('/api/personnel?per_page=10');

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
        $response = $this->getJson('/api/personnel');

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

        $personnelData = [
            'first_name' => 'Test',
            'last_name' => 'User',
            'email' => 'test@cerebral.com',
            'position' => 'Testeur',
            'department' => 'Test',
            'hire_date' => now()->format('Y-m-d'),
            'employee_id' => 'EMP9999',
            'created_by' => $this->user->id,
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $userToken,
            'Accept' => 'application/json'
        ])->postJson('/api/personnel', $personnelData);

        $response->assertStatus(403);
    }
}

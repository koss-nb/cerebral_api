<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_have_role()
    {
        $user = User::factory()->create([
            'role' => 'manager'
        ]);

        $this->assertTrue($user->hasRole('manager'));
        $this->assertFalse($user->hasRole('admin'));
    }

    public function test_user_can_have_multiple_roles()
    {
        $user = User::factory()->create([
            'role' => 'manager'
        ]);

        $this->assertTrue($user->hasAnyRole(['admin', 'manager']));
        $this->assertFalse($user->hasAnyRole(['admin', 'chef']));
    }

    public function test_user_can_have_permissions()
    {
        $user = User::factory()->create([
            'permissions' => ['projects.read', 'tasks.write']
        ]);

        $this->assertTrue($user->hasPermission('projects.read'));
        $this->assertTrue($user->hasPermission('tasks.write'));
        $this->assertFalse($user->hasPermission('personnel.read'));
    }

    public function test_admin_user_has_all_permissions()
    {
        $user = User::factory()->create([
            'role' => 'admin',
            'permissions' => ['all']
        ]);

        $this->assertTrue($user->hasPermission('any.permission'));
        $this->assertTrue($user->hasAnyPermission(['permission1', 'permission2']));
    }

    public function test_user_permission_methods_with_null_permissions()
    {
        $user = User::factory()->create([
            'permissions' => null
        ]);

        $this->assertFalse($user->hasPermission('any.permission'));
        $this->assertFalse($user->hasAnyPermission(['permission1', 'permission2']));
    }

    public function test_user_display_name()
    {
        $user = User::factory()->create([
            'first_name' => 'John',
            'last_name' => 'Doe'
        ]);

        $this->assertEquals('John Doe', $user->full_name);
        $this->assertEquals('John Doe', $user->display_name);
        $this->assertEquals('JD', $user->initials);
    }

    public function test_user_relationships()
    {
        $user = User::factory()->create();

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $user->managedProjects());
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $user->assignedTasks());
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $user->createdTasks());
    }
}

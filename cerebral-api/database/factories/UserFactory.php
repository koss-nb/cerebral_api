<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * The current password being used by the factory.
     */
    protected static ?string $password;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $role = $this->faker->randomElement(['admin', 'manager', 'chef', 'technicien', 'user']);

        return [
            'first_name' => $this->faker->firstName(),
            'last_name' => $this->faker->lastName(),
            'email' => $this->faker->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => static::$password ??= Hash::make('password'),
            'role' => $role,
            'permissions' => $this->getDefaultPermissions($role),
            'phone_number' => $this->faker->phoneNumber(),
            'department' => $this->faker->randomElement(['IT', 'Marketing', 'Sales', 'HR', 'Engineering']),
            'avatar_url' => null,
            'is_active' => true,
            'preferences' => null,
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     */
    public function unverified(): static
    {
        return $this->state(fn(array $attributes) => [
            'email_verified_at' => null,
        ]);
    }

    /**
     * Get default permissions based on role.
     */
    private function getDefaultPermissions(string $role): array
    {
        return match ($role) {
            'admin' => ['all'],
            'manager' => ['projects.read', 'projects.write', 'tasks.read', 'tasks.write', 'personnel.read'],
            'chef' => ['projects.read', 'tasks.read', 'tasks.write', 'personnel.read'],
            'technicien' => ['projects.read', 'tasks.read', 'tasks.write'],
            'user' => ['projects.read', 'tasks.read'],
            default => ['projects.read'],
        };
    }

    /**
     * Configure the model factory.
     */
    public function admin(): static
    {
        return $this->state(fn(array $attributes) => [
            'role' => 'admin',
            'permissions' => ['all'],
        ]);
    }

    /**
     * Configure the model factory.
     */
    public function manager(): static
    {
        return $this->state(fn(array $attributes) => [
            'role' => 'manager',
            'permissions' => ['projects.read', 'projects.write', 'tasks.read', 'tasks.write', 'personnel.read'],
        ]);
    }

    /**
     * Configure the model factory.
     */
    public function technicien(): static
    {
        return $this->state(fn(array $attributes) => [
            'role' => 'technicien',
            'permissions' => ['projects.read', 'tasks.read', 'tasks.write'],
        ]);
    }
}

<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create admin user
        User::create([
            'first_name' => 'Admin',
            'last_name' => 'Cerebral',
            'email' => 'admin@cerebral.com',
            'password' => Hash::make('password123'),
            'role' => 'admin',
            'permissions' => ['all', 'tasks.write', 'projects.write', 'personnel.write', 'budgets.write'],
            'phone_number' => '+33123456789',
            'department' => 'Direction',
            'is_active' => true,
        ]);

        // Create manager user
        User::create([
            'first_name' => 'Manager',
            'last_name' => 'Projet',
            'email' => 'manager@cerebral.com',
            'password' => Hash::make('password123'),
            'role' => 'manager',
            'permissions' => ['projects.read', 'projects.write', 'tasks.read', 'tasks.write', 'personnel.read'],
            'phone_number' => '+33123456790',
            'department' => 'Gestion de Projet',
            'is_active' => true,
        ]);

        // Create chef de chantier
        User::create([
            'first_name' => 'Chef',
            'last_name' => 'Chantier',
            'email' => 'chef@cerebral.com',
            'password' => Hash::make('password123'),
            'role' => 'chef',
            'permissions' => ['projects.read', 'tasks.read', 'tasks.write', 'personnel.read'],
            'phone_number' => '+33123456791',
            'department' => 'Chantier',
            'is_active' => true,
        ]);

        // Create technicien
        User::create([
            'first_name' => 'Technicien',
            'last_name' => 'Specialiste',
            'email' => 'technicien@cerebral.com',
            'password' => Hash::make('password123'),
            'role' => 'technicien',
            'permissions' => ['projects.read', 'tasks.read', 'tasks.write'],
            'phone_number' => '+33123456792',
            'department' => 'Technique',
            'is_active' => true,
        ]);

        // Create regular user
        User::create([
            'first_name' => 'Utilisateur',
            'last_name' => 'Standard',
            'email' => 'user@cerebral.com',
            'password' => Hash::make('password123'),
            'role' => 'user',
            'permissions' => ['projects.read', 'tasks.read'],
            'phone_number' => '+33123456793',
            'department' => 'Général',
            'is_active' => true,
        ]);

        $this->command->info('Users seeded successfully!');
    }
}

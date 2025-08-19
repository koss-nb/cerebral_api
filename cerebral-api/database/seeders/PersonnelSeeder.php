<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Personnel;
use App\Models\User;

class PersonnelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();

        // Personnel pour l'admin
        $adminUser = $users->where('email', 'admin@cerebral.com')->first();
        if ($adminUser) {
            Personnel::create([
                'first_name' => 'Admin',
                'last_name' => 'Cerebral',
                'email' => 'admin@cerebral.com',
                'phone' => '+33123456789',
                'employee_id' => 'EMP001',
                'position' => 'Directeur Général',
                'department' => 'Direction',
                'hire_date' => '2020-01-15',
                'salary' => 85000.00,
                'status' => 'active',
                'skills' => ['gestion', 'stratégie', 'leadership', 'finance'],
                'emergency_contact' => [
                    'name' => 'Marie Admin',
                    'phone' => '+33123456788',
                    'relationship' => 'Conjoint'
                ],
                'created_by' => $adminUser->id,
            ]);
        }

        // Personnel pour le manager
        $managerUser = $users->where('email', 'manager@cerebral.com')->first();
        if ($managerUser) {
            Personnel::create([
                'first_name' => 'Manager',
                'last_name' => 'Cerebral',
                'email' => 'manager@cerebral.com',
                'phone' => '+33123456789',
                'employee_id' => 'EMP002',
                'position' => 'Chef de Projet Senior',
                'department' => 'Gestion de Projet',
                'hire_date' => '2021-03-01',
                'salary' => 65000.00,
                'status' => 'active',
                'skills' => ['gestion_projet', 'planification', 'coordination', 'budget'],
                'emergency_contact' => [
                    'name' => 'Pierre Manager',
                    'phone' => '+33123456789',
                    'relationship' => 'Conjoint'
                ],
                'created_by' => $managerUser->id,
            ]);
        }

        // Personnel pour le chef de chantier
        $chefUser = $users->where('email', 'chef@cerebral.com')->first();
        if ($chefUser) {
            Personnel::create([
                'first_name' => 'Chef',
                'last_name' => 'Cerebral',
                'email' => 'chef@cerebral.com',
                'phone' => '+33123456790',
                'employee_id' => 'EMP003',
                'position' => 'Chef de Chantier',
                'department' => 'Chantier',
                'hire_date' => '2021-06-15',
                'salary' => 55000.00,
                'status' => 'active',
                'skills' => ['supervision', 'sécurité', 'coordination_équipe', 'lecture_plans'],
                'emergency_contact' => [
                    'name' => 'Sophie Chef',
                    'phone' => '+33123456790',
                    'relationship' => 'Conjoint'
                ],
                'created_by' => $chefUser->id,
            ]);
        }

        // Personnel pour le technicien
        $technicienUser = $users->where('email', 'technicien@cerebral.com')->first();
        if ($technicienUser) {
            Personnel::create([
                'first_name' => 'Technicien',
                'last_name' => 'Cerebral',
                'email' => 'technicien@cerebral.com',
                'phone' => '+33123456791',
                'employee_id' => 'EMP004',
                'position' => 'Technicien Spécialisé',
                'department' => 'Technique',
                'hire_date' => '2022-01-10',
                'salary' => 45000.00,
                'status' => 'active',
                'skills' => ['électricité', 'plomberie', 'maintenance', 'diagnostic'],
                'emergency_contact' => [
                    'name' => 'Jean Technicien',
                    'phone' => '+33123456791',
                    'relationship' => 'Conjoint'
                ],
                'created_by' => $technicienUser->id,
            ]);
        }

        // Personnel pour l'utilisateur standard
        $userStandard = $users->where('email', 'user@cerebral.com')->first();
        if ($userStandard) {
            Personnel::create([
                'first_name' => 'User',
                'last_name' => 'Cerebral',
                'email' => 'user@cerebral.com',
                'phone' => '+33123456792',
                'employee_id' => 'EMP005',
                'position' => 'Assistant Administratif',
                'department' => 'Général',
                'hire_date' => '2022-09-01',
                'salary' => 35000.00,
                'status' => 'active',
                'skills' => ['administration', 'comptabilité', 'communication', 'organisation'],
                'emergency_contact' => [
                    'name' => 'Lucie User',
                    'phone' => '+33123456792',
                    'relationship' => 'Conjoint'
                ],
                'created_by' => $userStandard->id,
            ]);
        }

        $this->command->info('Personnel seeded successfully!');
    }
}

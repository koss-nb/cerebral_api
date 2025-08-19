<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Task;
use App\Models\Project;
use App\Models\User;

class TaskSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $projects = Project::all();
        $users = User::all();

        // Tâches pour le projet de rénovation
        $renovationProject = $projects->where('name', 'Rénovation Appartement 3 Pièces')->first();
        if ($renovationProject) {
            Task::create([
                'title' => 'Démolition des cloisons',
                'description' => 'Retirer toutes les cloisons non porteuses et nettoyer les débris',
                'status' => 'completed',
                'priority' => 'high',
                'project_id' => $renovationProject->id,
                'assigned_to' => $users->where('email', 'technicien@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'manager@cerebral.com')->first()->id,
                'due_date' => '2024-02-15',
                'start_date' => '2024-01-20',
                'completed_at' => '2024-02-10',
                'progress' => 100.0,
                'estimated_hours' => 16,
                'actual_hours' => 14,
            ]);

            Task::create([
                'title' => 'Installation électrique',
                'description' => 'Remplacer tout le système électrique et installer de nouveaux points lumineux',
                'status' => 'in_progress',
                'priority' => 'high',
                'project_id' => $renovationProject->id,
                'assigned_to' => $users->where('email', 'technicien@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'manager@cerebral.com')->first()->id,
                'due_date' => '2024-03-15',
                'start_date' => '2024-02-20',
                'progress' => 60.0,
                'estimated_hours' => 24,
                'actual_hours' => 18,
            ]);

            Task::create([
                'title' => 'Peinture des murs',
                'description' => 'Préparer les murs et appliquer la peinture finale',
                'status' => 'pending',
                'priority' => 'medium',
                'project_id' => $renovationProject->id,
                'assigned_to' => $users->where('email', 'chef@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'manager@cerebral.com')->first()->id,
                'due_date' => '2024-04-15',
                'progress' => 0.0,
                'estimated_hours' => 20,
            ]);
        }

        // Tâches pour le projet de construction de bureau
        $bureauProject = $projects->where('name', 'Construction Bureau Moderne')->first();
        if ($bureauProject) {
            Task::create([
                'title' => 'Excavation et fondations',
                'description' => 'Creuser les fondations et couler le béton',
                'status' => 'in_progress',
                'priority' => 'urgent',
                'project_id' => $bureauProject->id,
                'assigned_to' => $users->where('email', 'chef@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'chef@cerebral.com')->first()->id,
                'due_date' => '2024-04-30',
                'start_date' => '2024-03-15',
                'progress' => 40.0,
                'estimated_hours' => 80,
                'actual_hours' => 45,
            ]);

            Task::create([
                'title' => 'Structure métallique',
                'description' => 'Monter la structure métallique du bâtiment',
                'status' => 'pending',
                'priority' => 'high',
                'project_id' => $bureauProject->id,
                'assigned_to' => $users->where('email', 'technicien@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'chef@cerebral.com')->first()->id,
                'due_date' => '2024-06-30',
                'progress' => 0.0,
                'estimated_hours' => 120,
            ]);
        }

        // Tâches pour le projet d'école
        $ecoleProject = $projects->where('name', 'Rénovation École Maternelle')->first();
        if ($ecoleProject) {
            Task::create([
                'title' => 'Mise aux normes sécurité',
                'description' => 'Installer les systèmes de sécurité et d\'alarme',
                'status' => 'completed',
                'priority' => 'urgent',
                'project_id' => $ecoleProject->id,
                'assigned_to' => $users->where('email', 'technicien@cerebral.com')->first()->id,
                'created_by' => $users->where('email', 'manager@cerebral.com')->first()->id,
                'due_date' => '2024-01-15',
                'start_date' => '2023-12-01',
                'completed_at' => '2024-01-10',
                'progress' => 100.0,
                'estimated_hours' => 40,
                'actual_hours' => 38,
            ]);
        }

        $this->command->info('Tasks seeded successfully!');
    }
}

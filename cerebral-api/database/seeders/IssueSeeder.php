<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Issue;
use App\Models\Project;
use App\Models\Task;
use App\Models\User;

class IssueSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminUser = User::where('role', 'admin')->first();
        $managerUser = User::where('role', 'manager')->first();
        $chefUser = User::where('role', 'chef')->first();
        
        $userId = $adminUser ? $adminUser->id : 1;
        $project = Project::first();
        $task = Task::first();

        $issues = [
            [
                'title' => 'Fuite d\'eau dans la salle de bain',
                'description' => 'Fuite d\'eau importante dans la salle de bain de la Villa A3. Joint défectueux à remplacer.',
                'priority' => 'high',
                'status' => 'open',
                'type' => 'technical',
                'project_id' => $project ? $project->id : null,
                'task_id' => $task ? $task->id : null,
                'reported_by' => $userId,
                'assigned_to' => $chefUser ? $chefUser->id : null,
                'reported_at' => now()->subHours(2),
                'location' => 'Villa A3 - Salle de bain',
            ],
            [
                'title' => 'Problème de sécurité sur le chantier',
                'description' => 'Échafaudage instable détecté sur le côté nord du bâtiment. Intervention urgente requise.',
                'priority' => 'critical',
                'status' => 'in_progress',
                'type' => 'safety',
                'project_id' => $project ? $project->id : null,
                'reported_by' => $userId,
                'assigned_to' => $managerUser ? $managerUser->id : null,
                'reported_at' => now()->subHours(6),
                'location' => 'Côté nord du bâtiment',
            ],
            [
                'title' => 'Matériaux manquants pour la finition',
                'description' => 'Manque de peinture blanche et de câbles électriques pour terminer la Villa A3.',
                'priority' => 'medium',
                'status' => 'open',
                'type' => 'logistics',
                'project_id' => $project ? $project->id : null,
                'reported_by' => $userId,
                'reported_at' => now()->subHours(12),
                'location' => 'Villa A3',
            ],
            [
                'title' => 'Qualité du béton insuffisante',
                'description' => 'Le béton livré hier ne respecte pas les normes de résistance requises.',
                'priority' => 'high',
                'status' => 'open',
                'type' => 'quality',
                'project_id' => $project ? $project->id : null,
                'reported_by' => $userId,
                'reported_at' => now()->subDay(),
                'location' => 'Fondations Villa A3',
            ],
        ];

        foreach ($issues as $issueData) {
            Issue::create($issueData);
        }

        $this->command->info('Issues seeded successfully!');
    }
}

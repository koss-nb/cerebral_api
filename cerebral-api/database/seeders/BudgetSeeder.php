<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Budget;
use App\Models\Project;
use App\Models\User;

class BudgetSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $projects = Project::all();
        $adminUser = User::where('role', 'admin')->first();
        $userId = $adminUser ? $adminUser->id : 1;

        // Budgets pour le projet de rénovation
        $renovationProject = $projects->where('name', 'Rénovation Appartement 3 Pièces')->first();
        if ($renovationProject) {
            // Dépenses
            Budget::create([
                'project_id' => $renovationProject->id,
                'category' => 'Matériaux',
                'description' => 'Achat des matériaux de construction et finition',
                'amount' => 8500.00,
                'type' => 'expense',
                'start_date' => '2024-01-20',
                'end_date' => '2024-01-20',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-001',
                'created_by' => $userId,
            ]);

            Budget::create([
                'project_id' => $renovationProject->id,
                'category' => 'Main d\'œuvre',
                'description' => 'Paiement de l\'équipe de rénovation',
                'amount' => 12000.00,
                'type' => 'expense',
                'start_date' => '2024-02-15',
                'end_date' => '2024-02-15',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-002',
                'created_by' => $userId,
            ]);

            Budget::create([
                'project_id' => $renovationProject->id,
                'category' => 'Équipements',
                'description' => 'Location d\'équipements et outils',
                'amount' => 1500.00,
                'type' => 'expense',
                'start_date' => '2024-01-25',
                'end_date' => '2024-01-25',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Carte bancaire',
                'reference_number' => 'FACT-003',
                'created_by' => $userId,
            ]);

            // Revenus
            Budget::create([
                'project_id' => $renovationProject->id,
                'category' => 'Paiement client',
                'description' => 'Acompte reçu du client',
                'amount' => 12500.00,
                'type' => 'income',
                'start_date' => '2024-01-15',
                'end_date' => '2024-01-15',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'REC-001',
                'created_by' => $userId,
            ]);
        }

        // Budgets pour le projet de construction de bureau
        $bureauProject = $projects->where('name', 'Construction Bureau Moderne')->first();
        if ($bureauProject) {
            // Dépenses
            Budget::create([
                'project_id' => $bureauProject->id,
                'category' => 'Fondations',
                'description' => 'Terrassement et coulage des fondations',
                'amount' => 25000.00,
                'type' => 'expense',
                'start_date' => '2024-03-20',
                'end_date' => '2024-03-20',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-004',
                'created_by' => $userId,
            ]);

            Budget::create([
                'project_id' => $bureauProject->id,
                'category' => 'Structure',
                'description' => 'Achat de la structure métallique',
                'amount' => 45000.00,
                'type' => 'expense',
                'start_date' => '2024-04-15',
                'end_date' => '2024-04-15',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-005',
                'created_by' => $userId,
            ]);

            // Revenus
            Budget::create([
                'project_id' => $bureauProject->id,
                'category' => 'Paiement client',
                'description' => 'Premier versement du client',
                'amount' => 50000.00,
                'type' => 'income',
                'start_date' => '2024-03-01',
                'end_date' => '2024-03-01',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'REC-002',
                'created_by' => $userId,
            ]);
        }

        // Budgets pour le projet d'école
        $ecoleProject = $projects->where('name', 'Rénovation École Maternelle')->first();
        if ($ecoleProject) {
            // Dépenses
            Budget::create([
                'project_id' => $ecoleProject->id,
                'category' => 'Sécurité',
                'description' => 'Installation des systèmes de sécurité',
                'amount' => 35000.00,
                'type' => 'expense',
                'start_date' => '2023-12-15',
                'end_date' => '2023-12-15',
                'fiscal_year' => 2023,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-006',
                'created_by' => $userId,
            ]);

            Budget::create([
                'project_id' => $ecoleProject->id,
                'category' => 'Rénovation',
                'description' => 'Travaux de rénovation générale',
                'amount' => 65000.00,
                'type' => 'expense',
                'start_date' => '2024-01-20',
                'end_date' => '2024-01-20',
                'fiscal_year' => 2024,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'FACT-007',
                'created_by' => $userId,
            ]);

            // Revenus
            Budget::create([
                'project_id' => $ecoleProject->id,
                'category' => 'Paiement mairie',
                'description' => 'Paiement de la mairie',
                'amount' => 120000.00,
                'type' => 'income',
                'start_date' => '2023-11-30',
                'end_date' => '2023-11-30',
                'fiscal_year' => 2023,
                'status' => 'approved',
                'payment_method' => 'Virement bancaire',
                'reference_number' => 'REC-003',
                'created_by' => $userId,
            ]);
        }

        $this->command->info('Budgets seeded successfully!');
    }
}

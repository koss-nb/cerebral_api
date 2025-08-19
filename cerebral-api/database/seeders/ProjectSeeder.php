<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Project;
use App\Models\User;

class ProjectSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();

        // Projet 1: Rénovation Appartement
        Project::create([
            'name' => 'Rénovation Appartement 3 Pièces',
            'description' => 'Rénovation complète d\'un appartement 3 pièces dans le 8ème arrondissement de Paris',
            'type' => 'residential',
            'status' => 'active',
            'budget' => 25000.00,
            'currency' => 'EUR',
            'client_name' => 'M. et Mme Dupont',
            'client_email' => 'dupont@email.com',
            'client_phone' => '01 23 45 67 89',
            'location' => 'Paris 8ème',
            'manager_id' => $users->where('email', 'manager@cerebral.com')->first()->id,
            'start_date' => '2024-01-15',
            'end_date' => '2024-06-30',
            'progress' => 35.0,
        ]);

        // Projet 2: Construction Bureau
        Project::create([
            'name' => 'Construction Bureau Moderne',
            'description' => 'Construction d\'un immeuble de bureaux de 5 étages avec parking souterrain',
            'type' => 'commercial',
            'status' => 'active',
            'budget' => 150000.00,
            'currency' => 'EUR',
            'client_name' => 'Société Immobilière Lyon',
            'client_email' => 'contact@sil.fr',
            'client_phone' => '04 78 12 34 56',
            'location' => 'Lyon Part-Dieu',
            'manager_id' => $users->where('email', 'chef@cerebral.com')->first()->id,
            'start_date' => '2024-03-01',
            'end_date' => '2025-02-28',
            'progress' => 15.0,
        ]);

        // Projet 3: Installation Industrielle
        Project::create([
            'name' => 'Installation Ligne de Production',
            'description' => 'Installation d\'une nouvelle ligne de production automatisée',
            'type' => 'industrial',
            'status' => 'on_hold',
            'budget' => 75000.00,
            'currency' => 'EUR',
            'client_name' => 'Industries Méditerranée',
            'client_email' => 'contact@indmed.fr',
            'client_phone' => '04 91 23 45 67',
            'location' => 'Marseille Port',
            'manager_id' => $users->where('email', 'admin@cerebral.com')->first()->id,
            'start_date' => '2024-02-01',
            'end_date' => '2024-08-31',
            'progress' => 0.0,
        ]);

        // Projet 4: Rénovation École
        Project::create([
            'name' => 'Rénovation École Maternelle',
            'description' => 'Rénovation complète d\'une école maternelle avec mise aux normes',
            'type' => 'commercial',
            'status' => 'completed',
            'budget' => 120000.00,
            'currency' => 'EUR',
            'client_name' => 'Mairie de Toulouse',
            'client_email' => 'contact@mairie-toulouse.fr',
            'client_phone' => '05 61 23 45 67',
            'location' => 'Toulouse Centre',
            'manager_id' => $users->where('email', 'manager@cerebral.com')->first()->id,
            'start_date' => '2023-09-01',
            'end_date' => '2024-01-31',
            'progress' => 100.0,
        ]);

        // Projet 5: Construction Maison
        Project::create([
            'name' => 'Construction Maison Individuelle',
            'description' => 'Construction d\'une maison individuelle de 150m² avec jardin',
            'type' => 'residential',
            'status' => 'active',
            'budget' => 180000.00,
            'currency' => 'EUR',
            'client_name' => 'Famille Martin',
            'client_email' => 'martin@email.com',
            'client_phone' => '05 56 78 90 12',
            'location' => 'Bordeaux Métropole',
            'manager_id' => $users->where('email', 'chef@cerebral.com')->first()->id,
            'start_date' => '2024-04-01',
            'end_date' => '2024-12-31',
            'progress' => 25.0,
        ]);

        $this->command->info('Projects seeded successfully!');
    }
}

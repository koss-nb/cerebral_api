<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Delivery;
use App\Models\Material;
use App\Models\Project;
use App\Models\User;

class DeliverySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminUser = User::where('role', 'admin')->first();
        $userId = $adminUser ? $adminUser->id : 1;

        $project = Project::first();
        $materials = Material::take(3)->get();

        $deliveries = [
            [
                'reference' => 'DEL-CIMENT001',
                'title' => 'Livraison ciment pour Villa A3',
                'description' => 'Livraison de 50 sacs de ciment Portland',
                'project_id' => $project ? $project->id : null,
                'supplier' => 'Fournisseur BTP',
                'supplier_contact' => 'contact@btp.fr',
                'expected_date' => now()->addDays(2),
                'status' => 'pending',
                'notes' => 'Livraison matin entre 8h et 12h',
                'created_by' => $userId,
            ],
            [
                'reference' => 'DEL-CABLES002',
                'title' => 'Livraison câbles électriques',
                'description' => 'Livraison de 20 rouleaux de câbles 2.5mm²',
                'project_id' => $project ? $project->id : null,
                'supplier' => 'Électricité Pro',
                'supplier_contact' => 'contact@elecpro.fr',
                'expected_date' => now()->addDays(1),
                'status' => 'confirmed',
                'notes' => 'Livraison urgente - stock faible',
                'created_by' => $userId,
            ],
            [
                'reference' => 'DEL-PVC003',
                'title' => 'Livraison tuyaux PVC',
                'description' => 'Livraison de 50 tuyaux PVC 100mm',
                'project_id' => $project ? $project->id : null,
                'supplier' => 'Plomberie Express',
                'supplier_contact' => 'contact@plomberie.fr',
                'expected_date' => now()->addDays(3),
                'status' => 'pending',
                'notes' => 'Livraison standard',
                'created_by' => $userId,
            ],
        ];

        foreach ($deliveries as $deliveryData) {
            $delivery = Delivery::create($deliveryData);

            // Attacher des matériaux à la livraison
            if ($materials->count() > 0) {
                $material = $materials->random();
                $delivery->materials()->attach($material->id, [
                    'quantity' => rand(10, 50),
                    'notes' => 'Livraison standard',
                ]);
            }
        }

        $this->command->info('Deliveries seeded successfully!');
    }
}

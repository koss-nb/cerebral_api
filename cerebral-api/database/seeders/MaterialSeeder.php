<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Material;
use App\Models\User;

class MaterialSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminUser = User::where('role', 'admin')->first();
        $userId = $adminUser ? $adminUser->id : 1;

        $materials = [
            [
                'name' => 'Ciment Portland',
                'description' => 'Ciment Portland de haute qualité pour construction',
                'category' => 'construction',
                'unit' => 'sac',
                'current_stock' => 150,
                'min_stock' => 20,
                'max_stock' => 300,
                'unit_price' => 15.50,
                'supplier' => 'Fournisseur BTP',
                'supplier_contact' => 'contact@btp.fr',
                'location' => 'Entrepôt A',
                'status' => 'available',
                'created_by' => $userId,
            ],
            [
                'name' => 'Câbles électriques',
                'description' => 'Câbles électriques 2.5mm² pour installation',
                'category' => 'electric',
                'unit' => 'rouleau',
                'current_stock' => 5,
                'min_stock' => 10,
                'max_stock' => 50,
                'unit_price' => 45.00,
                'supplier' => 'Électricité Pro',
                'supplier_contact' => 'contact@elecpro.fr',
                'location' => 'Entrepôt B',
                'status' => 'low_stock',
                'created_by' => $userId,
            ],
            [
                'name' => 'Tuyaux PVC',
                'description' => 'Tuyaux PVC 100mm pour plomberie',
                'category' => 'plumbing',
                'unit' => 'unité',
                'current_stock' => 120,
                'min_stock' => 30,
                'max_stock' => 200,
                'unit_price' => 8.75,
                'supplier' => 'Plomberie Express',
                'supplier_contact' => 'contact@plomberie.fr',
                'location' => 'Entrepôt C',
                'status' => 'available',
                'created_by' => $userId,
            ],
            [
                'name' => 'Peinture blanche',
                'description' => 'Peinture blanche mate pour intérieur',
                'category' => 'finishing',
                'unit' => 'bidon',
                'current_stock' => 15,
                'min_stock' => 5,
                'max_stock' => 30,
                'unit_price' => 25.00,
                'supplier' => 'Peintures & Co',
                'supplier_contact' => 'contact@peintures.fr',
                'location' => 'Entrepôt A',
                'status' => 'available',
                'created_by' => $userId,
            ],
            [
                'name' => 'Tôles acier',
                'description' => 'Tôles acier 2mm pour charpente',
                'category' => 'metal',
                'unit' => 'feuille',
                'current_stock' => 0,
                'min_stock' => 5,
                'max_stock' => 20,
                'unit_price' => 85.00,
                'supplier' => 'Métal Inc',
                'supplier_contact' => 'contact@metalinc.fr',
                'location' => 'Entrepôt B',
                'status' => 'out_of_stock',
                'created_by' => $userId,
            ],
        ];

        foreach ($materials as $materialData) {
            Material::create($materialData);
        }
    }
}

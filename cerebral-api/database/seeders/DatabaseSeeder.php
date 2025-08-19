<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            ProjectSeeder::class,
            TaskSeeder::class,
            PersonnelSeeder::class,
            BudgetSeeder::class,
            MaterialSeeder::class,
            DeliverySeeder::class,
            IssueSeeder::class,
        ]);
    }
}

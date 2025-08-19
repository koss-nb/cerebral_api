<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Vérifier si nous sommes sur un serveur MySQL 5.7 (Hostinger)
        $mysqlVersion = DB::select('SELECT VERSION() as version')[0]->version;
        $isMySQL57 = version_compare($mysqlVersion, '8.0.0', '<');

        if ($isMySQL57) {
            // Convertir toutes les tables vers utf8mb4_unicode_ci
            $tables = DB::select('SHOW TABLES');

            foreach ($tables as $table) {
                $tableName = array_values((array) $table)[0];

                // Convertir la table
                DB::statement("ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

                // Convertir tous les champs de type TEXT/VARCHAR
                $columns = DB::select("SHOW COLUMNS FROM `{$tableName}` WHERE Type LIKE '%varchar%' OR Type LIKE '%text%'");

                foreach ($columns as $column) {
                    $columnName = $column->Field;
                    $columnType = $column->Type;

                    // Reconstruire le type avec la bonne collation
                    if (strpos($columnType, 'varchar') !== false) {
                        $length = preg_replace('/[^0-9]/', '', $columnType);
                        DB::statement("ALTER TABLE `{$tableName}` MODIFY `{$columnName}` VARCHAR({$length}) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                    } elseif (strpos($columnType, 'text') !== false) {
                        DB::statement("ALTER TABLE `{$tableName}` MODIFY `{$columnName}` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                    }
                }
            }

            // Mettre à jour la base de données
            DB::statement("ALTER DATABASE " . env('DB_DATABASE') . " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Cette migration ne peut pas être annulée car elle modifie la structure de la base
        // En cas de besoin, recréer la base avec la collation originale
    }
};

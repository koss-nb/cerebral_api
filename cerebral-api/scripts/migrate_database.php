<?php

/**
 * Script de migration de la base de données pour Cerebral
 * 
 * Ce script exécute les migrations et les seeders
 * pour initialiser la base de données.
 */

echo "=== Migration de la base de données Cerebral ===\n\n";

// Vérifier si le fichier .env existe
$envFile = __DIR__ . '/../.env';
if (!file_exists($envFile)) {
    echo "❌ Erreur : Le fichier .env n'existe pas !\n";
    echo "Exécutez d'abord le script setup_database.php\n";
    exit(1);
}

echo "✅ Fichier .env trouvé\n";

// Changer vers le répertoire du projet
chdir(__DIR__ . '/..');

// Vérifier si les dépendances sont installées
if (!file_exists('vendor/autoload.php')) {
    echo "📦 Installation des dépendances Composer...\n";
    exec('composer install', $output, $returnCode);
    if ($returnCode !== 0) {
        echo "❌ Erreur lors de l'installation des dépendances\n";
        exit(1);
    }
    echo "✅ Dépendances installées\n\n";
}

// Générer la clé d'application
echo "🔑 Génération de la clé d'application...\n";
exec('php artisan key:generate', $output, $returnCode);
if ($returnCode !== 0) {
    echo "❌ Erreur lors de la génération de la clé\n";
    exit(1);
}
echo "✅ Clé d'application générée\n\n";

// Générer la clé JWT
echo "🔐 Génération de la clé JWT...\n";
exec('php artisan jwt:secret', $output, $returnCode);
if ($returnCode !== 0) {
    echo "❌ Erreur lors de la génération de la clé JWT\n";
    exit(1);
}
echo "✅ Clé JWT générée\n\n";

// Tester la connexion à la base de données
echo "🔍 Test de connexion à la base de données...\n";
exec('php artisan tinker --execute="echo DB::connection()->getPdo() ? \'Connexion OK\' : \'Erreur de connexion\';"', $output, $returnCode);
if ($returnCode !== 0) {
    echo "❌ Erreur de connexion à la base de données\n";
    echo "Vérifiez vos paramètres dans le fichier .env\n";
    exit(1);
}
echo "✅ Connexion à la base de données réussie\n\n";

// Exécuter les migrations
echo "📊 Exécution des migrations...\n";
exec('php artisan migrate', $output, $returnCode);
if ($returnCode !== 0) {
    echo "❌ Erreur lors des migrations\n";
    exit(1);
}
echo "✅ Migrations exécutées avec succès\n\n";

// Exécuter les seeders
echo "🌱 Exécution des seeders...\n";
exec('php artisan db:seed', $output, $returnCode);
if ($returnCode !== 0) {
    echo "❌ Erreur lors des seeders\n";
    exit(1);
}
echo "✅ Seeders exécutés avec succès\n\n";

// Optimiser l'application
echo "⚡ Optimisation de l'application...\n";
exec('php artisan config:cache', $output, $returnCode);
exec('php artisan route:cache', $output, $returnCode);
exec('php artisan view:cache', $output, $returnCode);
echo "✅ Application optimisée\n\n";

echo "🎉 Migration terminée avec succès !\n\n";

echo "📋 Prochaines étapes :\n";
echo "1. Configurez votre serveur web pour pointer vers le dossier public/\n";
echo "2. Assurez-vous que les permissions sont correctes\n";
echo "3. Testez l'API : https://cerebral.eveil-maturite.com/api/health\n";
echo "4. Mettez à jour la configuration Flutter\n\n";

echo "🔧 Commandes utiles :\n";
echo "- Voir les routes : php artisan route:list\n";
echo "- Vider le cache : php artisan cache:clear\n";
echo "- Voir les logs : tail -f storage/logs/laravel.log\n\n";

echo "✅ Configuration terminée !\n";

<?php

/**
 * Script de configuration de la base de données pour Cerebral
 * 
 * Ce script configure la connexion à la base de données MySQL
 * pour l'application Cerebral.
 */

echo "=== Configuration de la base de données Cerebral ===\n\n";

// Configuration de la base de données
$dbConfig = [
    'host' => 'localhost',
    'port' => '3306',
    'database' => 'u375558093_cerebral',
    'username' => 'u375558093_cerebral',
    'password' => 'xVB5kwg2*', // Mot de passe de la base de données
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
];

echo "Configuration de la base de données :\n";
echo "- Host: {$dbConfig['host']}\n";
echo "- Port: {$dbConfig['port']}\n";
echo "- Database: {$dbConfig['database']}\n";
echo "- Username: {$dbConfig['username']}\n";
echo "- Charset: {$dbConfig['charset']}\n\n";

// Créer le contenu du fichier .env
$envContent = "APP_NAME=Cerebral
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://cerebral.eveil-maturite.com

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST={$dbConfig['host']}
DB_PORT={$dbConfig['port']}
DB_DATABASE={$dbConfig['database']}
DB_USERNAME={$dbConfig['username']}
DB_PASSWORD={$dbConfig['password']}
DB_CHARSET={$dbConfig['charset']}
DB_COLLATION={$dbConfig['collation']}

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=\"hello@example.com\"
MAIL_FROM_NAME=\"\${APP_NAME}\"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME=\"\${APP_NAME}\"
VITE_PUSHER_APP_KEY=\"\${PUSHER_APP_KEY}\"
VITE_PUSHER_HOST=\"\${PUSHER_HOST}\"
VITE_PUSHER_PORT=\"\${PUSHER_PORT}\"
VITE_PUSHER_SCHEME=\"\${PUSHER_SCHEME}\"
VITE_PUSHER_APP_CLUSTER=\"\${PUSHER_APP_CLUSTER}\"

# Configuration JWT pour l'API
JWT_SECRET=
JWT_TTL=60
JWT_REFRESH_TTL=20160

# Configuration CORS pour l'API
CORS_ALLOWED_ORIGINS=*
CORS_ALLOWED_METHODS=GET,POST,PUT,DELETE,OPTIONS
CORS_ALLOWED_HEADERS=Content-Type,Authorization,X-Requested-With

# Configuration pour les uploads
UPLOAD_MAX_FILESIZE=10M
POST_MAX_SIZE=10M";

// Sauvegarder le contenu dans un fichier
$envFile = __DIR__ . '/../.env';
file_put_contents($envFile, $envContent);

echo "✅ Fichier .env créé avec succès !\n";
echo "📁 Emplacement: $envFile\n\n";

echo "📋 Instructions suivantes :\n";
echo "1. Modifiez le fichier .env et ajoutez votre mot de passe dans DB_PASSWORD\n";
echo "2. Générez une clé d'application avec : php artisan key:generate\n";
echo "3. Générez une clé JWT avec : php artisan jwt:secret\n";
echo "4. Exécutez les migrations : php artisan migrate\n";
echo "5. Exécutez les seeders : php artisan db:seed\n\n";

echo "🔧 Commandes à exécuter :\n";
echo "cd " . __DIR__ . "/..\n";
echo "php artisan key:generate\n";
echo "php artisan jwt:secret\n";
echo "php artisan migrate\n";
echo "php artisan db:seed\n\n";

echo "🌐 Configuration de l'API Flutter :\n";
echo "Modifiez le fichier cerebral/lib/core/config/api_config.dart\n";
echo "Changez la baseUrl vers : 'https://cerebral.eveil-maturite.com/api'\n\n";

echo "✅ Configuration terminée !\n";

// Fichier de débogage pour l'API des tâches
// Ce fichier contient des informations pour déboguer le problème

/*
PROBLÈME IDENTIFIÉ:
La page de détails des tâches (Screen4) ne charge pas les données de la tâche.

POSSIBLES CAUSES:
1. L'ID de la tâche n'est pas correctement passé depuis la liste
2. L'API getTaskById ne fonctionne pas
3. La structure des données retournées est différente de celle attendue
4. Erreur dans le chargement des données

ÉTAPES DE DÉBOGAGE:
1. Vérifier que l'ID est bien passé dans la navigation
2. Vérifier que l'API getTaskById est appelée
3. Vérifier la structure des données retournées
4. Vérifier que les données sont bien stockées dans l'état

LOGS AJOUTÉS:
- Dans tassk_list_page.dart: Logs lors du clic sur une tâche
- Dans screen4.dart: Logs lors du chargement des données

POUR TESTER:
1. Lancer l'application
2. Aller à la liste des tâches
3. Cliquer sur une tâche
4. Vérifier les logs dans la console
5. Vérifier que la page de détails s'affiche avec les bonnes données

STRUCTURE ATTENDUE DES DONNÉES:
{
  "id": 1,
  "title": "Titre de la tâche",
  "description": "Description de la tâche",
  "status": "pending",
  "priority": "high",
  "project_id": 1,
  "assigned_to": 1,
  "due_date": "2024-01-15T00:00:00.000Z",
  "created_at": "2024-01-01T00:00:00.000Z"
}
*/

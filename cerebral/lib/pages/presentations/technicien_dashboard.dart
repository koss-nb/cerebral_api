import 'package:cerebral/pages/presentations/techniciens/complete_task_rapport.dart';
import 'package:cerebral/core/services/dashboard_service.dart';
import 'package:cerebral/core/services/auth_service.dart';
import 'package:cerebral/core/services/technicien_service.dart';
import 'package:flutter/material.dart';

class TechnicienDashboard extends StatefulWidget {
  const TechnicienDashboard({super.key});

  @override
  State<TechnicienDashboard> createState() => _TechnicienDashboardState();
}

class _TechnicienDashboardState extends State<TechnicienDashboard> {
  int _selectedNavIndex = 0; // 0: Accueil, 1: Tâches, 2: Documents, 3: Profil

  // Services
  final DashboardService _dashboardService = DashboardService();
  final AuthService _authService = AuthService();
  final TechnicienService _technicienService = TechnicienService();

  // États des données
  bool _isLoading = true;
  Map<String, dynamic>? _technicienStats;
  List<Map<String, dynamic>>? _technicienTasks;
  List<Map<String, dynamic>>? _technicienProjects;
  Map<String, dynamic>? _technicienPerformance;
  List<Map<String, dynamic>>? _recentActivities;
  List<Map<String, dynamic>>? _notifications;
  Map<String, dynamic>? _currentUser;

  // Nouvelles données du service technicien
  Map<String, dynamic>? _dashboardData;
  List<Map<String, dynamic>>? _assignedTasks;
  List<Map<String, dynamic>>? _assignedProjects;
  List<Map<String, dynamic>>? _currentTasks;
  List<Map<String, dynamic>>? _urgentTasks;
  List<Map<String, dynamic>>? _completedTasks;
  Map<String, dynamic>? _timeSheet;
  List<Map<String, dynamic>>? _documents;
  Map<String, dynamic>? _currentStatus;

  // Liste des widgets pour chaque onglet
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _widgetOptions = [
      _buildHomeContent(), // Accueil
      CompleteTaskRapport(),
      _buildDocumentsContent(), // Documents
      _buildProfileContent(), // Profil
    ];
  }

  // Charger les données du dashboard
  Future<void> _loadDashboardData() async {
    print('🔍 Début du chargement des données du dashboard');
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les données de l'utilisateur actuel
      print('🔍 Chargement des données utilisateur...');
      await _loadCurrentUser();
      print('✅ Données utilisateur chargées: $_currentUser');

      // Charger toutes les données du service technicien en une fois
      print('🔍 Chargement des données du service technicien...');
      final dashboardData = await _technicienService.loadDashboardData();
      print('✅ Données du service technicien reçues: $dashboardData');

      if (mounted) {
        setState(() {
          _dashboardData = dashboardData['dashboard'];
          _technicienStats = dashboardData['stats'];
          _assignedTasks = dashboardData['assignedTasks'];
          _assignedProjects = dashboardData['assignedProjects'];
          _currentTasks = dashboardData['currentTasks'];
          _urgentTasks = dashboardData['urgentTasks'];
          _completedTasks = dashboardData['completedTasks'];
          _technicienPerformance = dashboardData['performance'];
          _timeSheet = dashboardData['timeSheet'];
          _documents = dashboardData['documents'];
          _currentStatus = dashboardData['currentStatus'];
          _recentActivities = dashboardData['recentActivities'];
          _isLoading = false;
        });

        print('📊 Données mises à jour:');
        print('  - Dashboard: $_dashboardData');
        print('  - Stats: $_technicienStats');
        print('  - Tâches assignées: ${_assignedTasks?.length ?? 0}');
        print('  - Projets assignés: ${_assignedProjects?.length ?? 0}');
        print('  - Tâches actuelles: ${_currentTasks?.length ?? 0}');
        print('  - Tâches urgentes: ${_urgentTasks?.length ?? 0}');
        print('  - Tâches terminées: ${_completedTasks?.length ?? 0}');
        print('  - Performance: $_technicienPerformance');
        print('  - Timesheet: $_timeSheet');
        print('  - Documents: ${_documents?.length ?? 0}');
        print('  - Statut actuel: $_currentStatus');
        print('  - Activités récentes: ${_recentActivities?.length ?? 0}');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des données: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showError('Erreur lors du chargement des données: $e');
      }
    }
  }

  // Charger les statistiques du technicien
  Future<void> _loadTechnicienStats() async {
    try {
      final stats = await _dashboardService.getTechnicienStats();
      if (mounted) {
        setState(() {
          _technicienStats = stats;
        });
      }
    } catch (e) {
      print('Erreur chargement stats technicien: $e');
    }
  }

  // Charger les tâches du technicien
  Future<void> _loadTechnicienTasks() async {
    try {
      final tasks = await _dashboardService.getTechnicienTasks();
      if (mounted) {
        setState(() {
          _technicienTasks = tasks;
        });
      }
    } catch (e) {
      print('Erreur chargement tâches technicien: $e');
    }
  }

  // Charger les projets du technicien
  Future<void> _loadTechnicienProjects() async {
    try {
      final projects = await _dashboardService.getTechnicienProjects();
      if (mounted) {
        setState(() {
          _technicienProjects = projects;
        });
      }
    } catch (e) {
      print('Erreur chargement projets technicien: $e');
    }
  }

  // Charger la performance du technicien
  Future<void> _loadTechnicienPerformance() async {
    try {
      final performance = await _dashboardService.getTechnicienPerformance();
      if (mounted) {
        setState(() {
          _technicienPerformance = performance;
        });
      }
    } catch (e) {
      print('Erreur chargement performance technicien: $e');
    }
  }

  // Charger les activités récentes
  Future<void> _loadRecentActivities() async {
    try {
      final activities =
          await _dashboardService.getRoleRecentActivities('technicien');
      if (mounted) {
        setState(() {
          _recentActivities = activities;
        });
      }
    } catch (e) {
      print('Erreur chargement activités récentes: $e');
    }
  }

  // Charger les notifications
  Future<void> _loadNotifications() async {
    try {
      final notifications =
          await _dashboardService.getRoleNotifications('technicien');
      if (mounted) {
        setState(() {
          _notifications = notifications;
        });
      }
    } catch (e) {
      print('Erreur chargement notifications: $e');
    }
  }

  // Charger l'utilisateur actuel
  Future<void> _loadCurrentUser() async {
    print('🔍 Chargement de l\'utilisateur actuel...');
    try {
      final user = await _authService.getCurrentUser();
      print('✅ Utilisateur récupéré: $user');
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
        print('✅ Utilisateur mis à jour dans l\'état: $_currentUser');
      }
    } catch (e) {
      print('❌ Erreur chargement utilisateur: $e');
    }
  }

  // Afficher une erreur
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Gérer la déconnexion
  Future<void> _handleLogout() async {
    try {
      // Afficher une boîte de dialogue de confirmation
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Déconnexion'),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        // Appeler le service de déconnexion
        await _authService.logout();

        if (mounted) {
          // Rediriger vers la page de connexion
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de la déconnexion: $e');
      }
    }
  }

  // ===== MÉTHODES UTILITAIRES POUR LES TÂCHES =====

  // Obtenir le label du statut
  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'À faire';
      case 'in_progress':
        return 'En cours';
      case 'waiting_validation':
        return 'En attente';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return 'Inconnu';
    }
  }

  // Obtenir la couleur du statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFE9ECEF);
      case 'in_progress':
        return const Color(0xFFFF9800);
      case 'waiting_validation':
        return const Color(0xFF1976D2);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Formater la date d'échéance
  String _formatDueDate(dynamic dueDate) {
    if (dueDate == null) return 'Pas de date';

    try {
      final date = DateTime.parse(dueDate.toString());
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference < 0) {
        return 'En retard';
      } else if (difference == 0) {
        return 'Aujourd\'hui';
      } else if (difference == 1) {
        return 'Demain';
      } else {
        return 'Dans $difference jours';
      }
    } catch (e) {
      return 'Date invalide';
    }
  }

  // Obtenir le texte du bouton
  String _getButtonText(String status) {
    switch (status) {
      case 'pending':
        return 'Commencer';
      case 'in_progress':
        return 'Continuer';
      case 'waiting_validation':
        return 'Voir détails';
      case 'completed':
        return 'Voir rapport';
      default:
        return 'Voir';
    }
  }

  // Obtenir l'icône du bouton
  IconData _getButtonIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.play_arrow;
      case 'in_progress':
        return Icons.play_arrow;
      case 'waiting_validation':
        return Icons.visibility;
      case 'completed':
        return Icons.description;
      default:
        return Icons.visibility;
    }
  }

  // Obtenir la couleur du bouton
  Color _getButtonColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFF1976D2);
      case 'in_progress':
        return const Color(0xFFFF9800);
      case 'waiting_validation':
        return const Color(0xFF1976D2);
      case 'completed':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Obtenir la valeur de progression
  double _getProgressValue(Map<String, dynamic> task) {
    try {
      final progress = task['progress']?['percentage'];
      if (progress != null) {
        final value = double.tryParse(progress.toString()) ?? 0.0;
        return value / 100.0; // Convertir en décimal (0.0 à 1.0)
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // En-tête bleu avec logo et informations utilisateur
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(color: Color(0xFF1976D2)),
            child: Row(
              children: [
                // Logo CEREBRAL avec clé anglaise
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.build,
                        color: Color(0xFF1976D2),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CEREBRAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          _currentUser != null
                              ? '${_currentUser!['first_name']} ${_currentUser!['last_name']}'
                              : 'Chargement...',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Notifications et avatar
                Row(
                  children: [
                    // Badge de notification
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                color: Color(0xFFF44336),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Avatar utilisateur
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _currentUser != null
                              ? '${_currentUser!['first_name']?[0] ?? ''}${_currentUser!['last_name']?[0] ?? ''}'
                              : '...',
                          style: const TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenu principal avec IndexedStack pour la navigation
          Expanded(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: _widgetOptions,
            ),
          ),
        ],
      ),

      // Barre de navigation en bas
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _buildNavItem(
                  Icons.home,
                  'Accueil',
                  0,
                  const Color(0xFF1976D2),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.checklist,
                  'Tâches',
                  1,
                  const Color(0xFF6C757D),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.description,
                  'Documents',
                  2,
                  const Color(0xFF6C757D),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.person,
                  'Profil',
                  3,
                  const Color(0xFF6C757D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Contenu de l'onglet Accueil
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Date et Heure avec bouton de pointage
          _buildDateTimeSection(),

          const SizedBox(height: 24),

          // Section Mes tâches
          _buildMyTasksSection(),

          const SizedBox(height: 24),

          // Section Actions rapides
          _buildQuickActionsSection(),

          const SizedBox(height: 24),

          // Section Activité récente
          _buildRecentActivitySection(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Contenu de l'onglet Tâches
  Widget _buildTasksContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête des tâches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes Tâches',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_assignedTasks?.length ?? 0} tâches',
                  style: const TextStyle(
                    color: Color(0xFF1976D2),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Filtres de statut
          _buildStatusFilters(),

          const SizedBox(height: 24),

          // Liste complète des tâches
          _buildCompleteTasksList(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Contenu de l'onglet Documents
  Widget _buildDocumentsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête des documents
          const Text(
            'Documents',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 20),

          // Filtres de documents
          _buildDocumentFilters(),

          const SizedBox(height: 24),

          // Liste des documents
          _buildDocumentsList(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Contenu de l'onglet Profil
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du profil
          _buildProfileHeader(),

          const SizedBox(height: 24),

          // Informations personnelles
          _buildPersonalInfo(),

          const SizedBox(height: 24),

          // Statistiques
          _buildStatistics(),

          const SizedBox(height: 24),

          // Actions du profil
          _buildProfileActions(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Filtres de statut pour les tâches
  Widget _buildStatusFilters() {
    return Row(
      children: [
        _buildFilterChip('Toutes', true),
        const SizedBox(width: 12),
        _buildFilterChip('En cours', false),
        const SizedBox(width: 12),
        _buildFilterChip('Terminées', false),
        const SizedBox(width: 12),
        _buildFilterChip('Urgentes', false),
      ],
    );
  }

  // Chip de filtre
  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Logique de filtrage à implémenter
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF1976D2) : const Color(0xFFE9ECEF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF23272F),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Liste complète des tâches
  Widget _buildCompleteTasksList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_assignedTasks == null || _assignedTasks!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.task_alt,
                size: 64,
                color: Color(0xFF6C757D),
              ),
              SizedBox(height: 16),
              Text(
                'Aucune tâche assignée',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Vous n\'avez pas de tâches en cours',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _assignedTasks!.map((task) {
        final status = task['status']?['value'] ?? 'pending';
        final priority = task['priority']?['value'] ?? 'medium';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildTaskCard(
            status: _getStatusLabel(status),
            statusColor: _getStatusColor(status),
            statusTextColor: Colors.white,
            project: task['project']?['name'] ?? 'Projet inconnu',
            title: task['title'] ?? 'Tâche sans titre',
            description: task['description'] ?? 'Aucune description',
            leftIcon: Icons.calendar_today,
            leftText: _formatDueDate(task['dates']?['due_date']),
            rightIcon: Icons.person,
            rightText:
                'Assigné par: ${task['created_by']?['name'] ?? 'Inconnu'}',
            buttonText: _getButtonText(status),
            buttonIcon: _getButtonIcon(status),
            buttonColor: _getButtonColor(status),
            showProgress: status == 'in_progress',
            progressValue: _getProgressValue(task),
          ),
        );
      }).toList(),
    );
  }

  // Filtres de documents
  Widget _buildDocumentFilters() {
    return Row(
      children: [
        _buildFilterChip('Tous', true),
        const SizedBox(width: 12),
        _buildFilterChip('Plans', false),
        const SizedBox(width: 12),
        _buildFilterChip('Photos', false),
        const SizedBox(width: 12),
        _buildFilterChip('Rapports', false),
      ],
    );
  }

  // Liste des documents
  Widget _buildDocumentsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_documents == null || _documents!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.folder_open,
                size: 64,
                color: Color(0xFF6C757D),
              ),
              SizedBox(height: 16),
              Text(
                'Aucun document',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Vous n\'avez pas de documents',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _documents!.map((document) {
        final fileName = document['file_name'] ?? 'Document sans nom';
        final fileSize = document['file_size'] ?? 'Taille inconnue';
        final fileType = document['file_type'] ?? 'application/octet-stream';
        final createdAt = document['created_at'] ?? '';

        // Déterminer l'icône et la couleur selon le type de fichier
        IconData icon;
        Color iconColor;

        if (fileType.contains('pdf')) {
          icon = Icons.picture_as_pdf;
          iconColor = const Color(0xFFF44336);
        } else if (fileType.contains('image')) {
          icon = Icons.photo_library;
          iconColor = const Color(0xFF4CAF50);
        } else if (fileType.contains('word') || fileType.contains('document')) {
          icon = Icons.description;
          iconColor = const Color(0xFF1976D2);
        } else {
          icon = Icons.insert_drive_file;
          iconColor = const Color(0xFF6C757D);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildDocumentCard(
            fileName,
            '$fileType • $fileSize',
            icon,
            iconColor,
            createdAt,
          ),
        );
      }).toList(),
    );
  }

  // Carte de document
  Widget _buildDocumentCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    String date,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFADB5BD),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Action pour ouvrir le document
            },
            icon: const Icon(Icons.download, color: Color(0xFF1976D2)),
          ),
        ],
      ),
    );
  }

  // En-tête du profil
  Widget _buildProfileHeader() {
    print('🔍 Construction de l\'en-tête du profil');
    print('  - _currentUser: $_currentUser');
    print(
        '  - Nom: ${_currentUser?['first_name']} ${_currentUser?['last_name']}');
    print('  - Rôle: ${_currentUser?['role']}');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _currentUser != null
                    ? '${_currentUser!['first_name']?[0] ?? ''}${_currentUser!['last_name']?[0] ?? ''}'
                    : '...',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nom et profession
          Text(
            _currentUser != null
                ? '${_currentUser!['first_name']} ${_currentUser!['last_name']}'
                : 'Chargement...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentUser != null
                ? '${_currentUser!['role']?.toString().toUpperCase() ?? 'TECHNICIEN'}'
                : 'Chargement...',
            style: const TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
          const SizedBox(height: 16),
          // Contact
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Color(0xFF1976D2)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.email, color: Color(0xFF1976D2)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message, color: Color(0xFF1976D2)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Informations personnelles
  Widget _buildPersonalInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations personnelles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _currentUser?['email'] ?? 'Non disponible'),
          _buildInfoRow(
              'Téléphone', _currentUser?['phone'] ?? 'Non disponible'),
          _buildInfoRow(
              'Adresse', _currentUser?['address'] ?? 'Non disponible'),
          _buildInfoRow('Date d\'embauche',
              _currentUser?['hire_date'] ?? 'Non disponible'),
          _buildInfoRow('Statut', _currentUser?['status'] ?? 'Actif'),
        ],
      ),
    );
  }

  // Ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF23272F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Statistiques
  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Tâches terminées',
            '${_completedTasks?.length ?? 0}',
            Icons.check_circle,
            const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Heures travaillées',
            '${_timeSheet?['total_hours'] ?? 0}h',
            Icons.access_time,
            const Color(0xFF1976D2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Projets',
            '${_assignedProjects?.length ?? 0}',
            Icons.business,
            const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }

  // Carte de statistique
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Actions du profil
  Widget _buildProfileActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionTile(Icons.edit, 'Modifier le profil', () {}),
          _buildActionTile(Icons.lock, 'Changer le mot de passe', () {}),
          _buildActionTile(
            Icons.notifications,
            'Paramètres notifications',
            () {},
          ),
          _buildActionTile(Icons.help, 'Aide et support', () {}),
          _buildActionTile(Icons.logout, 'Se déconnecter', _handleLogout),
        ],
      ),
    );
  }

  // Ligne d'action
  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1976D2)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFF6C757D),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  // Section Date et Heure avec bouton de pointage
  Widget _buildDateTimeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aujourd\'hui',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mercredi 27 Mars 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23272F),
                  ),
                ),
              ],
            ),
          ),
          // Bouton de pointage vert
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pointer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '(08:15)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Mes tâches
  Widget _buildMyTasksSection() {
    print('🔍 Construction de la section Mes tâches');
    print('  - _assignedTasks: $_assignedTasks');
    print('  - Nombre de tâches: ${_assignedTasks?.length ?? 0}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mes tâches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23272F),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_assignedTasks?.length ?? 0} actives',
                style: const TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Affichage des tâches réelles
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_assignedTasks == null || _assignedTasks!.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Aucune tâche assignée',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ..._assignedTasks!.take(3).map((task) {
            final status = task['status']?['value'] ?? 'pending';
            final priority = task['priority']?['value'] ?? 'medium';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTaskCard(
                status: _getStatusLabel(status),
                statusColor: _getStatusColor(status),
                statusTextColor: Colors.white,
                project: task['project']?['name'] ?? 'Projet inconnu',
                title: task['title'] ?? 'Tâche sans titre',
                description: task['description'] ?? 'Aucune description',
                leftIcon: Icons.calendar_today,
                leftText: _formatDueDate(task['dates']?['due_date']),
                rightIcon: Icons.person,
                rightText:
                    'Assigné par: ${task['created_by']?['name'] ?? 'Inconnu'}',
                buttonText: _getButtonText(status),
                buttonIcon: _getButtonIcon(status),
                buttonColor: _getButtonColor(status),
                showProgress: status == 'in_progress',
                progressValue: _getProgressValue(task),
              ),
            );
          }).toList(),
      ],
    );
  }

  // Carte de tâche
  Widget _buildTaskCard({
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String project,
    required String title,
    required String description,
    required IconData leftIcon,
    required String leftText,
    required IconData rightIcon,
    required String rightText,
    required String buttonText,
    required IconData buttonIcon,
    required Color buttonColor,
    bool showProgress = false,
    double progressValue = 0.0,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec statut et projet
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                project,
                style: const TextStyle(color: Color(0xFF6C757D), fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Titre de la tâche
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
          ),

          const SizedBox(height: 16),

          // Détails avec icônes
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(leftIcon, color: const Color(0xFF6C757D), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        leftText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (showProgress) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            rightIcon,
                            color: const Color(0xFFFF9800),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rightText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: const Color(0xFFE9ECEF),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF9800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(rightIcon, color: const Color(0xFF6C757D), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        rightText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Bouton d'action
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(buttonIcon, color: Colors.white, size: 20),
              label: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Actions rapides
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 20),

        // Grille 2x2 des actions rapides
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                Icons.camera_alt,
                'Photo validation',
                const Color(0xFF4CAF50),
                const Color(0xFFE8F5E8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                Icons.description,
                'Documents',
                const Color(0xFF1976D2),
                const Color(0xFFE3F2FD),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                Icons.warning,
                'Signaler problème',
                const Color(0xFFFF9800),
                const Color(0xFFFFF3E0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                Icons.chat_bubble,
                'Messages',
                const Color(0xFF9C27B0),
                const Color(0xFFF3E5F5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Carte d'action rapide
  Widget _buildQuickActionCard(
    IconData icon,
    String label,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: iconColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Section Activité récente
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activité récente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 20),

        // Activité 1
        _buildActivityItem(
          Icons.check_circle,
          const Color(0xFF4CAF50),
          const Color(0xFFE8F5E8),
          'Tâche terminée',
          'Villa B1 - Éclairage salon • Hier',
        ),

        const SizedBox(height: 16),

        // Activité 2
        _buildActivityItem(
          Icons.chat_bubble,
          const Color(0xFF1976D2),
          const Color(0xFFE3F2FD),
          'Nouveau commentaire',
          'Sophie B. sur Villa A3 • Il y a 2h',
        ),
      ],
    );
  }

  // Élément d'activité
  Widget _buildActivityItem(
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Élément de navigation
  Widget _buildNavItem(IconData icon, String label, int index, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _selectedNavIndex == index
              ? color.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthodes pour les nouvelles fonctionnalités

  // Pointage (Clock-in/Clock-out)
  Future<void> _handleClockIn() async {
    try {
      final clockInData = {
        'timestamp': DateTime.now().toIso8601String(),
        'location': 'Site principal',
        'notes': 'Pointage automatique',
      };

      final response = await _technicienService.clockIn(clockInData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Pointage d\'entrée enregistré: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors du pointage: $e');
      }
    }
  }

  Future<void> _handleClockOut() async {
    try {
      final clockOutData = {
        'timestamp': DateTime.now().toIso8601String(),
        'location': 'Site principal',
        'notes': 'Pointage automatique',
      };

      final response = await _technicienService.clockOut(clockOutData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Pointage de sortie enregistré: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors du pointage: $e');
      }
    }
  }

  // Actions sur les tâches
  Future<void> _completeTask(
      String taskId, Map<String, dynamic> completionData) async {
    try {
      final response =
          await _technicienService.completeTask(taskId, completionData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tâche terminée: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de la finalisation de la tâche: $e');
      }
    }
  }

  Future<void> _validateTask(
      String taskId, Map<String, dynamic> validationData) async {
    try {
      final response =
          await _technicienService.validateTask(taskId, validationData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tâche validée: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de la validation de la tâche: $e');
      }
    }
  }

  Future<void> _reportIssue(
      String taskId, Map<String, dynamic> issueData) async {
    try {
      final response = await _technicienService.reportIssue(taskId, issueData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Problème signalé: ${response['message']}'),
            backgroundColor: Colors.orange,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors du signalement du problème: $e');
      }
    }
  }
}

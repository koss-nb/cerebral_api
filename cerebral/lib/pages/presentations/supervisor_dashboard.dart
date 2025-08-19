import 'package:flutter/material.dart';
import '../../core/services/supervisor_service.dart';
import '../../core/services/auth_service.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  int _selectedNavIndex = 0; // 0: Accueil, 1: Flux, 2: Tâches, 3: Équipe

  // Services
  final SupervisorService _supervisorService = SupervisorService();
  final AuthService _authService = AuthService();

  // États des données
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<Map<String, dynamic>>? _myTeams;
  List<Map<String, dynamic>>? _supervisedProjects;
  List<Map<String, dynamic>>? _supervisionReports;
  List<Map<String, dynamic>>? _qualityChecks;
  List<Map<String, dynamic>>? _incidents;
  List<Map<String, dynamic>>? _technicalIssues;
  List<Map<String, dynamic>>? _pendingApprovals;
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Charger les données du dashboard
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les données de l'utilisateur actuel
      await _loadCurrentUser();

      // Charger toutes les données du service supervisor en une fois
      final dashboardData = await _supervisorService.loadDashboardData();

      if (mounted) {
        setState(() {
          _dashboardData = dashboardData['dashboard'];
          _myTeams = dashboardData['myTeams'];
          _supervisedProjects = dashboardData['supervisedProjects'];
          _supervisionReports = dashboardData['supervisionReports'];
          _qualityChecks = dashboardData['qualityChecks'];
          _incidents = dashboardData['incidents'];
          _technicalIssues = dashboardData['technicalIssues'];
          _pendingApprovals = dashboardData['pendingApprovals'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showError('Erreur lors du chargement des données: $e');
      }
    }
  }

  // Méthode pour afficher les erreurs
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Charger l'utilisateur actuel
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Erreur chargement utilisateur: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête vert avec logo et notifications
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
              child: Row(
                children: [
                  // Logo CEREBRAL avec casque
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.construction,
                          color: Color(0xFF4CAF50),
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
                                ? '${_currentUser!['first_name']} ${_currentUser!['last_name']} - ${_currentUser!['role']?.toString().toUpperCase() ?? 'SUPERVISEUR'}'
                                : 'Chargement...',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Badge de notification
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'SB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Sélecteur de projet
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  const Expanded(
                    child: Text(
                      'Résidence Soleil (12 villas)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF6C757D),
                    size: 24,
                  ),
                ],
              ),
            ),

            // Contenu principal avec navigation par onglets
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : IndexedStack(
                      index: _selectedNavIndex,
                      children: [
                        // Onglet Accueil (index 0)
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Validations en attente
                              _buildPendingValidationsSection(),

                              const SizedBox(height: 24),

                              // Section Avancement du projet
                              _buildProjectProgressSection(),

                              const SizedBox(height: 24),

                              // Section Équipe sur site
                              _buildOnSiteTeamSection(),

                              const SizedBox(height: 24),

                              // Boutons d'action rapide
                              _buildQuickActionButtons(),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        // Onglet Flux (index 1)
                        _buildWorkflowTab(),

                        // Onglet Tâches (index 2)
                        _buildTasksTab(),

                        // Onglet Équipe (index 3)
                        _buildTeamTab(),
                      ],
                    ),
            ),
          ],
        ),
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
                  _selectedNavIndex == 0
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF6C757D),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.account_tree,
                  'Flux',
                  1,
                  _selectedNavIndex == 1
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF6C757D),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.checklist,
                  'Tâches',
                  2,
                  _selectedNavIndex == 2
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF6C757D),
                ),
                const Spacer(),
                _buildNavItem(
                  Icons.people,
                  'Équipe',
                  3,
                  _selectedNavIndex == 3
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF6C757D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Validations en attente
  Widget _buildPendingValidationsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
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
          // En-tête avec icône et titre
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFFF44336),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Validations en attente (5)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Liste des validations
          _buildValidationItem(
            'Villa A3 - Électricité',
            'Jean Dupont • Il y a 2h',
          ),
          const SizedBox(height: 16),
          _buildValidationItem(
            'Apt B12 - Plomberie',
            'Marie Martin • Il y a 4h',
          ),

          const SizedBox(height: 20),

          // Lien vers toutes les validations
          Center(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Voir toutes les validations',
                style: TextStyle(
                  color: Color(0xFF1976D2),
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

  // Élément de validation
  Widget _buildValidationItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
      ),
      child: Row(
        children: [
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
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Valider',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Avancement du projet
  Widget _buildProjectProgressSection() {
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
            'Avancement Résidence Soleil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          // Statistiques de résumé
          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  '8',
                  'Terminées',
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressStat(
                  '3',
                  'En cours',
                  const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressStat(
                  '1',
                  'Bloquée',
                  const Color(0xFFF44336),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Liste des villas avec statut
          _buildVillaProgressItem(
            'Villa A1',
            'Finitions',
            90,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildVillaProgressItem(
            'Villa A2',
            'Électricité',
            65,
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: 16),
          _buildVillaProgressItem(
            'Villa A3',
            'Bloquée',
            45,
            const Color(0xFFF44336),
          ),
        ],
      ),
    );
  }

  // Statistique de progression
  Widget _buildProgressStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Élément de progression d'une villa
  Widget _buildVillaProgressItem(
    String villa,
    String status,
    int percentage,
    Color statusColor,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                villa,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  // Section Équipe sur site
  Widget _buildOnSiteTeamSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Équipe sur site',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const Text(
                '12 personnes',
                style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Liste des membres d'équipe
          _buildTeamMemberItem(
            'JD',
            'Jean Dupont',
            'Électricien • Villa A3',
            const Color(0xFF1976D2),
            'Présent',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildTeamMemberItem(
            'MM',
            'Marie Martin',
            'Plombier • Apt B12',
            const Color(0xFF4CAF50),
            'Présent',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildTeamMemberItem(
            'PD',
            'Pierre Durand',
            'Maçon • Villa A1',
            const Color(0xFFFF9800),
            'Absent',
            const Color(0xFFF44336),
          ),

          const SizedBox(height: 20),

          // Lien vers toute l'équipe
          Center(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Voir toute l\'équipe',
                style: TextStyle(
                  color: Color(0xFF1976D2),
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

  // Élément membre d'équipe
  Widget _buildTeamMemberItem(
    String initials,
    String name,
    String role,
    Color avatarColor,
    String status,
    Color statusColor,
  ) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Informations
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),
        ),
        // Statut et téléphone
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Icon(Icons.phone, color: const Color(0xFF6C757D), size: 20),
          ],
        ),
      ],
    );
  }

  // Boutons d'action rapide
  Widget _buildQuickActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                Icons.play_arrow,
                'Lancer étape',
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionButton(
                Icons.checklist,
                'Créer tâche',
                const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                Icons.description,
                'Rapport',
                const Color(0xFFFF9800),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionButton(
                Icons.show_chart,
                'Budget',
                const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Bouton d'action rapide
  Widget _buildQuickActionButton(IconData icon, String label, Color color) {
    return Container(
      height: 100,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        constraints: const BoxConstraints(
          minWidth: 60,
          maxWidth: double.infinity,
          minHeight: 60,
          maxHeight: double.infinity,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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

  // Onglet Flux (Workflow)
  Widget _buildWorkflowTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestion des Flux de Travail',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          // Statistiques des workflows
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '8',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Actifs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '3',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'En pause',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '2',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Bloqués',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Workflows en cours
          const Text(
            'Workflows en cours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildWorkflowItem(
            'Construction Villa A3',
            'Électricité • Étape 3/5',
            60,
            const Color(0xFF4CAF50),
            'Jean Dupont',
          ),
          const SizedBox(height: 16),
          _buildWorkflowItem(
            'Plomberie Apt B12',
            'Installation • Étape 2/4',
            50,
            const Color(0xFFFF9800),
            'Marie Martin',
          ),
          const SizedBox(height: 16),
          _buildWorkflowItem(
            'Finitions Villa A1',
            'Peinture • Étape 4/4',
            90,
            const Color(0xFF4CAF50),
            'Alice Lambert',
          ),

          const SizedBox(height: 24),

          // Bouton d'ajout de workflow
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Créer un nouveau workflow'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Élément de workflow
  Widget _buildWorkflowItem(
    String title,
    String subtitle,
    int progress,
    Color color,
    String responsible,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: double.infinity,
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
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
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$progress%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: const Color(0xFFE9ECEF),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Responsable: $responsible',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C757D),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.play_arrow, color: Color(0xFF4CAF50)),
                    tooltip: 'Démarrer',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.pause, color: Color(0xFFFF9800)),
                    tooltip: 'Pause',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.stop, color: Color(0xFFF44336)),
                    tooltip: 'Arrêter',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Onglet Tâches
  Widget _buildTasksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestion des Tâches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          // Filtres et recherche
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF6C757D)),
                      SizedBox(width: 8),
                      Text('Rechercher une tâche...'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9ECEF)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF6C757D)),
                    SizedBox(width: 8),
                    Text('Filtres'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Statistiques des tâches
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '15',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'À faire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '8',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'En cours',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Terminées',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '3',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Bloquées',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Liste des tâches
          const Text(
            'Tâches prioritaires',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildSupervisorTaskItem(
            'Validation électricité Villa A3',
            'Jean Dupont • Urgent • Échéance: Aujourd\'hui',
            const Color(0xFFF44336),
            'Valider',
            const Color(0xFFF44336),
            'Villa A3',
            'Électricité',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTaskItem(
            'Contrôle plomberie Apt B12',
            'Marie Martin • En cours • Échéance: Demain',
            const Color(0xFFFF9800),
            'Suivre',
            const Color(0xFFFF9800),
            'Apt B12',
            'Plomberie',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTaskItem(
            'Livraison matériaux',
            'Prévue à 14h00 • Échéance: Aujourd\'hui',
            const Color(0xFF1976D2),
            'Préparer',
            const Color(0xFF1976D2),
            'Entrepôt',
            'Logistique',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTaskItem(
            'Contrôle sécurité',
            'Pierre Durand • En attente • Échéance: Cette semaine',
            const Color(0xFF9C27B0),
            'Programmer',
            const Color(0xFF9C27B0),
            'Site entier',
            'Sécurité',
          ),
        ],
      ),
    );
  }

  // Élément de tâche pour superviseur
  Widget _buildSupervisorTaskItem(
    String title,
    String subtitle,
    Color priorityColor,
    String buttonText,
    Color buttonColor,
    String location,
    String category,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 120,
        maxHeight: double.infinity,
      ),
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
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration:
                    BoxDecoration(color: priorityColor, shape: BoxShape.circle),
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
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Informations supplémentaires
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF1976D2), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.category,
                        color: Color(0xFF9C27B0), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9C27B0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Onglet Équipe
  Widget _buildTeamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestion de l\'Équipe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          // Statistiques de l'équipe
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '9',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Présents',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '2',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'En pause',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Absent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Actions d'équipe
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add),
                  label: const Text('Ajouter membre'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.schedule),
                  label: const Text('Pointage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Liste des membres d'équipe
          const Text(
            'Membres de l\'équipe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildSupervisorTeamMemberItem(
            'JD',
            'Jean Dupont',
            'Électricien • Villa A3',
            const Color(0xFF1976D2),
            'Présent',
            const Color(0xFF4CAF50),
            '08:15',
            'Villa A3',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTeamMemberItem(
            'MM',
            'Marie Martin',
            'Plombier • Apt B12',
            const Color(0xFF4CAF50),
            'Présent',
            const Color(0xFF4CAF50),
            '08:00',
            'Apt B12',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTeamMemberItem(
            'PD',
            'Pierre Durand',
            'Maçon • Villa A1',
            const Color(0xFFFF9800),
            'Absent',
            const Color(0xFFF44336),
            '--',
            'Villa A1',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTeamMemberItem(
            'AL',
            'Alice Lambert',
            'Peintre • Villa A2',
            const Color(0xFF9C27B0),
            'Présent',
            const Color(0xFF4CAF50),
            '08:30',
            'Villa A2',
          ),
          const SizedBox(height: 16),
          _buildSupervisorTeamMemberItem(
            'ML',
            'Marc Leroy',
            'Menuisier • Villa A4',
            const Color(0xFF607D8B),
            'En pause',
            const Color(0xFFFF9800),
            '10:45',
            'Villa A4',
          ),
        ],
      ),
    );
  }

  // Élément membre d'équipe pour superviseur
  Widget _buildSupervisorTeamMemberItem(
    String initials,
    String name,
    String role,
    Color avatarColor,
    String status,
    Color statusColor,
    String time,
    String location,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: double.infinity,
      ),
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
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(color: avatarColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF6C757D)),
                    ),
                  ],
                ),
              ),
              // Statut
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Informations supplémentaires
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time,
                        color: Color(0xFF1976D2), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF9C27B0), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9C27B0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Actions
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, color: Color(0xFF1976D2)),
                    tooltip: 'Appeler',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message, color: Color(0xFF4CAF50)),
                    tooltip: 'Message',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Color(0xFFFF9800)),
                    tooltip: 'Modifier',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Méthodes pour les nouvelles fonctionnalités supervisor

  // Approbation de contrôles qualité
  Future<void> _approveQualityCheck(
      String checkId, Map<String, dynamic> approvalData) async {
    try {
      final response =
          await _supervisorService.approveQualityCheck(checkId, approvalData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contrôle qualité approuvé: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de l\'approbation: $e');
      }
    }
  }

  // Résolution d'incidents
  Future<void> _resolveIncident(Map<String, dynamic> resolutionData) async {
    try {
      final response = await _supervisorService.resolveIncident(resolutionData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incident résolu: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de la résolution: $e');
      }
    }
  }

  // Revue technique
  Future<void> _technicalReview(
      String taskId, Map<String, dynamic> reviewData) async {
    try {
      final response =
          await _supervisorService.technicalReview(taskId, reviewData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Revue technique effectuée: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de la revue technique: $e');
      }
    }
  }

  // Escalade d'incidents
  Future<void> _escalateIssue(Map<String, dynamic> escalationData) async {
    try {
      final response = await _supervisorService.escalateIssue(escalationData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incident escaladé: ${response['message']}'),
            backgroundColor: Colors.orange,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de l\'escalade: $e');
      }
    }
  }

  // Approbation finale
  Future<void> _finalApproval(
      String projectId, Map<String, dynamic> approvalData) async {
    try {
      final response =
          await _supervisorService.finalApproval(projectId, approvalData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Projet approuvé: ${response['message']}'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur lors de l\'approbation finale: $e');
      }
    }
  }
}

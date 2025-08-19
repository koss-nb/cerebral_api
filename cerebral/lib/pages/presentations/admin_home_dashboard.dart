import 'package:cerebral/pages/presentations/admin_rapport_page.dart';
import 'package:cerebral/pages/presentations/screen14.dart';
import 'package:flutter/material.dart';
import 'package:cerebral/core/services/dashboard_service.dart';

class AdminHomeDashboard extends StatefulWidget {
  const AdminHomeDashboard({super.key});

  @override
  State<AdminHomeDashboard> createState() => _AdminHomeDashboardState();
}

class _AdminHomeDashboardState extends State<AdminHomeDashboard> {
  final DashboardService _dashboardService = DashboardService();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  String? _errorMessage;

  // Données des projets
  List<dynamic>? _projects;
  bool _isLoadingProjects = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadProjects();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _dashboardService.getStats();

      if (mounted) {
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Charger les données des projets
  Future<void> _loadProjects() async {
    try {
      print('🚀 Début du chargement des projets...');
      setState(() {
        _isLoadingProjects = true;
      });

      final projectsData = await _dashboardService.getProjects();
      print('✅ Données reçues de l\'API: $projectsData');
      print('🔍 Type de données: ${projectsData.runtimeType}');
      print('🔍 Clés disponibles: ${projectsData.keys.toList()}');

      if (mounted) {
        setState(() {
          // Extraire la liste des projets de la réponse
          if (projectsData['data'] != null) {
            _projects = List<dynamic>.from(projectsData['data']);
            print('📊 Projets extraits de "data": ${_projects!.length}');
          } else if (projectsData['projects'] != null) {
            _projects = List<dynamic>.from(projectsData['projects']);
            print('📊 Projets extraits de "projects": ${_projects!.length}');
          } else {
            _projects = [];
            print('⚠️ Aucune clé de projets trouvée, données: $projectsData');

            // Fallback: utiliser des données de test
            print('🔄 Utilisation des données de test...');
            _projects = [
              {
                'id': 1,
                'name': 'Résidence Soleil',
                'type': 'residential',
                'status': 'in_progress',
                'progress': 75.0,
                'budget': 2500000.0,
                'currency': 'EUR',
                'location': 'Nice, France',
                'description': 'Résidence de luxe avec 12 villas'
              },
              {
                'id': 2,
                'name': 'Les Jardins',
                'type': 'residential',
                'status': 'on_hold',
                'progress': 45.0,
                'budget': 1800000.0,
                'currency': 'EUR',
                'location': 'Lyon, France',
                'description': '18 appartements avec jardin'
              },
              {
                'id': 3,
                'name': 'Villa Moderne',
                'type': 'residential',
                'status': 'completed',
                'progress': 90.0,
                'budget': 800000.0,
                'currency': 'EUR',
                'location': 'Bordeaux, France',
                'description': '8 villas contemporaines'
              }
            ];
            print('✅ Données de test chargées: ${_projects!.length} projets');
          }
          _isLoadingProjects = false;
        });

        print('🎯 Projets chargés: ${_projects?.length ?? 0}');
        if (_projects != null && _projects!.isNotEmpty) {
          print('📋 Premier projet: ${_projects!.first}');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des projets: $e');
      if (mounted) {
        setState(() {
          _projects = [];
          _isLoadingProjects = false;
        });
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
            // Header bleu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2549B2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Logo et titre
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.psychology,
                            color: Color(0xFF2549B2),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'CEREBRAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Promoteur - Vue Globale',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Indicateur de chargement des projets
                  if (_isLoadingProjects)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Projets',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Notifications
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'PM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Bannière d'alertes critiques
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '3 alertes critiques',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal avec scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Vue d'ensemble
                    Row(
                      children: [
                        const Text(
                          'Vue d\'ensemble',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _loadDashboardData();
                            _loadProjects();
                          },
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Rafraîchir les données',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grille des statistiques
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Projets actifs',
                          _projects != null ? '${_projects!.length}' : '4',
                          _projects != null
                              ? '${_projects!.where((p) => p['status'] == 'in_progress').length} en cours'
                              : '+1 ce mois',
                          Icons.business,
                          const Color(0xFFE3F2FD),
                          const Color(0xFF1976D2),
                          _projects != null ? Colors.green : Colors.grey,
                        ),
                        _buildStatCard(
                          'Villas/Appts',
                          '47',
                          '12 en cours',
                          Icons.home,
                          const Color(0xFFE8F5E8),
                          const Color(0xFF388E3C),
                          const Color(0xFF1976D2),
                        ),
                        _buildStatCard(
                          'Budget global',
                          _projects != null
                              ? _formatBudget(_calculateTotalBudget())
                              : '8.2M€',
                          _projects != null
                              ? '${_projects!.length} projets'
                              : '87% consommé',
                          Icons.euro,
                          const Color(0xFFFFF3E0),
                          const Color(0xFFFF9800),
                          const Color(0xFFFF9800),
                        ),
                        _buildStatCard(
                          'Personnel',
                          '68',
                          '45 actifs',
                          Icons.people,
                          const Color(0xFFF3E5F5),
                          const Color(0xFF9C27B0),
                          const Color(0xFF9C27B0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Section Avancement par projet
                    Row(
                      children: [
                        const Text(
                          'Avancement par projet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const Spacer(),
                        if (_isLoadingProjects)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        if (_projects != null && _projects!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_projects!.length} projets',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Affichage des projets réels
                    if (_projects != null && _projects!.isNotEmpty) ...[
                      ..._projects!.map((project) {
                        print('🎨 Affichage du projet: $project');
                        final progress = (project['progress'] ?? 0.0) / 100.0;
                        final name = project['name'] ?? 'Projet sans nom';
                        final type = project['type'] ?? 'N/A';
                        final status = project['status'] ?? 'N/A';

                        // Déterminer la couleur selon le statut
                        Color statusColor;
                        switch (status.toString().toLowerCase()) {
                          case 'completed':
                            statusColor = Colors.green;
                            break;
                          case 'in_progress':
                            statusColor = const Color(0xFF1976D2);
                            break;
                          case 'on_hold':
                            statusColor = const Color(0xFFFF9800);
                            break;
                          case 'cancelled':
                            statusColor = Colors.red;
                            break;
                          default:
                            statusColor = Colors.grey;
                        }

                        // Construire la description
                        String description = type;
                        if (project['budget'] != null) {
                          description +=
                              ' • ${project['budget']} ${project['currency'] ?? 'EUR'}';
                        }
                        if (project['location'] != null) {
                          description += ' • ${project['location']}';
                        }

                        return Column(
                          children: [
                            _buildProgressCard(
                              name,
                              progress,
                              description,
                              statusColor,
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                    ] else if (_isLoadingProjects) ...[
                      // Affichage pendant le chargement
                      _buildProgressCard(
                        'Chargement...',
                        0.0,
                        'Récupération des projets',
                        Colors.grey,
                      ),
                    ] else ...[
                      // Aucun projet trouvé
                      _buildProgressCard(
                        'Aucun projet',
                        0.0,
                        'Aucun projet disponible',
                        Colors.grey,
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Section Alertes critiques détaillées
                    const Text(
                      'Alertes critiques',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAlertCard(
                      'Retard Villa A3',
                      'Électricité bloquée depuis 3 jours',
                      '-3j',
                      Icons.access_time,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(
                      'Dépassement budget',
                      'Projet Les Jardins +15%',
                      '+180k€',
                      Icons.euro,
                      const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertCard(
                      'Stock matériaux',
                      'Ciment en rupture',
                      '0 sacs',
                      Icons.inventory,
                      Colors.amber,
                    ),

                    const SizedBox(height: 32),

                    // Section Actions rapides
                    const Text(
                      'Actions rapides',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildActionCard(
                          title: 'Nouveau Projet',
                          icon: Icons.add,
                          bgColor: const Color(0xFFE3F2FD),
                          iconColor: const Color(0xFF1976D2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Screen14(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          title: 'Rapports',
                          icon: Icons.assessment,
                          bgColor: const Color(0xFFE8F5E8),
                          iconColor: const Color(0xFF388E3C),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminRapportPage(),
                              ),
                            );
                          },
                        ),
                        // _buildActionCard(
                        //   title: 'Utilisateurs',
                        //   icon: Icons.person_add,
                        //   bgColor: const Color(0xFFF3E5F5),
                        //   iconColor: const Color(0xFF9C27B0),
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => PersonnelManagementPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // _buildActionCard(
                        //   title: 'Paramètres',
                        //   icon: Icons.settings,
                        //   bgColor: const Color(0xFFFFF3E0),
                        //   iconColor: const Color(0xFFFF9800),
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => Settings(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Section Activité récente
                    const Text(
                      'Activité récente',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildActivityCard(
                      'Villa B2 - Plomberie validée',
                      'Il y a 2h • Par Sophie Blanc',
                      Icons.check_circle,
                      const Color(0xFFE8F5E8),
                      const Color(0xFF388E3C),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityCard(
                      'Facture BTP Solutions - 25,000€',
                      'Il y a 4h • En attente validation',
                      Icons.euro,
                      const Color(0xFFE3F2FD),
                      const Color(0xFF1976D2),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityCard(
                      'Nouveau technicien ajouté',
                      'Hier • Marc Dubois - Électricien',
                      Icons.person,
                      const Color(0xFFFFF3E0),
                      const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String detail,
    IconData icon,
    Color bgColor,
    Color iconColor,
    Color detailColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // évite l'overflow
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23272F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5B6478),
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: detailColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    double progress,
    String details,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5B6478)),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
    String title,
    String subtitle,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
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
                    color: Color(0xFF5B6478),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
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
                    color: Color(0xFF5B6478),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculer le budget total des projets
  double _calculateTotalBudget() {
    if (_projects == null || _projects!.isEmpty) return 0.0;

    double total = 0.0;
    for (final project in _projects!) {
      if (project['budget'] != null) {
        total += (project['budget'] is int)
            ? (project['budget'] as int).toDouble()
            : (project['budget'] is double)
                ? project['budget']
                : double.tryParse(project['budget'].toString()) ?? 0.0;
      }
    }
    return total;
  }

  // Formater le budget pour l'affichage
  String _formatBudget(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M€';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K€';
    } else {
      return '${amount.toStringAsFixed(0)}€';
    }
  }
}

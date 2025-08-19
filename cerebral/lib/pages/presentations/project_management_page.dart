import 'package:cerebral/pages/presentations/screen14.dart';
import 'package:flutter/material.dart';
import 'package:cerebral/core/services/project_service.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  final ProjectService _projectService = ProjectService();

  bool _isLoading = true;
  List<dynamic>? _projects;
  String? _errorMessage;

  // Variables pour les popups
  Map<String, dynamic>? _selectedProject;
  bool _isEditing = false;
  bool _isUpdating = false;

  // Contrôleurs pour l'édition
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();
  final TextEditingController _editBudgetController = TextEditingController();
  final TextEditingController _editLocationController = TextEditingController();
  String _editSelectedType = '';
  String _editSelectedStatus = '';
  double _editProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editDescriptionController.dispose();
    _editBudgetController.dispose();
    _editLocationController.dispose();
    super.dispose();
  }

  // Charger les projets
  Future<void> _loadProjects() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _projectService.getProjects();

      if (mounted) {
        setState(() {
          // Gérer différents formats de réponse
          try {
            if (data['projects'] != null) {
              _projects = List<dynamic>.from(data['projects']);
            } else if (data['data'] != null) {
              _projects = List<dynamic>.from(data['data']);
            } else if (data.values.isNotEmpty) {
              // Si c'est une Map, essayer de trouver une liste dans les valeurs
              final firstValue = data.values.first;
              if (firstValue is List) {
                _projects = List<dynamic>.from(firstValue);
              } else {
                _projects = [];
              }
            } else {
              _projects = [];
            }
          } catch (e) {
            _projects = [];
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // En-tête bleu foncé avec navigation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(color: Color(0xFF1E3A8A)),
            child: Row(
              children: [
                // Bouton retour
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Titre centré
                const Expanded(
                  child: Text(
                    'Gestion des Projets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16),
                // Icônes de droite
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section des statistiques des projets
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Erreur: $_errorMessage',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProjects,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildStatisticItem(
                              '${_projects?.length ?? 0}',
                              'Total',
                              const Color(0xFF1976D2),
                            ),
                          ),
                          Expanded(
                            child: _buildStatisticItem(
                              '${_projects?.where((p) => p['status'] == 'active').length ?? 0}',
                              'Actifs',
                              const Color(0xFF4CAF50),
                            ),
                          ),
                          Expanded(
                            child: _buildStatisticItem(
                              '${_projects?.where((p) => p['status'] == 'completed').length ?? 0}',
                              'Terminés',
                              const Color(0xFFFF9800),
                            ),
                          ),
                          Expanded(
                            child: _buildStatisticItem(
                              '${_projects?.where((p) => p['status'] == 'pending').length ?? 0}',
                              'En attente',
                              const Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
          ),

          // Liste des projets avec scroll
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Erreur: $_errorMessage',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProjects,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _projects == null || _projects!.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun projet trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _projects!.length,
                            itemBuilder: (context, index) {
                              final project = _projects![index];
                              return Column(
                                children: [
                                  _buildDynamicProjectCard(project),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
          ),
        ],
      ),

      // Bouton d'action flottant
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Screen14()),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 100),
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF1976D2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  // Élément de statistique
  Widget _buildStatisticItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF23272F)),
        ),
      ],
    );
  }

  // Carte de projet dynamique basée sur les vraies données
  Widget _buildDynamicProjectCard(Map<String, dynamic> project) {
    // Extraire les données du projet
    final name = project['name'] ?? 'Sans nom';
    final description = project['description'] ?? 'Aucune description';
    final status = project['status'] ?? 'unknown';
    final progress =
        (double.tryParse(project['progress']?.toString() ?? '0') ?? 0.0) /
            100.0; // Convertir % en décimal
    final budget = double.tryParse(project['budget']?.toString() ?? '0') ?? 0.0;
    final currency = project['currency'] ?? 'EUR';
    final location = project['location'] ?? 'Localisation inconnue';
    final startDate = project['start_date'] ?? '';
    final clientName = project['client_name'] ?? 'Client inconnu';
    final teamMemberIds =
        project['team_member_ids'] ?? project['teamMemberIds'] ?? [];
    final managerId = project['manager_id'] ?? project['managerId'];

    // Déterminer les couleurs selon le statut
    Color statusColor;
    String statusText;
    switch (status.toString().toLowerCase()) {
      case 'active':
      case 'in_progress':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Actif';
        break;
      case 'pending':
      case 'planning':
        statusColor = const Color(0xFFFF9800);
        statusText = 'En attente';
        break;
      case 'completed':
        statusColor = const Color(0xFF1976D2);
        statusText = 'Terminé';
        break;
      case 'cancelled':
      case 'on_hold':
        statusColor = const Color(0xFFF44336);
        statusText = 'En pause';
        break;
      default:
        statusColor = const Color(0xFF6C757D);
        statusText = 'Inconnu';
    }

    // Formater la date
    String formattedDate = 'Date inconnue';
    if (startDate.isNotEmpty) {
      try {
        final date = DateTime.parse(startDate);
        formattedDate = 'Démarré: ${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = 'Date: $startDate';
      }
    }

    // Formater le budget
    String formattedBudget = '${budget.toStringAsFixed(0)} $currency';
    if (budget >= 1000000) {
      formattedBudget = '${(budget / 1000000).toStringAsFixed(1)}M $currency';
    } else if (budget >= 1000) {
      formattedBudget = '${(budget / 1000).toStringAsFixed(0)}K $currency';
    }

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
          // En-tête avec titre, détails et menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$description • $location',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Menu des options
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditProjectDialog(project);
                      break;
                    case 'team':
                      _showTeamManagementDialog(project);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(project);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'team',
                    child: Row(
                      children: [
                        Icon(Icons.people, size: 20),
                        SizedBox(width: 8),
                        Text('Gérer l\'équipe'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF6C757D),
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tag de statut
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date de démarrage
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 14, color: Color(0xFF23272F)),
          ),

          const SizedBox(height: 20),

          // Barre de progression globale
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Avancement global',
                style: TextStyle(fontSize: 14, color: Color(0xFF23272F)),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE9ECEF),
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),

          const SizedBox(height: 20),

          // Métriques du projet (4 colonnes)
          Row(
            children: [
              // Budget
              Expanded(
                child: Column(
                  children: [
                    Text(
                      formattedBudget,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const Text(
                      'Budget',
                      style: TextStyle(fontSize: 12, color: Color(0xFF23272F)),
                    ),
                  ],
                ),
              ),
              // Client
              Expanded(
                child: Column(
                  children: [
                    Text(
                      clientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Client',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF23272F),
                      ),
                    ),
                  ],
                ),
              ),
              // Type
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _formatProjectType(project['type'] ?? 'N/A'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const Text(
                      'Type',
                      style: TextStyle(fontSize: 12, color: Color(0xFF23272F)),
                    ),
                  ],
                ),
              ),
              // Équipe
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${teamMemberIds.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                    const Text(
                      'Équipe',
                      style: TextStyle(fontSize: 12, color: Color(0xFF23272F)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Boutons d'action
          Row(
            children: [
              // Bouton Détails (gauche)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showProjectDetails(project),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Détails',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bouton Équipe (droite)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showTeamManagementDialog(project),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Équipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Afficher les détails du projet
  void _showProjectDetails(Map<String, dynamic> project) {
    setState(() {
      _selectedProject = project;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF1976D2)),
              const SizedBox(width: 8),
              const Text('Détails du Projet'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Nom', project['name'] ?? 'N/A'),
                _buildDetailRow('Description',
                    project['description'] ?? 'Aucune description'),
                _buildDetailRow('Type', project['type'] ?? 'N/A'),
                _buildDetailRow('Statut', project['status'] ?? 'N/A'),
                _buildDetailRow('Budget',
                    '${project['budget'] ?? 0} ${project['currency'] ?? 'EUR'}'),
                _buildDetailRow('Localisation', project['location'] ?? 'N/A'),
                _buildDetailRow('Progression', '${project['progress'] ?? 0}%'),
                if (project['start_date'] != null)
                  _buildDetailRow(
                      'Date de début', _formatDate(project['start_date'])),
                if (project['end_date'] != null)
                  _buildDetailRow(
                      'Date de fin', _formatDate(project['end_date'])),
                if (project['client_name'] != null)
                  _buildDetailRow('Client', project['client_name']),
                if (project['client_email'] != null)
                  _buildDetailRow('Email client', project['client_email']),
                _buildDetailRow('Créé le', _formatDate(project['created_at'])),
                if (project['updated_at'] != null)
                  _buildDetailRow(
                      'Modifié le', _formatDate(project['updated_at'])),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditProjectDialog(project);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
              ),
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  // Afficher le dialogue de modification
  void _showEditProjectDialog(Map<String, dynamic> project) {
    // Initialiser les contrôleurs avec les valeurs actuelles
    _editNameController.text = project['name'] ?? '';
    _editDescriptionController.text = project['description'] ?? '';
    _editBudgetController.text = (project['budget'] ?? 0).toString();
    _editLocationController.text = project['location'] ?? '';
    _editSelectedType = project['type'] ?? '';
    _editSelectedStatus = project['status'] ?? '';
    _editProgress = (project['progress'] ?? 0.0).toDouble();

    // Mettre à jour l'état de la classe parent
    setState(() {
      _selectedProject = project;
      _isEditing = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFF1976D2)),
                  const SizedBox(width: 8),
                  const Text('Modifier le Projet'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nom du projet
                    TextField(
                      controller: _editNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du projet *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextField(
                      controller: _editDescriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Type de projet
                    DropdownButtonFormField<String>(
                      value: _editSelectedType.isNotEmpty
                          ? _editSelectedType
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Type de projet *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'residential', child: Text('Résidentiel')),
                        DropdownMenuItem(
                            value: 'commercial', child: Text('Commercial')),
                        DropdownMenuItem(
                            value: 'industrial', child: Text('Industriel')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _editSelectedType = value ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Statut
                    DropdownButtonFormField<String>(
                      value: _editSelectedStatus.isNotEmpty
                          ? _editSelectedStatus
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Statut *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'planning', child: Text('Planification')),
                        DropdownMenuItem(
                            value: 'in_progress', child: Text('En cours')),
                        DropdownMenuItem(
                            value: 'on_hold', child: Text('En attente')),
                        DropdownMenuItem(
                            value: 'completed', child: Text('Terminé')),
                        DropdownMenuItem(
                            value: 'cancelled', child: Text('Annulé')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _editSelectedStatus = value ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Budget
                    TextField(
                      controller: _editBudgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Budget',
                        border: OutlineInputBorder(),
                        suffixText: 'EUR',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Localisation
                    TextField(
                      controller: _editLocationController,
                      decoration: const InputDecoration(
                        labelText: 'Localisation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Progression
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Progression: ${_editProgress.toInt()}%'),
                        Slider(
                          value: _editProgress,
                          min: 0.0,
                          max: 100.0,
                          divisions: 100,
                          label: '${_editProgress.toInt()}%',
                          onChanged: (value) {
                            setDialogState(() {
                              _editProgress = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Mettre à jour l'état de la classe parent
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed:
                      _isUpdating ? null : () => _updateProject(project['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sauvegarder'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Mettre à jour le projet
  Future<void> _updateProject(int projectId) async {
    if (_editNameController.text.isEmpty ||
        _editSelectedType.isEmpty ||
        _editSelectedStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final budget =
          double.tryParse(_editBudgetController.text.replaceAll(',', '.'));

      await _projectService.updateProject(
        projectId,
        name: _editNameController.text.trim(),
        description: _editDescriptionController.text.trim(),
        type: _editSelectedType,
        status: _editSelectedStatus,
        budget: budget,
        location: _editLocationController.text.trim(),
        progress: _editProgress,
      );

      // Succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projet mis à jour avec succès !'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        // Fermer le dialogue et recharger les projets
        Navigator.of(context).pop();
        setState(() {
          _isEditing = false;
        });
        _loadProjects(); // Recharger les projets
      }
    } catch (e) {
      // Gestion des erreurs
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: ${e.toString()}'),
            backgroundColor: Color(0xFFF44336),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  // Construire une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF6C757D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Formater une date
  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'N/A';

    try {
      if (dateValue is String) {
        final date = DateTime.parse(dateValue);
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } else if (dateValue is DateTime) {
        return '${dateValue.day.toString().padLeft(2, '0')}/${dateValue.month.toString().padLeft(2, '0')}/${dateValue.year}';
      }
    } catch (e) {
      return 'Date invalide';
    }

    return 'N/A';
  }

  // Formater le type de projet
  String _formatProjectType(String type) {
    switch (type.toLowerCase()) {
      case 'residential':
        return 'Résidentiel';
      case 'commercial':
        return 'Commercial';
      case 'industrial':
        return 'Industriel';
      case 'infrastructure':
        return 'Infrastructure';
      case 'renovation':
        return 'Rénovation';
      default:
        return type;
    }
  }

  // Afficher le dialogue de gestion de l'équipe
  void _showTeamManagementDialog(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gérer l\'équipe du projet'),
          content:
              const Text('Fonctionnalité de gestion d\'équipe à implémenter.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  // Afficher la confirmation de suppression
  void _showDeleteConfirmation(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer le projet "${project['name']}"? Cette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProject(project['id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  // Supprimer un projet
  Future<void> _deleteProject(int projectId) async {
    try {
      await _projectService.deleteProject(projectId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projet supprimé avec succès !'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        _loadProjects(); // Recharger les projets
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: ${e.toString()}'),
            backgroundColor: Color(0xFFF44336),
          ),
        );
      }
    }
  }
}

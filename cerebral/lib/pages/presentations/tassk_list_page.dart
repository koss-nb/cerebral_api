import 'package:cerebral/pages/presentations/screen16.dart';
import 'package:cerebral/pages/presentations/screen4.dart';
import 'package:flutter/material.dart';
import 'package:cerebral/core/services/task_service.dart';
import 'package:cerebral/core/services/project_service.dart';
import 'package:cerebral/core/services/personnel_service.dart';

class TasskListPage extends StatefulWidget {
  const TasskListPage({super.key});

  @override
  State<TasskListPage> createState() => _TasskListPageState();
}

class _TasskListPageState extends State<TasskListPage> {
  int _selectedViewIndex = 0; // 0 pour Liste, 1 pour Kanban

  // Services
  final TaskService _taskService = TaskService();
  final ProjectService _projectService = ProjectService();
  final PersonnelService _personnelService = PersonnelService();

  // Données
  List<dynamic>? _tasks;
  List<dynamic>? _projects;
  List<dynamic>? _personnel;
  bool _isLoading = true;
  String? _errorMessage;

  // Filtres
  String? _selectedProjectFilter;
  String? _selectedStatusFilter;
  String? _selectedPriorityFilter;

  // États des colonnes Kanban
  final Map<String, List<dynamic>> _kanbanColumns = {
    'pending': [],
    'in_progress': [],
    'waiting_validation': [],
    'completed': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Charger les données
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Charger les projets, les tâches et le personnel en parallèle
      await Future.wait([
        _loadProjects(),
        _loadTasks(),
        _loadPersonnel(),
      ]);

      if (mounted) {
        setState(() {
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

  // Charger les projets
  Future<void> _loadProjects() async {
    try {
      final projectsData = await _projectService.getProjects();

      if (mounted) {
        setState(() {
          if (projectsData['data'] != null) {
            _projects = List<dynamic>.from(projectsData['data']);
          } else if (projectsData['projects'] != null) {
            _projects = List<dynamic>.from(projectsData['projects']);
          } else {
            _projects = [];
          }
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des projets: $e');
    }
  }

  // Charger les tâches
  Future<void> _loadTasks() async {
    try {
      final tasksData = await _taskService.getTasks();

      if (mounted) {
        setState(() {
          if (tasksData['data'] != null) {
            _tasks = List<dynamic>.from(tasksData['data']);
          } else if (tasksData['tasks'] != null) {
            _tasks = List<dynamic>.from(tasksData['tasks']);
          } else {
            _tasks = [];
          }

          // Debug: Afficher la structure des premières tâches
          if (_tasks != null && _tasks!.isNotEmpty) {
            print('=== Structure des tâches ===');
            print('Nombre de tâches: ${_tasks!.length}');
            if (_tasks!.isNotEmpty) {
              print('Première tâche: ${_tasks!.first}');
              print(
                  'Clés de la première tâche: ${_tasks!.first.keys.toList()}');
              print(
                  'Type de project_id: ${_tasks!.first['project_id'].runtimeType}');
              print(
                  'Type de assigned_to: ${_tasks!.first['assigned_to']?.runtimeType}');
            }
          }

          // Organiser les tâches dans les colonnes Kanban
          _organizeTasksInColumns();
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des tâches: $e');
    }
  }

  // Charger le personnel
  Future<void> _loadPersonnel() async {
    try {
      final personnelData = await _personnelService.getPersonnel();
      if (mounted) {
        setState(() {
          _personnel = List<dynamic>.from(personnelData['data'] ?? []);
        });
      }
    } catch (e) {
      print('Erreur lors du chargement du personnel: $e');
    }
  }

  // Organiser les tâches dans les colonnes Kanban
  void _organizeTasksInColumns() {
    if (_tasks == null) return;

    // Réinitialiser les colonnes
    _kanbanColumns.forEach((key, value) => value.clear());

    for (final task in _tasks!) {
      final statusRaw = task['status'];
      String status = 'pending';

      // Nouvelle structure: status est un objet avec value
      if (statusRaw is Map<String, dynamic>) {
        status = (statusRaw['value'] ?? 'pending').toString().toLowerCase();
      } else if (statusRaw is String) {
        status = statusRaw.toLowerCase();
      }

      if (status == 'pending' || status == 'to_do') {
        _kanbanColumns['pending']!.add(task);
      } else if (status == 'in_progress' || status == 'working') {
        _kanbanColumns['in_progress']!.add(task);
      } else if (status == 'waiting_validation' || status == 'review') {
        _kanbanColumns['waiting_validation']!.add(task);
      } else if (status == 'completed' || status == 'done') {
        _kanbanColumns['completed']!.add(task);
      } else {
        // Tâches avec statut inconnu vont dans "pending"
        _kanbanColumns['pending']!.add(task);
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
            // En-tête
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Bouton retour
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF23272F),
                      size: 24,
                    ),
                  ),
                  // Titre central
                  const Expanded(
                    child: Text(
                      'Gestion des Tâches',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                  ),
                  // Icônes droite
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sélecteur de vue (Segmented Control)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Bouton Liste (sélectionné)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedViewIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedViewIndex == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _selectedViewIndex == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted,
                              color: _selectedViewIndex == 0
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Liste',
                              style: TextStyle(
                                color: _selectedViewIndex == 0
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedViewIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bouton Kanban (non sélectionné)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedViewIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedViewIndex == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _selectedViewIndex == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: _selectedViewIndex == 1
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kanban',
                              style: TextStyle(
                                color: _selectedViewIndex == 1
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedViewIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filtres (Dropdowns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Filtre Projet
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showProjectFilterDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedProjectFilter != null
                              ? const Color(0xFF1976D2).withOpacity(0.1)
                              : const Color(0xFFE9ECEF),
                          borderRadius: BorderRadius.circular(12),
                          border: _selectedProjectFilter != null
                              ? Border.all(color: const Color(0xFF1976D2))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedProjectFilter ?? 'Tous les projets',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedProjectFilter != null
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF23272F),
                                fontWeight: _selectedProjectFilter != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF6C757D),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filtre Villa (sélectionné)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF1976D2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Toutes villas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contenu principal - Vue Liste ou Kanban
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Chargement des tâches...'),
                        ],
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Erreur: $_errorMessage',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadData,
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        )
                      : _selectedViewIndex == 0
                          ? _buildListView()
                          : _buildKanbanView(),
            ),
          ],
        ),
      ),

      // Bouton d'action flottant (FAB)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Screen16()),
            );
          },
          backgroundColor: const Color(0xFF1976D2),
          heroTag: "task_fab",
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  // Vue Liste
  Widget _buildListView() {
    if (_tasks == null || _tasks!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Color(0xFF6C757D)),
            SizedBox(height: 16),
            Text(
              'Aucune tâche trouvée',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6C757D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _tasks!.length + 1, // +1 pour l'espace en bas
      itemBuilder: (context, index) {
        // Dernier élément = espace en bas
        if (index == _tasks!.length) {
          return const SizedBox(height: 120); // Espace pour le FAB
        }

        final task = _tasks![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildTaskCard(
            task,
            task['title'] ?? 'Tâche sans titre',
            task['description'] ?? '',
            _getAssigneeName(task['assigned_to']),
            _formatDueDate(task['dates']),
            _extractPriorityLabel(task['priority']),
            _getPriorityColor(_normalizePriority(task['priority'])),
            hasAttachments: task['metadata'] != null &&
                (task['metadata']['attachments_count'] ?? 0) > 0,
            attachmentCount: task['metadata']?['attachments_count'] ?? 0,
            hasComments: false,
            commentCount: 0,
          ),
        );
      },
    );
  }

  // Vue Kanban
  Widget _buildKanbanView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne des colonnes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne "En attente"
              _buildTaskColumn(
                'En attente',
                const Color(0xFF6C757D),
                _kanbanColumns['pending']?.length ?? 0,
                _buildTaskCardsFromData(_kanbanColumns['pending'] ?? []),
              ),

              const SizedBox(width: 20),

              // Colonne "En cours"
              _buildTaskColumn(
                'En cours',
                const Color(0xFF1976D2),
                _kanbanColumns['in_progress']?.length ?? 0,
                _buildTaskCardsFromData(_kanbanColumns['in_progress'] ?? []),
              ),

              const SizedBox(width: 20),

              // Colonne "En attente de validation"
              _buildTaskColumn(
                'En attente de validation',
                const Color(0xFFFF9800),
                _kanbanColumns['waiting_validation']?.length ?? 0,
                _buildTaskCardsFromData(
                    _kanbanColumns['waiting_validation'] ?? []),
              ),

              const SizedBox(width: 20),

              // Colonne "Terminé"
              _buildTaskColumn(
                'Terminé',
                const Color(0xFF4CAF50),
                _kanbanColumns['completed']?.length ?? 0,
                _buildTaskCardsFromData(_kanbanColumns['completed'] ?? []),
              ),
            ],
          ),
          // Espace en bas pour le FAB
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // Colonne de tâches
  Widget _buildTaskColumn(
    String title,
    Color color,
    int taskCount,
    List<Widget> tasks,
  ) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de colonne
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  taskCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tâches
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: task,
            ),
          ),
        ],
      ),
    );
  }

  // Carte de tâche
  Widget _buildTaskCard(
    Map<String, dynamic> task,
    String title,
    String subtitle,
    String assignee,
    String dueDate,
    String priority,
    Color priorityColor, {
    bool hasAttachments = false,
    int attachmentCount = 0,
    bool hasComments = false,
    int commentCount = 0,
  }) {
    return GestureDetector(
      onTap: () {
        print('🖱️ Clic sur la tâche:');
        print('   - Task complet: $task');
        print('   - Task ID: ${task['id']}');
        print('   - Task ID type: ${task['id'].runtimeType}');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Screen4(taskId: task['id'])),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et priorité avec bouton d'édition
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Bouton d'édition
                GestureDetector(
                  onTap: () {
                    _showTaskEditDialog(task);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF1976D2),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Sous-titre
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
            ),

            const SizedBox(height: 12),

            // Assigné
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF6C757D), size: 16),
                const SizedBox(width: 8),
                Text(
                  assignee,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date d'échéance
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF6C757D),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  dueDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),

            // Pièces jointes ou commentaires
            if (hasAttachments) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    color: Color(0xFF6C757D),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$attachmentCount p',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ],

            if (hasComments) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.chat_bubble,
                    color: Color(0xFF6C757D),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    commentCount.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Afficher le dialogue de filtre des projets
  void _showProjectFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrer par projet'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Option "Tous les projets"
                ListTile(
                  title: const Text('Tous les projets'),
                  leading: Radio<String?>(
                    value: null,
                    groupValue: _selectedProjectFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedProjectFilter = value;
                      });
                      Navigator.of(context).pop();
                      _applyFilters();
                    },
                  ),
                ),
                // Liste des projets
                if (_projects != null) ...[
                  ..._projects!.map((project) => ListTile(
                        title: Text(project['name'] ?? 'Projet sans nom'),
                        subtitle: Text(project['type'] ?? ''),
                        leading: Radio<String>(
                          value: project['name'] ?? '',
                          groupValue: _selectedProjectFilter,
                          onChanged: (value) {
                            setState(() {
                              _selectedProjectFilter = value;
                            });
                            Navigator.of(context).pop();
                            _applyFilters();
                          },
                        ),
                      )),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // Appliquer les filtres
  void _applyFilters() {
    // Recharger les tâches avec les filtres
    _loadTasks();
  }

  // Construire les cartes de tâches à partir des données
  List<Widget> _buildTaskCardsFromData(List<dynamic> tasks) {
    return tasks.map((task) {
      final title = task['title'] ?? 'Tâche sans titre';
      final description = task['description'] ?? '';
      final projectName = _getProjectName(task['project']);
      final assignee = _getAssigneeName(task['assigned_to']);
      final dueDate = _formatDueDate(task['dates']);
      final normalizedPriority = _normalizePriority(task['priority']);
      final priorityLabel = _extractPriorityLabel(task['priority']);
      final priorityColor = _getPriorityColor(normalizedPriority);
      final hasAttachments = task['metadata'] != null &&
          (task['metadata']['attachments_count'] ?? 0) > 0;
      final attachmentCount = task['metadata']?['attachments_count'] ?? 0;
      final hasComments =
          false; // Pas d'info sur les commentaires dans la nouvelle structure
      final commentCount = 0;

      return _buildTaskCard(
        task,
        title,
        '$projectName • $description',
        assignee,
        dueDate,
        priorityLabel,
        priorityColor,
        hasAttachments: hasAttachments,
        attachmentCount: attachmentCount,
        hasComments: hasComments,
        commentCount: commentCount,
      );
    }).toList();
  }

  // Obtenir le nom du projet
  String _getProjectName(dynamic projectId) {
    if (projectId == null) return 'Projet inconnu';

    // Nouvelle structure: project est un objet avec name
    if (projectId is Map<String, dynamic>) {
      return projectId['name'] ?? 'Projet inconnu';
    }

    return 'Projet inconnu';
  }

  // Obtenir le nom de l'assigné
  String _getAssigneeName(dynamic assigneeId) {
    if (assigneeId == null) return 'Non assigné';

    // Nouvelle structure: assigned_to est un objet avec name
    if (assigneeId is Map<String, dynamic>) {
      return assigneeId['name'] ?? 'Utilisateur inconnu';
    } else {
      return 'Non assigné';
    }
  }

  // Formater la date d'échéance
  String _formatDueDate(dynamic dueDate) {
    if (dueDate == null) return 'Pas de date';

    // Nouvelle structure: dates est un objet avec due_date et days_remaining
    if (dueDate is Map<String, dynamic>) {
      final daysRemaining = dueDate['days_remaining'];
      final isOverdue = dueDate['is_overdue'] ?? false;

      if (isOverdue) return 'En retard';
      if (daysRemaining == 0) return 'Aujourd\'hui';
      if (daysRemaining == 1) return 'Demain';
      if (daysRemaining != null && daysRemaining <= 7) return 'Cette semaine';

      // Si on a une date brute
      final dueDateStr = dueDate['due_date'];
      if (dueDateStr != null) {
        try {
          final date = DateTime.parse(dueDateStr);
          return '${date.day}/${date.month}/${date.year}';
        } catch (e) {
          return 'Date invalide';
        }
      }
    }

    // Fallback pour l'ancienne structure
    if (dueDate is String) {
      try {
        final date = DateTime.parse(dueDate);
        final now = DateTime.now();
        final difference = date.difference(now).inDays;

        if (difference < 0) return 'En retard';
        if (difference == 0) return 'Aujourd\'hui';
        if (difference == 1) return 'Demain';
        if (difference <= 7) return 'Cette semaine';
        return '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        return 'Date invalide';
      }
    }

    return 'Pas de date';
  }

  // Normaliser la valeur de priorité depuis différents formats (String ou Map)
  String _normalizePriority(dynamic priority) {
    if (priority == null) return 'medium';
    if (priority is String) return priority.toLowerCase();
    if (priority is Map<String, dynamic>) {
      final dynamic value = priority['value'];
      if (value is String && value.isNotEmpty) {
        return value.toLowerCase();
      }
      final dynamic label = priority['label'];
      if (label is String && label.isNotEmpty) {
        final lower = label.toLowerCase();
        if (lower.contains('crit') || lower.contains('urgent'))
          return 'critical';
        if (lower.contains('haut') ||
            lower.contains('élev') ||
            lower.contains('high')) return 'high';
        if (lower.contains('normal') ||
            lower.contains('moyen') ||
            lower.contains('medium')) return 'medium';
        if (lower.contains('faible') || lower.contains('low')) return 'low';
      }
    }
    return 'medium';
  }

  // Extraire un label affichable pour la priorité
  String _extractPriorityLabel(dynamic priority) {
    // Afficher EXACTEMENT la valeur envoyée par l'API si disponible
    if (priority == null) return 'medium';
    if (priority is Map<String, dynamic>) {
      final dynamic value = priority['value'];
      if (value is String && value.isNotEmpty) return value;
      final dynamic label = priority['label'];
      if (label is String && label.isNotEmpty) return label;
      return 'medium';
    }
    if (priority is String) return priority;
    return 'medium';
  }

  // Obtenir la couleur de priorité
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
      case 'urgent':
      case 'high':
        return const Color(0xFFF44336);
      case 'normal':
      case 'medium':
        return const Color(0xFFFF9800);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Afficher le popup de modification de tâche
  void _showTaskEditDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskEditDialog(
          task: task,
          personnel: _personnel ?? [],
          projects: _projects ?? [],
          onTaskUpdated: (updatedTask) async {
            print('🔄 DEBUG: Callback onTaskUpdated appelé');
            print('🔄 DEBUG: Tâche mise à jour reçue: $updatedTask');
            print('🔄 DEBUG: ID de la tâche: ${updatedTask['id']}');
            print('🔄 DEBUG: Nouveau statut: ${updatedTask['status']}');

            // Mettre à jour la tâche dans la liste
            print('🔄 DEBUG: Mise à jour de la liste locale...');
            setState(() {
              final index =
                  _tasks?.indexWhere((t) => t['id'] == updatedTask['id']);
              print('🔄 DEBUG: Index trouvé: $index');
              if (index != null && index != -1) {
                print('🔄 DEBUG: Mise à jour de la tâche à l\'index $index');
                print('🔄 DEBUG: Ancien statut: ${_tasks![index]['status']}');
                _tasks![index] = updatedTask;
                print(
                    '🔄 DEBUG: Nouveau statut après mise à jour: ${_tasks![index]['status']}');
              } else {
                print('❌ DEBUG: Tâche non trouvée dans la liste locale');
              }
            });

            // Reorganiser les colonnes Kanban
            print('🔄 DEBUG: Réorganisation des colonnes Kanban...');
            _organizeTasksInColumns();
            print('🔄 DEBUG: Colonnes Kanban réorganisées');

            // Recharger les données depuis l'API pour s'assurer de la synchronisation
            print('🔄 DEBUG: Rechargement des données depuis l\'API...');
            await _loadTasks();
            print('🔄 DEBUG: Données rechargées depuis l\'API');
            print('🎉 DEBUG: Processus de mise à jour terminé');
          },
        );
      },
    );
  }
}

// Classe pour le popup de modification de tâche
class TaskEditDialog extends StatefulWidget {
  final Map<String, dynamic> task;
  final List<dynamic> personnel;
  final List<dynamic> projects;
  final Function(Map<String, dynamic>) onTaskUpdated;

  const TaskEditDialog({
    super.key,
    required this.task,
    required this.personnel,
    required this.projects,
    required this.onTaskUpdated,
  });

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late TextEditingController _estimatedHoursController;
  late TextEditingController _actualHoursController;

  String _selectedStatus = 'pending';
  String _selectedPriority = 'medium';
  String _selectedProject = '';
  String _selectedAssignee = '';
  DateTime? _selectedDueDate;
  double _progress = 0.0;

  bool _isLoading = false;

  // Helpers pour gérer la priorité (copiés ici pour portée locale au dialog)
  String _normalizePriority(dynamic priority) {
    if (priority == null) return 'medium';
    if (priority is String) return priority.toLowerCase();
    if (priority is Map<String, dynamic>) {
      final dynamic value = priority['value'];
      if (value is String && value.isNotEmpty) {
        return value.toLowerCase();
      }
      final dynamic label = priority['label'];
      if (label is String && label.isNotEmpty) {
        final lower = label.toLowerCase();
        if (lower.contains('crit') || lower.contains('urgent'))
          return 'critical';
        if (lower.contains('haut') ||
            lower.contains('élev') ||
            lower.contains('high')) return 'high';
        if (lower.contains('normal') ||
            lower.contains('moyen') ||
            lower.contains('medium')) return 'medium';
        if (lower.contains('faible') || lower.contains('low')) return 'low';
      }
    }
    return 'medium';
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final task = widget.task;

    _titleController = TextEditingController(text: task['title'] ?? '');
    _descriptionController =
        TextEditingController(text: task['description'] ?? '');
    _notesController = TextEditingController(text: task['notes'] ?? '');
    // Nouvelle structure: time_tracking est un objet avec estimated_hours et actual_hours
    final timeTrackingRaw = task['time_tracking'];
    if (timeTrackingRaw is Map<String, dynamic>) {
      _estimatedHoursController = TextEditingController(
          text: (timeTrackingRaw['estimated_hours'] ?? 0).toString());
      _actualHoursController = TextEditingController(
          text: (timeTrackingRaw['actual_hours'] ?? 0).toString());
    } else {
      // Fallback pour l'ancienne structure
      _estimatedHoursController = TextEditingController(
          text: (task['estimated_hours'] ?? 0).toString());
      _actualHoursController =
          TextEditingController(text: (task['actual_hours'] ?? 0).toString());
    }

    // Nouvelle structure: status est un objet avec value
    final statusRaw = task['status'];
    if (statusRaw is Map<String, dynamic>) {
      _selectedStatus = statusRaw['value'] ?? 'pending';
    } else if (statusRaw is String) {
      _selectedStatus = statusRaw;
    } else {
      _selectedStatus = 'pending';
    }

    _selectedPriority = _normalizePriority(task['priority']);
    // Nouvelle structure: project est un objet avec id
    final projectRaw = task['project'];
    if (projectRaw is Map<String, dynamic>) {
      _selectedProject = (projectRaw['id'] ?? '').toString();
    } else if (projectRaw is int) {
      _selectedProject = projectRaw.toString();
    } else {
      _selectedProject = '';
    }

    // Nouvelle structure: assigned_to est un objet avec id
    final assignedTo = task['assigned_to'];
    if (assignedTo is Map<String, dynamic>) {
      _selectedAssignee = assignedTo['id']?.toString() ?? '';
    } else if (assignedTo is int) {
      _selectedAssignee = assignedTo.toString();
    } else {
      _selectedAssignee = '';
    }

    // Nouvelle structure: dates est un objet avec due_date
    final datesRaw = task['dates'];
    if (datesRaw is Map<String, dynamic>) {
      final dueDateStr = datesRaw['due_date'];
      if (dueDateStr != null) {
        _selectedDueDate = DateTime.parse(dueDateStr);
      }
    } else if (task['due_date'] != null) {
      // Fallback pour l'ancienne structure
      _selectedDueDate = DateTime.parse(task['due_date']);
    }

    // Nouvelle structure: progress est un objet avec percentage
    final progressRaw = task['progress'];
    if (progressRaw is Map<String, dynamic>) {
      final percentage = progressRaw['percentage'];
      if (percentage != null) {
        if (percentage is String) {
          _progress = double.tryParse(percentage) ?? 0.0;
        } else if (percentage is num) {
          _progress = percentage.toDouble();
        } else {
          _progress = 0.0;
        }
      } else {
        _progress = 0.0;
      }
    } else if (progressRaw != null) {
      // Fallback pour l'ancienne structure
      if (progressRaw is String) {
        _progress = double.tryParse(progressRaw) ?? 0.0;
      } else if (progressRaw is num) {
        _progress = progressRaw.toDouble();
      } else {
        _progress = 0.0;
      }
    } else {
      _progress = 0.0;
    }

    // S'assurer que la progression est entre 0 et 1
    _progress = _progress.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _estimatedHoursController.dispose();
    _actualHoursController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    print('🔍 DEBUG: Début de _saveTask');
    print('🔍 DEBUG: Statut sélectionné: $_selectedStatus');
    print('🔍 DEBUG: Priorité sélectionnée: $_selectedPriority');

    if (!_formKey.currentState!.validate()) {
      print('❌ DEBUG: Validation du formulaire échouée');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final taskId = widget.task['id'];
      print('🔍 DEBUG: ID de la tâche: $taskId');
      print('🔍 DEBUG: Tâche originale: ${widget.task}');

      final updatedTask = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'project_id': int.tryParse(_selectedProject) ?? 1,
        'due_date': _selectedDueDate?.toIso8601String(),
        'estimated_hours': int.tryParse(_estimatedHoursController.text) ?? 0,
        'actual_hours': int.tryParse(_actualHoursController.text) ?? 0,
        'progress': (_progress * 100).round() / 100, // Arrondir à 2 décimales
        'notes': _notesController.text.trim(),
      };

      print('🔍 DEBUG: Données à envoyer: $updatedTask');

      // Utiliser directement l'ID de l'assigné
      if (_selectedAssignee.isNotEmpty) {
        updatedTask['assigned_to'] = int.tryParse(_selectedAssignee);
        print('🔍 DEBUG: Assigné ID: ${updatedTask['assigned_to']}');
      }

      Map<String, dynamic> result;
      if (taskId != null) {
        // Mise à jour d'une tâche existante
        print('🔍 DEBUG: Appel de updateTask pour ID: $taskId');
        result = await _taskService.updateTask(
          taskId,
          title: updatedTask['title'],
          description: updatedTask['description'],
          status: updatedTask['status'],
          priority: updatedTask['priority'],
          projectId: updatedTask['project_id'],
          dueDate: updatedTask['due_date'] != null
              ? DateTime.parse(updatedTask['due_date'])
              : null,
          assignedTo: updatedTask['assigned_to'],
          estimatedHours: updatedTask['estimated_hours'],
          actualHours: updatedTask['actual_hours'],
          notes: updatedTask['notes'],
        );
        print('🔍 DEBUG: Résultat de updateTask: $result');
      } else {
        // Création d'une nouvelle tâche
        print('🔍 DEBUG: Appel de createTask');
        result = await _taskService.createTask(
          title: updatedTask['title'],
          description: updatedTask['description'],
          projectId: updatedTask['project_id'],
          status: updatedTask['status'],
          priority: updatedTask['priority'],
          dueDate: updatedTask['due_date'] != null
              ? DateTime.parse(updatedTask['due_date'])
              : DateTime.now(),
          assignedTo: updatedTask['assigned_to'],
          estimatedHours: updatedTask['estimated_hours'],
          actualHours: updatedTask['actual_hours'],
          notes: updatedTask['notes'],
        );
        print('🔍 DEBUG: Résultat de createTask: $result');
      }

      print('🔍 DEBUG: Vérification du résultat');
      print('🔍 DEBUG: Success: ${result['success']}');
      print('🔍 DEBUG: Message: ${result['message']}');
      print('🔍 DEBUG: Data: ${result['data']}');

      if (result['success'] == true) {
        print('✅ DEBUG: Succès détecté, appel du callback');

        // Créer un objet complet avec les données mises à jour
        final completeUpdatedTask = {
          ...widget.task, // Garder toutes les données originales
          ...updatedTask, // Remplacer par les nouvelles valeurs
          'id': widget.task['id'], // S'assurer que l'ID est présent
        };

        print(
            '✅ DEBUG: Tâche complète à passer au callback: $completeUpdatedTask');

        // Appeler le callback avec les données complètes mises à jour
        widget.onTaskUpdated(completeUpdatedTask);
        print('✅ DEBUG: Callback exécuté');

        // Fermer le popup
        Navigator.of(context).pop();
        print('✅ DEBUG: Popup fermé');

        // Afficher le message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(taskId != null
                ? 'Tâche mise à jour avec succès'
                : 'Tâche créée avec succès'),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
          ),
        );
        print('✅ DEBUG: Message de succès affiché');
      } else {
        print('❌ DEBUG: Échec détecté');
        // Gérer le cas où l'API retourne success: false
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erreur lors de la sauvegarde'),
            backgroundColor: const Color(0xFFFF9800),
            duration: const Duration(seconds: 3),
          ),
        );
        print('❌ DEBUG: Message d\'erreur affiché');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: const Color(0xFFF44336),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Modifier la tâche',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Contenu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre
                      _buildInputField(
                        label: 'Titre',
                        controller: _titleController,
                        isRequired: true,
                      ),

                      const SizedBox(height: 16),

                      // Description
                      _buildInputField(
                        label: 'Description',
                        controller: _descriptionController,
                        isMultiline: true,
                        isRequired: true,
                      ),

                      const SizedBox(height: 16),

                      // Statut et Priorité
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Statut',
                              value: _selectedStatus,
                              items: [
                                {'value': 'pending', 'label': 'En attente'},
                                {'value': 'in_progress', 'label': 'En cours'},
                                {'value': 'completed', 'label': 'Terminée'},
                                {'value': 'blocked', 'label': 'Bloquée'},
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Priorité',
                              value: _selectedPriority,
                              items: [
                                {'value': 'low', 'label': 'Faible'},
                                {'value': 'medium', 'label': 'Normale'},
                                {'value': 'high', 'label': 'Urgente'},
                                {'value': 'critical', 'label': 'Critique'},
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedPriority = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Projet et Assigné
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Projet',
                              value: _selectedProject,
                              items: widget.projects.map((project) {
                                return {
                                  'value': project['id'].toString(),
                                  'label': project['name']?.toString() ??
                                      'Projet ${project['id']}',
                                };
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedProject = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Assigné à',
                              value: _selectedAssignee,
                              items: [
                                {'value': '', 'label': 'Non assigné'},
                                ...widget.personnel.map((person) {
                                  final personalInfo = person['personal_info']
                                      as Map<String, dynamic>?;
                                  final fullName =
                                      personalInfo?['full_name']?.toString() ??
                                          '';
                                  final personId =
                                      person['id']?.toString() ?? '';
                                  return {
                                    'value': personId,
                                    'label': fullName.isNotEmpty
                                        ? fullName
                                        : 'Personnel ${personId}',
                                  };
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedAssignee = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Date d'échéance
                      _buildDateField(
                        label: 'Date d\'échéance',
                        value: _selectedDueDate,
                        onChanged: (date) {
                          setState(() {
                            _selectedDueDate = date;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Heures estimées et réelles
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Heures estimées',
                              controller: _estimatedHoursController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInputField(
                              label: 'Heures réelles',
                              controller: _actualHoursController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Progression
                      Text(
                        'Progression: ${(_progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF23272F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _progress,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: const Color(0xFF1976D2),
                        onChanged: (value) {
                          setState(() {
                            _progress = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Notes
                      _buildInputField(
                        label: 'Notes',
                        controller: _notesController,
                        isMultiline: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Boutons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    bool isMultiline = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMultiline ? 3 : 1,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ce champ est requis';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']!),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required Function(DateTime?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                      : 'Sélectionner une date',
                  style: TextStyle(
                    color: value != null
                        ? const Color(0xFF23272F)
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

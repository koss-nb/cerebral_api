import 'package:flutter/material.dart';
import '../../core/services/task_service.dart';
import '../../core/services/personnel_service.dart';
import '../../core/services/project_service.dart';

class WorkflowManagementPage extends StatefulWidget {
  const WorkflowManagementPage({super.key});

  @override
  State<WorkflowManagementPage> createState() => _WorkflowManagementPageState();
}

class _WorkflowManagementPageState extends State<WorkflowManagementPage> {
  final TaskService _taskService = TaskService();
  final PersonnelService _personnelService = PersonnelService();
  final ProjectService _projectService = ProjectService();

  List<dynamic>? _tasks;
  List<dynamic>? _personnel;
  List<dynamic>? _projects;
  bool _isLoading = false;

  // Définition des colonnes (étapes de travail)
  final List<String> columns = [
    'Acq.',
    'Fond.',
    'G.Œ.',
    'Élec.',
    'Plomb.',
    'Fin.',
    'Cont.',
    'Liv.',
  ];

  // Définition des lignes (unités)
  final List<String> rows = [
    'Villa A1',
    'Villa A2',
    'Villa A3',
    'Apt B1',
    'Apt B2',
  ];

  // Map pour stocker les statuts de chaque cellule
  Map<String, Map<String, String>> statusMap = {};

  @override
  void initState() {
    super.initState();
    // Initialisation des statuts par défaut
    _initializeStatusMap();
    // Chargement des données
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadTasks(),
        _loadPersonnel(),
        _loadProjects(),
      ]);
    } catch (e) {
      debugPrint('Erreur lors du chargement des données: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTasks() async {
    try {
      final tasksData = await _taskService.getTasks();
      if (mounted) {
        setState(() {
          _tasks = List<dynamic>.from(tasksData['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des tâches: $e');
    }
  }

  Future<void> _loadPersonnel() async {
    try {
      final personnelData = await _personnelService.getPersonnel();
      if (mounted) {
        setState(() {
          _personnel = List<dynamic>.from(personnelData['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement du personnel: $e');
    }
  }

  Future<void> _loadProjects() async {
    try {
      final projectsData = await _projectService.getProjects();
      if (mounted) {
        setState(() {
          _projects = List<dynamic>.from(projectsData['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des projets: $e');
    }
  }

  void _initializeStatusMap() {
    statusMap = {
      'Villa A1': {
        'Acq.': 'completed',
        'Fond.': 'completed',
        'G.Œ.': 'in_progress',
        'Élec.': 'not_started',
        'Plomb.': 'not_started',
        'Fin.': 'not_started',
        'Cont.': 'not_started',
        'Liv.': 'not_started',
      },
      'Villa A2': {
        'Acq.': 'completed',
        'Fond.': 'completed',
        'G.Œ.': 'completed',
        'Élec.': 'in_progress',
        'Plomb.': 'not_started',
        'Fin.': 'not_started',
        'Cont.': 'not_started',
        'Liv.': 'not_started',
      },
      'Villa A3': {
        'Acq.': 'completed',
        'Fond.': 'completed',
        'G.Œ.': 'completed',
        'Élec.': 'blocked',
        'Plomb.': 'in_progress',
        'Fin.': 'not_started',
        'Cont.': 'not_started',
        'Liv.': 'not_started',
      },
      'Apt B1': {
        'Acq.': 'completed',
        'Fond.': 'in_progress',
        'G.Œ.': 'not_started',
        'Élec.': 'not_started',
        'Plomb.': 'not_started',
        'Fin.': 'not_started',
        'Cont.': 'not_started',
        'Liv.': 'not_started',
      },
      'Apt B2': {
        'Acq.': 'completed',
        'Fond.': 'not_started',
        'G.Œ.': 'not_started',
        'Élec.': 'not_started',
        'Plomb.': 'not_started',
        'Fin.': 'not_started',
        'Cont.': 'not_started',
        'Liv.': 'not_started',
      },
    };
  }

  // Méthode pour mettre à jour le statut d'une cellule
  void _updateStatus(String unit, String column, String newStatus) {
    setState(() {
      statusMap[unit]![column] = newStatus;
    });

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Statut mis à jour : $unit - $column'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Méthode pour afficher le menu contextuel
  void _showStatusMenu(BuildContext context, String unit, String column) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 200,
      ),
      items: [
        _buildStatusMenuItem('Non commencée', 'not_started', unit, column),
        _buildStatusMenuItem('En cours', 'in_progress', unit, column),
        _buildStatusMenuItem('Terminée', 'completed', unit, column),
        _buildStatusMenuItem('Bloquée', 'blocked', unit, column),
      ],
    ).then((selectedStatus) {
      if (selectedStatus != null) {
        _updateStatus(unit, column, selectedStatus);
      }
    });
  }

  // Méthode pour construire un élément du menu
  PopupMenuItem<String> _buildStatusMenuItem(
    String label,
    String status,
    String unit,
    String column,
  ) {
    final currentStatus = statusMap[unit]?[column] ?? 'not_started';
    final isSelected = currentStatus == status;

    return PopupMenuItem<String>(
      value: status,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF23272F),
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, color: Color(0xFF1976D2), size: 16),
        ],
      ),
    );
  }

  // Méthode pour obtenir la couleur d'un statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFFFF9800);
      case 'blocked':
        return const Color(0xFFF44336);
      default: // not_started
        return const Color(0xFFE9ECEF);
    }
  }

  // Méthode pour obtenir le nombre de cellules par statut
  Map<String, int> _getStatusCounts() {
    Map<String, int> counts = {
      'completed': 0,
      'in_progress': 0,
      'blocked': 0,
      'not_started': 0,
    };

    for (String unit in rows) {
      for (String column in columns) {
        final status = statusMap[unit]?[column] ?? 'not_started';
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final statusCounts = _getStatusCounts();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête de la page
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Bouton retour
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF23272F),
                      size: 24,
                    ),
                  ),
                  // Titre central
                  const Expanded(
                    child: Text(
                      'Flux de Travaux',
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
                        onPressed: () {
                          // Action de filtrage
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Action de plein écran
                        },
                        icon: const Icon(
                          Icons.open_in_full,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sélecteur de projet
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  const Text(
                    'Résidence Soleil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF23272F),
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

            const SizedBox(height: 24),

            // Légende des statuts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusLegend('Non commencée', const Color(0xFFE9ECEF)),
                  _buildStatusLegend('En cours', const Color(0xFFFF9800)),
                  _buildStatusLegend('Terminée', const Color(0xFF4CAF50)),
                  _buildStatusLegend('Bloquée', const Color(0xFFF44336)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF1976D2).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF1976D2),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Appuyez longuement sur une cellule pour changer son statut',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tableau de suivi des travaux
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(child: _buildWorkflowTable()),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Résumé des statuts
            Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      '${statusCounts['completed'] ?? 0}',
                      'Terminées',
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      '${statusCounts['in_progress'] ?? 0}',
                      'En cours',
                      const Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      '${statusCounts['blocked'] ?? 0}',
                      'Bloquées',
                      const Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      '${statusCounts['not_started'] ?? 0}',
                      'À venir',
                      const Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6C757D),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowTable() {
    return DataTable(
      columnSpacing: 16,
      horizontalMargin: 16,
      columns: [
        const DataColumn(
          label: SizedBox(
            width: 80,
            child: Text(
              'Unité',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF23272F),
              ),
            ),
          ),
        ),
        ...columns.map(
          (column) => DataColumn(
            label: SizedBox(
              width: 60,
              child: Text(
                column,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
      rows: rows.map((row) {
        return DataRow(
          cells: [
            DataCell(
              SizedBox(
                width: 80,
                child: Text(
                  row,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
            ),
            ...columns.map((column) {
              final status = statusMap[row]?[column] ?? 'not_started';
              return DataCell(
                GestureDetector(
                  onLongPress: () {
                    _showStatusMenu(context, row, column);
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: _buildStatusIcon(status),
                  ),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return const Icon(Icons.check, color: Colors.white, size: 20);
      case 'in_progress':
        return const Icon(Icons.schedule, color: Colors.white, size: 20);
      case 'blocked':
        return const Icon(Icons.warning, color: Colors.white, size: 20);
      default: // not_started
        return Container(); // Cellule vide pour "non commencée"
    }
  }
}

// Classe pour le popup de modification de tâche
class TaskEditDialog extends StatefulWidget {
  final Map<String, dynamic>? task;
  final String unit;
  final String column;
  final List<dynamic> personnel;
  final List<dynamic> projects;
  final Function(Map<String, dynamic>) onTaskUpdated;

  const TaskEditDialog({
    super.key,
    required this.task,
    required this.unit,
    required this.column,
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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final task = widget.task;
    
    _titleController = TextEditingController(text: task?['title'] ?? '');
    _descriptionController = TextEditingController(text: task?['description'] ?? '');
    _notesController = TextEditingController(text: task?['notes'] ?? '');
    _estimatedHoursController = TextEditingController(text: (task?['estimated_hours'] ?? 0).toString());
    _actualHoursController = TextEditingController(text: (task?['actual_hours'] ?? 0).toString());
    
    _selectedStatus = task?['status'] ?? 'pending';
    _selectedPriority = task?['priority'] ?? 'medium';
    _selectedProject = (task?['project_id'] ?? '').toString();
    
    if (task?['assigned_to'] != null) {
      final assignedTo = task!['assigned_to'];
      if (assignedTo is Map<String, dynamic>) {
        _selectedAssignee = '${assignedTo['first_name']} ${assignedTo['last_name']}';
      }
    }
    
    if (task?['due_date'] != null) {
      _selectedDueDate = DateTime.parse(task!['due_date']);
    }
    
    _progress = (task?['progress'] ?? 0.0).toDouble();
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final taskId = widget.task?['id'];
      final updatedTask = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'project_id': int.tryParse(_selectedProject) ?? 1,
        'due_date': _selectedDueDate?.toIso8601String(),
        'estimated_hours': int.tryParse(_estimatedHoursController.text) ?? 0,
        'actual_hours': int.tryParse(_actualHoursController.text) ?? 0,
        'progress': _progress,
        'notes': _notesController.text.trim(),
      };

      // Trouver l'ID de l'assigné
      if (_selectedAssignee.isNotEmpty) {
        final person = widget.personnel.firstWhere(
          (p) {
            final personalInfo = p['personal_info'] as Map<String, dynamic>?;
            final fullName = personalInfo?['full_name']?.toString() ?? '';
            return fullName == _selectedAssignee;
          },
          orElse: () => <String, dynamic>{},
        );
        if (person.isNotEmpty) {
          updatedTask['assigned_to'] = person['id'];
        }
      }

      Map<String, dynamic> result;
      if (taskId != null) {
        // Mise à jour d'une tâche existante
        result = await _taskService.updateTask(
          taskId,
          title: updatedTask['title'],
          description: updatedTask['description'],
          status: updatedTask['status'],
          priority: updatedTask['priority'],
          projectId: updatedTask['project_id'],
          dueDate: updatedTask['due_date'] != null ? DateTime.parse(updatedTask['due_date']) : null,
          assignedTo: updatedTask['assigned_to'],
          estimatedHours: updatedTask['estimated_hours'],
          actualHours: updatedTask['actual_hours'],
          notes: updatedTask['notes'],
        );
      } else {
        // Création d'une nouvelle tâche
        result = await _taskService.createTask(
          title: updatedTask['title'],
          description: updatedTask['description'],
          projectId: updatedTask['project_id'],
          status: updatedTask['status'],
          priority: updatedTask['priority'],
          dueDate: updatedTask['due_date'] != null ? DateTime.parse(updatedTask['due_date']) : DateTime.now(),
          assignedTo: updatedTask['assigned_to'],
          estimatedHours: updatedTask['estimated_hours'],
          actualHours: updatedTask['actual_hours'],
          notes: updatedTask['notes'],
        );
      }

      if (result['success'] == true) {
        widget.onTaskUpdated(result['data'] ?? updatedTask);
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(taskId != null ? 'Tâche mise à jour avec succès' : 'Tâche créée avec succès'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
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
        constraints: const BoxConstraints(maxHeight: 600),
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
                      'Modifier la tâche - ${widget.unit} - ${widget.column}',
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
            Flexible(
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
                                  'label': project['name']?.toString() ?? 'Projet ${project['id']}',
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
                                  final personalInfo = person['personal_info'] as Map<String, dynamic>?;
                                  final fullName = personalInfo?['full_name']?.toString() ?? '';
                                  return {
                                    'value': fullName,
                                    'label': fullName,
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
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
            ),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                      : 'Sélectionner une date',
                  style: TextStyle(
                    color: value != null ? const Color(0xFF23272F) : Colors.grey.shade600,
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

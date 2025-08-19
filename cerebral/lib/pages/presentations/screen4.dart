import 'package:flutter/material.dart';
import 'package:cerebral/core/services/task_service.dart';
import 'package:cerebral/core/services/project_service.dart';

class Screen4 extends StatefulWidget {
  final int? taskId; // ID optionnel de la tâche

  const Screen4({
    super.key,
    this.taskId,
  });

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  final TextEditingController _commentController = TextEditingController();

  // Services
  final TaskService _taskService = TaskService();
  final ProjectService _projectService = ProjectService();

  // Données
  Map<String, dynamic>? _task;
  Map<String, dynamic>? _project;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTaskDetails();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Charger les détails de la tâche
  Future<void> _loadTaskDetails() async {
    try {
      print(
          '🚀 Début du chargement des détails de la tâche ID: ${widget.taskId}');
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Charger les détails de la tâche
      print('📞 Appel de _taskService.getTaskById(${widget.taskId})');
      final taskData = await _taskService.getTaskById(widget.taskId!);
      print('✅ Réponse de l\'API tâche: $taskData');
      print('🔍 Structure de la réponse: ${taskData.runtimeType}');
      print('🔑 Clés disponibles: ${taskData.keys.toList()}');

      if (mounted) {
        setState(() {
          _task = taskData;
          _isLoading = false;
        });
        print('📊 Tâche chargée dans l\'état: $_task');

        // Charger les détails du projet associé
        if (_task != null && _task!['project_id'] != null) {
          print('🏗️ Chargement du projet associé: ${_task!['project_id']}');
          await _loadProjectDetails();
        } else {
          print('⚠️ Pas de projet associé ou project_id manquant');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du chargement de la tâche: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Charger les détails du projet
  Future<void> _loadProjectDetails() async {
    try {
      print('🏗️ Début du chargement du projet');
      int projectId;
      if (_task!['project_id'] is Map<String, dynamic>) {
        projectId = _task!['project_id']['id'];
        print('🔍 Project ID extrait de Map: $projectId');
      } else {
        projectId = _task!['project_id'];
        print('🔍 Project ID direct: $projectId');
      }

      print('📞 Appel de _projectService.getProjectById($projectId)');
      final projectData = await _projectService.getProjectById(projectId);
      print('✅ Réponse de l\'API projet: $projectData');
      print('🔑 Clés du projet: ${projectData.keys.toList()}');

      if (mounted) {
        setState(() {
          _project = projectData;
        });
        print('📊 Projet chargé dans l\'état: $_project');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement du projet: $e');
    }
  }

  // Mettre à jour le statut de la tâche
  Future<void> _updateTaskStatus(String newStatus) async {
    try {
      setState(() {
        _isUpdating = true;
      });

      await _taskService.updateTask(
        widget.taskId!,
        status: newStatus,
      );

      // Recharger les détails de la tâche
      await _loadTaskDetails();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statut mis à jour: $newStatus'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: $e'),
            backgroundColor: Colors.red,
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

  // Obtenir le nom de l'assigné
  String _getAssigneeName(dynamic assigneeId) {
    if (assigneeId == null) return 'Non assigné';

    if (assigneeId is Map<String, dynamic>) {
      return assigneeId['name'] ?? 'Utilisateur inconnu';
    } else if (assigneeId is int) {
      return 'Utilisateur $assigneeId';
    } else {
      return 'Non assigné';
    }
  }

  // Formater la date
  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'Non spécifiée';

    try {
      if (dateValue is String) {
        final date = DateTime.parse(dateValue);
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    } catch (e) {
      return 'Date invalide';
    }

    return 'Non spécifiée';
  }

  // Formater la date d'échéance
  String _formatDueDate(dynamic dueDate) {
    if (dueDate == null) return 'Non spécifiée';

    try {
      if (dueDate is String) {
        final date = DateTime.parse(dueDate);
        final now = DateTime.now();
        final difference = date.difference(now).inDays;

        if (difference < 0) return 'En retard';
        if (difference == 0) return 'Aujourd\'hui';
        if (difference == 1) return 'Demain';
        if (difference <= 7) return 'Cette semaine';
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    } catch (e) {
      return 'Date invalide';
    }

    return 'Non spécifiée';
  }

  // Obtenir la couleur de priorité
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'high':
        return Colors.red;
      case 'normal':
      case 'medium':
        return const Color(0xFFFF9800);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Obtenir la couleur de statut
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF6C757D);
      case 'in_progress':
        return const Color(0xFFFF9800);
      case 'waiting_validation':
        return const Color(0xFFFF9800);
      case 'completed':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C757D);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ Build appelé - État actuel:');
    print('   - _isLoading: $_isLoading');
    print('   - _errorMessage: $_errorMessage');
    print('   - _task: $_task');
    print('   - _project: $_project');

    // Afficher l'écran de chargement
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2549B2)),
              ),
              SizedBox(height: 16),
              Text(
                'Chargement des détails de la tâche...',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF23272F),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Afficher l'écran d'erreur
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erreur de chargement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadTaskDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2549B2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Réessayer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // En-tête bleu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(color: Color(0xFF2549B2)),
            child: Row(
              children: [
                // Bouton retour
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                // Titre central
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _task?['title'] ?? 'Détail de la tâche',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _project?['name'] ?? 'Projet inconnu',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                // Icônes droite
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenu principal avec scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre de la tâche avec étiquette Urgent
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _task?['title'] ?? 'Tâche sans titre',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF23272F),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                                _task?['priority'] ?? 'normal'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _task?['priority'] == 'high'
                                ? 'Urgent'
                                : _task?['priority'] == 'normal'
                                    ? 'Normal'
                                    : 'Basse',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Description
                    Container(
                      width: double.infinity,
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
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF23272F),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _task?['description'] ??
                                'Aucune description disponible',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5B6478),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section Informations clés
                    Container(
                      width: double.infinity,
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
                          const Text(
                            'Informations clés',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF23272F),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                              'Statut',
                              _task?['status'] == 'pending'
                                  ? 'En attente'
                                  : _task?['status'] == 'in_progress'
                                      ? 'En cours'
                                      : _task?['status'] == 'waiting_validation'
                                          ? 'En attente de validation'
                                          : _task?['status'] == 'completed'
                                              ? 'Terminé'
                                              : 'Inconnu',
                              isStatus: true),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Projet', _project?['name'] ?? 'Projet inconnu'),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Type', _project?['type'] ?? 'Non spécifié'),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Budget',
                              _project?['budget'] != null
                                  ? '${_project!['budget']}€'
                                  : 'Non spécifié'),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Responsable',
                            _getAssigneeName(_task?['assigned_to']),
                            hasAvatar: true,
                            initials: _getAssigneeName(_task?['assigned_to'])
                                .split(' ')
                                .map((e) => e[0])
                                .join(''),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Créée le', _formatDate(_task?['created_at'])),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Échéance',
                            _formatDueDate(_task?['due_date']),
                            isDueDate: true,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'Priorité',
                              _task?['priority'] == 'high'
                                  ? 'Urgent'
                                  : _task?['priority'] == 'normal'
                                      ? 'Normal'
                                      : 'Basse',
                              isPriority: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section Validation requise
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFC107),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFC107),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Validation requise',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF23272F),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Cette tâche nécessite une validation avec preuve photographique.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5B6478),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Approuver',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
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
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Rejeter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF44336),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Pièces jointes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pièces jointes (3)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF23272F),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                '+ Ajouter',
                                style: TextStyle(
                                  color: Color(0xFF2549B2),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Image 1
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFFC107),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFFFFC107),
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Image 2
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1976D2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.build,
                                color: Color(0xFF1976D2),
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // PDF
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE91E63),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf,
                                    color: Color(0xFFE91E63),
                                    size: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Rapport.pdf',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFE91E63),
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

                    const SizedBox(height: 32),

                    // Section Commentaires & Historique
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Commentaires & Historique',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Commentaire Jean Dupont
                        _buildCommentItem(
                          'JD',
                          'Jean Dupont',
                          'Installation terminée. En attente de validation par le superviseur.',
                          'Il y a 2h',
                          const Color(0xFF1976D2),
                        ),
                        const SizedBox(height: 16),

                        // Commentaire Système
                        _buildCommentItem(
                          null,
                          'Système',
                          'Statut changé de "En attente" à "En cours"',
                          'Il y a 4h',
                          const Color(0xFF6C757D),
                          isSystem: true,
                        ),
                        const SizedBox(height: 16),

                        // Commentaire Marie Martin
                        _buildCommentItem(
                          'MM',
                          'Marie Martin',
                          'Matériel livré et vérifié. Prêt pour l\'installation.',
                          'Hier',
                          const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 24),

                        // Champ de commentaire
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECEF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF6C757D),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Ajouter un commentaire...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFF6C757D),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2549B2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 100), // Espace pour la barre d'action
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Barre d'action flottante en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUpdating ? null : () => _showStatusUpdateDialog(),
                icon: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  _isUpdating ? 'Mise à jour...' : 'Modifier le statut',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isUpdating ? Colors.grey : const Color(0xFF2549B2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.share,
                color: Color(0xFF6C757D),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isStatus = false,
    bool hasAvatar = false,
    String? initials,
    bool isDueDate = false,
    bool isPriority = false,
  }) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6C757D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          if (hasAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: isStatus || isPriority
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isStatus
                          ? const Color(0xFFFF9800).withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: isStatus ? const Color(0xFFFF9800) : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDueDate ? Colors.red : const Color(0xFF23272F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    String? initials,
    String name,
    String comment,
    String time,
    Color color, {
    bool isSystem = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: isSystem
              ? const Icon(Icons.settings, color: Color(0xFF6C757D), size: 20)
              : Center(
                  child: Text(
                    initials ?? '',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF23272F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5B6478),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Afficher le dialogue de mise à jour du statut
  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le statut'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sélectionnez le nouveau statut :'),
              const SizedBox(height: 20),
              _buildStatusOption('pending', 'En attente'),
              _buildStatusOption('in_progress', 'En cours'),
              _buildStatusOption(
                  'waiting_validation', 'En attente de validation'),
              _buildStatusOption('completed', 'Terminé'),
            ],
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

  // Option de statut dans le dialogue
  Widget _buildStatusOption(String status, String label) {
    final isCurrentStatus = _task?['status'] == status;
    final isSelected = false; // Pour la sélection multiple si nécessaire

    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: status,
        groupValue: _task?['status'] ?? '',
        onChanged: (value) {
          Navigator.of(context).pop();
          if (value != null) {
            _updateTaskStatus(value);
          }
        },
      ),
      tileColor: isCurrentStatus ? const Color(0xFFE3F2FD) : null,
    );
  }
}

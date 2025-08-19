import 'package:flutter/material.dart';
import 'package:cerebral/core/services/task_service.dart';
import 'package:cerebral/core/services/project_service.dart';
import 'package:cerebral/core/services/auth_service.dart';
import 'package:cerebral/core/services/personnel_service.dart';

class Screen16 extends StatefulWidget {
  const Screen16({super.key});

  @override
  State<Screen16> createState() => _Screen16State();
}

class _Screen16State extends State<Screen16> {
  // Services
  final TaskService _taskService = TaskService();
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();
  final PersonnelService _personnelService = PersonnelService();

  // Contrôleurs pour les champs de saisie
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '4',
  );
  final TextEditingController _copyToController = TextEditingController();

  // États
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;

  // Données dynamiques
  List<dynamic>? _projects;
  List<dynamic>? _personnel;

  // Variables de sélection
  String _selectedProject = '';
  String _selectedUnit = '';
  String _selectedStep = '';
  String _selectedPriority = 'normale';
  String _selectedUnitType = 'Heures';
  String _selectedAssignee = '';
  String _selectedSupervisor = '';

  // Dates sélectionnées
  DateTime? _selectedStartDate;
  DateTime? _selectedDueDate;

  // Listes de sélection
  List<String> get _availableProjects =>
      _projects
          ?.map((p) => p['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList() ??
      [
        'Résidence Soleil',
        'Les Jardins',
        'Villa Moderne',
        'Projet Horizon',
      ];

  final List<String> _availableUnits = [
    'Villa A1',
    'Villa A2',
    'Villa A3',
    'Apt B1',
    'Apt B2',
  ];

  final List<String> _availableSteps = [
    'Acquisition',
    'Fondations',
    'Gros œuvre',
    'Électricité',
    'Plomberie',
    'Finitions',
  ];

  final List<String> _availableUnitTypes = ['Heures', 'Jours', 'Semaines'];

  List<String> get _availableSupervisors =>
      _personnel
          ?.map((p) {
            final personalInfo = p['personal_info'] as Map<String, dynamic>?;
            return personalInfo?['full_name']?.toString() ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toList() ??
      [
        'Sophie Bernard',
        'Marc Dubois',
        'Claire Moreau',
      ];

  // Supprimer cette variable inutilisée
  // List<String> get _availableAssignees =>
  //     _users
  //         ?.map((u) => u['name']?.toString() ?? '')
  //         .where((name) => name.isNotEmpty)
  //         .toList() ??
  //     [
  //       'Jean Dupont',
  //       'Marie Martin',
  //       'Pierre Durand',
  //     ];

  // Notifications
  bool _notifyByEmail = true;
  bool _notifyBySMS = true;
  bool _notifyByWhatsApp = false;
  bool _notifyByPush = true;

  // Rappels automatiques
  bool _reminder24h = false;
  bool _reminderDayOf = true;
  bool _reminderDelay = false;

  // Exigences de validation
  bool _photoRequired = true;
  bool _supervisorValidation = false;
  bool _writtenReport = false;
  bool _externalQualityControl = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Charger les données nécessaires
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Charger les projets et personnel en parallèle
      await Future.wait([
        _loadProjects(),
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
      // Remplacer print par un log approprié
      debugPrint('Erreur lors du chargement des projets: $e');
    }
  }

  // Charger le personnel
  Future<void> _loadPersonnel() async {
    try {
      final personnelData = await _personnelService.getPersonnel();

      if (mounted) {
        setState(() {
          if (personnelData['data'] != null) {
            _personnel = List<dynamic>.from(personnelData['data']);
          } else if (personnelData['personnel'] != null) {
            _personnel = List<dynamic>.from(personnelData['personnel']);
          } else {
            _personnel = [];
          }
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement du personnel: $e');
    }
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _copyToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Afficher l'écran de chargement
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
              SizedBox(height: 16),
              Text(
                'Chargement des données...',
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
        backgroundColor: const Color(0xFFF5F5F5),
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
              Text(
                'Erreur de chargement',
                style: const TextStyle(
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
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête vert foncé avec navigation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
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
                  const SizedBox(width: 16),
                  // Titre
                  const Expanded(
                    child: Text(
                      'Créer une Tâche',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Bouton fermer
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal avec scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Section Informations de base
                    _buildSectionCard(
                      title: 'Informations de base',
                      children: [
                        _buildInputField(
                          label: 'Titre de la tâche *',
                          controller: _taskTitleController,
                          placeholder: 'Ex: Contrôle installation électrique',
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: 'Description détaillée',
                          controller: _descriptionController,
                          placeholder:
                              'Décrivez précisément ce qui doit être fait (minimum 10 caractères)...',
                          isRequired: false,
                          isMultiline: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Localisation
                    _buildSectionCard(
                      title: 'Localisation',
                      children: [
                        _buildDropdownField(
                          label: 'Projet *',
                          value: _selectedProject,
                          hint: 'Sélectionner un projet',
                          items: _availableProjects,
                          onChanged: (value) {
                            setState(() {
                              _selectedProject = value ?? '';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildDropdownField(
                          label: 'Villa/Appartement *',
                          value: _selectedUnit,
                          hint: 'Sélectionner une unité',
                          items: _availableUnits,
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value ?? '';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildDropdownField(
                          label: 'Étape du projet',
                          value: _selectedStep,
                          hint: 'Sélectionner une étape',
                          items: _availableSteps,
                          onChanged: (value) {
                            setState(() {
                              _selectedStep = value ?? '';
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Priorité et planning
                    _buildSectionCard(
                      title: 'Priorité et planning',
                      children: [
                        // Priorité
                        Row(
                          children: [
                            const Text(
                              'Priorité *',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF23272F),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: Color(0xFFF44336),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildPriorityButton(
                                'Faible',
                                Icons.keyboard_arrow_down,
                                const Color(0xFF4CAF50),
                                'faible',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPriorityButton(
                                'Normale',
                                Icons.remove,
                                const Color(0xFFFF9800),
                                'normale',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPriorityButton(
                                'Urgente',
                                Icons.priority_high,
                                const Color(0xFFF44336),
                                'urgente',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Dates
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                label: 'Date de début',
                                selectedDate: _selectedStartDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _selectedStartDate = date;
                                  });
                                },
                                isRequired: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateField(
                                label: 'Échéance *',
                                selectedDate: _selectedDueDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _selectedDueDate = date;
                                  });
                                },
                                isRequired: true,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Durée
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'Durée estimée',
                                controller: _durationController,
                                placeholder: '0',
                                isRequired: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Unité',
                                value: _selectedUnitType,
                                hint: 'Sélectionner une unité',
                                items: _availableUnitTypes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUnitType = value ?? 'Heures';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Assignation
                    _buildSectionCard(
                      title: 'Assignation',
                      children: [
                        const Text(
                          'Assigner à',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_personnel != null && _personnel!.isNotEmpty) ...[
                          ..._personnel!.map((person) {
                            final personalInfo = person['personal_info']
                                    as Map<String, dynamic>? ??
                                {};
                            final professionalInfo = person['professional_info']
                                    as Map<String, dynamic>? ??
                                {};
                            final statusInfo =
                                person['status'] as Map<String, dynamic>? ?? {};

                            final fullName =
                                personalInfo['full_name']?.toString() ?? '';
                            final initials =
                                personalInfo['initials']?.toString() ?? '';
                            final position =
                                professionalInfo['position']?.toString() ??
                                    'Non défini';
                            final status =
                                statusInfo['label']?.toString() ?? 'Non défini';
                            final isActive = statusInfo['is_active'] == true;

                            // Générer des couleurs basées sur la position
                            final avatarColor = _getAvatarColor(position);
                            final statusColor = isActive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF6C757D);

                            return Column(
                              children: [
                                _buildAssigneeCard(
                                  initials,
                                  fullName,
                                  position,
                                  status,
                                  avatarColor,
                                  statusColor,
                                  fullName,
                                  isBusy: !isActive,
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ] else ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Aucun personnel disponible',
                                style: TextStyle(
                                  color: Color(0xFF6C757D),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        _buildDropdownField(
                          label: 'Superviseur responsable',
                          value: _selectedSupervisor,
                          hint: 'Sélectionner un superviseur',
                          items: _availableSupervisors,
                          onChanged: (value) {
                            setState(() {
                              _selectedSupervisor = value ?? '';
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Notifications
                    _buildSectionCard(
                      title: 'Notifications',
                      children: [
                        const Text(
                          'Notifier par',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildNotificationCheckbox(
                          'Email',
                          Icons.email,
                          const Color(0xFF1976D2),
                          _notifyByEmail,
                          (value) {
                            setState(() {
                              _notifyByEmail = value ?? false;
                            });
                          },
                        ),
                        _buildNotificationCheckbox(
                          'SMS',
                          Icons.sms,
                          const Color(0xFF4CAF50),
                          _notifyBySMS,
                          (value) {
                            setState(() {
                              _notifyBySMS = value ?? false;
                            });
                          },
                        ),
                        _buildNotificationCheckbox(
                          'WhatsApp',
                          Icons.chat,
                          const Color(0xFF4CAF50),
                          _notifyByWhatsApp,
                          (value) {
                            setState(() {
                              _notifyByWhatsApp = value ?? false;
                            });
                          },
                        ),
                        _buildNotificationCheckbox(
                          'Notification push',
                          Icons.notifications,
                          const Color(0xFFF44336),
                          _notifyByPush,
                          (value) {
                            setState(() {
                              _notifyByPush = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Rappels automatiques',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildReminderCheckbox(
                          '24h avant l\'échéance',
                          _reminder24h,
                          (value) {
                            setState(() {
                              _reminder24h = value ?? false;
                            });
                          },
                        ),
                        _buildReminderCheckbox(
                          'Le jour de l\'échéance',
                          _reminderDayOf,
                          (value) {
                            setState(() {
                              _reminderDayOf = value ?? false;
                            });
                          },
                        ),
                        _buildReminderCheckbox(
                          'En cas de retard',
                          _reminderDelay,
                          (value) {
                            setState(() {
                              _reminderDelay = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildInputField(
                          label: 'Copie à (optionnel)',
                          controller: _copyToController,
                          placeholder: 'email1@example.com, email2@exampl',
                          isRequired: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Exigences de validation
                    _buildSectionCard(
                      title: 'Exigences de validation',
                      children: [
                        _buildValidationCheckbox(
                          'Photo obligatoire à la fin',
                          _photoRequired,
                          (value) {
                            setState(() {
                              _photoRequired = value ?? false;
                            });
                          },
                        ),
                        _buildValidationCheckbox(
                          'Validation par superviseur requise',
                          _supervisorValidation,
                          (value) {
                            setState(() {
                              _supervisorValidation = value ?? false;
                            });
                          },
                        ),
                        _buildValidationCheckbox(
                          'Rapport écrit obligatoire',
                          _writtenReport,
                          (value) {
                            setState(() {
                              _writtenReport = value ?? false;
                            });
                          },
                        ),
                        _buildValidationCheckbox(
                          'Contrôle qualité externe',
                          _externalQualityControl,
                          (value) {
                            setState(() {
                              _externalQualityControl = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Boutons d'action en bas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Bouton Brouillon
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveDraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFFE9ECEF),
                            width: 1,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.folder,
                        color: Color(0xFF23272F),
                        size: 20,
                      ),
                      label: const Text(
                        'Brouillon',
                        style: TextStyle(
                          color: Color(0xFF23272F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bouton Créer et assigner
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isCreating ? null : _createAndAssign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isCreating ? Colors.grey : const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isCreating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                      label: Text(
                        _isCreating ? 'Création...' : 'Créer et assigner',
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
            ),
          ],
        ),
      ),
    );
  }

  // Carte de section
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // Champ de saisie
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isRequired,
    bool isMultiline = false,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: isMultiline ? 3 : 1,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      color: Color(0xFFADB5BD),
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
              if (suffixIcon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    suffixIcon,
                    color: const Color(0xFF6C757D),
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Champ dropdown
  Widget _buildDropdownField({
    required String label,
    required String value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF23272F),
                size: 20,
              ),
            ),
            hint: Text(hint),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          ),
        ),
      ],
    );
  }

  // Bouton de priorité
  Widget _buildPriorityButton(
    String label,
    IconData icon,
    Color iconColor,
    String value,
  ) {
    final isSelected = _selectedPriority == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? iconColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? iconColor : const Color(0xFFE9ECEF),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? iconColor : const Color(0xFF23272F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carte d'assignation
  Widget _buildAssigneeCard(
    String initials,
    String name,
    String role,
    String status,
    Color avatarColor,
    Color statusColor,
    String value, {
    bool isBusy = false,
    bool isTomorrow = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAssignee = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedAssignee == value
              ? const Color(0xFFE8F5E8)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAssignee == value
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE9ECEF),
            width: _selectedAssignee == value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedAssignee,
              onChanged: (newValue) {
                setState(() {
                  _selectedAssignee = newValue ?? '';
                });
              },
              activeColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
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
                      fontSize: 14,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Checkbox de notification
  Widget _buildNotificationCheckbox(
    String title,
    IconData icon,
    Color iconColor,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Checkbox de rappel
  Widget _buildReminderCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Checkbox de validation
  Widget _buildValidationCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Sauvegarder en brouillon
  void _saveDraft() {
    // Remplacer print par un log approprié
    debugPrint('Sauvegarde en brouillon...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Brouillon sauvegardé !'),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  // Créer et assigner la tâche
  Future<void> _createAndAssign() async {
    try {
      // Validation des champs requis
      if (_taskTitleController.text.trim().isEmpty) {
        _showError('Le titre de la tâche est requis');
        return;
      }

      // Validation de la description (minimum 10 caractères)
      if (_descriptionController.text.trim().length < 10) {
        _showError('La description doit contenir au moins 10 caractères');
        return;
      }

      if (_selectedProject.isEmpty) {
        _showError('Veuillez sélectionner un projet');
        return;
      }

      if (_selectedDueDate == null) {
        _showError('La date d\'échéance est requise');
        return;
      }

      if (_selectedAssignee.isEmpty) {
        _showError('Veuillez sélectionner un assigné');
        return;
      }

      setState(() {
        _isCreating = true;
        _errorMessage = null;
      });

      // Obtenir l'utilisateur connecté
      final currentUser = await _authService.getCurrentUser();
      if (currentUser['id'] == null) {
        _showError('Erreur d\'authentification. Veuillez vous reconnecter.');
        setState(() {
          _isCreating = false;
        });
        return;
      }

      // Trouver l'ID du projet sélectionné
      final project = _projects?.firstWhere(
        (p) => p['name'] == _selectedProject,
        orElse: () => <String, dynamic>{},
      );

      if (project.isEmpty) {
        _showError('Projet non trouvé');
        setState(() {
          _isCreating = false;
        });
        return;
      }

      // Trouver l'ID du personnel assigné
      int? assignedToId;
      if (_selectedAssignee.isNotEmpty) {
        final person = _personnel?.firstWhere(
          (p) {
            final personalInfo = p['personal_info'] as Map<String, dynamic>?;
            final fullName = personalInfo?['full_name']?.toString() ?? '';
            return fullName == _selectedAssignee;
          },
          orElse: () => <String, dynamic>{},
        );
        assignedToId = person.isNotEmpty ? person['id'] : null;
      }

      if (assignedToId == null) {
        _showError('Utilisateur assigné non trouvé');
        setState(() {
          _isCreating = false;
        });
        return;
      }

      // Utiliser la date d'échéance sélectionnée
      final dueDate = _selectedDueDate!;

      // Créer la tâche via l'API
      final newTask = await _taskService.createTask(
        title: _taskTitleController.text.trim(),
        description: _descriptionController.text.trim(),
        projectId: project['id'],
        status: 'pending',
        priority: _mapPriorityToApi(_selectedPriority),
        dueDate: dueDate,
        assignedTo: assignedToId,
        createdBy: currentUser['id'],
        estimatedHours: int.tryParse(_durationController.text),
        notes: _buildTaskNotes(),
      );

      if (mounted) {
        setState(() {
          _isCreating = false;
        });

        // Afficher le succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tâche créée avec succès ! ID: ${newTask['id']}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );

        // Rediriger vers la liste des tâches ou vider le formulaire
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreating = false;
          _errorMessage = e.toString();
        });

        // Gestion spécifique des erreurs de validation
        if (e.toString().contains('ValidationException')) {
          if (e.toString().contains('description')) {
            _showError('La description doit contenir au moins 10 caractères');
          } else if (e.toString().contains('priority')) {
            _showError(
                'Priorité invalide. Veuillez sélectionner une priorité valide.');
          } else {
            _showError(
                'Erreur de validation des données. Veuillez vérifier les informations saisies.');
          }
        } else {
          _showError('Erreur lors de la création: $e');
        }
      }
    }
  }

  // Mapper la priorité vers l'API
  String _mapPriorityToApi(String uiPriority) {
    switch (uiPriority.toLowerCase()) {
      case 'urgente':
        return 'high';
      case 'normale':
        return 'medium';
      case 'faible':
        return 'low';
      default:
        return 'medium';
    }
  }

  // Construire les notes de la tâche
  String _buildTaskNotes() {
    final notes = <String>[];

    if (_selectedUnit.isNotEmpty) {
      notes.add('Unité: $_selectedUnit');
    }

    if (_selectedStep.isNotEmpty) {
      notes.add('Étape: $_selectedStep');
    }

    if (_selectedSupervisor.isNotEmpty) {
      notes.add('Superviseur: $_selectedSupervisor');
    }

    // Ajouter les exigences de validation
    if (_photoRequired) notes.add('Photo requise');
    if (_supervisorValidation) notes.add('Validation superviseur requise');
    if (_writtenReport) notes.add('Rapport écrit requis');
    if (_externalQualityControl) notes.add('Contrôle qualité externe requis');

    return notes.join(' | ');
  }

  // Réinitialiser le formulaire
  void _resetForm() {
    _taskTitleController.clear();
    _descriptionController.clear();
    _durationController.text = '4';
    _copyToController.clear();

    setState(() {
      _selectedProject = '';
      _selectedUnit = '';
      _selectedStep = '';
      _selectedPriority = 'normale';
      _selectedUnitType = 'Heures';
      _selectedAssignee = '';
      _selectedSupervisor = '';

      // Réinitialiser les dates
      _selectedStartDate = null;
      _selectedDueDate = null;

      _notifyByEmail = true;
      _notifyBySMS = true;
      _notifyByWhatsApp = false;
      _notifyByPush = true;

      _reminder24h = false;
      _reminderDayOf = true;
      _reminderDelay = false;

      _photoRequired = true;
      _supervisorValidation = false;
      _writtenReport = false;
      _externalQualityControl = false;
    });
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

  // Générer une couleur d'avatar basée sur la position
  Color _getAvatarColor(String position) {
    switch (position.toLowerCase()) {
      case 'électricien':
        return const Color(0xFF1976D2);
      case 'plombier':
        return const Color(0xFF4CAF50);
      case 'maçon':
        return const Color(0xFFFF9800);
      case 'technicien':
        return const Color(0xFF9C27B0);
      case 'manager':
        return const Color(0xFFF44336);
      case 'assistant':
        return const Color(0xFF607D8B);
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Champ de sélection de date
  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, onDateSelected, selectedDate),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                        : 'Sélectionner une date',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null
                          ? const Color(0xFF23272F)
                          : const Color(0xFFADB5BD),
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF6C757D),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Sélectionner une date
  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime?) onDateSelected,
    DateTime? initialDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      // Supprimer le locale français qui peut causer des erreurs
      // locale: const Locale('fr', 'FR'),
      // Supprimer le builder personnalisé qui peut causer des erreurs
      // builder: (context, child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: const ColorScheme.light(
      //         primary: Color(0xFF2E7D32),
      //         onPrimary: Colors.white,
      //         onSurface: Color(0xFF23272F),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

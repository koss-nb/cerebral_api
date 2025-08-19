import 'package:flutter/material.dart';
import 'package:cerebral/core/services/personnel_service.dart';
import 'package:cerebral/core/services/auth_service.dart';

class Screen13 extends StatefulWidget {
  const Screen13({super.key});

  @override
  State<Screen13> createState() => _Screen13State();
}

class _Screen13State extends State<Screen13> {
  final AuthService _authService = AuthService();
  int _currentStep = 0; // 0: Informations, 1: Rôle & Accès, 2: Confirmation

  // Service
  final PersonnelService _personnelService = PersonnelService();

  // États
  bool _isCreating = false;

  // Contrôleurs pour l'étape 1 - Informations
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _hireDateController = TextEditingController();

  // Variables pour l'étape 2 - Rôle & Accès
  String _selectedRole = '';
  String _selectedProfession = '';
  final List<String> _selectedProjects = [];
  String _contractType = 'CDI';
  final TextEditingController _hourlyRateController = TextEditingController(
    text: '18.50',
  );

  // Variables pour l'étape 3 - Confirmation
  bool _sendInvitationEmail = true;
  bool _sendWelcomeSMS = false;
  bool _generateTempPassword = true;
  final TextEditingController _personalizedMessageController =
      TextEditingController();

  // Validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _employeeIdController.dispose();
    _dateOfBirthController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _hireDateController.dispose();
    _hourlyRateController.dispose();
    _personalizedMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // En-tête bleu foncé avec navigation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
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
                        'Créer un Utilisateur',
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

              // Indicateur de progression
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Étape 1
                    Expanded(
                      child: _buildProgressStep(
                        stepNumber: 1,
                        stepTitle: 'Informations',
                        isActive: _currentStep == 0,
                        isCompleted: _currentStep > 0,
                      ),
                    ),
                    // Ligne de connexion
                    Expanded(
                      child: Container(
                        height: 2,
                        color: _currentStep > 0
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE9ECEF),
                      ),
                    ),
                    // Étape 2
                    Expanded(
                      child: _buildProgressStep(
                        stepNumber: 2,
                        stepTitle: 'Rôle & Accès',
                        isActive: _currentStep == 1,
                        isCompleted: _currentStep > 1,
                      ),
                    ),
                    // Ligne de connexion
                    Expanded(
                      child: Container(
                        height: 2,
                        color: _currentStep > 1
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE9ECEF),
                      ),
                    ),
                    // Étape 3
                    Expanded(
                      child: _buildProgressStep(
                        stepNumber: 3,
                        stepTitle: 'Confirmation',
                        isActive: _currentStep == 2,
                        isCompleted: false,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenu principal selon l'étape
              Expanded(child: _buildStepContent()),

              // Boutons de navigation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: _buildNavigationButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Étape de progression
  Widget _buildProgressStep({
    required int stepNumber,
    required String stepTitle,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : isActive
                    ? const Color(0xFF1976D2)
                    : const Color(0xFFE9ECEF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF6C757D),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stepTitle,
          style: TextStyle(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : isActive
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF6C757D),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Contenu selon l'étape
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildInformationsStep();
      case 1:
        return _buildRoleAccessStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return _buildInformationsStep();
    }
  }

  // Étape 1 - Informations personnelles
  Widget _buildInformationsStep() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations personnelles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23272F),
              ),
            ),

            const SizedBox(height: 24),

            // Photo de profil
            _buildProfilePictureSection(),

            const SizedBox(height: 32),

            // Champs de saisie
            _buildInputField(
              label: 'Prénom *',
              controller: _firstNameController,
              placeholder: 'Entrez le prénom',
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le prénom est requis';
                }
                if (value.trim().length < 2) {
                  return 'Le prénom doit contenir au moins 2 caractères';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Nom *',
              controller: _lastNameController,
              placeholder: 'Entrez le nom',
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est requis';
                }
                if (value.trim().length < 2) {
                  return 'Le nom doit contenir au moins 2 caractères';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Email *',
              controller: _emailController,
              placeholder: 'exemple@email.com',
              isRequired: true,
              helperText: 'Un email d\'invitation sera envoyé à cette adresse',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L\'email est requis';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Téléphone *',
              controller: _phoneController,
              placeholder: '06 12 34 56 78',
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le téléphone est requis';
                }
                if (!RegExp(r'^(\+33|0)[1-9](\d{8})$')
                    .hasMatch(value.replaceAll(' ', ''))) {
                  return 'Veuillez entrer un numéro de téléphone valide';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Numéro d\'employé',
              controller: _employeeIdController,
              placeholder:
                  'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
              isRequired: false,
              helperText:
                  'Numéro d\'identification unique (généré automatiquement si vide)',
            ),

            const SizedBox(height: 20),

            _buildDateField(
              label: 'Date de naissance',
              controller: _dateOfBirthController,
              placeholder: 'Sélectionner une date',
              isRequired: false,
              helperText: 'Date de naissance du personnel',
              initialDate: DateTime.now()
                  .subtract(const Duration(days: 6570)), // 18 ans par défaut
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Adresse',
              controller: _addressController,
              placeholder: 'Adresse complète',
              isRequired: false,
              isMultiline: true,
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Contact d\'urgence',
              controller: _emergencyContactController,
              placeholder: 'Nom du contact d\'urgence',
              isRequired: false,
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: 'Téléphone d\'urgence',
              controller: _emergencyPhoneController,
              placeholder: '06 12 34 56 78',
              isRequired: false,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Étape 2 - Rôle et accès
  Widget _buildRoleAccessStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rôle et accès',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 24),

          // Sélection du rôle
          const Text(
            'Rôle *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '*',
            style: TextStyle(
              color: Color(0xFFF44336),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Options de rôle
          _buildRoleOption(
            'Promoteur',
            'Accès complet à tous les modules',
            Icons.star,
            const Color(0xFFFFD700),
            'promoteur',
          ),
          const SizedBox(height: 12),
          _buildRoleOption(
            'Superviseur',
            'Validation et suivi des travaux',
            Icons.construction,
            const Color(0xFF4CAF50),
            'superviseur',
          ),
          const SizedBox(height: 12),
          _buildRoleOption(
            'Chef de chantier',
            'Gestion terrain et équipes',
            Icons.engineering,
            const Color(0xFFFF9800),
            'chef_chantier',
          ),
          const SizedBox(height: 12),
          _buildRoleOption(
            'Technicien',
            'Exécution des tâches',
            Icons.build,
            const Color(0xFF1976D2),
            'technicien',
          ),

          const SizedBox(height: 32),

          // Corps de métier
          _buildDropdownField(
            label: 'Corps de métier',
            value: _selectedProfession,
            hint: 'Sélectionner un métier',
            items: const [
              'Électricien',
              'Plombier',
              'Maçon',
              'Menuisier',
              'Peintre',
            ],
            onChanged: (value) {
              setState(() {
                _selectedProfession = value ?? '';
              });
            },
          ),

          const SizedBox(height: 24),

          // Projets assignés
          const Text(
            'Projets assignés',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildProjectCheckbox('Résidence Soleil'),
          _buildProjectCheckbox('Les Jardins'),
          _buildProjectCheckbox('Villa Moderne'),
          _buildProjectCheckbox('Projet Horizon'),

          const SizedBox(height: 24),

          // Type de contrat
          _buildDropdownField(
            label: 'Type de contrat',
            value: _contractType,
            hint: 'Sélectionner un type',
            items: const ['CDI', 'CDD', 'Intérim', 'Stage'],
            onChanged: (value) {
              setState(() {
                _contractType = value ?? 'CDI';
              });
            },
          ),

          const SizedBox(height: 24),

          // Date d'embauche
          _buildDateField(
            label: 'Date d\'embauche',
            controller: _hireDateController,
            placeholder: 'Sélectionner une date',
            isRequired: false,
            helperText: 'Date de début de contrat',
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ),

          const SizedBox(height: 20),

          // Taux horaire
          _buildInputField(
            label: 'Taux horaire (€)',
            controller: _hourlyRateController,
            placeholder: '0.00',
            isRequired: false,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Étape 3 - Confirmation
  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Confirmation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23272F),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Récapitulatif
          const Text(
            'Récapitulatif',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          _buildSummaryRow(
            'Nom complet:',
            '${_firstNameController.text} ${_lastNameController.text}',
          ),
          _buildSummaryRow('Email:', _emailController.text),
          _buildSummaryRow(
            'Rôle:',
            '$_selectedRole - $_selectedProfession',
          ),
          _buildSummaryRow('Projets:', _selectedProjects.join(', ')),

          const SizedBox(height: 32),

          // Actions
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),

          _buildActionCheckbox(
            'Envoyer un email d\'invitation',
            _sendInvitationEmail,
            (value) {
              setState(() {
                _sendInvitationEmail = value ?? false;
              });
            },
          ),
          _buildActionCheckbox('Envoyer un SMS de bienvenue', _sendWelcomeSMS, (
            value,
          ) {
            setState(() {
              _sendWelcomeSMS = value ?? false;
            });
          }),
          _buildActionCheckbox(
            'Générer un mot de passe temporaire',
            _generateTempPassword,
            (value) {
              setState(() {
                _generateTempPassword = value ?? false;
              });
            },
          ),

          const SizedBox(height: 24),

          // Message personnalisé
          const Text(
            'Message personnalisé (optionnel)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
            ),
            child: TextField(
              controller: _personalizedMessageController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Message de bienvenue personnalisé...',
                hintStyle: TextStyle(color: Color(0xFFADB5BD), fontSize: 16),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Boutons de navigation
  Widget _buildNavigationButtons() {
    if (_currentStep == 0) {
      // Première étape - seulement Suivant
      return ElevatedButton.icon(
        onPressed: _goToNextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        label: const Text(
          'Suivant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (_currentStep == 2) {
      // Dernière étape - Précédent et Créer
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _goToPreviousStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8F9FA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF23272F),
                size: 20,
              ),
              label: const Text(
                'Précédent',
                style: TextStyle(
                  color: Color(0xFF23272F),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isCreating ? null : _createUser,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.person_add, color: Colors.white, size: 20),
              label: Text(
                _isCreating ? 'Création...' : 'Créer l\'utilisateur',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Étapes intermédiaires - Précédent et Suivant
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _goToPreviousStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8F9FA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF23272F),
                size: 20,
              ),
              label: const Text(
                'Précédent',
                style: TextStyle(
                  color: Color(0xFF23272F),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _goToNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Suivant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  // Navigation entre étapes
  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToNextStep() {
    if (_currentStep == 0) {
      // Valider l'étape 1
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep++;
        });
      }
    } else if (_currentStep == 1) {
      // Valider l'étape 2
      if (_selectedRole.isEmpty) {
        _showError('Veuillez sélectionner un rôle');
        return;
      }
      setState(() {
        _currentStep++;
      });
    }
  }

  // Création de l'utilisateur
  Future<void> _createUser() async {
    try {
      // Validation des champs requis
      if (_firstNameController.text.trim().isEmpty) {
        _showError('Le prénom est requis');
        return;
      }

      if (_lastNameController.text.trim().isEmpty) {
        _showError('Le nom est requis');
        return;
      }

      if (_emailController.text.trim().isEmpty) {
        _showError('L\'email est requis');
        return;
      }

      if (_phoneController.text.trim().isEmpty) {
        _showError('Le téléphone est requis');
        return;
      }

      if (_selectedRole.isEmpty) {
        _showError('Veuillez sélectionner un rôle');
        return;
      }

      setState(() {
        _isCreating = true;
      });

      // Obtenir l'utilisateur connecté (pour created_by)
      final currentUser = await _authService.getCurrentUser();
      final createdBy = currentUser['id'] as int?;

      // Mapper le type de contrat UI -> API
      String _mapContractType(String uiValue) {
        switch ((uiValue).toLowerCase()) {
          case 'cdi':
            return 'full_time';
          case 'cdd':
            return 'contract';
          case 'intérim':
          case 'interim':
            return 'temporary';
          case 'stage':
            return 'intern';
          default:
            return 'full_time';
        }
      }

      // Construire l'objet emergency_contact attendu par l'API
      Map<String, dynamic>? emergencyContactObj;
      if (_emergencyContactController.text.trim().isNotEmpty ||
          _emergencyPhoneController.text.trim().isNotEmpty) {
        emergencyContactObj = {
          'name': _emergencyContactController.text.trim().isEmpty
              ? null
              : _emergencyContactController.text.trim(),
          'phone': _emergencyPhoneController.text.trim().isEmpty
              ? null
              : _emergencyPhoneController.text.trim(),
          'relationship': null,
        };
      }

      // Générer un ID d'employé unique si vide
      String employeeId = _employeeIdController.text.trim();
      if (employeeId.isEmpty) {
        employeeId =
            'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      }

      // Vérifier si l'ID d'employé existe déjà
      try {
        final existingPersonnel =
            await _personnelService.getPersonnelByEmployeeId(employeeId);
        if (existingPersonnel['success'] == true &&
            existingPersonnel['data'] != null) {
          _showError(
              'Cet identifiant employé ($employeeId) est déjà utilisé. Veuillez en choisir un autre.');
          setState(() {
            _isCreating = false;
          });
          return;
        }
      } catch (e) {
        // Si l'erreur n'est pas liée à l'existence, on continue
        print('Vérification ID employé: $e');
      }

      // Créer le personnel via l'API
      final newPersonnel = await _personnelService.createPersonnel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        employeeId: employeeId,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        position: _selectedProfession.isEmpty ? null : _selectedProfession,
        department: _getDepartmentFromRole(_selectedRole),
        contractType: _mapContractType(_contractType),
        status: 'active',
        hireDate: _hireDateController.text.trim().isEmpty
            ? DateTime.now()
            : _parseDate(_hireDateController.text.trim()) ?? DateTime.now(),
        dateOfBirth: _dateOfBirthController.text.trim().isEmpty
            ? null
            : _parseDate(_dateOfBirthController.text.trim()),
        salary: double.tryParse(_hourlyRateController.text),
        skills: _selectedProfession.isNotEmpty ? [_selectedProfession] : null,
        emergencyContact: emergencyContactObj,
        notes: _buildPersonnelNotes(),
        createdBy: createdBy,
      );

      if (mounted) {
        setState(() {
          _isCreating = false;
        });

        // Afficher le succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Personnel créé avec succès ! ID: ${newPersonnel['id']}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );

        // Rediriger ou vider le formulaire
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });

        // Gestion spécifique des erreurs de validation
        if (e.toString().contains('ValidationException')) {
          if (e.toString().contains('employee_id')) {
            _showError(
                'Cet identifiant employé est déjà utilisé. Veuillez en choisir un autre.');
          } else if (e.toString().contains('email')) {
            _showError(
                'Cette adresse email est déjà utilisée. Veuillez en choisir une autre.');
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

  // Obtenir le département à partir du rôle
  String _getDepartmentFromRole(String role) {
    switch (role.toLowerCase()) {
      case 'promoteur':
        return 'Direction';
      case 'superviseur':
        return 'Supervision';
      case 'chef_chantier':
        return 'Construction';
      case 'technicien':
        return 'Technique';
      default:
        return 'Général';
    }
  }

  // Construire les notes du personnel
  String _buildPersonnelNotes() {
    final notes = <String>[];

    if (_selectedProjects.isNotEmpty) {
      notes.add('Projets: ${_selectedProjects.join(', ')}');
    }

    if (_personalizedMessageController.text.isNotEmpty) {
      notes.add('Message: ${_personalizedMessageController.text}');
    }

    // Ajouter les actions sélectionnées
    if (_sendInvitationEmail) notes.add('Email d\'invitation envoyé');
    if (_sendWelcomeSMS) notes.add('SMS de bienvenue envoyé');
    if (_generateTempPassword) notes.add('Mot de passe temporaire généré');

    return notes.join(' | ');
  }

  // Parser une date depuis le format JJ/MM/AAAA
  DateTime? _parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Retourner null si la date n'est pas valide
    }
    return null;
  }

  // Réinitialiser le formulaire
  void _resetForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _employeeIdController.clear();
    _dateOfBirthController.clear();
    _emergencyContactController.clear();
    _emergencyPhoneController.clear();
    _hireDateController.clear();
    _hourlyRateController.text = '18.50';
    _personalizedMessageController.clear();

    setState(() {
      _selectedRole = '';
      _selectedProfession = '';
      _selectedProjects.clear();
      _contractType = 'CDI';
      _sendInvitationEmail = true;
      _sendWelcomeSMS = false;
      _generateTempPassword = true;
      _currentStep = 0;
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

  // Section photo de profil
  Widget _buildProfilePictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE9ECEF), width: 2),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Color(0xFF6C757D),
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ajouter une photo (optionnel)',
          style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
        ),
      ],
    );
  }

  // Champ de saisie
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isRequired,
    String? helperText,
    bool isMultiline = false,
    String? Function(String?)? validator,
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
          child: TextFormField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            validator: validator,
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
              errorStyle: const TextStyle(
                color: Color(0xFFF44336),
                fontSize: 12,
              ),
            ),
            style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
          ),
        ],
      ],
    );
  }

  // Champ de sélection de date
  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isRequired,
    String? helperText,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
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
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate ??
                  DateTime.now().subtract(const Duration(days: 6570)),
              firstDate: firstDate ?? DateTime(1900),
              lastDate: lastDate ?? DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF2549B2), // Couleur principale
                      onPrimary: Colors.white,
                      onSurface: Color(0xFF23272F),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2549B2),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              setState(() {
                controller.text =
                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty ? placeholder : controller.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: controller.text.isEmpty
                            ? const Color(0xFFADB5BD)
                            : const Color(0xFF23272F),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF2549B2),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
          ),
        ],
      ],
    );
  }

  // Option de rôle
  Widget _buildRoleOption(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    String value,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              _selectedRole == value ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedRole == value
                ? const Color(0xFF1976D2)
                : const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedRole,
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue ?? '';
                });
              },
              activeColor: const Color(0xFF1976D2),
            ),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
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
                ],
              ),
            ),
          ],
        ),
      ),
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 12),
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
                color: Color(0xFF6C757D),
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

  // Checkbox de projet
  Widget _buildProjectCheckbox(String projectName) {
    return CheckboxListTile(
      title: Text(
        projectName,
        style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
      ),
      value: _selectedProjects.contains(projectName),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedProjects.add(projectName);
          } else {
            _selectedProjects.remove(projectName);
          }
        });
      },
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Checkbox d'action
  Widget _buildActionCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Ligne de résumé
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'Non renseigné' : value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF23272F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

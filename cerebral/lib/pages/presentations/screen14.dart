import 'package:flutter/material.dart';
import '../../core/services/project_service.dart';
import '../../core/services/auth_service.dart';

class Screen14 extends StatefulWidget {
  const Screen14({super.key});

  @override
  State<Screen14> createState() => _Screen14State();
}

class _Screen14State extends State<Screen14> {
  int _currentStep = 0; // 0: Général, 1: Unités, 2: Étapes, 3: Équipe

  // Services
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();

  // État de chargement
  bool _isCreating = false;

  // Contrôleurs pour l'étape 1 - Informations générales
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController(
    text: '2500000',
  );
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  String _selectedProjectType = '';

  // Variables pour l'étape 2 - Unités
  String _selectedUnitType = '';
  int _numberOfUnits = 0;
  final List<String> _selectedFeatures = [];
  final TextEditingController _averageSurfaceController =
      TextEditingController();

  // Variables pour l'étape 3 - Étapes
  List<Map<String, dynamic>> _projectPhases = [];
  final List<String> _defaultPhases = [
    'Acquisition',
    'Fondation',
    'Gros Œuvre',
    'Électricité',
    'Plomberie',
    'Finitions',
    'Contrôle',
    'Livraison',
  ];

  // Variables pour l'étape 4 - Équipe
  String _selectedProjectManager = '';
  final List<Map<String, dynamic>> _technicalTeam = [];
  final List<Map<String, dynamic>> _subcontractors = [];

  // Variables pour les dates
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _initializeProjectPhases();
  }

  void _initializeProjectPhases() {
    _projectPhases = _defaultPhases
        .map(
          (phase) => {
            'name': phase,
            'duration': 30,
            'responsible': '',
            'startDate': '',
            'endDate': '',
          },
        )
        .toList();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _fullAddressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _budgetController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _clientEmailController.dispose();
    _averageSurfaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
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
              padding: const EdgeInsets.all(30),
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
                      'Créer un Projet',
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

            // Indicateur de progression (4 étapes)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Étape 1
                  Expanded(
                    child: _buildProgressStep(
                      stepNumber: 1,
                      stepTitle: 'Général',
                      isActive: _currentStep == 0,
                      isCompleted: _currentStep > 0,
                    ),
                  ),
                  // Ligne de connexion
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 0
                          ? const Color(0xFF1976D2)
                          : const Color(0xFFE9ECEF),
                    ),
                  ),
                  // Étape 2
                  Expanded(
                    child: _buildProgressStep(
                      stepNumber: 2,
                      stepTitle: 'Unités',
                      isActive: _currentStep == 1,
                      isCompleted: _currentStep > 1,
                    ),
                  ),
                  // Ligne de connexion
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 1
                          ? const Color(0xFF1976D2)
                          : const Color(0xFFE9ECEF),
                    ),
                  ),
                  // Étape 3
                  Expanded(
                    child: _buildProgressStep(
                      stepNumber: 3,
                      stepTitle: 'Étapes',
                      isActive: _currentStep == 2,
                      isCompleted: _currentStep > 2,
                    ),
                  ),
                  // Ligne de connexion
                  Expanded(
                    child: Container(
                      height: 2,
                      color: _currentStep > 2
                          ? const Color(0xFF1976D2)
                          : const Color(0xFFE9ECEF),
                    ),
                  ),
                  // Étape 4
                  Expanded(
                    child: _buildProgressStep(
                      stepNumber: 4,
                      stepTitle: 'Équipe',
                      isActive: _currentStep == 3,
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
                ? const Color(0xFF1976D2)
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
                ? const Color(0xFF1976D2)
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
        return _buildGeneralStep();
      case 1:
        return _buildUnitsStep();
      case 2:
        return _buildPhasesStep();
      case 3:
        return _buildTeamStep();
      default:
        return _buildGeneralStep();
    }
  }

  // Étape 1 - Informations générales
  Widget _buildGeneralStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations générales',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 24),

          // Nom du projet
          _buildInputField(
            label: 'Nom du projet *',
            controller: _projectNameController,
            placeholder: 'Ex: Résidence Les Palmiers',
            isRequired: true,
          ),

          const SizedBox(height: 20),

          // Description
          _buildInputField(
            label: 'Description',
            controller: _descriptionController,
            placeholder: 'Description du projet immobilier...',
            isRequired: false,
            isMultiline: true,
          ),

          const SizedBox(height: 20),

          // Email du client
          _buildInputField(
            label: 'Email du client',
            controller: _clientEmailController,
            placeholder: 'client@example.com',
            isRequired: false,
            suffixIcon: Icons.email,
          ),

          const SizedBox(height: 20),

          // Localisation
          const Text(
            'Localisation *',
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

          // Adresse complète
          _buildInputField(
            label: 'Adresse complète',
            controller: _fullAddressController,
            placeholder: 'Adresse complète',
            isRequired: false,
          ),

          const SizedBox(height: 20),

          // Code postal et ville
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Code postal',
                  controller: _postalCodeController,
                  placeholder: 'Code postal',
                  isRequired: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  label: 'Ville',
                  controller: _cityController,
                  placeholder: 'Ville',
                  isRequired: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Budget prévisionnel
          _buildInputField(
            label: 'Budget prévisionnel *',
            controller: _budgetController,
            placeholder: '0',
            isRequired: true,
            suffix: '€',
          ),

          const SizedBox(height: 20),

          // Date de début
          _buildDateField(
            label: 'Date de début',
            value: _startDate,
            onTap: _selectStartDate,
            placeholder: 'Sélectionner une date',
            isRequired: false,
          ),

          const SizedBox(height: 20),

          // Date de fin prévue
          _buildDateField(
            label: 'Date de fin prévue',
            value: _endDate,
            onTap: _selectEndDate,
            placeholder: 'Sélectionner une date',
            isRequired: false,
          ),

          const SizedBox(height: 20),

          // Type de projet
          _buildDropdownField(
            label: 'Type de projet',
            value: _selectedProjectType,
            hint: 'Sélectionner un type',
            items: const [
              'Résidentiel',
              'Commercial',
              'Industriel',
            ],
            onChanged: (value) {
              setState(() {
                _selectedProjectType = value ?? '';
              });
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Étape 2 - Unités
  Widget _buildUnitsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuration des unités',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 24),

          // Type d'unités
          _buildDropdownField(
            label: 'Type d\'unités *',
            value: _selectedUnitType,
            hint: 'Sélectionner un type',
            items: const [
              'Villas',
              'Appartements',
              'Maisons',
              'Bureaux',
              'Locaux commerciaux',
            ],
            onChanged: (value) {
              setState(() {
                _selectedUnitType = value ?? '';
              });
            },
          ),

          const SizedBox(height: 24),

          // Nombre d'unités
          _buildInputField(
            label: 'Nombre d\'unités *',
            controller: TextEditingController(text: _numberOfUnits.toString()),
            placeholder: '0',
            isRequired: true,
            onChanged: (value) {
              setState(() {
                _numberOfUnits = int.tryParse(value) ?? 0;
              });
            },
          ),

          const SizedBox(height: 24),

          // Caractéristiques
          const Text(
            'Caractéristiques',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildFeatureCheckbox('Parking'),
          _buildFeatureCheckbox('Jardin'),
          _buildFeatureCheckbox('Balcon'),
          _buildFeatureCheckbox('Terrasse'),
          _buildFeatureCheckbox('Cave'),
          _buildFeatureCheckbox('Ascenseur'),

          const SizedBox(height: 24),

          // Surface moyenne
          _buildInputField(
            label: 'Surface moyenne (m²)',
            controller: _averageSurfaceController,
            placeholder: '0',
            isRequired: false,
            suffix: 'm²',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Étape 3 - Étapes
  Widget _buildPhasesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phases du projet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 24),

          // Liste des phases
          ..._projectPhases.map((phase) => _buildPhaseCard(phase)),

          const SizedBox(height: 24),

          // Bouton ajouter une phase
          Center(
            child: ElevatedButton.icon(
              onPressed: _addNewPhase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text(
                'Ajouter une phase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Étape 4 - Équipe
  Widget _buildTeamStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Composition de l\'équipe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),

          const SizedBox(height: 24),

          // Chef de projet
          _buildDropdownField(
            label: 'Chef de projet *',
            value: _selectedProjectManager,
            hint: 'Sélectionner un chef de projet',
            items: const [
              'Jean Dupont',
              'Marie Martin',
              'Pierre Durand',
              'Sophie Bernard',
            ],
            onChanged: (value) {
              setState(() {
                _selectedProjectManager = value ?? '';
              });
            },
          ),

          const SizedBox(height: 24),

          // Équipe technique
          const Text(
            'Équipe technique',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildTeamMemberCard('Électricien', '2 membres'),
          _buildTeamMemberCard('Plombier', '1 membre'),
          _buildTeamMemberCard('Maçon', '3 membres'),
          _buildTeamMemberCard('Menuisier', '1 membre'),

          const SizedBox(height: 24),

          // Sous-traitants
          const Text(
            'Sous-traitants',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 16),

          _buildSubcontractorCard('Électricité Plus', 'Électricité'),
          _buildSubcontractorCard('Plomberie Pro', 'Plomberie'),
          _buildSubcontractorCard('Maçonnerie Express', 'Maçonnerie'),

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
    } else if (_currentStep == 3) {
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
              onPressed: _isCreating ? null : _createProject,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCreating
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF4CAF50),
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
                  : const Icon(
                      Icons.add_business,
                      color: Colors.white,
                      size: 20,
                    ),
              label: Text(
                _isCreating ? 'Création...' : 'Créer le projet',
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
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  // Création du projet
  Future<void> _createProject() async {
    // Validation des champs obligatoires
    if (_projectNameController.text.isEmpty || _selectedProjectType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    // Validation de l'email si saisi
    if (_clientEmailController.text.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_clientEmailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez saisir un email valide'),
            backgroundColor: Color(0xFFF44336),
          ),
        );
        return;
      }
    }

    // Validation du budget
    final budgetValue =
        double.tryParse(_budgetController.text.replaceAll(',', '.'));
    if (budgetValue == null || budgetValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un budget valide'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Récupérer l'ID de l'utilisateur connecté
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Préparer les données du projet
      final projectData = await _projectService.createProject(
        name: _projectNameController.text.trim(),
        type: _mapProjectTypeToApi(
            _selectedProjectType), // Mapper le type vers l'API
        status: 'planning', // Statut valide selon l'API
        priority: 'medium', // Priorité valide selon l'API
        clientName: 'Client du projet', // À adapter selon vos besoins
        clientEmail: _clientEmailController.text.isNotEmpty
            ? _clientEmailController.text.trim()
            : 'client@example.com',
        location:
            '${_fullAddressController.text}, ${_postalCodeController.text} ${_cityController.text}',
        managerId: currentUser['id'] ?? 1, // ID de l'utilisateur connecté
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        budget: budgetValue,
        currency: 'EUR',
        startDate: _startDate, // Utiliser les variables DateTime
        endDate: _endDate, // Utiliser les variables DateTime
        progress: 0.0, // Progression initiale
        tags: _buildValidTags(), // Construire des tags valides
      );

      // Succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Projet "${_projectNameController.text}" créé avec succès !'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );

        // Retourner à la page précédente
        Navigator.pop(context);
      }
    } catch (e) {
      // Gestion des erreurs
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erreur lors de la création du projet: ${e.toString()}'),
            backgroundColor: const Color(0xFFF44336),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  // Ajouter une nouvelle phase
  void _addNewPhase() {
    setState(() {
      _projectPhases.add({
        'name': 'Nouvelle phase',
        'duration': 30,
        'responsible': '',
        'startDate': '',
        'endDate': '',
      });
    });
  }

  // Champ de saisie
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isRequired,
    String? suffix,
    IconData? suffixIcon,
    bool isMultiline = false,
    Function(String)? onChanged,
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
                  onChanged: onChanged,
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
              if (suffix != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    suffix,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6C757D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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

  // Checkbox de caractéristique
  Widget _buildFeatureCheckbox(String feature) {
    return CheckboxListTile(
      title: Text(
        feature,
        style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
      ),
      value: _selectedFeatures.contains(feature),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedFeatures.add(feature);
          } else {
            _selectedFeatures.remove(feature);
          }
        });
      },
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Carte de phase
  Widget _buildPhaseCard(Map<String, dynamic> phase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  phase['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _projectPhases.remove(phase);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFFF44336),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Durée (jours)',
                  controller: TextEditingController(
                    text: phase['duration'].toString(),
                  ),
                  placeholder: '0',
                  isRequired: false,
                  onChanged: (value) {
                    phase['duration'] = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Responsable',
                  value: phase['responsible'],
                  hint: 'Sélectionner',
                  items: const ['Jean Dupont', 'Marie Martin', 'Pierre Durand'],
                  onChanged: (value) {
                    phase['responsible'] = value ?? '';
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Carte de membre d'équipe
  Widget _buildTeamMemberCard(String role, String members) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
                Text(
                  members,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Color(0xFF1976D2), size: 20),
          ),
        ],
      ),
    );
  }

  // Carte de sous-traitant
  Widget _buildSubcontractorCard(String name, String specialty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business, color: Colors.white, size: 24),
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
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Color(0xFF1976D2), size: 20),
          ),
        ],
      ),
    );
  }

  // Mapper le type de projet vers l'API
  String _mapProjectTypeToApi(String uiType) {
    switch (uiType.toLowerCase()) {
      case 'résidentiel':
      case 'residential':
        return 'residential';
      case 'commercial':
        return 'commercial';
      case 'industriel':
      case 'industrial':
        return 'industrial';
      default:
        return 'residential'; // Valeur par défaut
    }
  }

  // Construire des tags valides
  List<String> _buildValidTags() {
    final tags = <String>[];

    if (_selectedUnitType.isNotEmpty) {
      tags.add(_selectedUnitType);
    }

    if (_numberOfUnits > 0) {
      tags.add('${_numberOfUnits} unités');
    }

    // Ajouter des tags par défaut si aucun n'est défini
    if (tags.isEmpty) {
      tags.add('nouveau projet');
    }

    return tags;
  }

  // Sélectionner la date de début
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 ans
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // Sélectionner la date de fin
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // 10 ans
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
    // Validation : la date de fin doit être après la date de début
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      setState(() {
        _endDate = null;
        _endDateController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La date de fin doit être après la date de début'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
    }
  }

  // Champ de sélection de date
  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required String placeholder,
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
        InkWell(
          onTap: onTap,
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
                    value != null
                        ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                        : placeholder,
                    style: TextStyle(
                      color: value != null
                          ? const Color(0xFF23272F)
                          : const Color(0xFFADB5BD),
                      fontSize: 16,
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
}

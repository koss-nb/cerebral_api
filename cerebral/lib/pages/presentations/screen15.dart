import 'package:flutter/material.dart';

class Screen15 extends StatefulWidget {
  const Screen15({super.key});

  @override
  State<Screen15> createState() => _Screen15State();
}

class _Screen15State extends State<Screen15> {
  // Contrôleurs pour les champs de saisie
  final TextEditingController _stepNameController = TextEditingController();
  final TextEditingController _stepCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '15',
  );

  // Variables de sélection
  String _selectedColor = 'blue';
  String _selectedIcon = 'hammer';
  String _selectedUnit = 'Jours';
  String _selectedPosition = '';
  String _selectedTrade = '';

  // Listes de sélection
  final List<String> _availableColors = [
    'blue',
    'green',
    'orange',
    'red',
    'purple',
    'cyan',
  ];
  final List<Map<String, dynamic>> _availableIcons = [
    {'id': 'hammer', 'icon': Icons.handyman, 'color': Color(0xFF8D6E63)},
    {'id': 'lightning', 'icon': Icons.flash_on, 'color': Color(0xFFFFD700)},
    {'id': 'wrench', 'icon': Icons.build, 'color': Color(0xFF1976D2)},
    {'id': 'paintbrush', 'icon': Icons.brush, 'color': Color(0xFF9C27B0)},
    {'id': 'snowflake', 'icon': Icons.ac_unit, 'color': Color(0xFF00BCD4)},
    {
      'id': 'fire',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFFF5722),
    },
  ];

  final List<String> _availableUnits = ['Jours', 'Semaines', 'Mois'];
  final List<String> _availablePositions = [
    'Début',
    'Milieu',
    'Fin',
    'Après fondations',
    'Après gros œuvre',
  ];
  final List<String> _availableTrades = [
    'Électricien',
    'Plombier',
    'Maçon',
    'Menuisier',
    'Peintre',
    'Carreleur',
  ];

  // Prérequis
  final List<Map<String, dynamic>> _prerequisites = [
    {'name': 'Acquisition', 'icon': Icons.home, 'isChecked': false},
    {'name': 'Fondations', 'icon': Icons.construction, 'isChecked': false},
    {'name': 'Gros œuvre', 'icon': Icons.business, 'isChecked': true},
    {'name': 'Électricité', 'icon': Icons.flash_on, 'isChecked': false},
  ];

  // Exigences de validation
  bool _photoRequired = true;
  bool _supervisorValidation = false;
  bool _technicalDocument = false;
  bool _externalQualityControl = false;

  @override
  void dispose() {
    _stepNameController.dispose();
    _stepCodeController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête violet avec navigation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF9C27B0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Bouton retour
                  IconButton(
                    onPressed: () {},
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
                      'Créer une Étape',
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

            // Titre principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text(
                  'Nouvelle étape personnalisée',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
            ),

            // Contenu principal avec scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations de base
                    _buildSectionTitle('Informations de base'),
                    const SizedBox(height: 20),

                    _buildInputField(
                      label: 'Nom de l\'étape *',
                      controller: _stepNameController,
                      placeholder: 'Ex: Installation climatisation',
                      isRequired: true,
                    ),

                    const SizedBox(height: 20),

                    _buildInputField(
                      label: 'Code étape *',
                      controller: _stepCodeController,
                      placeholder: 'EX: CLIM',
                      isRequired: true,
                      helperText: 'Code unique pour identifier l\'étape',
                    ),

                    const SizedBox(height: 20),

                    _buildInputField(
                      label: 'Description',
                      controller: _descriptionController,
                      placeholder: 'Description détaillée de l\'étape...',
                      isRequired: false,
                      isMultiline: true,
                    ),

                    const SizedBox(height: 32),

                    // Section Configuration visuelle
                    _buildSectionTitle('Configuration visuelle'),
                    const SizedBox(height: 20),

                    // Couleur de l'étape
                    const Text(
                      'Couleur de l\'étape',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: _availableColors.map((color) {
                        return _buildColorSwatch(color);
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Icône
                    const Text(
                      'Icône',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _availableIcons.map((iconData) {
                          return _buildIconButton(iconData);
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section Planification
                    _buildSectionTitle('Planification'),
                    const SizedBox(height: 20),

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
                            value: _selectedUnit,
                            hint: 'Sélectionner une unité',
                            items: _availableUnits,
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value ?? 'Jours';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildDropdownField(
                      label: 'Position dans le workflow',
                      value: _selectedPosition,
                      hint: 'Sélectionner une position',
                      items: _availablePositions,
                      onChanged: (value) {
                        setState(() {
                          _selectedPosition = value ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // Section Prérequis
                    _buildSectionTitle('Prérequis'),
                    const SizedBox(height: 16),

                    const Text(
                      'Sélectionnez les étapes qui doivent être terminées avant celle-ci :',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                    ),
                    const SizedBox(height: 20),

                    ..._prerequisites
                        .map(
                          (prerequisite) =>
                              _buildPrerequisiteItem(prerequisite),
                        )
                        .toList(),

                    const SizedBox(height: 32),

                    // Section Corps de métier par défaut
                    _buildSectionTitle('Corps de métier par défaut'),
                    const SizedBox(height: 16),

                    const Text(
                      'Métier principal pour cette étape',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                    ),
                    const SizedBox(height: 20),

                    _buildDropdownField(
                      label: '',
                      value: _selectedTrade,
                      hint: 'Sélectionner un métier',
                      items: _availableTrades,
                      onChanged: (value) {
                        setState(() {
                          _selectedTrade = value ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // Section Exigences de validation
                    _buildSectionTitle('Exigences de validation'),
                    const SizedBox(height: 20),

                    _buildValidationCheckbox(
                      'Photo obligatoire pour validation',
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
                      'Document technique requis',
                      _technicalDocument,
                      (value) {
                        setState(() {
                          _technicalDocument = value ?? false;
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
                  // Bouton Aperçu
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _previewStep,
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
                        Icons.visibility,
                        color: Color(0xFF23272F),
                        size: 20,
                      ),
                      label: const Text(
                        'Aperçu',
                        style: TextStyle(
                          color: Color(0xFF23272F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bouton Créer l'étape
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _createStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Créer l\'étape',
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
            ),
          ],
        ),
      ),
    );
  }

  // Titre de section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF23272F),
      ),
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

  // Échantillon de couleur
  Widget _buildColorSwatch(String colorName) {
    final Map<String, Color> colorMap = {
      'blue': const Color(0xFF1976D2),
      'green': const Color(0xFF4CAF50),
      'orange': const Color(0xFFFF9800),
      'red': const Color(0xFFF44336),
      'purple': const Color(0xFF9C27B0),
      'cyan': const Color(0xFF00BCD4),
    };

    final isSelected = _selectedColor == colorName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorName;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorMap[colorName],
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF23272F) : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  // Bouton d'icône
  Widget _buildIconButton(Map<String, dynamic> iconData) {
    final isSelected = _selectedIcon == iconData['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = iconData['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1976D2)
                : const Color(0xFFE9ECEF),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(iconData['icon'], color: iconData['color'], size: 24),
      ),
    );
  }

  // Élément de prérequis
  Widget _buildPrerequisiteItem(Map<String, dynamic> prerequisite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          Checkbox(
            value: prerequisite['isChecked'],
            onChanged: (bool? value) {
              setState(() {
                prerequisite['isChecked'] = value ?? false;
              });
            },
            activeColor: const Color(0xFF1976D2),
          ),
          const SizedBox(width: 16),
          Icon(prerequisite['icon'], color: const Color(0xFF6C757D), size: 24),
          const SizedBox(width: 16),
          Text(
            prerequisite['name'],
            style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          ),
        ],
      ),
    );
  }

  // Checkbox de validation
  Widget _buildValidationCheckbox(
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

  // Aperçu de l'étape
  void _previewStep() {
    // Ici vous pouvez implémenter la logique d'aperçu
    print('Aperçu de l\'étape...');
    print('Nom: ${_stepNameController.text}');
    print('Code: ${_stepCodeController.text}');
    print('Couleur: $_selectedColor');
    print('Icône: $_selectedIcon');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aperçu de l\'étape généré !'),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  // Création de l'étape
  void _createStep() {
    // Ici vous pouvez implémenter la logique de création
    print('Création de l\'étape...');
    print('Nom: ${_stepNameController.text}');
    print('Code: ${_stepCodeController.text}');
    print('Description: ${_descriptionController.text}');
    print('Durée: ${_durationController.text} $_selectedUnit');
    print('Couleur: $_selectedColor');
    print('Icône: $_selectedIcon');
    print('Position: $_selectedPosition');
    print('Métier: $_selectedTrade');

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Étape créée avec succès !'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

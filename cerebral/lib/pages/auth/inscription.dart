import 'package:cerebral/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Contrôleurs pour les champs de saisie
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  // Variables de sélection
  String _selectedRole = '';
  String _selectedCompanyType = '';

  // États des champs
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _acceptNewsletter = false;

  // États de l'application
  bool _isLoading = false;
  String? _errorMessage;

  // Listes de sélection
  final List<String> _availableRoles = [
    'Chef de Projet',
    'Chef de Chantier',
    'Électricien',
    'Plombier',
    'Maçon',
    'Architecte',
    'Ingénieur',
    'Autre',
  ];

  final List<String> _availableCompanyTypes = [
    'Entreprise individuelle',
    'SARL',
    'SAS',
    'SA',
    'Association',
    'Autre',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // En-tête avec logo et titre
                _buildHeader(),

                const SizedBox(height: 32),

                // Formulaire d'inscription
                _buildRegistrationForm(),

                // Affichage des erreurs
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],

                const SizedBox(height: 32),

                // Bouton d'inscription
                _buildRegisterButton(),

                const SizedBox(height: 24),

                // Lien vers la connexion
                _buildLoginLink(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // En-tête avec logo et titre
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo CEREBRAL
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 40),
        ),

        const SizedBox(height: 24),

        // Titre principal
        const Text(
          'Créer votre compte',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF23272F),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Sous-titre
        const Text(
          'Rejoignez CEREBRAL et gérez vos projets de construction efficacement',
          style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Formulaire d'inscription
  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Informations personnelles
          _buildSectionTitle('Informations personnelles'),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Prénom *',
                  controller: _firstNameController,
                  placeholder: 'Votre prénom',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le prénom est requis';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  label: 'Nom *',
                  controller: _lastNameController,
                  placeholder: 'Votre nom',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le nom est requis';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildInputField(
            label: 'Email *',
            controller: _emailController,
            placeholder: 'exemple@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'L\'email est requis';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
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
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le téléphone est requis';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Informations professionnelles
          _buildSectionTitle('Informations professionnelles'),
          const SizedBox(height: 20),

          _buildDropdownField(
            label: 'Rôle principal *',
            value: _selectedRole,
            hint: 'Sélectionner votre rôle',
            items: _availableRoles,
            onChanged: (value) {
              setState(() {
                _selectedRole = value ?? '';
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le rôle est requis';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          _buildInputField(
            label: 'Nom de l\'entreprise',
            controller: _companyController,
            placeholder: 'Nom de votre entreprise (optionnel)',
          ),

          const SizedBox(height: 20),

          _buildDropdownField(
            label: 'Type d\'entreprise',
            value: _selectedCompanyType,
            hint: 'Sélectionner le type',
            items: _availableCompanyTypes,
            onChanged: (value) {
              setState(() {
                _selectedCompanyType = value ?? '';
              });
            },
          ),

          const SizedBox(height: 32),

          // Sécurité
          _buildSectionTitle('Sécurité'),
          const SizedBox(height: 20),

          _buildInputField(
            label: 'Mot de passe *',
            controller: _passwordController,
            placeholder: 'Minimum 8 caractères',
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le mot de passe est requis';
              }
              if (value.length < 8) {
                return 'Le mot de passe doit contenir au moins 8 caractères';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          _buildInputField(
            label: 'Confirmer le mot de passe *',
            controller: _confirmPasswordController,
            placeholder: 'Retapez votre mot de passe',
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La confirmation est requise';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Conditions et préférences
          _buildSectionTitle('Conditions et préférences'),
          const SizedBox(height: 20),

          _buildCheckboxTile(
            'J\'accepte les conditions d\'utilisation et la politique de confidentialité *',
            _acceptTerms,
            (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            isRequired: true,
          ),

          const SizedBox(height: 16),

          _buildCheckboxTile(
            'Je souhaite recevoir la newsletter et les actualités CEREBRAL',
            _acceptNewsletter,
            (value) {
              setState(() {
                _acceptNewsletter = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  // Titre de section
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Champ de saisie
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF44336)),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF6C757D),
                    ),
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          validator: validator,
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
    String? Function(String?)? validator,
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
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6C757D),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          validator: validator,
        ),
      ],
    );
  }

  // Checkbox avec texte
  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool?) onChanged, {
    bool isRequired = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1976D2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                text: title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF23272F)),
                children: isRequired
                    ? [
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Color(0xFFF44336),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Bouton d'inscription
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF1976D2).withValues(alpha: 0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Créer mon compte',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // Affichage des messages d'erreur
  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF44336)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFF44336),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFFF44336),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Lien vers la connexion
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Vous avez déjà un compte ? ',
          style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
        ),
        GestureDetector(
          onTap: () {
            // Navigation vers la page de connexion
            Navigator.pop(context);
          },
          child: const Text(
            'Se connecter',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1976D2),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // Gestion de l'inscription
  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez accepter les conditions d\'utilisation'),
            backgroundColor: Color(0xFFF44336),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Préparer les données pour l'inscription
        final userData = {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
          'role': _selectedRole,
          'company_name': _companyController.text.trim().isNotEmpty
              ? _companyController.text.trim()
              : null,
          'company_type':
              _selectedCompanyType.isNotEmpty ? _selectedCompanyType : null,
          'accept_terms': _acceptTerms,
          'accept_newsletter': _acceptNewsletter,
        };

        // Appeler l'API d'inscription
        final response = await _authService.register(
          firstName: userData['first_name'] as String,
          lastName: userData['last_name'] as String,
          email: userData['email'] as String,
          password: userData['password'] as String,
          passwordConfirmation: userData['password_confirmation'] as String,
          role: userData['role'] as String,
          phone: userData['phone'] as String?,
          companyName: userData['company_name'] as String?,
          companyType: userData['company_type'] as String?,
          acceptTerms: userData['accept_terms'] as bool?,
          acceptNewsletter: userData['accept_newsletter'] as bool?,
        );

        if (response['success'] == true) {
          // Inscription réussie
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response['message'] ??
                      'Compte créé avec succès ! Vérifiez votre email pour confirmer.',
                ),
                backgroundColor: const Color(0xFF4CAF50),
                duration: const Duration(seconds: 4),
              ),
            );

            // Naviguer vers la page de connexion après un délai
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/login');
              }
            });
          }
        } else {
          // Erreur de l'API
          setState(() {
            _errorMessage =
                response['message'] ?? 'Erreur lors de l\'inscription';
          });
        }
      } catch (e) {
        // Gestion des erreurs
        setState(() {
          _errorMessage = _getErrorMessage(e);
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // Obtenir un message d'erreur lisible
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('email already exists')) {
      return 'Cette adresse email est déjà utilisée';
    } else if (error.toString().contains('validation')) {
      return 'Veuillez vérifier les informations saisies';
    } else if (error.toString().contains('network')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet';
    } else {
      return 'Une erreur est survenue lors de l\'inscription';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cerebral/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import '../presentations/my_home_page.dart';
import '../presentations/site_manager_dashboard.dart';
import '../presentations/supervisor_dashboard.dart';
import '../presentations/technicien_dashboard.dart';
// Pas d'import circulaire nécessaire

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Contrôleurs pour les champs de saisie
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // États des champs
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

                // Formulaire de connexion
                _buildLoginForm(),

                // Affichage des erreurs
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],

                const SizedBox(height: 32),

                // Bouton de connexion
                _buildLoginButton(),

                const SizedBox(height: 24),

                // Lien vers l'inscription
                _buildSignupLink(),

                const SizedBox(height: 32),

                // Identifiants de test
                _buildTestCredentials(),

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
          'Connexion',
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
          'Connectez-vous à votre compte CEREBRAL',
          style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Formulaire de connexion
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
            label: 'Email',
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
            label: 'Mot de passe',
            controller: _passwordController,
            placeholder: 'Votre mot de passe',
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
              return null;
            },
          ),
        ],
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

  // Bouton de connexion
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
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
                'Se connecter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // Lien vers l'inscription
  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Vous n\'avez pas de compte ? ',
          style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
        ),
        GestureDetector(
          onTap: () {
            // Navigation vers la page d'inscription
            context.push('/signup');
          },
          child: const Text(
            'S\'inscrire',
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

  // Identifiants de test
  Widget _buildTestCredentials() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1976D2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF1976D2),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Identifiants de test',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Utilisez ces identifiants pour tester l\'application :',
            style: TextStyle(
              color: Color(0xFF1976D2),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          _buildTestCredential('Admin', 'admin@cerebral.com', 'password123'),
          _buildTestCredential(
              'Manager', 'manager@cerebral.com', 'password123'),
          _buildTestCredential(
              'Chef de chantier', 'chef@cerebral.com', 'password123'),
          _buildTestCredential(
              'Technicien', 'technicien@cerebral.com', 'password123'),
        ],
      ),
    );
  }

  // Affichage d'un identifiant de test
  Widget _buildTestCredential(String role, String email, String password) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            '$role: ',
            style: const TextStyle(
              color: Color(0xFF1976D2),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            email,
            style: const TextStyle(
              color: Color(0xFF1976D2),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Gestion de la connexion
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Appeler l'API de connexion
        final response = await _authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (response['success'] == true || response['token'] != null) {
          // Connexion réussie
          if (mounted) {
            // Debug: Afficher la réponse complète
            print('🔍 Réponse API complète: $response');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response['message'] ?? 'Connexion réussie !',
                ),
                backgroundColor: const Color(0xFF4CAF50),
                duration: const Duration(seconds: 2),
              ),
            );

            // Rediriger vers le dashboard approprié selon le rôle avec un délai
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  // Forcer le rebuild avant la redirection
                });
                _redirectToDashboard(context, response);
              }
            });
          }
        } else {
          // Erreur de l'API
          setState(() {
            _errorMessage =
                response['message'] ?? 'Erreur lors de la connexion';
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

  // Rediriger vers le dashboard approprié selon le rôle
  void _redirectToDashboard(
      BuildContext context, Map<String, dynamic> response) {
    // Debug: Afficher les informations de redirection
    print('🔍 Début de redirection');
    print('🔍 Réponse reçue: $response');

    // Récupérer le rôle de l'utilisateur depuis la réponse
    final userRole = response['user']?['role'] ?? response['role'];
    final userEmail =
        response['user']?['email'] ?? _emailController.text.trim();

    print('🔍 Rôle détecté: $userRole');
    print('🔍 Email: $userEmail');

    String route;
    String roleName;

    // Déterminer la route selon le rôle
    switch (userRole?.toString().toLowerCase()) {
      case 'admin':
      case 'administrator':
        route = 'dashboard'; // Redirection vers MyHomePage (route racine)
        roleName = 'Administrateur';
        break;
      case 'manager':
      case 'site_manager':
      case 'project_manager':
        route = '/site-manager-dashboard';
        roleName = 'Chef de Projet';
        break;
      case 'supervisor':
      case 'chef_chantier':
      case 'site_supervisor':
        route = '/supervisor-dashboard';
        roleName = 'Chef de Chantier';
        break;
      case 'technicien':
      case 'technician':
        route = '/technicien-dashboard';
        roleName = 'Technicien';
        break;
      default:
        // Fallback vers le dashboard admin pour les rôles non reconnus
        route = '/dashboard';
        roleName = 'Utilisateur';
    }

    // Afficher un message de bienvenue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Bienvenue $roleName ! Redirection vers votre dashboard...'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );

    // Debug: Afficher la route finale
    print('🔍 Route finale: $route');
    print('🔍 Nom du rôle: $roleName');

    // Navigation directe avec Navigator selon le rôle
    print('🚀 Navigation vers: $route');
    print('🚀 Rôle exact reçu: "$userRole"');
    print('🚀 Rôle en minuscules: "${userRole?.toString().toLowerCase()}"');

    if (mounted) {
      // Navigation selon le rôle
      switch (userRole?.toString().toLowerCase()) {
        case 'admin':
        case 'administrator':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
          print('✅ Navigation vers MyHomePage (Admin)');
          break;
        case 'manager':
        case 'site_manager':
        case 'project_manager':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const SiteManagerDashboard()),
          );
          print('✅ Navigation vers SiteManagerDashboard (Manager)');
          break;
        case 'chef':
        case 'supervisor':
        case 'chef_chantier':
        case 'site_supervisor':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const SupervisorDashboard()),
          );
          print('✅ Navigation vers SupervisorDashboard (Supervisor/Chef)');
          break;
        case 'technicien':
        case 'technician':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const TechnicienDashboard()),
          );
          print('✅ Navigation vers TechnicienDashboard (Technicien)');
          break;
        default:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
          print('✅ Navigation vers MyHomePage (Rôle par défaut)');
      }
    }
  }

  // Obtenir un message d'erreur lisible
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('invalid credentials')) {
      return 'Email ou mot de passe incorrect';
    } else if (error.toString().contains('validation')) {
      return 'Veuillez vérifier les informations saisies';
    } else if (error.toString().contains('network')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet';
    } else {
      return 'Une erreur est survenue lors de la connexion';
    }
  }
}

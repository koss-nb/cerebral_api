import 'package:cerebral/pages/auth/connexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for SystemNavigator.pop()

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedDrawerIndex =
      0; // 0: Mon Profil, 1: Étapes, 2: Métiers, 3: Matériaux, 4: Notifications
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2549B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Réglages',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildMainContent(),
    );
  }

  // Construction du drawer (navigation latérale)
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // En-tête du drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: const BoxDecoration(color: Color(0xFF2549B2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cerebral',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gestion de projet',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            // Liste des éléments du menu
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Mon Profil',
                    index: 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.format_list_bulleted,
                    title: 'Étapes',
                    index: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.construction,
                    title: 'Métiers',
                    index: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.layers,
                    title: 'Matériaux',
                    index: 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    index: 4,
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    index: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construction d'un élément du drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedDrawerIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(
            color: isSelected ? const Color(0xFF2549B2) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF2549B2) : const Color(0xFF6C757D),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF2549B2)
                : const Color(0xFF6C757D),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
        ),
        onTap: () {
          if (index == 5) {
            // Gestion spéciale pour la déconnexion
            _showLogoutDialog();
          } else {
            setState(() {
              _selectedDrawerIndex = index;
            });
            Navigator.pop(context); // Ferme le drawer
          }
        },
      ),
    );
  }

  // Contenu principal selon l'élément sélectionné
  Widget _buildMainContent() {
    switch (_selectedDrawerIndex) {
      case 0:
        return _buildProfileSection();
      case 1:
        return _buildStepsSection();
      case 2:
        return _buildTradesSection();
      case 3:
        return _buildMaterialsSection();
      case 4:
        return _buildNotificationsSection();
      case 5:
        return _buildLogoutSection();
      default:
        return _buildProfileSection();
    }
  }

  // Section Mon Profil
  Widget _buildProfileSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mon Profil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 32),

          // Section photo de profil
          Center(
            child: Column(
              children: [
                // Avatar circulaire
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2549B2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'JM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Lien pour changer la photo
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        color: Color(0xFF2549B2),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Changer la photo',
                        style: TextStyle(
                          color: Color(0xFF2549B2),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Champs d'information personnelle
          _buildInputField('Prénom', 'Jean'),
          const SizedBox(height: 20),
          _buildInputField('Nom', 'Martin'),
          const SizedBox(height: 20),
          _buildInputField('Email', 'j.martin@cerebral.com'),
          const SizedBox(height: 20),
          _buildInputField('Téléphone', '06 12 34 56 78'),
          const SizedBox(height: 20),
          _buildInputField('Rôle', 'Superviseur'),

          const SizedBox(height: 32),

          // Section changement de mot de passe
          const Text(
            'Changer le mot de passe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),
          _buildPasswordField('Mot de passe actuel'),
          const SizedBox(height: 20),
          _buildPasswordField('Nouveau mot de passe'),
          const SizedBox(height: 20),
          _buildPasswordField('Confirmer le mot de passe'),

          const SizedBox(height: 40),

          // Bouton d'enregistrement
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Enregistrer les modifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2549B2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Étapes
  Widget _buildStepsSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.format_list_bulleted, size: 64, color: Color(0xFF6C757D)),
          SizedBox(height: 16),
          Text(
            'Section Étapes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gestion des étapes de projet',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
        ],
      ),
    );
  }

  // Section Métiers
  Widget _buildTradesSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Color(0xFF6C757D)),
          SizedBox(height: 16),
          Text(
            'Section Métiers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gestion des métiers et compétences',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
        ],
      ),
    );
  }

  // Section Matériaux
  Widget _buildMaterialsSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers, size: 64, color: Color(0xFF6C757D)),
          SizedBox(height: 16),
          Text(
            'Section Matériaux',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gestion des matériaux et ressources',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
        ],
      ),
    );
  }

  // Section Notifications
  Widget _buildNotificationsSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 64, color: Color(0xFF6C757D)),
          SizedBox(height: 16),
          Text(
            'Section Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gestion des notifications et alertes',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
        ],
      ),
    );
  }

  // Section Déconnexion
  Widget _buildLogoutSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 64, color: Color(0xFF6C757D)),
          SizedBox(height: 16),
          Text(
            'Déconnexion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Voulez-vous vraiment vous déconnecter ?',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Logique de déconnexion ici
                  // Par exemple, supprimer le token d'authentification
                  // et rediriger vers la page de connexion
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Connexion()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFDC3545,
                  ), // Couleur rouge pour la déconnexion
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Affiche la boîte de dialogue de déconnexion
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Déconnexion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                _performLogout(); // Exécute la déconnexion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Déconnexion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Exécute la déconnexion
  void _performLogout() {
    // Ici vous pouvez ajouter votre logique de déconnexion
    // Par exemple :
    // - Supprimer le token d'authentification
    // - Vider le cache utilisateur
    // - Réinitialiser les données de session

    // Pour l'instant, on ferme simplement l'application
    // Vous pouvez remplacer cela par une navigation vers la page de connexion
    SystemNavigator.pop(); // Ferme l'application
  }

  // Construction d'un champ de saisie
  Widget _buildInputField(String label, String initialValue) {
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
        TextField(
          controller: TextEditingController(text: initialValue),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2549B2), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
        ),
      ],
    );
  }

  // Construction d'un champ de mot de passe
  Widget _buildPasswordField(String label) {
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
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2549B2), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
        ),
      ],
    );
  }
}

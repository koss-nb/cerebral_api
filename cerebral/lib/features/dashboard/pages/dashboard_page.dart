import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard_header.dart';
import '../sections/stats_section.dart';
import '../../../shared/widgets/custom_button.dart';

class DashboardPage extends StatefulWidget {
  final Widget child;

  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation drawer (sidebar)
          if (MediaQuery.of(context).size.width > 768) _buildSidebar(),

          // Contenu principal
          Expanded(
            child: Column(
              children: [
                // En-tête du dashboard
                DashboardHeader(
                  title: 'CEREBRAL',
                  subtitle: 'Dashboard principal',
                  notificationCount: 8,
                  onNotificationTap: () => context.go('/notifications'),
                  onProfileTap: () => context.go('/profile'),
                ),

                // Contenu de la route
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
      // Bottom navigation pour mobile
      bottomNavigationBar: MediaQuery.of(context).size.width <= 768
          ? _buildBottomNavigation()
          : null,
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Logo et titre
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.psychology, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'CEREBRAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Menu de navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    context.go('/dashboard');
                  },
                ),
                _buildNavItem(
                  icon: Icons.business,
                  title: 'Projets',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    context.go('/projects');
                  },
                ),
                _buildNavItem(
                  icon: Icons.task,
                  title: 'Tâches',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    context.go('/tasks');
                  },
                ),
                _buildNavItem(
                  icon: Icons.people,
                  title: 'Personnel',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    context.go('/personnel');
                  },
                ),
                _buildNavItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Budget',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    setState(() => _selectedIndex = 4);
                    context.go('/budget');
                  },
                ),
                _buildNavItem(
                  icon: Icons.timeline,
                  title: 'Workflows',
                  isSelected: _selectedIndex == 5,
                  onTap: () {
                    setState(() => _selectedIndex = 5);
                    context.go('/workflows');
                  },
                ),
                _buildNavItem(
                  icon: Icons.analytics,
                  title: 'Rapports',
                  isSelected: _selectedIndex == 6,
                  onTap: () {
                    setState(() => _selectedIndex = 6);
                    context.go('/reports');
                  },
                ),
                const Divider(),
                _buildNavItem(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  isSelected: _selectedIndex == 7,
                  onTap: () {
                    setState(() => _selectedIndex = 7);
                    context.go('/settings');
                  },
                ),
                _buildNavItem(
                  icon: Icons.help,
                  title: 'Aide',
                  isSelected: _selectedIndex == 8,
                  onTap: () {
                    setState(() => _selectedIndex = 8);
                    context.go('/help');
                  },
                ),
              ],
            ),
          ),

          // Bouton de déconnexion
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              text: 'Déconnexion',
              onPressed: () {
                // TODO: Implémenter la déconnexion
                context.go('/login');
              },
              type: ButtonType.outline,
              icon: Icons.logout,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/projects');
            break;
          case 2:
            context.go('/tasks');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Projets'),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tâches'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}

// Contenu du dashboard
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // Section des statistiques
          StatsSection(),

          // Autres sections à ajouter...
        ],
      ),
    );
  }
}

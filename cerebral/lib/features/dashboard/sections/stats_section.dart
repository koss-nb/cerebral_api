import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../../../theme/app_theme.dart';

class StatsSection extends StatelessWidget {
  final VoidCallback? onProjectsTap;
  final VoidCallback? onTasksTap;
  final VoidCallback? onBudgetTap;
  final VoidCallback? onPersonnelTap;

  const StatsSection({
    super.key,
    this.onProjectsTap,
    this.onTasksTap,
    this.onBudgetTap,
    this.onPersonnelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue d\'ensemble',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Grille de statistiques
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Projets actifs',
                value: '12',
                icon: Icons.business,
                iconColor: AppTheme.primaryColor,
                onTap: onProjectsTap,
              ),
              StatCard(
                title: 'Tâches en cours',
                value: '34',
                icon: Icons.task,
                iconColor: AppTheme.secondaryColor,
                onTap: onTasksTap,
              ),
              StatCard(
                title: 'Budget total',
                value: '2.5M €',
                icon: Icons.account_balance_wallet,
                iconColor: AppTheme.accentColor,
                onTap: onBudgetTap,
              ),
              StatCard(
                title: 'Équipe',
                value: '28',
                icon: Icons.people,
                iconColor: AppTheme.infoColor,
                onTap: onPersonnelTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

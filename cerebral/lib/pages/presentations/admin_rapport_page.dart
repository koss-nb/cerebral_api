import 'package:flutter/material.dart';

class AdminRapportPage extends StatefulWidget {
  const AdminRapportPage({super.key});

  @override
  State<AdminRapportPage> createState() => _AdminRapportPageState();
}

class _AdminRapportPageState extends State<AdminRapportPage> {
  String _selectedPeriod = 'Ce mois';
  String _selectedProject = 'Tous les projets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2549B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rapports & Analyses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white, size: 22),
            onPressed: () => _downloadReport(),
            tooltip: 'Télécharger',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 22),
            onPressed: () => _shareReport(),
            tooltip: 'Partager',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtres de période et projet
            _buildFilters(),
            const SizedBox(height: 20),

            // Résumé des indicateurs clés
            _buildKPISection(),
            const SizedBox(height: 20),

            // Graphiques et analyses
            _buildChartsSection(),
            const SizedBox(height: 20),

            // Tableau des projets
            _buildProjectsTable(),
            const SizedBox(height: 20),

            // Rapports détaillés
            _buildDetailedReports(),
            const SizedBox(height: 20),

            // Actions recommandées
            _buildRecommendedActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Section des filtres
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Filtre Période
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Période',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C757D),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedPeriod,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    ['Ce mois', 'Ce trimestre', 'Cette année', 'Personnalisé']
                        .map(
                          (period) => DropdownMenuItem(
                            value: period,
                            child: Text(
                              period,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriod = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filtre Projet
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Projet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C757D),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedProject,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    [
                          'Tous les projets',
                          'Résidence Soleil',
                          'Les Jardins',
                          'Villa Moderne',
                        ]
                        .map(
                          (project) => DropdownMenuItem(
                            value: project,
                            child: Text(
                              project,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProject = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section des indicateurs clés (KPIs)
  Widget _buildKPISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Indicateurs Clés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4, // Augmenté pour éviter l'overflow
          children: [
            _buildKPICard(
              'Projets Actifs',
              '4',
              '+1 vs mois dernier',
              Icons.business,
              const Color(0xFFE3F2FD),
              const Color(0xFF1976D2),
            ),
            _buildKPICard(
              'Budget Utilisé',
              '87%',
              '6.8M€ / 8.2M€',
              Icons.euro,
              const Color(0xFFFFF3E0),
              const Color(0xFFFF9800),
            ),
            _buildKPICard(
              'Avancement Moyen',
              '68%',
              '+5% vs mois dernier',
              Icons.trending_up,
              const Color(0xFFE8F5E8),
              const Color(0xFF4CAF50),
            ),
            _buildKPICard(
              'Personnel Actif',
              '45',
              'Sur 68 total',
              Icons.people,
              const Color(0xFFF3E5F5),
              const Color(0xFF9C27B0),
            ),
          ],
        ),
      ],
    );
  }

  // Carte KPI
  Widget _buildKPICard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Évite l'overflow
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20, // Réduit pour éviter l'overflow
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13, // Réduit pour éviter l'overflow
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
            overflow: TextOverflow.ellipsis, // Gère le texte trop long
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11, // Réduit pour éviter l'overflow
              color: Color(0xFF6C757D),
            ),
            overflow: TextOverflow.ellipsis, // Gère le texte trop long
            maxLines: 2, // Limite à 2 lignes
          ),
        ],
      ),
    );
  }

  // Section des graphiques
  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Analyses & Graphiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140, // Réduit pour éviter l'overflow
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildChartCard(
                'Évolution Budget',
                'Consommation mensuelle',
                Icons.show_chart,
                const Color(0xFFE3F2FD),
                width:
                    MediaQuery.of(context).size.width *
                    0.75, // Réduit la largeur
              ),
              const SizedBox(width: 12),
              _buildChartCard(
                'Répartition Métiers',
                'Par spécialité',
                Icons.pie_chart,
                const Color(0xFFE8F5E8),
                width:
                    MediaQuery.of(context).size.width *
                    0.75, // Réduit la largeur
              ),
              const SizedBox(width: 12),
              _buildChartCard(
                'Projets par Statut',
                'Répartition globale',
                Icons.stacked_bar_chart,
                const Color(0xFFFFF3E0),
                width:
                    MediaQuery.of(context).size.width *
                    0.75, // Réduit la largeur
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Carte de graphique corrigée
  Widget _buildChartCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor, {
    double? width,
  }) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // garde la colonne compacte
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF6C757D), size: 20),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.fullscreen, size: 20),
                onPressed: () => _showFullChart(title),
                color: const Color(0xFF6C757D),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF23272F),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6C757D)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Graphique simulé dans un Flexible pour éviter l'overflow
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Graphique',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tableau des projets
  Widget _buildProjectsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Détail par Projet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTableHeader(),
              _buildTableRow(
                'Résidence Soleil',
                '75%',
                '2.4M€',
                '3',
                'En retard',
              ),
              _buildTableRow('Les Jardins', '45%', '1.8M€', '1', 'Bloqué'),
              _buildTableRow('Villa Moderne', '90%', '0.6M€', '0', 'À jour'),
              _buildTableRow(
                'Projet Horizon',
                '5%',
                '3.4M€',
                '-',
                'Planification',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // En-tête du tableau
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Projet',
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Avancement',
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Budget',
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Retards',
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Statut',
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Ligne du tableau
  Widget _buildTableRow(
    String project,
    String progress,
    String budget,
    String delays,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              project,
              style: const TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                fontWeight: FontWeight.w500,
                color: Color(0xFF23272F),
              ),
              overflow: TextOverflow.ellipsis, // Gère le texte trop long
            ),
          ),
          Expanded(
            child: Text(
              progress,
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                color: _getProgressColor(progress),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Gère le texte trop long
            ),
          ),
          Expanded(
            child: Text(
              budget,
              style: const TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                color: Color(0xFF23272F),
              ),
              overflow: TextOverflow.ellipsis, // Gère le texte trop long
            ),
          ),
          Expanded(
            child: Text(
              delays,
              style: TextStyle(
                fontSize: 12, // Réduit pour éviter l'overflow
                color: delays == '-' ? Colors.grey : const Color(0xFF23272F),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Gère le texte trop long
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11, // Réduit pour éviter l'overflow
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(status),
                ),
                overflow: TextOverflow.ellipsis, // Gère le texte trop long
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Couleur du statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'En retard':
        return const Color(0xFFD32F2F);
      case 'Bloqué':
        return const Color(0xFFF57C00);
      case 'À jour':
        return const Color(0xFF388E3C);
      case 'Planification':
        return const Color(0xFF616161);
      default:
        return Colors.grey;
    }
  }

  // Couleur de progression
  Color _getProgressColor(String progress) {
    final percent = int.tryParse(progress.replaceAll('%', '')) ?? 0;
    if (percent >= 80) return const Color(0xFF388E3C);
    if (percent >= 50) return const Color(0xFFF57C00);
    return const Color(0xFFD32F2F);
  }

  // Section des rapports détaillés
  Widget _buildDetailedReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Rapports Détaillés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildReportCard(
          'Rapport Financier',
          'Analyse détaillée des coûts et budgets',
          Icons.account_balance_wallet,
          const Color(0xFFE3F2FD),
        ),
        const SizedBox(height: 8),
        _buildReportCard(
          'Rapport RH',
          'Effectifs, compétences et charge de travail',
          Icons.people,
          const Color(0xFFE8F5E8),
        ),
        const SizedBox(height: 8),
        _buildReportCard(
          'Rapport Qualité',
          'Contrôles, retours et améliorations',
          Icons.verified,
          const Color(0xFFFFF3E0),
        ),
      ],
    );
  }

  // Carte de rapport
  Widget _buildReportCard(
    String title,
    String description,
    IconData icon,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C757D), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Évite l'overflow
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14, // Réduit pour éviter l'overflow
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                  overflow: TextOverflow.ellipsis, // Gère le texte trop long
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12, // Réduit pour éviter l'overflow
                    color: Color(0xFF6C757D),
                  ),
                  overflow: TextOverflow.ellipsis, // Gère le texte trop long
                  maxLines: 2, // Limite à 2 lignes
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: () => _openReport(title),
            color: const Color(0xFF6C757D),
            padding: EdgeInsets.zero, // Réduit le padding
            constraints:
                const BoxConstraints(), // Supprime les contraintes par défaut
          ),
        ],
      ),
    );
  }

  // Section des actions recommandées
  Widget _buildRecommendedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Actions Recommandées',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          'Optimiser le budget',
          'Réduire les coûts de 15% sur le projet Les Jardins',
          Icons.trending_down,
          const Color(0xFFFFF3E0),
          'Urgent',
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          'Renforcer l\'équipe',
          'Ajouter 2 électriciens pour le projet Résidence Soleil',
          Icons.person_add,
          const Color(0xFFE8F5E8),
          'Important',
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          'Accélérer les livraisons',
          'Réduire les délais de 20% sur Villa Moderne',
          Icons.speed,
          const Color(0xFFE3F2FD),
          'Normal',
        ),
      ],
    );
  }

  // Carte d'action
  Widget _buildActionCard(
    String title,
    String description,
    IconData icon,
    Color bgColor,
    String priority,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C757D), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Évite l'overflow
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14, // Réduit pour éviter l'overflow
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF23272F),
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Gère le texte trop long
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 11, // Réduit pour éviter l'overflow
                          fontWeight: FontWeight.w500,
                          color: _getPriorityColor(priority),
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Gère le texte trop long
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12, // Réduit pour éviter l'overflow
                    color: Color(0xFF6C757D),
                  ),
                  overflow: TextOverflow.ellipsis, // Gère le texte trop long
                  maxLines: 2, // Limite à 2 lignes
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Couleur de priorité
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return const Color(0xFFD32F2F);
      case 'Important':
        return const Color(0xFFF57C00);
      case 'Normal':
        return const Color(0xFF1976D2);
      default:
        return Colors.grey;
    }
  }

  // Méthodes utilitaires
  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du rapport en cours...'),
        backgroundColor: Color(0xFF2549B2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage du rapport...'),
        backgroundColor: Color(0xFF2549B2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showFullChart(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Affichage du graphique: $title'),
        backgroundColor: const Color(0xFF2549B2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _openReport(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture du rapport: $title'),
        backgroundColor: const Color(0xFF2549B2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

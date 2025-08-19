import 'package:flutter/material.dart';

class Screen7 extends StatefulWidget {
  final Map<String, dynamic>? personnelData;

  const Screen7({super.key, this.personnelData});

  @override
  State<Screen7> createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
  int _selectedTabIndex = 0; // 0: Contrat, 1: Pointage, 2: Financier

  // Données du personnel
  Map<String, dynamic>? _personnelData;

  @override
  void initState() {
    super.initState();
    _personnelData = widget.personnelData;

    print('🔍 Screen7 - Données reçues: $_personnelData');
    if (_personnelData != null) {
      print('🔍 Screen7 - Clés disponibles: ${_personnelData!.keys.toList()}');
      print('🔍 Screen7 - first_name: "${_personnelData!['first_name']}"');
      print('🔍 Screen7 - last_name: "${_personnelData!['last_name']}"');
      print('🔍 Screen7 - email: "${_personnelData!['email']}"');
      print('🔍 Screen7 - position: "${_personnelData!['position']}"');
    }

    // Si aucune donnée n'est fournie, utiliser des données de test
    _personnelData ??= {
      'id': 1,
      'first_name': 'Jean',
      'last_name': 'Dupont',
      'email': 'jean.dupont@cerebral.com',
      'phone': '06 12 34 56 78',
      'position': 'Électricien',
      'department': 'Électricité',
      'status': 'Actif',
      'contract_type': 'CDI',
      'hire_date': '2024-01-15',
      'salary': 2500.0,
      'address': '123 Rue de la Paix, 75001 Paris',
    };
  }

  // Obtenir les initiales du personnel
  String _getInitials() {
    final firstName = _getFirstName();
    final lastName = _getLastName();

    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

    return '$firstInitial$lastInitial';
  }

  // Obtenir le nom complet du personnel
  String _getFullName() {
    final firstName = _getFirstName();
    final lastName = _getLastName();

    return '${firstName} ${lastName}'.trim();
  }

  // Obtenir le prénom avec la nouvelle structure API
  String _getFirstName() {
    final personalInfo =
        _personnelData?['personal_info'] as Map<String, dynamic>?;
    return personalInfo?['first_name']?.toString().trim() ?? '';
  }

  // Obtenir le nom de famille avec la nouvelle structure API
  String _getLastName() {
    final personalInfo =
        _personnelData?['personal_info'] as Map<String, dynamic>?;
    return personalInfo?['last_name']?.toString().trim() ?? '';
  }

  // Obtenir l'affichage du type de contrat
  String _getContractTypeDisplay() {
    final professionalInfo =
        _personnelData?['professional_info'] as Map<String, dynamic>?;
    final contractType =
        professionalInfo?['contract_type'] as Map<String, dynamic>?;
    return contractType?['label']?.toString() ?? 'Non défini';
  }

  // Formater une date
  String _formatDate(dynamic dateValue) {
    if (dateValue == null || dateValue.toString().isEmpty) {
      return 'Non définie';
    }

    try {
      final date = DateTime.parse(dateValue.toString());
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateValue.toString();
    }
  }

  // Obtenir l'affichage du statut
  String _getStatusDisplay() {
    final statusInfo = _personnelData?['status'] as Map<String, dynamic>?;
    return statusInfo?['label']?.toString() ?? 'Non défini';
  }

  // Obtenir la couleur du statut
  Color _getStatusColor() {
    final statusInfo = _personnelData?['status'] as Map<String, dynamic>?;
    final color = statusInfo?['color']?.toString() ?? 'gray';
    switch (color) {
      case 'green':
        return const Color(0xFFE8F5E8);
      case 'red':
        return const Color(0xFFFFEBEE);
      case 'orange':
        return const Color(0xFFFFF3E0);
      case 'gray':
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  // Obtenir la couleur du texte du statut
  Color _getStatusTextColor() {
    final statusInfo = _personnelData?['status'] as Map<String, dynamic>?;
    final color = statusInfo?['color']?.toString() ?? 'gray';
    switch (color) {
      case 'green':
        return const Color(0xFF2E7D32);
      case 'red':
        return const Color(0xFFD32F2F);
      case 'orange':
        return const Color(0xFFF57C00);
      case 'gray':
      default:
        return const Color(0xFF6C757D);
    }
  }

  // Obtenir l'affichage du contact d'urgence
  String _getEmergencyContactDisplay() {
    final emergencyContact = _personnelData?['emergency_contact'];
    if (emergencyContact == null) return 'Non défini';

    if (emergencyContact is Map) {
      final name = emergencyContact['name']?.toString() ?? '';
      final phone = emergencyContact['phone']?.toString() ?? '';
      final relationship = emergencyContact['relationship']?.toString() ?? '';

      final parts = <String>[];
      if (name.isNotEmpty) parts.add(name);
      if (phone.isNotEmpty) parts.add(phone);
      if (relationship.isNotEmpty) parts.add('($relationship)');

      return parts.isEmpty ? 'Non défini' : parts.join(' - ');
    }

    return emergencyContact.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // En-tête bleu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(color: Color(0xFF2549B2)),
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
                // Avatar et informations
                Expanded(
                  child: Row(
                    children: [
                      // Avatar circulaire
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1976D2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Nom et profession
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getFullName(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _personnelData?['position'] ?? 'Non défini',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Icônes de contact
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Onglets de navigation
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    // Onglet Contrat
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _selectedTabIndex == 0
                                    ? const Color(0xFF2549B2)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Contrat',
                              style: TextStyle(
                                color: _selectedTabIndex == 0
                                    ? const Color(0xFF2549B2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedTabIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Onglet Pointage
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _selectedTabIndex == 1
                                    ? const Color(0xFF2549B2)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Pointage',
                              style: TextStyle(
                                color: _selectedTabIndex == 1
                                    ? const Color(0xFF2549B2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedTabIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Onglet Financier
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 2;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _selectedTabIndex == 2
                                    ? const Color(0xFF2549B2)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Financier',
                              style: TextStyle(
                                color: _selectedTabIndex == 2
                                    ? const Color(0xFF2549B2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedTabIndex == 2
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenu principal avec scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),

      // Boutons d'action en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Bouton Modifier
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Modifier',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2549B2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Bouton Imprimer
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
              ),
              child: const Icon(
                Icons.print,
                color: Color(0xFF23272F),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire le contenu selon l'onglet sélectionné
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildContractTab();
      case 1:
        return _buildTimeTrackingTab();
      case 2:
        return _buildFinancialTab();
      default:
        return _buildContractTab();
    }
  }

  // Onglet Contrat
  Widget _buildContractTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Informations générales
        Container(
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
              const Text(
                'Informations générales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoRow('Nom complet', _getFullName()),
              const SizedBox(height: 16),
              _buildInfoRow(
                  'Corps de métier',
                  (_personnelData?['professional_info']
                              as Map<String, dynamic>?)?['position']
                          ?.toString() ??
                      'Non défini'),
              const SizedBox(height: 16),
              _buildInfoRow(
                'Type de contrat',
                _getContractTypeDisplay(),
                hasTag: true,
                tagColor: const Color(0xFFE8F5E8),
                tagTextColor: const Color(0xFF2E7D32),
              ),
              const SizedBox(height: 16),
                              _buildInfoRow(
                    'Date d\'embauche',
                    _formatDate((_personnelData?['professional_info'] as Map<String, dynamic>?)?['hire_date'])),
              const SizedBox(height: 16),
                              _buildInfoRow('Salaire horaire',
                    (_personnelData?['compensation'] as Map<String, dynamic>?)?['salary']?['formatted']?.toString() ?? 'Non défini'),
              const SizedBox(height: 16),
              _buildInfoRow(
                'Statut',
                _getStatusDisplay(),
                hasTag: true,
                tagColor: _getStatusColor(),
                tagTextColor: _getStatusTextColor(),
              ),
                              if ((_personnelData?['professional_info'] as Map<String, dynamic>?)?['employee_id'] != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'ID Employé',
                      (_personnelData?['professional_info'] as Map<String, dynamic>?)?['employee_id']?.toString() ?? 'Non défini'),
                ],
                              if ((_personnelData?['professional_info'] as Map<String, dynamic>?)?['department'] != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'Département',
                      (_personnelData?['professional_info'] as Map<String, dynamic>?)?['department']?.toString() ?? 'Non défini'),
                ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Section Contact
        Container(
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
              const Text(
                'Contact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              _buildContactRow(
                  Icons.phone,
                  'Téléphone',
                  (_personnelData?['personal_info'] as Map<String, dynamic>?)?['phone']?.toString() ?? 'Non défini'),
              const SizedBox(height: 16),
              _buildContactRow(
                  Icons.email,
                  'Email',
                  (_personnelData?['personal_info'] as Map<String, dynamic>?)?['email']?.toString() ?? 'Non défini'),
              const SizedBox(height: 16),
              if (_personnelData?['address'] != null &&
                  _personnelData!['address'].toString().isNotEmpty) ...[
                _buildContactRow(
                  Icons.location_on,
                  'Adresse',
                  _personnelData?['address'] ?? 'Non définie',
                ),
                const SizedBox(height: 16),
              ],
              if (_personnelData?['emergency_contact'] != null) ...[
                _buildContactRow(
                  Icons.emergency,
                  'Contact d\'urgence',
                  _getEmergencyContactDisplay(),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Section Documents
        Container(
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
              const Text(
                'Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              _buildDocumentRow('Contrat de travail'),
              const SizedBox(height: 16),
              _buildDocumentRow('Certificat médical'),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // Onglet Pointage (Time Tracking)
  Widget _buildTimeTrackingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec titre et bouton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mars 2024',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF23272F),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.access_time, color: Colors.white),
              label: const Text(
                'Pointer aujourd\'hui',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Calendrier
        Container(
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
            children: [
              // Jours de la semaine
              Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        'L',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'J',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'V',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'D',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Grille du calendrier
              _buildCalendarGrid(),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Résumé du mois
        Container(
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
              const Text(
                'Résumé du mois',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      '18',
                      'Jours présents',
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryItem(
                      '1',
                      'Jours absents',
                      const Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryItem(
                      '144h',
                      'Heures travaillées',
                      const Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // Onglet Financier
  Widget _buildFinancialTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carte Situation financière
        Container(
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
              const Text(
                'Situation financière',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              _buildFinancialRow(
                'Heures travaillées (Mars)',
                '144h',
                const Color(0xFF1976D2),
              ),
              const SizedBox(height: 16),
              _buildFinancialRow(
                'Salaire brut calculé',
                '2,664€',
                const Color(0xFF23272F),
              ),
              const SizedBox(height: 16),
              _buildFinancialRow(
                'Avances versées',
                '-800€',
                const Color(0xFFF44336),
              ),
              const SizedBox(height: 16),
              _buildFinancialRow(
                'Solde restant',
                '1,864€',
                const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Carte Historique des avances
        Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Historique des avances',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23272F),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Ajouter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2549B2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAdvanceRow('Avance sur salaire', '15/03/2024', '-500€'),
              const SizedBox(height: 16),
              _buildAdvanceRow('Avance exceptionnelle', '08/03/2024', '-300€'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Carte Récapitulatif de paie
        Container(
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
              const Text(
                'Récapitulatif de paie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(height: 20),
              _buildPayRow('Salaire de base', '2,664€'),
              const SizedBox(height: 16),
              _buildPayRow('Heures supplémentaires', '148€'),
              const SizedBox(height: 16),
              _buildPayRow('Prime de chantier', '100€'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total brut',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const Text(
                      '2,912€',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2549B2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // Construction de la grille du calendrier
  Widget _buildCalendarGrid() {
    // Définition des jours avec leurs statuts
    final List<Map<String, dynamic>> days = [
      // Semaine 1
      {'day': 1, 'status': 'present'},
      {'day': 2, 'status': 'empty'},
      {'day': 3, 'status': 'empty'},
      {'day': 4, 'status': 'present'},
      {'day': 5, 'status': 'present'},
      {'day': 6, 'status': 'present'},
      {'day': 7, 'status': 'present'},
      // Semaine 2
      {'day': 8, 'status': 'present'},
      {'day': 9, 'status': 'empty'},
      {'day': 10, 'status': 'empty'},
      {'day': 11, 'status': 'present'},
      {'day': 12, 'status': 'present'},
      {'day': 13, 'status': 'absent'},
      {'day': 14, 'status': 'present'},
      // Semaine 3
      {'day': 15, 'status': 'present'},
      {'day': 16, 'status': 'empty'},
      {'day': 17, 'status': 'empty'},
      {'day': 18, 'status': 'present'},
      {'day': 19, 'status': 'present'},
      {'day': 20, 'status': 'present'},
      {'day': 21, 'status': 'present'},
      // Semaine 4
      {'day': 22, 'status': 'present'},
      {'day': 23, 'status': 'empty'},
      {'day': 24, 'status': 'empty'},
      {'day': 25, 'status': 'present'},
      {'day': 26, 'status': 'present'},
      {'day': 27, 'status': 'current'},
      {'day': 28, 'status': 'empty'},
      // Semaine 5
      {'day': 29, 'status': 'empty'},
      {'day': 30, 'status': 'empty'},
      {'day': 31, 'status': 'empty'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return _buildCalendarDay(day['day'] as int, day['status'] as String);
      },
    );
  }

  // Construction d'un jour du calendrier
  Widget _buildCalendarDay(int day, String status) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (status) {
      case 'present':
        backgroundColor = const Color(0xFFE8F5E8);
        textColor = const Color(0xFF2E7D32);
        borderColor = const Color(0xFF4CAF50);
        break;
      case 'absent':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        borderColor = const Color(0xFFF44336);
        break;
      case 'current':
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        borderColor = const Color(0xFF1976D2);
        break;
      default:
        backgroundColor = Colors.white;
        textColor = const Color(0xFF6C757D);
        borderColor = const Color(0xFFE9ECEF);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Construction d'un élément de résumé
  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool hasTag = false,
    Color? tagColor,
    Color? tagTextColor,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6C757D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (hasTag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: tagTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF23272F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C757D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF23272F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(String documentName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          // Icône PDF rouge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color(0xFFD32F2F),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Nom du document
          Expanded(
            child: Text(
              documentName,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF23272F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Bouton de téléchargement
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.download,
              color: Color(0xFF1976D2),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Construction d'une ligne financière
  Widget _buildFinancialRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // Construction d'une ligne d'avance
  Widget _buildAdvanceRow(String label, String date, String amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          // Icône d'avance
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFFF44336),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Informations de l'avance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF23272F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Montant
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF44336),
            ),
          ),
        ],
      ),
    );
  }

  // Construction d'une ligne de paie
  Widget _buildPayRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF23272F),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

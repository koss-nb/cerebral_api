import 'package:cerebral/pages/presentations/sceen7.dart';
import 'package:cerebral/pages/presentations/screen13.dart';
import 'package:flutter/material.dart';
import 'package:cerebral/core/services/personnel_service.dart';

class PersonnelManagementPage extends StatefulWidget {
  const PersonnelManagementPage({super.key});

  @override
  State<PersonnelManagementPage> createState() =>
      _PersonnelManagementPageState();
}

class _PersonnelManagementPageState extends State<PersonnelManagementPage> {
  int _selectedTabIndex = 0; // 0: Tous, 1: Actifs, 2: Inactifs

  // Service
  final PersonnelService _personnelService = PersonnelService();

  // États
  bool _isLoading = true;
  List<dynamic>? _personnel;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  // Charger le personnel
  Future<void> _loadPersonnel() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _personnelService.getPersonnel();

      print('🔍 Données reçues de l\'API personnel: $data');
      print('🔍 Clés disponibles: ${data.keys.toList()}');

      if (data['data'] != null) {
        print('🔍 Données dans "data": ${data['data']}');
        if (data['data'] is List && data['data'].isNotEmpty) {
          print('🔍 Premier personnel: ${data['data'][0]}');
          print(
              '🔍 Clés du premier personnel: ${data['data'][0].keys.toList()}');
        }
      }

      if (mounted) {
        setState(() {
          if (data['data'] != null) {
            _personnel = List<dynamic>.from(data['data']);
          } else if (data['personnel'] != null) {
            _personnel = List<dynamic>.from(data['personnel']);
          } else {
            _personnel = [];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Obtenir le personnel filtré selon l'onglet sélectionné
  List<dynamic> get _filteredPersonnel {
    if (_personnel == null) return [];

    switch (_selectedTabIndex) {
      case 0: // Tous
        return _personnel!;
      case 1: // Actifs
        return _personnel!.where((p) => p['status'] == 'active').toList();
      case 2: // Inactifs
        return _personnel!.where((p) => p['status'] == 'inactive').toList();
      default:
        return _personnel!;
    }
  }

  // Obtenir les statistiques
  Map<String, int> get _statistics {
    if (_personnel == null)
      return {'total': 0, 'active': 0, 'inactive': 0, 'on_leave': 0};

    return {
      'total': _personnel!.length,
      'active': _personnel!.where((p) => p['status'] == 'active').length,
      'inactive': _personnel!.where((p) => p['status'] == 'inactive').length,
      'on_leave': _personnel!.where((p) => p['status'] == 'on_leave').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Bouton retour
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF23272F),
                      size: 24,
                    ),
                  ),
                  // Titre central
                  const Expanded(
                    child: Text(
                      'Gestion Personnel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                  ),
                  // Icônes droite
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: _loadPersonnel,
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Onglets de filtre
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Onglet "Tous"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 0
                              ? const Color(0xFFE3F2FD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Tous (${_statistics['total']})',
                            style: TextStyle(
                              color: _selectedTabIndex == 0
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              fontWeight: _selectedTabIndex == 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Onglet "Actifs"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 1
                              ? const Color(0xFFE3F2FD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Actifs (${_statistics['active']})',
                            style: TextStyle(
                              color: _selectedTabIndex == 1
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              fontWeight: _selectedTabIndex == 1
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Onglet "Inactifs"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 2
                              ? const Color(0xFFE3F2FD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Inactifs (${_statistics['inactive']})',
                            style: TextStyle(
                              color: _selectedTabIndex == 2
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              fontWeight: _selectedTabIndex == 2
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Liste du personnel
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Erreur: $_errorMessage',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadPersonnel,
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        )
                      : _filteredPersonnel.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun personnel trouvé',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6C757D),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                itemCount: _filteredPersonnel.length,
                                itemBuilder: (context, index) {
                                  final person = _filteredPersonnel[index];
                                  return Column(
                                    children: [
                                      _buildPersonnelCard(person),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                            ),
            ),

            const SizedBox(height: 24),

            // Section de résumé
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
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
                  // Personnel actif
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_statistics['active']}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Personnel actif',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6C757D),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // En congé
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_statistics['on_leave']}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'En congé',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6C757D),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Total
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_statistics['total']}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6C757D),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bouton d'action flottant (FAB)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Screen13()),
            ).then((_) {
              // Recharger la liste après création
              _loadPersonnel();
            });
          },
          backgroundColor: const Color(0xFF2549B2),
          heroTag: "personnel_fab",
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildPersonnelCard(Map<String, dynamic> person) {
    print('🔍 Construction carte pour: $person');
    print('🔍 Clés disponibles: ${person.keys.toList()}');

    // Extraire les données de la nouvelle structure API
    final personalInfo = person['personal_info'] as Map<String, dynamic>? ?? {};
    final professionalInfo =
        person['professional_info'] as Map<String, dynamic>? ?? {};
    final compensation = person['compensation'] as Map<String, dynamic>? ?? {};
    final statusInfo = person['status'] as Map<String, dynamic>? ?? {};

    final firstName = personalInfo['first_name']?.toString() ?? '';
    final lastName = personalInfo['last_name']?.toString() ?? '';
    final email = personalInfo['email']?.toString() ?? '';
    final phone = personalInfo['phone']?.toString() ?? '';

    final position =
        professionalInfo['position']?.toString() ?? 'Poste non défini';
    final department =
        professionalInfo['department']?.toString() ?? 'Département non défini';
    final employeeId = professionalInfo['employee_id']?.toString() ?? '';
    final hireDate = professionalInfo['hire_date']?.toString() ?? '';

    final contractType =
        professionalInfo['contract_type']?['label']?.toString() ?? 'CDI';
    final status = statusInfo['label']?.toString() ?? 'unknown';

    final salary = compensation['salary']?['formatted']?.toString() ?? '';

    print('🔍 firstName: "$firstName"');
    print('🔍 lastName: "$lastName"');
    print('🔍 email: "$email"');
    print('🔍 position: "$position"');

    // Utiliser les initiales fournies par l'API ou les générer
    final initials = personalInfo['initials']?.toString() ??
        '${firstName.isNotEmpty ? firstName[0].toUpperCase() : ''}${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}';

    // Déterminer les couleurs selon le statut
    Color statusColor;
    String statusText;
    bool isActive;

    switch (status.toString().toLowerCase()) {
      case 'active':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Actif';
        isActive = true;
        break;
      case 'inactive':
        statusColor = const Color(0xFF6C757D);
        statusText = 'Inactif';
        isActive = false;
        break;
      case 'on_leave':
        statusColor = const Color(0xFFFF9800);
        statusText = 'En congé';
        isActive = false;
        break;
      case 'terminated':
        statusColor = const Color(0xFFF44336);
        statusText = 'Terminé';
        isActive = false;
        break;
      default:
        statusColor = const Color(0xFF6C757D);
        statusText = 'Inconnu';
        isActive = false;
    }

    // Formater la date d'embauche
    String formattedHireDate = 'Date inconnue';
    if (hireDate.isNotEmpty) {
      try {
        final date = DateTime.parse(hireDate);
        formattedHireDate = 'Embauché: ${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedHireDate = 'Date: $hireDate';
      }
    }

    // Couleur de l'avatar basée sur le département
    Color avatarColor = _getDepartmentColor(department);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Screen7(personnelData: person),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar avec initiales
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials.isNotEmpty ? initials : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Informations du personnel
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${firstName.trim()} ${lastName.trim()}'.trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23272F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$position • $contractType',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6C757D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    department,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 12,
                          color: Color(0xFF6C757D),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6C757D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    formattedHireDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C757D),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Flèche vers la droite
            const Icon(Icons.chevron_right, color: Color(0xFF6C757D), size: 24),
          ],
        ),
      ),
    );
  }

  // Obtenir la couleur du département
  Color _getDepartmentColor(String department) {
    switch (department.toLowerCase()) {
      case 'direction':
        return const Color(0xFF1976D2);
      case 'supervision':
        return const Color(0xFF4CAF50);
      case 'construction':
        return const Color(0xFFFF9800);
      case 'technique':
        return const Color(0xFF9C27B0);
      case 'général':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF6C757D);
    }
  }
}

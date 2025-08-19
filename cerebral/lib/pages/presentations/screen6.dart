import 'package:flutter/material.dart';
import 'package:cerebral/core/services/personnel_service.dart';

class Screen6 extends StatefulWidget {
  const Screen6({super.key});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  final PersonnelService _personnelService = PersonnelService();

  // États
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _personnel = [];

  // Filtres
  String _selectedStatus = '';
  String _selectedDepartment = '';
  String _selectedPosition = '';
  String _selectedContractType = '';
  String _searchQuery = '';

  // Contrôleurs
  final TextEditingController _searchController = TextEditingController();

  // Pagination
  final int _perPage = 15;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Charger le personnel
  Future<void> _loadPersonnel({bool refresh = false}) async {
    try {
      if (refresh) {
        _hasMoreData = true;
      }

      if (!_hasMoreData && !refresh) return;

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _personnelService.getPersonnel(
        status: _selectedStatus.isEmpty ? null : _selectedStatus,
        department: _selectedDepartment.isEmpty ? null : _selectedDepartment,
        position: _selectedPosition.isEmpty ? null : _selectedPosition,
        contractType:
            _selectedContractType.isEmpty ? null : _selectedContractType,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        perPage: _perPage,
      );

      if (mounted) {
        setState(() {
          if (refresh) {
            _personnel = List<dynamic>.from(response['data'] ?? []);
          } else {
            _personnel.addAll(List<dynamic>.from(response['data'] ?? []));
          }

          _hasMoreData = (response['data'] ?? []).length >= _perPage;
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

  // Rechercher
  void _performSearch() {
    _searchQuery = _searchController.text.trim();
    _loadPersonnel(refresh: true);
  }

  // Appliquer les filtres
  void _applyFilters() {
    _loadPersonnel(refresh: true);
  }

  // Réinitialiser les filtres
  void _resetFilters() {
    setState(() {
      _selectedStatus = '';
      _selectedDepartment = '';
      _selectedPosition = '';
      _selectedContractType = '';
      _searchQuery = '';
      _searchController.clear();
    });
    _loadPersonnel(refresh: true);
  }

  // Naviguer vers les détails
  void _navigateToDetails(dynamic person) {
    Navigator.pushNamed(
      context,
      '/personnel-details',
      arguments: person,
    );
  }

  // Naviguer vers la création
  void _navigateToCreate() {
    Navigator.pushNamed(context, '/create-personnel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            _buildHeader(),

            // Barre de recherche et filtres
            _buildSearchAndFilters(),

            // Contenu principal
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  // En-tête
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Gestion du Personnel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  // Barre de recherche et filtres
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un membre du personnel...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6C757D)),
                suffixIcon: IconButton(
                  onPressed: _performSearch,
                  icon:
                      const Icon(Icons.arrow_forward, color: Color(0xFF1E3A8A)),
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),

          const SizedBox(height: 16),

          // Filtres
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Statut',
                  value: _selectedStatus,
                  items: const [
                    '',
                    'Actif',
                    'Inactif',
                    'En congé',
                    'En formation'
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? '';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Département',
                  value: _selectedDepartment,
                  items: const [
                    '',
                    'Construction',
                    'Électricité',
                    'Plomberie',
                    'Finitions'
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value ?? '';
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Poste',
                  value: _selectedPosition,
                  items: const [
                    '',
                    'Électricien',
                    'Plombier',
                    'Maçon',
                    'Superviseur'
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPosition = value ?? '';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Contrat',
                  value: _selectedContractType,
                  items: const ['', 'CDI', 'CDD', 'Intérim', 'Stage'],
                  onChanged: (value) {
                    setState(() {
                      _selectedContractType = value ?? '';
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bouton appliquer les filtres
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Appliquer les filtres',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contenu principal
  Widget _buildContent() {
    if (_isLoading && _personnel.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
        ),
      );
    }

    if (_errorMessage != null && _personnel.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadPersonnel(refresh: true),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_personnel.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, color: Color(0xFF6C757D), size: 64),
            SizedBox(height: 16),
            Text(
              'Aucun membre du personnel trouvé',
              style: TextStyle(fontSize: 18, color: Color(0xFF6C757D)),
            ),
            SizedBox(height: 8),
            Text(
              'Essayez de modifier vos filtres ou créez un nouveau membre',
              style: TextStyle(color: Color(0xFF6C757D)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadPersonnel(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _personnel.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _personnel.length) {
            return _buildLoadMoreButton();
          }

          final person = _personnel[index];
          return _buildPersonnelCard(person);
        },
      ),
    );
  }

  // Carte du personnel
  Widget _buildPersonnelCard(dynamic person) {
    final firstName = person['first_name'] ?? '';
    final lastName = person['last_name'] ?? '';
    final position = person['position'] ?? 'Non défini';
    final status = person['status'] ?? 'Non défini';
    final contractType = person['contract_type'] ?? 'Non défini';
    final email = person['email'] ?? '';
    final phone = person['phone'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetails(person),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      position,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusChip(status),
                        const SizedBox(width: 8),
                        _buildContractChip(contractType),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (email.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.email,
                              size: 16, color: Color(0xFF6C757D)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              email,
                              style: const TextStyle(color: Color(0xFF6C757D)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 16, color: Color(0xFF6C757D)),
                          const SizedBox(width: 4),
                          Text(
                            phone,
                            style: const TextStyle(color: Color(0xFF6C757D)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Bouton d'action
              IconButton(
                onPressed: () => _navigateToDetails(person),
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF6C757D)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bouton charger plus
  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  _loadPersonnel();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Charger plus',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  // Filtre dropdown
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF23272F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: InputBorder.none,
            ),
            hint: Text('Tous'),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item.isEmpty ? 'Tous' : item),
              );
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Chip de statut
  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'actif':
        color = const Color(0xFF4CAF50);
        break;
      case 'inactif':
        color = const Color(0xFFF44336);
        break;
      case 'en congé':
        color = const Color(0xFFFF9800);
        break;
      case 'en formation':
        color = const Color(0xFF2196F3);
        break;
      default:
        color = const Color(0xFF6C757D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Chip de contrat
  Widget _buildContractChip(String contractType) {
    Color color;
    switch (contractType.toLowerCase()) {
      case 'cdi':
        color = const Color(0xFF4CAF50);
        break;
      case 'cdd':
        color = const Color(0xFFFF9800);
        break;
      case 'intérim':
        color = const Color(0xFF2196F3);
        break;
      case 'stage':
        color = const Color(0xFF9C27B0);
        break;
      default:
        color = const Color(0xFF6C757D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        contractType,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Couleur du statut
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'actif':
        return const Color(0xFF4CAF50);
      case 'inactif':
        return const Color(0xFFF44336);
      case 'en congé':
        return const Color(0xFFFF9800);
      case 'en formation':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF6C757D);
    }
  }
}

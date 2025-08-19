import 'package:flutter/material.dart';
import 'package:cerebral_flutter_api/cerebral_api.dart';

/// Exemple d'utilisation rapide du package CEREBRAL Flutter API
class ExampleUsage extends StatefulWidget {
  const ExampleUsage({super.key});

  @override
  State<ExampleUsage> createState() => _ExampleUsageState();
}

class _ExampleUsageState extends State<ExampleUsage> {
  final ApiService _apiService = ApiService();
  List<Project> _projects = [];
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Connexion automatique avec un compte de test
      await _apiService.login('admin@cerebral.com', 'password123');

      // Récupération des projets
      final projects = await _apiService.getProjects();

      // Récupération des tâches
      final tasks = await _apiService.getTasks();

      setState(() {
        _projects = projects;
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _testClockIn() async {
    try {
      if (_projects.isNotEmpty) {
        final result = await _apiService.clockIn(
          userId: 1,
          projectId: _projects.first.id,
          location: 'Villa A3',
          notes: 'Test pointage via Flutter',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pointage réussi: ${result['clock_in']}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur pointage: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testCreateIssue() async {
    try {
      if (_projects.isNotEmpty) {
        final result = await _apiService.createIssue(
          title: 'Test problème Flutter',
          description: 'Problème créé depuis l\'application Flutter',
          priority: 'medium',
          type: 'technical',
          projectId: _projects.first.id,
          location: 'Villa A3',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Problème créé: ${result['title']}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur création problème: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEREBRAL API - Exemple d\'utilisation'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildContentWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.construction,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'CEREBRAL API',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Package Flutter fonctionnel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions de test
          const Text(
            'Actions de test',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _testClockIn,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Test Pointage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _testCreateIssue,
                  icon: const Icon(Icons.warning),
                  label: const Text('Test Problème'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Statistiques
          const Text(
            'Statistiques',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Projets',
                  _projects.length.toString(),
                  Icons.business,
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Tâches',
                  _tasks.length.toString(),
                  Icons.checklist,
                  const Color(0xFF1976D2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Liste des projets
          const Text(
            'Projets récents',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ..._projects.take(3).map((project) => _buildProjectCard(project)),

          const SizedBox(height: 32),

          // Liste des tâches
          const Text(
            'Tâches récentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ..._tasks.take(3).map((task) => _buildTaskCard(task)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Color(int.parse(project.statusColor.replaceAll('#', '0xFF'))),
          child: Text(
            project.name[0],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(project.name),
        subtitle: Text(project.location),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                Color(int.parse(project.statusColor.replaceAll('#', '0xFF'))),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            project.status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Color(int.parse(task.priorityColor.replaceAll('#', '0xFF'))),
          child: Icon(
            Icons.checklist,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(int.parse(task.statusColor.replaceAll('#', '0xFF'))),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

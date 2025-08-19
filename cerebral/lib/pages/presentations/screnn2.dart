import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int _selectedViewIndex = 0; // 0 pour Liste, 1 pour Kanban

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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF23272F),
                      size: 24,
                    ),
                  ),
                  // Titre central
                  const Expanded(
                    child: Text(
                      'Gestion des Tâches',
                      textAlign: TextAlign.center,
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
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF23272F),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sélecteur de vue (Segmented Control)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Bouton Liste (sélectionné)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedViewIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedViewIndex == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _selectedViewIndex == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted,
                              color: _selectedViewIndex == 0
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Liste',
                              style: TextStyle(
                                color: _selectedViewIndex == 0
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedViewIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bouton Kanban (non sélectionné)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedViewIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedViewIndex == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _selectedViewIndex == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: _selectedViewIndex == 1
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF6C757D),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kanban',
                              style: TextStyle(
                                color: _selectedViewIndex == 1
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF6C757D),
                                fontWeight: _selectedViewIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filtres (Dropdowns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Filtre Projet
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9ECEF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Résidence Soleil',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF23272F),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF6C757D),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filtre Villa (sélectionné)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF1976D2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Toutes villas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contenu principal - Vue Kanban
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colonne "En attente"
                    _buildTaskColumn('En attente', const Color(0xFF6C757D), 2, [
                      _buildTaskCard(
                        'Inspection sécurité',
                        'Villa Moderne • Finitions',
                        'Sophie Blanc',
                        'Lundi',
                        'Urgent',
                        const Color(0xFFF44336),
                      ),
                      _buildTaskCard(
                        'Contrôle fondations',
                        'Les Jardins • Gros œuvre',
                        'Marc Dubois',
                        'Mardi',
                        'Normal',
                        const Color(0xFFFF9800),
                      ),
                    ]),

                    const SizedBox(width: 20),

                    // Colonne "En cours" (partiellement visible)
                    _buildTaskColumn('En cours', const Color(0xFF1976D2), 3, [
                      _buildTaskCard(
                        'Validation',
                        'Villa A3 • Électricité',
                        'Jean Dupont',
                        'Aujourd\'hui',
                        'Urgent',
                        const Color(0xFFF44336),
                        hasAttachments: true,
                        attachmentCount: 2,
                      ),
                      _buildTaskCard(
                        'Contrôle',
                        'Apt B12 • Plomberie',
                        'Marie Martin',
                        'Demain',
                        'Normal',
                        const Color(0xFFFF9800),
                        hasComments: true,
                        commentCount: 3,
                      ),
                    ]),

                    const SizedBox(width: 20),

                    // Colonne "En attente de validation"
                    _buildTaskColumn(
                      'En attente de validation',
                      const Color(0xFFFF9800),
                      1,
                      [
                        _buildTaskCard(
                          'Validation finale',
                          'Villa C1 • Finitions',
                          'Pierre Durand',
                          'Mercredi',
                          'Normal',
                          const Color(0xFFFF9800),
                        ),
                      ],
                    ),

                    const SizedBox(width: 20),

                    // Colonne "Terminé"
                    _buildTaskColumn('Terminé', const Color(0xFF4CAF50), 0, []),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bouton d'action flottant (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1976D2),
        heroTag: "task_fab",
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Colonne de tâches
  Widget _buildTaskColumn(
    String title,
    Color color,
    int taskCount,
    List<Widget> tasks,
  ) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de colonne
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23272F),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  taskCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tâches
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: task,
            ),
          ),
        ],
      ),
    );
  }

  // Carte de tâche
  Widget _buildTaskCard(
    String title,
    String subtitle,
    String assignee,
    String dueDate,
    String priority,
    Color priorityColor, {
    bool hasAttachments = false,
    int attachmentCount = 0,
    bool hasComments = false,
    int commentCount = 0,
  }) {
    return Container(
      width: double.infinity,
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
        children: [
          // Titre et priorité
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23272F),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Sous-titre
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
          ),

          const SizedBox(height: 12),

          // Assigné
          Row(
            children: [
              const Icon(Icons.person, color: Color(0xFF6C757D), size: 16),
              const SizedBox(width: 8),
              Text(
                assignee,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Date d'échéance
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF6C757D),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                dueDate,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
              ),
            ],
          ),

          // Pièces jointes ou commentaires
          if (hasAttachments) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  color: Color(0xFF6C757D),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '$attachmentCount p',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ],

          if (hasComments) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.chat_bubble,
                  color: Color(0xFF6C757D),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  commentCount.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

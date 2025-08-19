import 'package:cerebral/classes/audioclasse.dart';
import 'package:flutter/material.dart';

class CompleteTaskRapport extends StatefulWidget {
  const CompleteTaskRapport({super.key});

  @override
  State<CompleteTaskRapport> createState() => _CompleteTaskRapportState();
}

class _CompleteTaskRapportState extends State<CompleteTaskRapport> {
  // Contrôleurs pour les champs de saisie
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  // Variables de sélection
  String _selectedStatus = 'Terminé';
  String _selectedProject = '';
  String _selectedUnit = '';
  final String _selectedStep = '';
  final String _selectedPriority = 'Normale';
  String _selectedQuality = 'Conforme';

  // Listes de sélection
  final List<String> _availableStatuses = [
    'Terminé',
    'En cours',
    'En attente',
    'Bloqué',
    'Annulé',
  ];

  final List<String> _availableProjects = [
    'Résidence Soleil',
    'Les Jardins',
    'Villa Moderne',
    'Projet Horizon',
  ];

  final List<String> _availableUnits = [
    'Villa A1',
    'Villa A2',
    'Villa A3',
    'Apt B1',
    'Apt B2',
  ];

  final List<String> _availableSteps = [
    'Acquisition',
    'Fondations',
    'Gros œuvre',
    'Électricité',
    'Plomberie',
    'Finitions',
  ];

  final List<String> _availablePriorities = ['Faible', 'Normale', 'Urgente'];

  final List<String> _availableQualities = [
    'Conforme',
    'Non conforme',
    'À vérifier',
  ];

  // États des checkboxes
  bool _hasPhotos = true;
  bool _hasIssues = false;
  bool _needsFollowUp = false;
  bool _materialsUsed = true;
  bool _safetyCompliant = true;

  // Photos prises
  int _photosCount = 3;

  // États pour les messages audio
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _hasAudioMessage = false;
  int _recordingDuration = 0;
  int _currentPlaybackPosition = 0;
  final List<AudioMessage> _audioMessages = [];

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    _observationsController.dispose();
    _materialsController.dispose();
    _hoursController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  // Démarrer l'enregistrement audio
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });

    // Simuler l'enregistrement avec un timer
    _recordingTimer();
  }

  // Arrêter l'enregistrement audio
  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _hasAudioMessage = true;
    });

    // Créer un nouveau message audio
    final newMessage = AudioMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Message audio ${_audioMessages.length + 1}',
      duration: _recordingDuration,
      timestamp: DateTime.now(),
    );

    setState(() {
      _audioMessages.add(newMessage);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message audio enregistré !'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  // Timer pour simuler l'enregistrement
  void _recordingTimer() {
    if (_isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isRecording) {
          setState(() {
            _recordingDuration++;
          });
          _recordingTimer();
        }
      });
    }
  }

  // Jouer un message audio
  void _playAudio(String messageId) {
    setState(() {
      _isPlaying = true;
      _currentPlaybackPosition = 0;
    });

    // Simuler la lecture audio
    _playbackTimer(messageId);
  }

  // Arrêter la lecture audio
  void _stopAudio() {
    setState(() {
      _isPlaying = false;
      _currentPlaybackPosition = 0;
    });
  }

  // Timer pour simuler la lecture audio
  void _playbackTimer(String messageId) {
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlaying) {
          setState(() {
            _currentPlaybackPosition++;
          });

          // Arrêter automatiquement après la durée du message
          final message = _audioMessages.firstWhere((m) => m.id == messageId);
          if (_currentPlaybackPosition >= message.duration) {
            _stopAudio();
          } else {
            _playbackTimer(messageId);
          }
        }
      });
    }
  }

  // Supprimer un message audio
  void _deleteAudioMessage(String messageId) {
    setState(() {
      _audioMessages.removeWhere((message) => message.id == messageId);
      _hasAudioMessage = _audioMessages.isNotEmpty;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message audio supprimé !'),
        backgroundColor: Color(0xFFF44336),
      ),
    );
  }

  // Formater la durée en mm:ss
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // En-tête bleu avec navigation

          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.only(
          //     top: 20,
          //     left: 20,
          //     right: 20,
          //     bottom: 20,
          //   ),
          //   decoration: const BoxDecoration(
          //     color: Color(0xFF1976D2),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(20),
          //       bottomRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       // Bouton retour
          //       IconButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         icon: const Icon(
          //           Icons.arrow_back,
          //           color: Colors.white,
          //           size: 24,
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       // Titre
          //       const Expanded(
          //         child: Text(
          //           'Rapport de Travail',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       // Bouton fermer
          //       IconButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         icon: const Icon(Icons.close, color: Colors.white, size: 24),
          //       ),
          //     ],
          //   ),
          // ),

          // Contenu principal avec scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Section Informations de base
                  _buildSectionCard(
                    title: 'Informations de base',
                    children: [
                      _buildInputField(
                        label: 'Titre de la tâche *',
                        controller: _taskTitleController,
                        placeholder: 'Ex: Installation électrique Villa A3',
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      _buildDropdownField(
                        label: 'Statut du travail *',
                        value: _selectedStatus,
                        hint: 'Sélectionner le statut',
                        items: _availableStatuses,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value ?? 'Terminé';
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildDropdownField(
                        label: 'Projet',
                        value: _selectedProject,
                        hint: 'Sélectionner un projet',
                        items: _availableProjects,
                        onChanged: (value) {
                          setState(() {
                            _selectedProject = value ?? '';
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      _buildDropdownField(
                        label: 'Unité',
                        value: _selectedUnit,
                        hint: 'Sélectionner une unité',
                        items: _availableUnits,
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value ?? '';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Messages audio
                  _buildSectionCard(
                    title: 'Messages audio',
                    children: [
                      const Text(
                        'Enregistrez des messages audio pour compléter votre rapport',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contrôles d'enregistrement
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isRecording
                                ? const Color(0xFFF44336)
                                : const Color(0xFFE9ECEF),
                            width: _isRecording ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Bouton d'enregistrement
                                GestureDetector(
                                  onTap: _isRecording
                                      ? _stopRecording
                                      : _startRecording,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: _isRecording
                                          ? const Color(0xFFF44336)
                                          : const Color(0xFF1976D2),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (_isRecording
                                                      ? const Color(0xFFF44336)
                                                      : const Color(0xFF1976D2))
                                                  .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isRecording ? Icons.stop : Icons.mic,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Affichage de la durée
                                Column(
                                  children: [
                                    Text(
                                      _isRecording
                                          ? _formatDuration(_recordingDuration)
                                          : '00:00',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _isRecording
                                            ? const Color(0xFFF44336)
                                            : const Color(0xFF23272F),
                                      ),
                                    ),
                                    Text(
                                      _isRecording
                                          ? 'Enregistrement...'
                                          : 'Prêt à enregistrer',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _isRecording
                                            ? const Color(0xFFF44336)
                                            : const Color(0xFF6C757D),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (_isRecording) ...[
                              const SizedBox(height: 16),
                              const LinearProgressIndicator(
                                backgroundColor: Color(0xFFE0E0E0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFF44336),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Liste des messages audio
                      if (_audioMessages.isNotEmpty) ...[
                        const Text(
                          'Messages enregistrés :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF23272F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._audioMessages.map(
                          (message) => _buildAudioMessageCard(message),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Description et observations
                  _buildSectionCard(
                    title: 'Description et observations',
                    children: [
                      _buildInputField(
                        label: 'Description du travail effectué *',
                        controller: _descriptionController,
                        placeholder: 'Décrivez en détail le travail réalisé...',
                        isRequired: true,
                        isMultiline: true,
                      ),

                      const SizedBox(height: 20),

                      _buildInputField(
                        label: 'Observations particulières',
                        controller: _observationsController,
                        placeholder: 'Observations, problèmes rencontrés...',
                        isRequired: false,
                        isMultiline: true,
                      ),

                      const SizedBox(height: 20),

                      _buildInputField(
                        label: 'Matériaux utilisés',
                        controller: _materialsController,
                        placeholder: 'Liste des matériaux et quantités',
                        isRequired: false,
                        isMultiline: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Temps et qualité
                  _buildSectionCard(
                    title: 'Temps et qualité',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Heures travaillées',
                              controller: _hoursController,
                              placeholder: '0',
                              isRequired: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Qualité du travail',
                              value: _selectedQuality,
                              hint: 'Sélectionner la qualité',
                              items: _availableQualities,
                              onChanged: (value) {
                                setState(() {
                                  _selectedQuality = value ?? 'Conforme';
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Photos prises
                      Row(
                        children: [
                          const Text(
                            'Photos prises',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF23272F),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_photosCount > 0) _photosCount--;
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: const Color(0xFF1976D2),
                          ),
                          Text(
                            '$_photosCount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _photosCount++;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: const Color(0xFF1976D2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Aperçu des photos
                      if (_photosCount > 0)
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE9ECEF)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              _photosCount,
                              (index) => Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF1976D2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: Color(0xFF1976D2),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Vérifications
                  _buildSectionCard(
                    title: 'Vérifications',
                    children: [
                      _buildCheckboxTile(
                        'Photos prises et jointes',
                        _hasPhotos,
                        (value) {
                          setState(() {
                            _hasPhotos = value ?? false;
                          });
                        },
                      ),

                      _buildCheckboxTile('Problèmes signalés', _hasIssues, (
                        value,
                      ) {
                        setState(() {
                          _hasIssues = value ?? false;
                        });
                      }),

                      _buildCheckboxTile('Suivi requis', _needsFollowUp, (
                        value,
                      ) {
                        setState(() {
                          _needsFollowUp = value ?? false;
                        });
                      }),

                      _buildCheckboxTile(
                        'Matériaux utilisés documentés',
                        _materialsUsed,
                        (value) {
                          setState(() {
                            _materialsUsed = value ?? false;
                          });
                        },
                      ),

                      _buildCheckboxTile(
                        'Conformité sécurité respectée',
                        _safetyCompliant,
                        (value) {
                          setState(() {
                            _safetyCompliant = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Commentaires
                  _buildSectionCard(
                    title: 'Commentaires additionnels',
                    children: [
                      _buildInputField(
                        label: 'Commentaires',
                        controller: _commentsController,
                        placeholder: 'Commentaires, suggestions, remarques...',
                        isRequired: false,
                        isMultiline: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Boutons d'action en bas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Bouton Brouillon
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveDraft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFFE9ECEF),
                          width: 1,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.save,
                      color: Color(0xFF23272F),
                      size: 20,
                    ),
                    label: const Text(
                      'Brouillon',
                      style: TextStyle(
                        color: Color(0xFF23272F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Bouton Envoyer rapport
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    label: const Text(
                      'Envoyer rapport',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Carte de message audio
  Widget _buildAudioMessageCard(AudioMessage message) {
    final isCurrentlyPlaying = _isPlaying && _currentPlaybackPosition > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icône audio
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.audiotrack,
                  color: Color(0xFF1976D2),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Informations du message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF23272F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(message.duration)} • ${_formatTimestamp(message.timestamp)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ],
                ),
              ),
              // Boutons de contrôle
              Row(
                children: [
                  // Bouton play/pause
                  IconButton(
                    onPressed: () {
                      if (isCurrentlyPlaying) {
                        _stopAudio();
                      } else {
                        _playAudio(message.id);
                      }
                    },
                    icon: Icon(
                      isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFF1976D2),
                      size: 24,
                    ),
                  ),
                  // Bouton supprimer
                  IconButton(
                    onPressed: () => _deleteAudioMessage(message.id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFF44336),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Barre de progression pour la lecture
          if (isCurrentlyPlaying) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _currentPlaybackPosition / message.duration,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1976D2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Formater le timestamp
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Carte de section
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF23272F),
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // Champ de saisie
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isRequired,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF23272F),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFADB5BD),
                fontSize: 16,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          ),
        ),
      ],
    );
  }

  // Champ dropdown
  Widget _buildDropdownField({
    required String label,
    required String value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
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
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF23272F),
                size: 20,
              ),
            ),
            hint: Text(hint),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Color(0xFF23272F)),
          ),
        ),
      ],
    );
  }

  // Checkbox
  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      contentPadding: EdgeInsets.zero,
    );
  }

  // Sauvegarder en brouillon
  void _saveDraft() {
    print('Sauvegarde du rapport en brouillon...');
    print('Messages audio: ${_audioMessages.length}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rapport sauvegardé en brouillon !'),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }

  // Envoyer le rapport
  void _submitReport() {
    print('Envoi du rapport de travail...');
    print('Titre: ${_taskTitleController.text}');
    print('Statut: $_selectedStatus');
    print('Projet: $_selectedProject');
    print('Unité: $_selectedUnit');
    print('Heures: ${_hoursController.text}');
    print('Qualité: $_selectedQuality');
    print('Photos: $_photosCount');
    print('Messages audio: ${_audioMessages.length}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rapport envoyé avec succès !'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );

    // Retour à la page précédente après envoi
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}

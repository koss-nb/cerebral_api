// Classe pour représenter un message audio
class AudioMessage {
  final String id;
  final String title;
  final int duration;
  final DateTime timestamp;
  final bool isUploaded;

  AudioMessage({
    required this.id,
    required this.title,
    required this.duration,
    required this.timestamp,
    this.isUploaded = false,
  });
}

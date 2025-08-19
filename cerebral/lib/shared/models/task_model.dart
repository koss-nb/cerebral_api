import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String projectId;
  final String? assignedToId;
  final String createdById;
  final DateTime dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final bool isActive;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    this.assignedToId,
    required this.createdById,
    required this.dueDate,
    this.completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.tags = const [],
    this.metadata = const {},
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Getters
  bool get isCompleted => status == TaskStatus.completed;
  bool get isOverdue => !isCompleted && DateTime.now().isAfter(dueDate);
  bool get isDueToday => !isCompleted && DateTime.now().difference(dueDate).inDays == 0;
  bool get isDueSoon => !isCompleted && DateTime.now().difference(dueDate).inDays <= 3;
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
  double get progressPercentage {
    switch (status) {
      case TaskStatus.notStarted:
        return 0.0;
      case TaskStatus.inProgress:
        return 50.0;
      case TaskStatus.review:
        return 80.0;
      case TaskStatus.completed:
        return 100.0;
      default:
        return 0.0;
    }
  }

  // Méthodes
  bool canUserAccess(String userId, List<String> userPermissions) {
    return assignedToId == userId || 
           createdById == userId || 
           userPermissions.contains('view_tasks');
  }

  bool canUserEdit(String userId, List<String> userPermissions) {
    return assignedToId == userId || 
           createdById == userId || 
           userPermissions.contains('edit_tasks');
  }

  // Copie avec modifications
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? projectId,
    String? assignedToId,
    String? createdById,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    bool? isActive,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      assignedToId: assignedToId ?? this.assignedToId,
      createdById: createdById ?? this.createdById,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
    );
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'projectId': projectId,
      'assignedToId': assignedToId,
      'createdById': createdById,
      'dueDate': dueDate.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'metadata': metadata,
      'isActive': isActive,
    };
  }

  // Création depuis JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      projectId: json['projectId'] as String,
      assignedToId: json['assignedToId'] as String?,
      createdById: json['createdById'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, priority: $priority)';
  }
}

// Statuts de tâche
class TaskStatus {
  static const String notStarted = 'not_started';
  static const String inProgress = 'in_progress';
  static const String review = 'review';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [notStarted, inProgress, review, completed, cancelled];
}

// Priorités de tâche
class TaskPriority {
  static const String low = 'low';
  static const String medium = 'medium';
  static const String high = 'high';
  static const String urgent = 'urgent';

  static const List<String> all = [low, medium, high, urgent];
}

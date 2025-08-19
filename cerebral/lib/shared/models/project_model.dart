import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String status;
  final String type;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? estimatedEndDate;
  final double budget;
  final double spentAmount;
  final String location;
  final String? address;
  final List<String> tags;
  final String managerId;
  final List<String> teamMemberIds;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Project({
    String? id,
    required this.name,
    required this.description,
    required this.status,
    required this.type,
    required this.startDate,
    this.endDate,
    this.estimatedEndDate,
    required this.budget,
    this.spentAmount = 0.0,
    required this.location,
    this.address,
    this.tags = const [],
    required this.managerId,
    this.teamMemberIds = const [],
    this.metadata = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Getters
  double get remainingBudget => budget - spentAmount;
  double get progressPercentage => endDate != null ? 100.0 : 0.0;
  bool get isOverBudget => spentAmount > budget;
  bool get isDelayed => estimatedEndDate != null && DateTime.now().isAfter(estimatedEndDate!);
  int get durationInDays => DateTime.now().difference(startDate).inDays;

  // Méthodes
  bool isTeamMember(String userId) {
    return teamMemberIds.contains(userId);
  }

  bool canUserAccess(String userId, List<String> userPermissions) {
    return managerId == userId || 
           isTeamMember(userId) || 
           userPermissions.contains('view_projects');
  }

  // Copie avec modifications
  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? estimatedEndDate,
    double? budget,
    double? spentAmount,
    String? location,
    String? address,
    List<String>? tags,
    String? managerId,
    List<String>? teamMemberIds,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      estimatedEndDate: estimatedEndDate ?? this.estimatedEndDate,
      budget: budget ?? this.budget,
      spentAmount: spentAmount ?? this.spentAmount,
      location: location ?? this.location,
      address: address ?? this.address,
      tags: tags ?? this.tags,
      managerId: managerId ?? this.managerId,
      teamMemberIds: teamMemberIds ?? this.teamMemberIds,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'estimatedEndDate': estimatedEndDate?.toIso8601String(),
      'budget': budget,
      'spentAmount': spentAmount,
      'location': location,
      'address': address,
      'tags': tags,
      'managerId': managerId,
      'teamMemberIds': teamMemberIds,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Création depuis JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      estimatedEndDate: json['estimatedEndDate'] != null ? DateTime.parse(json['estimatedEndDate'] as String) : null,
      budget: (json['budget'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String,
      address: json['address'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      managerId: json['managerId'] as String,
      teamMemberIds: List<String>.from(json['teamMemberIds'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, status: $status, type: $type)';
  }
}

// Statuts de projet
class ProjectStatus {
  static const String planning = 'planning';
  static const String active = 'active';
  static const String onHold = 'on_hold';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [planning, active, onHold, completed, cancelled];
}

// Types de projet
class ProjectType {
  static const String residential = 'residential';
  static const String commercial = 'commercial';
  static const String industrial = 'industrial';
  static const String infrastructure = 'infrastructure';
  static const String renovation = 'renovation';

  static const List<String> all = [residential, commercial, industrial, infrastructure, renovation];
}

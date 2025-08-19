class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final int projectId;
  final int assignedTo;
  final int createdBy;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final double? estimatedHours;
  final double? actualHours;
  final String? location;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    required this.assignedTo,
    required this.createdBy,
    this.dueDate,
    this.completedAt,
    this.estimatedHours,
    this.actualHours,
    this.location,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      projectId: json['project_id'],
      assignedTo: json['assigned_to'],
      createdBy: json['created_by'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      estimatedHours: json['estimated_hours'] != null ? double.parse(json['estimated_hours'].toString()) : null,
      actualHours: json['actual_hours'] != null ? double.parse(json['actual_hours'].toString()) : null,
      location: json['location'],
      category: json['category'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'project_id': projectId,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'due_date': dueDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'estimated_hours': estimatedHours,
      'actual_hours': actualHours,
      'location': location,
      'category': category,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;
  
  bool get isUrgent => priority == 'urgent';
  bool get isHigh => priority == 'high';
  bool get isNormal => priority == 'normal';
  bool get isLow => priority == 'low';
  
  String get priorityColor {
    switch (priority) {
      case 'urgent':
        return '#F44336';
      case 'high':
        return '#FF9800';
      case 'normal':
        return '#2196F3';
      case 'low':
        return '#4CAF50';
      default:
        return '#9E9E9E';
    }
  }
  
  String get statusColor {
    switch (status) {
      case 'completed':
        return '#4CAF50';
      case 'in_progress':
        return '#FF9800';
      case 'pending':
        return '#2196F3';
      case 'cancelled':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }
}

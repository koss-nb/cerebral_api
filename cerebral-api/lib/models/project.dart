class Project {
  final int id;
  final String name;
  final String description;
  final String type;
  final String status;
  final double budget;
  final String currency;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String location;
  final int managerId;
  final DateTime startDate;
  final DateTime endDate;
  final double progress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.budget,
    required this.currency,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.location,
    required this.managerId,
    required this.startDate,
    required this.endDate,
    required this.progress,
    this.createdAt,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      budget: double.parse(json['budget'].toString()),
      currency: json['currency'],
      clientName: json['client_name'],
      clientEmail: json['client_email'],
      clientPhone: json['client_phone'],
      location: json['location'],
      managerId: json['manager_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      progress: double.parse(json['progress'].toString()),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'status': status,
      'budget': budget,
      'currency': currency,
      'client_name': clientName,
      'client_email': clientEmail,
      'client_phone': clientPhone,
      'location': location,
      'manager_id': managerId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'progress': progress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isOnHold => status == 'on_hold';
  bool get isCancelled => status == 'cancelled';
  
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  bool get isOverdue => daysRemaining < 0;
  
  String get statusColor {
    switch (status) {
      case 'active':
        return '#4CAF50';
      case 'completed':
        return '#2196F3';
      case 'on_hold':
        return '#FF9800';
      case 'cancelled':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }
}

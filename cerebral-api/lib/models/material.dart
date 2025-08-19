class Material {
  final int id;
  final String name;
  final String description;
  final String category;
  final String unit;
  final int currentStock;
  final int minimumStock;
  final int maximumStock;
  final double unitPrice;
  final String? supplier;
  final String? location;
  final String status;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Material({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    required this.currentStock,
    required this.minimumStock,
    required this.maximumStock,
    required this.unitPrice,
    this.supplier,
    this.location,
    required this.status,
    this.lastUpdated,
    this.createdAt,
    this.updatedAt,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      unit: json['unit'],
      currentStock: json['current_stock'],
      minimumStock: json['minimum_stock'],
      maximumStock: json['maximum_stock'],
      unitPrice: double.parse(json['unit_price'].toString()),
      supplier: json['supplier'],
      location: json['location'],
      status: json['status'],
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'unit': unit,
      'current_stock': currentStock,
      'minimum_stock': minimumStock,
      'maximum_stock': maximumStock,
      'unit_price': unitPrice,
      'supplier': supplier,
      'location': location,
      'status': status,
      'last_updated': lastUpdated?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isLowStock => currentStock <= minimumStock;
  bool get isOutOfStock => currentStock == 0;
  bool get isOverstocked => currentStock > maximumStock;
  bool get isAvailable => currentStock > 0;
  
  double get stockPercentage => maximumStock > 0 ? (currentStock / maximumStock) * 100 : 0;
  double get totalValue => currentStock * unitPrice;
  
  String get stockStatus {
    if (isOutOfStock) return 'Rupture';
    if (isLowStock) return 'Stock faible';
    if (isOverstocked) return 'Surstock';
    return 'Normal';
  }
  
  String get stockStatusColor {
    if (isOutOfStock) return '#F44336';
    if (isLowStock) return '#FF9800';
    if (isOverstocked) return '#9C27B0';
    return '#4CAF50';
  }
}

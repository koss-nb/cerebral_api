class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final List<String> permissions;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.permissions,
    this.createdAt,
    this.lastLoginAt,
  });

  // Getters
  String get displayName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  String get fullName => '$firstName $lastName';

  // Vérification des permissions
  bool hasPermission(String permission) {
    return permissions.contains('all') || permissions.contains(permission);
  }

  bool hasAnyPermission(List<String> requiredPermissions) {
    return permissions.contains('all') ||
        requiredPermissions.any(
          (permission) => permissions.contains(permission),
        );
  }

  // Conversion en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'permissions': permissions,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  // Création depuis une Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.parse(map['lastLoginAt'])
          : null,
    );
  }

  // Copie avec modifications
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $displayName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Rôles prédéfinis
class UserRoles {
  static const String admin = 'admin';
  static const String manager = 'manager';
  static const String chef = 'chef';
  static const String technicien = 'technicien';
  static const String user = 'user';

  static const List<String> all = [admin, manager, chef, technicien, user];
}

// Permissions prédéfinies
class UserPermissions {
  // Gestion des projets
  static const String viewProjects = 'view_projects';
  static const String createProjects = 'create_projects';
  static const String editProjects = 'edit_projects';
  static const String deleteProjects = 'delete_projects';

  // Gestion du budget
  static const String viewBudget = 'view_budget';
  static const String editBudget = 'edit_budget';
  static const String approveBudget = 'approve_budget';

  // Gestion des tâches
  static const String viewTasks = 'view_tasks';
  static const String createTasks = 'create_tasks';
  static const String editTasks = 'edit_tasks';
  static const String deleteTasks = 'delete_tasks';
  static const String assignTasks = 'assign_tasks';

  // Gestion du personnel
  static const String viewPersonnel = 'view_personnel';
  static const String editPersonnel = 'edit_personnel';
  static const String managePersonnel = 'manage_personnel';

  // Gestion des workflows
  static const String viewWorkflows = 'view_workflows';
  static const String editWorkflows = 'edit_workflows';
  static const String manageWorkflows = 'manage_workflows';

  // Administration
  static const String viewReports = 'view_reports';
  static const String manageUsers = 'manage_users';
  static const String systemSettings = 'system_settings';

  // Permissions par rôle
  static Map<String, List<String>> rolePermissions = {
    UserRoles.admin: [
      viewProjects,
      createProjects,
      editProjects,
      deleteProjects,
      viewBudget,
      editBudget,
      approveBudget,
      viewTasks,
      createTasks,
      editTasks,
      deleteTasks,
      assignTasks,
      viewPersonnel,
      editPersonnel,
      managePersonnel,
      viewWorkflows,
      editWorkflows,
      manageWorkflows,
      viewReports,
      manageUsers,
      systemSettings,
    ],
    UserRoles.manager: [
      viewProjects,
      createProjects,
      editProjects,
      viewBudget,
      editBudget,
      viewTasks,
      createTasks,
      editTasks,
      assignTasks,
      viewPersonnel,
      editPersonnel,
      viewWorkflows,
      editWorkflows,
      viewReports,
    ],
    UserRoles.chef: [
      viewProjects,
      editProjects,
      viewBudget,
      viewTasks,
      createTasks,
      editTasks,
      assignTasks,
      viewPersonnel,
      viewWorkflows,
      editWorkflows,
    ],
    UserRoles.technicien: [
      viewProjects,
      viewTasks,
      editTasks,
      viewPersonnel,
      viewWorkflows,
    ],
    UserRoles.user: [viewProjects, viewTasks, viewPersonnel, viewWorkflows],
  };
}

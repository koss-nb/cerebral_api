import 'api_service.dart';

class PersonnelService {
  final ApiService _apiService = ApiService.instance;

  // Obtenir tous le personnel avec filtres, recherche, tri et pagination
  Future<Map<String, dynamic>> getPersonnel({
    String? status,
    String? department,
    String? position,
    String? contractType,
    int? managerId,
    String? searchQuery,
    String? sortBy = 'hire_date',
    String? sortOrder = 'desc',
    int? perPage = 15,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (status != null) {
        queryParams['status'] = status;
      }

      if (department != null) {
        queryParams['department'] = department;
      }

      if (position != null) {
        queryParams['position'] = position;
      }

      if (contractType != null) {
        queryParams['contract_type'] = contractType;
      }

      if (managerId != null) {
        queryParams['manager_id'] = managerId.toString();
      }

      if (searchQuery != null) {
        queryParams['search'] = searchQuery;
      }

      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }

      if (sortOrder != null) {
        queryParams['sort_order'] = sortOrder;
      }

      if (perPage != null) {
        queryParams['per_page'] = perPage.toString();
      }

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/personnel$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Créer un nouveau membre du personnel
  Future<Map<String, dynamic>> createPersonnel({
    required String firstName,
    required String lastName,
    required String email,
    String? employeeId,
    String? position,
    String? department,
    String? contractType,
    String? status,
    DateTime? hireDate,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    List<String>? languages,
    int? managerId,
    Map<String, dynamic>? emergencyContact,
    String? notes,
    int? createdBy,
  }) async {
    try {
      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      };

      if (employeeId != null) {
        data['employee_id'] = employeeId;
      }

      if (position != null) {
        data['position'] = position;
      }

      if (department != null) {
        data['department'] = department;
      }

      if (contractType != null) {
        data['contract_type'] = contractType;
      }

      if (status != null) {
        data['status'] = status;
      }

      if (hireDate != null) {
        data['hire_date'] = hireDate.toIso8601String();
      }

      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String();
      }

      if (phone != null) {
        data['phone'] = phone;
      }

      if (address != null) {
        data['address'] = address;
      }

      if (salary != null) {
        data['salary'] = salary;
      }

      if (skills != null) {
        data['skills'] = skills;
      }

      if (certifications != null) {
        data['certifications'] = certifications;
      }

      if (languages != null) {
        data['languages'] = languages;
      }

      if (managerId != null) {
        data['manager_id'] = managerId;
      }

      if (emergencyContact != null) {
        data['emergency_contact'] = emergencyContact;
      }

      if (notes != null) {
        data['notes'] = notes;
      }

      if (createdBy != null) {
        data['created_by'] = createdBy;
      }

      return await _apiService.post('/personnel', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un membre du personnel spécifique
  Future<Map<String, dynamic>> getPersonnelById(int personnelId) async {
    try {
      return await _apiService.get('/personnel/$personnelId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un membre du personnel
  Future<Map<String, dynamic>> updatePersonnel(
    int personnelId, {
    String? firstName,
    String? lastName,
    String? email,
    String? employeeId,
    String? position,
    String? department,
    String? contractType,
    String? status,
    DateTime? hireDate,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    List<String>? languages,
    int? managerId,
    String? emergencyContact,
    String? emergencyPhone,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (firstName != null) {
        data['first_name'] = firstName;
      }

      if (lastName != null) {
        data['last_name'] = lastName;
      }

      if (email != null) {
        data['email'] = email;
      }

      if (employeeId != null) {
        data['employee_id'] = employeeId;
      }

      if (position != null) {
        data['position'] = position;
      }

      if (department != null) {
        data['department'] = department;
      }

      if (contractType != null) {
        data['contract_type'] = contractType;
      }

      if (status != null) {
        data['status'] = status;
      }

      if (hireDate != null) {
        data['hire_date'] = hireDate.toIso8601String();
      }

      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String();
      }

      if (phone != null) {
        data['phone'] = phone;
      }

      if (address != null) {
        data['address'] = address;
      }

      if (salary != null) {
        data['salary'] = salary;
      }

      if (skills != null) {
        data['skills'] = skills;
      }

      if (certifications != null) {
        data['certifications'] = certifications;
      }

      if (languages != null) {
        data['languages'] = languages;
      }

      if (managerId != null) {
        data['manager_id'] = managerId;
      }

      if (emergencyContact != null) {
        data['emergency_contact'] = emergencyContact;
      }

      if (emergencyPhone != null) {
        data['emergency_phone'] = emergencyPhone;
      }

      if (notes != null) {
        data['notes'] = notes;
      }

      return await _apiService.put('/personnel/$personnelId', data);
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un membre du personnel
  Future<Map<String, dynamic>> deletePersonnel(int personnelId) async {
    try {
      return await _apiService.delete('/personnel/$personnelId');
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le statut du personnel
  Future<Map<String, dynamic>> updatePersonnelStatus(
    int personnelId, {
    required String status,
  }) async {
    try {
      final data = <String, dynamic>{
        'status': status,
      };

      return await _apiService.put('/personnel/$personnelId/status', data);
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour les compétences du personnel
  Future<Map<String, dynamic>> updatePersonnelSkills(
    int personnelId, {
    required List<String> skills,
  }) async {
    try {
      final data = <String, dynamic>{
        'skills': skills,
      };

      return await _apiService.put('/personnel/$personnelId/skills', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les compétences du personnel
  Future<Map<String, dynamic>> getPersonnelSkills(int personnelId) async {
    try {
      return await _apiService.get('/personnel/$personnelId/skills');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par département
  Future<Map<String, dynamic>> getPersonnelByDepartment(
      String department) async {
    try {
      return await _apiService.get('/personnel/department/$department');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques du personnel
  Future<Map<String, dynamic>> getPersonnelStats() async {
    try {
      return await _apiService.get('/personnel/stats');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir la hiérarchie du personnel
  Future<Map<String, dynamic>> getPersonnelHierarchy() async {
    try {
      return await _apiService.get('/personnel/hierarchy');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour filtrer le personnel

  // Obtenir le personnel par statut
  Future<Map<String, dynamic>> getPersonnelByStatus(String status,
      {int? perPage}) async {
    return await getPersonnel(status: status, perPage: perPage);
  }

  // Obtenir le personnel par département
  Future<Map<String, dynamic>> getPersonnelByDepartmentFilter(String department,
      {int? perPage}) async {
    return await getPersonnel(department: department, perPage: perPage);
  }

  // Obtenir le personnel par position
  Future<Map<String, dynamic>> getPersonnelByPosition(String position,
      {int? perPage}) async {
    return await getPersonnel(position: position, perPage: perPage);
  }

  // Obtenir le personnel par type de contrat
  Future<Map<String, dynamic>> getPersonnelByContractType(String contractType,
      {int? perPage}) async {
    return await getPersonnel(contractType: contractType, perPage: perPage);
  }

  // Obtenir le personnel par manager
  Future<Map<String, dynamic>> getPersonnelByManager(int managerId,
      {int? perPage}) async {
    return await getPersonnel(managerId: managerId, perPage: perPage);
  }

  // Rechercher du personnel
  Future<Map<String, dynamic>> searchPersonnel(String searchQuery,
      {int? perPage}) async {
    return await getPersonnel(searchQuery: searchQuery, perPage: perPage);
  }

  // Obtenir le personnel actif
  Future<Map<String, dynamic>> getActivePersonnel({int? perPage}) async {
    return await getPersonnel(status: 'active', perPage: perPage);
  }

  // Obtenir le personnel inactif
  Future<Map<String, dynamic>> getInactivePersonnel({int? perPage}) async {
    return await getPersonnel(status: 'inactive', perPage: perPage);
  }

  // Obtenir le personnel en congé
  Future<Map<String, dynamic>> getOnLeavePersonnel({int? perPage}) async {
    return await getPersonnel(status: 'on_leave', perPage: perPage);
  }

  // Obtenir le personnel licencié
  Future<Map<String, dynamic>> getTerminatedPersonnel({int? perPage}) async {
    return await getPersonnel(status: 'terminated', perPage: perPage);
  }

  // Obtenir le personnel par département spécifique
  Future<Map<String, dynamic>> getPersonnelBySpecificDepartment(
      String department,
      {int? perPage}) async {
    try {
      final departmentPersonnel = await getPersonnelByDepartment(department);

      if (departmentPersonnel['success'] == true) {
        return {
          'success': true,
          'data': departmentPersonnel['data'],
          'meta': {
            'department': department,
            'count': departmentPersonnel['meta']['count'],
            'per_page': perPage ?? 15,
          },
        };
      }

      return departmentPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par gamme de salaire
  Future<Map<String, dynamic>> getPersonnelBySalaryRange({
    double? minSalary,
    double? maxSalary,
    int? perPage,
  }) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final salaryRangePersonnel = personnel.where((person) {
          final salary = person['salary'] ?? 0.0;

          if (minSalary != null && salary < minSalary) {
            return false;
          }

          if (maxSalary != null && salary > maxSalary) {
            return false;
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': salaryRangePersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': salaryRangePersonnel.length,
            'total': salaryRangePersonnel.length,
            'min_salary': minSalary,
            'max_salary': maxSalary,
            'salary_range_count': salaryRangePersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par gamme d'âge
  Future<Map<String, dynamic>> getPersonnelByAgeRange({
    int? minAge,
    int? maxAge,
    int? perPage,
  }) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final ageRangePersonnel = personnel.where((person) {
          final dateOfBirth = person['date_of_birth'];
          if (dateOfBirth == null) return false;

          final birthDate = DateTime.parse(dateOfBirth);
          final now = DateTime.now();
          final age = now.year -
              birthDate.year -
              (now.isBefore(DateTime(now.year, birthDate.month, birthDate.day))
                  ? 1
                  : 0);

          if (minAge != null && age < minAge) {
            return false;
          }

          if (maxAge != null && age > maxAge) {
            return false;
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': ageRangePersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': ageRangePersonnel.length,
            'total': ageRangePersonnel.length,
            'min_age': minAge,
            'max_age': maxAge,
            'age_range_count': ageRangePersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par gamme d'ancienneté
  Future<Map<String, dynamic>> getPersonnelByTenureRange({
    int? minTenure,
    int? maxTenure,
    int? perPage,
  }) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final tenureRangePersonnel = personnel.where((person) {
          final hireDate = person['hire_date'];
          if (hireDate == null) return false;

          final startDate = DateTime.parse(hireDate);
          final now = DateTime.now();
          final tenureYears = now.difference(startDate).inDays / 365.25;

          if (minTenure != null && tenureYears < minTenure) {
            return false;
          }

          if (maxTenure != null && tenureYears > maxTenure) {
            return false;
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': tenureRangePersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': tenureRangePersonnel.length,
            'total': tenureRangePersonnel.length,
            'min_tenure': minTenure,
            'max_tenure': maxTenure,
            'tenure_range_count': tenureRangePersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par compétences
  Future<Map<String, dynamic>> getPersonnelBySkills(List<String> skills,
      {int? perPage}) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final skillsPersonnel = personnel.where((person) {
          final personSkills = person['skills'] ?? [];

          for (final skill in skills) {
            if (!personSkills.contains(skill)) {
              return false;
            }
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': skillsPersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': skillsPersonnel.length,
            'total': skillsPersonnel.length,
            'required_skills': skills,
            'skills_match_count': skillsPersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par langues
  Future<Map<String, dynamic>> getPersonnelByLanguages(List<String> languages,
      {int? perPage}) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final languagesPersonnel = personnel.where((person) {
          final personLanguages = person['languages'] ?? [];

          for (final language in languages) {
            if (!personLanguages.contains(language)) {
              return false;
            }
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': languagesPersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': languagesPersonnel.length,
            'total': languagesPersonnel.length,
            'required_languages': languages,
            'languages_match_count': languagesPersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par certifications
  Future<Map<String, dynamic>> getPersonnelByCertifications(
      List<String> certifications,
      {int? perPage}) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final certificationsPersonnel = personnel.where((person) {
          final personCertifications = person['certifications'] ?? [];

          for (final certification in certifications) {
            if (!personCertifications.contains(certification)) {
              return false;
            }
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': certificationsPersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': certificationsPersonnel.length,
            'total': certificationsPersonnel.length,
            'required_certifications': certifications,
            'certifications_match_count': certificationsPersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par période d'embauche
  Future<Map<String, dynamic>> getPersonnelByHirePeriod({
    DateTime? startDate,
    DateTime? endDate,
    int? perPage,
  }) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final hirePeriodPersonnel = personnel.where((person) {
          final hireDate = person['hire_date'];
          if (hireDate == null) return false;

          final hire = DateTime.parse(hireDate);

          if (startDate != null && hire.isBefore(startDate)) {
            return false;
          }

          if (endDate != null && hire.isAfter(endDate)) {
            return false;
          }

          return true;
        }).toList();

        return {
          'success': true,
          'data': hirePeriodPersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': hirePeriodPersonnel.length,
            'total': hirePeriodPersonnel.length,
            'start_date': startDate?.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'hire_period_count': hirePeriodPersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par localisation
  Future<Map<String, dynamic>> getPersonnelByLocation(String location,
      {int? perPage}) async {
    try {
      final allPersonnel = await getPersonnel(perPage: perPage);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final locationPersonnel = personnel.where((person) {
          final personAddress =
              person['address']?.toString().toLowerCase() ?? '';
          return personAddress.contains(location.toLowerCase());
        }).toList();

        return {
          'success': true,
          'data': locationPersonnel,
          'meta': {
            'current_page': 1,
            'last_page': 1,
            'per_page': locationPersonnel.length,
            'total': locationPersonnel.length,
            'location': location,
            'location_count': locationPersonnel.length,
          },
        };
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par numéro d'employé
  Future<Map<String, dynamic>> getPersonnelByEmployeeId(
      String employeeId) async {
    try {
      final allPersonnel = await getPersonnel(perPage: 1000);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final employeePersonnel = personnel.where((person) {
          return person['employee_id'] == employeeId;
        }).toList();

        if (employeePersonnel.isNotEmpty) {
          return {
            'success': true,
            'data': employeePersonnel.first,
            'meta': {
              'employee_id': employeeId,
              'found': true,
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Aucun employé trouvé avec cet ID',
            'meta': {
              'employee_id': employeeId,
              'found': false,
            },
          };
        }
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le personnel par email
  Future<Map<String, dynamic>> getPersonnelByEmail(String email) async {
    try {
      final allPersonnel = await getPersonnel(perPage: 1000);

      if (allPersonnel['success'] == true && allPersonnel['data'] != null) {
        final personnel = allPersonnel['data'] as List;

        final emailPersonnel = personnel.where((person) {
          return person['email']?.toString().toLowerCase() ==
              email.toLowerCase();
        }).toList();

        if (emailPersonnel.isNotEmpty) {
          return {
            'success': true,
            'data': emailPersonnel.first,
            'meta': {
              'email': email,
              'found': true,
            },
          };
        } else {
          return {
            'success': false,
            'message': 'Aucun employé trouvé avec cet email',
            'meta': {
              'email': email,
              'found': false,
            },
          };
        }
      }

      return allPersonnel;
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si un employé peut être supprimé
  Future<bool> canDeletePersonnel(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        final subordinatesCount = data['subordinates']?.length ?? 0;
        final tasksCount = data['tasks']?.length ?? 0;

        return subordinatesCount == 0 && tasksCount == 0;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le nombre de subordonnés d'un employé
  Future<int> getSubordinatesCount(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return data['subordinates']?.length ?? 0;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nombre de tâches assignées à un employé
  Future<int> getAssignedTasksCount(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return data['tasks']?.length ?? 0;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir le nom complet d'un employé
  Future<String> getPersonnelFullName(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  // Obtenir le département d'un employé
  Future<String?> getPersonnelDepartment(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return data['department'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la position d'un employé
  Future<String?> getPersonnelPosition(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return data['position'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le manager d'un employé
  Future<Map<String, dynamic>?> getPersonnelManager(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return data['manager'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les subordonnés d'un employé
  Future<List<Map<String, dynamic>>> getPersonnelSubordinates(
      int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return List<Map<String, dynamic>>.from(data['subordinates'] ?? []);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les projets d'un employé
  Future<List<Map<String, dynamic>>> getPersonnelProjects(
      int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return List<Map<String, dynamic>>.from(data['projects'] ?? []);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les tâches d'un employé
  Future<List<Map<String, dynamic>>> getPersonnelTasks(int personnelId) async {
    try {
      final personnel = await getPersonnelById(personnelId);

      if (personnel['success'] == true) {
        final data = personnel['data'];
        return List<Map<String, dynamic>>.from(data['tasks'] ?? []);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // ===== MÉTHODES SPÉCIALISÉES PAR RÔLE =====

  // Obtenir tous les techniciens
  Future<Map<String, dynamic>> getTechniciens({
    String? status,
    String? department,
    String? searchQuery,
    String? sortBy = 'hire_date',
    String? sortOrder = 'desc',
    int? perPage = 15,
  }) async {
    try {
      return await getPersonnel(
        position: 'Technicien',
        status: status,
        department: department,
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortOrder: sortOrder,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les managers
  Future<Map<String, dynamic>> getManagers({
    String? status,
    String? department,
    String? searchQuery,
    String? sortBy = 'hire_date',
    String? sortOrder = 'desc',
    int? perPage = 15,
  }) async {
    try {
      return await getPersonnel(
        position: 'Manager',
        status: status,
        department: department,
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortOrder: sortOrder,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les supervisors
  Future<Map<String, dynamic>> getSupervisors({
    String? status,
    String? department,
    String? searchQuery,
    String? sortBy = 'hire_date',
    String? sortOrder = 'desc',
    int? perPage = 15,
  }) async {
    try {
      return await getPersonnel(
        position: 'Supervisor',
        status: status,
        department: department,
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortOrder: sortOrder,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques par rôle
  Future<Map<String, dynamic>> getRoleStatistics() async {
    try {
      final response = await _apiService.get('/personnel/statistics/roles');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les techniciens par manager
  Future<Map<String, dynamic>> getTechniciensByManager(int managerId) async {
    try {
      return await getPersonnel(
        position: 'Technicien',
        managerId: managerId,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les équipes par supervisor
  Future<Map<String, dynamic>> getEquipesBySupervisor(int supervisorId) async {
    try {
      return await getPersonnel(
        managerId: supervisorId,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Créer un technicien
  Future<Map<String, dynamic>> createTechnicien({
    required String firstName,
    required String lastName,
    required String email,
    String? employeeId,
    String? department,
    String? contractType,
    String? status,
    DateTime? hireDate,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    List<String>? languages,
    int? managerId,
    Map<String, dynamic>? emergencyContact,
    String? notes,
    int? createdBy,
  }) async {
    try {
      return await createPersonnel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        employeeId: employeeId,
        position: 'Technicien',
        department: department,
        contractType: contractType,
        status: status,
        hireDate: hireDate,
        dateOfBirth: dateOfBirth,
        phone: phone,
        address: address,
        salary: salary,
        skills: skills,
        certifications: certifications,
        languages: languages,
        managerId: managerId,
        emergencyContact: emergencyContact,
        notes: notes,
        createdBy: createdBy,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Créer un manager
  Future<Map<String, dynamic>> createManager({
    required String firstName,
    required String lastName,
    required String email,
    String? employeeId,
    String? department,
    String? contractType,
    String? status,
    DateTime? hireDate,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    List<String>? languages,
    int? supervisorId,
    Map<String, dynamic>? emergencyContact,
    String? notes,
    int? createdBy,
  }) async {
    try {
      return await createPersonnel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        employeeId: employeeId,
        position: 'Manager',
        department: department,
        contractType: contractType,
        status: status,
        hireDate: hireDate,
        dateOfBirth: dateOfBirth,
        phone: phone,
        address: address,
        salary: salary,
        skills: skills,
        certifications: certifications,
        languages: languages,
        managerId: supervisorId,
        emergencyContact: emergencyContact,
        notes: notes,
        createdBy: createdBy,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Créer un supervisor
  Future<Map<String, dynamic>> createSupervisor({
    required String firstName,
    required String lastName,
    required String email,
    String? employeeId,
    String? department,
    String? contractType,
    String? status,
    DateTime? hireDate,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    List<String>? languages,
    Map<String, dynamic>? emergencyContact,
    String? notes,
    int? createdBy,
  }) async {
    try {
      return await createPersonnel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        employeeId: employeeId,
        position: 'Supervisor',
        department: department,
        contractType: contractType,
        status: status,
        hireDate: hireDate,
        dateOfBirth: dateOfBirth,
        phone: phone,
        address: address,
        salary: salary,
        skills: skills,
        certifications: certifications,
        languages: languages,
        emergencyContact: emergencyContact,
        notes: notes,
        createdBy: createdBy,
      );
    } catch (e) {
      rethrow;
    }
  }
}

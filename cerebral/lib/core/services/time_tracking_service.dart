import 'api_service.dart';

class TimeTrackingService {
  final ApiService _apiService = ApiService.instance;

  // Pointer l'arrivée
  Future<Map<String, dynamic>> clockIn({
    required int projectId,
    String? notes,
    String? location,
  }) async {
    try {
      final data = <String, dynamic>{
        'project_id': projectId,
      };

      if (notes != null) {
        data['notes'] = notes;
      }

      if (location != null) {
        data['location'] = location;
      }

      return await _apiService.post('/time-tracking/clock-in', data);
    } catch (e) {
      rethrow;
    }
  }

  // Pointer le départ
  Future<Map<String, dynamic>> clockOut({String? notes}) async {
    try {
      final data = <String, dynamic>{};

      if (notes != null) {
        data['notes'] = notes;
      }

      return await _apiService.post('/time-tracking/clock-out', data);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages
  Future<Map<String, dynamic>> getHistory({
    int? userId,
    int? projectId,
    DateTime? date,
    int? perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (userId != null) {
        queryParams['user_id'] = userId.toString();
      }
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }
      
      if (date != null) {
        queryParams['date'] = date.toIso8601String().split('T')[0];
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/time-tracking/history$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le statut de l'équipe
  Future<Map<String, dynamic>> getTeamStatus({int? projectId}) async {
    try {
      final queryParams = <String, String>{};
      
      if (projectId != null) {
        queryParams['project_id'] = projectId.toString();
      }

      final queryString = queryParams.isNotEmpty 
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      return await _apiService.get('/time-tracking/team-status$queryString');
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le pointage actuel de l'utilisateur
  Future<Map<String, dynamic>> getCurrent() async {
    try {
      return await _apiService.get('/time-tracking/current');
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes utilitaires pour analyser le suivi du temps

  // Vérifier si l'utilisateur a un pointage actif
  Future<bool> hasActiveTracking() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true) {
        return current['data'] != null;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le pointage actif de l'utilisateur
  Future<Map<String, dynamic>?> getActiveTracking() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true) {
        return current['data'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir l'historique des pointages de l'utilisateur connecté
  Future<Map<String, dynamic>> getMyHistory({
    int? projectId,
    DateTime? date,
    int? perPage,
  }) async {
    try {
      return await getHistory(
        projectId: projectId,
        date: date,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages d'un projet spécifique
  Future<Map<String, dynamic>> getProjectHistory({
    required int projectId,
    int? userId,
    DateTime? date,
    int? perPage,
  }) async {
    try {
      return await getHistory(
        userId: userId,
        projectId: projectId,
        date: date,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages d'un utilisateur spécifique
  Future<Map<String, dynamic>> getUserHistory({
    required int userId,
    int? projectId,
    DateTime? date,
    int? perPage,
  }) async {
    try {
      return await getHistory(
        userId: userId,
        projectId: projectId,
        date: date,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages d'une date spécifique
  Future<Map<String, dynamic>> getDateHistory({
    required DateTime date,
    int? userId,
    int? projectId,
    int? perPage,
  }) async {
    try {
      return await getHistory(
        userId: userId,
        projectId: projectId,
        date: date,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages de la semaine en cours
  Future<Map<String, dynamic>> getCurrentWeekHistory({
    int? userId,
    int? projectId,
    int? perPage,
  }) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));
      
      final weekHistory = <Map<String, dynamic>>[];
      
      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        final dayHistory = await getDateHistory(
          date: date,
          userId: userId,
          projectId: projectId,
          perPage: perPage,
        );
        
        if (dayHistory['success'] == true && dayHistory['data'] != null) {
          weekHistory.addAll(dayHistory['data']);
        }
      }
      
      return {
        'success': true,
        'data': weekHistory,
        'meta': {
          'start_date': startOfWeek.toIso8601String(),
          'end_date': endOfWeek.toIso8601String(),
          'total_entries': weekHistory.length,
        },
      };
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir l'historique des pointages du mois en cours
  Future<Map<String, dynamic>> getCurrentMonthHistory({
    int? userId,
    int? projectId,
    int? perPage,
  }) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      
      final monthHistory = <Map<String, dynamic>>[];
      
      for (int i = 0; i < endOfMonth.day; i++) {
        final date = startOfMonth.add(Duration(days: i));
        final dayHistory = await getDateHistory(
          date: date,
          userId: userId,
          projectId: projectId,
          perPage: perPage,
        );
        
        if (dayHistory['success'] == true && dayHistory['data'] != null) {
          monthHistory.addAll(dayHistory['data']);
        }
      }
      
      return {
        'success': true,
        'data': monthHistory,
        'meta': {
          'start_date': startOfMonth.toIso8601String(),
          'end_date': endOfMonth.toIso8601String(),
          'total_entries': monthHistory.length,
        },
      };
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le statut de l'équipe pour un projet spécifique
  Future<Map<String, dynamic>> getProjectTeamStatus(int projectId) async {
    try {
      return await getTeamStatus(projectId: projectId);
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le statut global de l'équipe
  Future<Map<String, dynamic>> getGlobalTeamStatus() async {
    try {
      return await getTeamStatus();
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir le nombre d'utilisateurs actifs
  Future<int> getActiveUsersCount({int? projectId}) async {
    try {
      final teamStatus = await getTeamStatus(projectId: projectId);
      
      if (teamStatus['success'] == true) {
        return teamStatus['data']['total_active'] ?? 0;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Obtenir la liste des utilisateurs actifs
  Future<List<Map<String, dynamic>>> getActiveUsers({int? projectId}) async {
    try {
      final teamStatus = await getTeamStatus(projectId: projectId);
      
      if (teamStatus['success'] == true) {
        return List<Map<String, dynamic>>.from(teamStatus['data']['users'] ?? []);
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Obtenir les utilisateurs actifs par projet
  Future<Map<int, List<Map<String, dynamic>>>> getActiveUsersByProject() async {
    try {
      final allProjects = await getGlobalTeamStatus();
      
      if (allProjects['success'] == true) {
        final users = allProjects['data']['users'] ?? [];
        final usersByProject = <int, List<Map<String, dynamic>>>{};
        
        for (final user in users) {
          final projectId = user['project_id'];
          if (projectId != null) {
            usersByProject.putIfAbsent(projectId, () => []).add(user);
          }
        }
        
        return usersByProject;
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  // Obtenir la durée du pointage actuel
  Future<Duration?> getCurrentTrackingDuration() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true && current['data'] != null) {
        final clockIn = DateTime.parse(current['data']['clock_in']);
        final now = DateTime.now();
        return now.difference(clockIn);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la durée du pointage actuel en heures
  Future<double?> getCurrentTrackingHours() async {
    try {
      final duration = await getCurrentTrackingDuration();
      
      if (duration != null) {
        return duration.inMinutes / 60.0;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la durée du pointage actuel en minutes
  Future<int?> getCurrentTrackingMinutes() async {
    try {
      final duration = await getCurrentTrackingDuration();
      
      if (duration != null) {
        return duration.inMinutes;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Formater la durée du pointage actuel
  Future<String?> getCurrentTrackingFormatted() async {
    try {
      final duration = await getCurrentTrackingDuration();
      
      if (duration != null) {
        final hours = duration.inHours;
        final minutes = duration.inMinutes % 60;
        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le projet du pointage actuel
  Future<Map<String, dynamic>?> getCurrentTrackingProject() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true && current['data'] != null) {
        return current['data']['project'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir la localisation du pointage actuel
  Future<String?> getCurrentTrackingLocation() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true && current['data'] != null) {
        return current['data']['location'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les notes du pointage actuel
  Future<String?> getCurrentTrackingNotes() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true && current['data'] != null) {
        return current['data']['notes'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Calculer la durée totale des pointages d'une période
  Future<Duration> calculateTotalDuration({
    required DateTime startDate,
    required DateTime endDate,
    int? userId,
    int? projectId,
  }) async {
    try {
      final totalDuration = Duration.zero;
      
      for (DateTime date = startDate;
          date.isBefore(endDate.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        final dayHistory = await getDateHistory(
          date: date,
          userId: userId,
          projectId: projectId,
        );
        
        if (dayHistory['success'] == true && dayHistory['data'] != null) {
          for (final entry in dayHistory['data']) {
            if (entry['clock_in'] != null && entry['clock_out'] != null) {
              final clockIn = DateTime.parse(entry['clock_in']);
              final clockOut = DateTime.parse(entry['clock_out']);
              totalDuration + clockOut.difference(clockIn);
            }
          }
        }
      }
      
      return totalDuration;
    } catch (e) {
      return Duration.zero;
    }
  }

  // Calculer le nombre total d'heures d'une période
  Future<double> calculateTotalHours({
    required DateTime startDate,
    required DateTime endDate,
    int? userId,
    int? projectId,
  }) async {
    try {
      final totalDuration = await calculateTotalDuration(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        projectId: projectId,
      );
      
      return totalDuration.inMinutes / 60.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Obtenir les statistiques de pointage d'une période
  Future<Map<String, dynamic>> getTrackingStats({
    required DateTime startDate,
    required DateTime endDate,
    int? userId,
    int? projectId,
  }) async {
    try {
      final totalHours = await calculateTotalHours(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        projectId: projectId,
      );
      
      final totalDays = endDate.difference(startDate).inDays + 1;
      final averageHoursPerDay = totalDays > 0 ? totalHours / totalDays : 0.0;
      
      return {
        'total_hours': totalHours,
        'total_days': totalDays,
        'average_hours_per_day': averageHoursPerDay,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'user_id': userId,
        'project_id': projectId,
      };
    } catch (e) {
      return {
        'total_hours': 0.0,
        'total_days': 0,
        'average_hours_per_day': 0.0,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'user_id': userId,
        'project_id': projectId,
      };
    }
  }

  // Vérifier si l'utilisateur peut pointer l'arrivée
  Future<bool> canClockIn() async {
    try {
      return !(await hasActiveTracking());
    } catch (e) {
      return false;
    }
  }

  // Vérifier si l'utilisateur peut pointer le départ
  Future<bool> canClockOut() async {
    try {
      return await hasActiveTracking();
    } catch (e) {
      return false;
    }
  }

  // Obtenir le statut du pointage
  Future<String> getTrackingStatus() async {
    try {
      if (await hasActiveTracking()) {
        return 'active';
      } else {
        return 'inactive';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  // Obtenir le résumé du pointage actuel
  Future<Map<String, dynamic>?> getCurrentTrackingSummary() async {
    try {
      final current = await getCurrent();
      
      if (current['success'] == true && current['data'] != null) {
        final data = current['data'];
        final clockIn = DateTime.parse(data['clock_in']);
        final now = DateTime.now();
        final duration = now.difference(clockIn);
        
        return {
          'project_name': data['project']?['name'] ?? 'Projet inconnu',
          'location': data['location'] ?? 'Localisation non définie',
          'clock_in': data['clock_in'],
          'duration': duration.inMinutes,
          'duration_formatted': '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}',
          'notes': data['notes'] ?? 'Aucune note',
        };
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Obtenir le résumé de l'équipe
  Future<Map<String, dynamic>> getTeamSummary({int? projectId}) async {
    try {
      final teamStatus = await getTeamStatus(projectId: projectId);
      
      if (teamStatus['success'] == true) {
        final data = teamStatus['data'];
        final users = data['users'] ?? [];
        
        final summary = {
          'total_active': data['total_active'] ?? 0,
          'users_count': users.length,
          'projects_count': users.map((u) => u['project_id']).toSet().length,
          'average_duration': users.isNotEmpty 
              ? users.map((u) => u['duration'] ?? 0.0).reduce((a, b) => a + b) / users.length 
              : 0.0,
        };
        
        return summary;
      }
      
      return {
        'total_active': 0,
        'users_count': 0,
        'projects_count': 0,
        'average_duration': 0.0,
      };
    } catch (e) {
      return {
        'total_active': 0,
        'users_count': 0,
        'projects_count': 0,
        'average_duration': 0.0,
      };
    }
  }
}

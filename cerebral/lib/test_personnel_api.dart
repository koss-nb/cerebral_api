import 'core/services/personnel_service.dart';

/// Test simple pour vérifier l'API personnel
class PersonnelApiTest {
  final PersonnelService _personnelService = PersonnelService();

  /// Test de récupération du personnel
  Future<void> testGetPersonnel() async {
    try {
      print('🧪 Test de récupération du personnel...');

      final result = await _personnelService.getPersonnel();

      print('✅ API appel réussi !');
      print('🔍 Structure de la réponse:');
      print('   Clés principales: ${result.keys.toList()}');

      if (result['data'] != null) {
        print('   Type de data: ${result['data'].runtimeType}');
        if (result['data'] is List) {
          print('   Nombre d\'éléments: ${result['data'].length}');

          if (result['data'].isNotEmpty) {
            final firstPerson = result['data'][0];
            print('   Premier élément:');
            print('     Type: ${firstPerson.runtimeType}');
            print('     Clés: ${firstPerson.keys.toList()}');
            print('     Contenu: $firstPerson');

            // Vérifier les clés importantes
            print('   Vérification des clés importantes:');
            print('     first_name: ${firstPerson['first_name']}');
            print('     last_name: ${firstPerson['last_name']}');
            print('     email: ${firstPerson['email']}');
            print('     position: ${firstPerson['position']}');
            print('     department: ${firstPerson['department']}');
          }
        }
      }

      if (result['meta'] != null) {
        print('   Meta: ${result['meta']}');
      }
    } catch (e) {
      print('❌ Erreur lors du test: $e');
    }
  }

  /// Test de création d'un personnel simple
  Future<void> testCreatePersonnel() async {
    try {
      print('🧪 Test de création d\'un personnel...');

      final result = await _personnelService.createPersonnel(
        firstName: 'Test',
        lastName: 'User',
        email: 'test.user@example.com',
        position: 'Testeur',
        department: 'Test',
        contractType: 'CDI',
        status: 'active',
      );

      print('✅ Création réussie !');
      print('   Réponse: $result');
    } catch (e) {
      print('❌ Erreur lors de la création: $e');
    }
  }
}

/// Fonction principale pour exécuter les tests
void main() async {
  final test = PersonnelApiTest();

  print('🚀 Début des tests de l\'API personnel\n');

  await test.testGetPersonnel();
  print('');
  await test.testCreatePersonnel();

  print('\n✅ Tests terminés !');
}

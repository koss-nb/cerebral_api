import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';

class PersonnelPage extends StatelessWidget {
  const PersonnelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestion du Personnel',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Nouveau Membre',
              onPressed: () {},
              icon: Icons.person_add,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Page du personnel en cours de développement...',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cerebral/pages/presentations/personnel_management_page.dart';

void main() {
  runApp(const PersonnelManagementTestApp());
}

class PersonnelManagementTestApp extends StatelessWidget {
  const PersonnelManagementTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Page Gestion Personnel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PersonnelManagementPage(),
    );
  }
}

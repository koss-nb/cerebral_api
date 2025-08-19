import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final void Function(int)? onTap;
  final int currentIndex;
  const BottomNavbar({super.key, this.onTap, required this.currentIndex});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 5,

      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "P"),
        BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: "rdv"),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "profileSection",
        ),
      ],
    );
  }
}

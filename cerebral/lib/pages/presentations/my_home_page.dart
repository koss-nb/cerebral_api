import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// Import des pages
import 'admin_home_dashboard.dart';
import 'tassk_list_page.dart';
import 'budget_management_page.dart';
import 'workflow_management_page.dart';
import 'personnel_management_page.dart';
import 'project_management_page.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;

  late AnimationController _expandController;
  late AnimationController _buttonController;
  late Animation<double> _expandAnimation;
  late Animation<double> _buttonAnimation;
  late final List<Widget> _pages;
  late final List<ExpandedOption> _expandedOptions;

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.elasticOut,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    );

    _pages = [
      AdminHomeDashboard(),
      ProjectManagementPage(),
      BudgetManagementPage(),
      TasskListPage(),
      PersonnelManagementPage(),
      WorkflowManagementPage(),
      Settings(),
    ];

    _expandedOptions = [
      ExpandedOption(Icons.business, 'Projets', const Color(0xFF1976D2),
          ProjectManagementPage),
      ExpandedOption(Icons.account_balance_wallet, 'Budget',
          const Color(0xFFFF9800), BudgetManagementPage),
      ExpandedOption(
          Icons.task, 'Tâches', const Color(0xFF4CAF50), TasskListPage),
      ExpandedOption(Icons.people, 'Équipes', const Color(0xFF9C27B0),
          PersonnelManagementPage),
      ExpandedOption(Icons.timeline, 'Flux', const Color(0xFF607D8B),
          WorkflowManagementPage),
      ExpandedOption(
          Icons.settings, 'Réglages', const Color(0xFF795548), Settings),
    ];
  }

  @override
  void dispose() {
    _expandController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
      _buttonController.forward();
    } else {
      _expandController.reverse();
      _buttonController.reverse();
    }
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
  }

  void _selectPageByType(Type pageType) {
    final idx = _pages.indexWhere((w) => w.runtimeType == pageType);
    if (idx != -1) {
      setState(() => _selectedIndex = idx);
    }
  }

  Future<bool> _onWillPop() async {
    if (_isExpanded) {
      _toggleExpanded();
      return false;
    }
    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return false;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quitter l'application"),
        content: const Text("Voulez-vous vraiment quitter CEREBRAL ?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annuler",
                style: TextStyle(color: Color(0xFF6C757D))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Quitter", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (shouldExit == true) SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: _pages[_selectedIndex]),
            Align(alignment: Alignment.bottomCenter, child: _buildBottomBar()),
            if (_isExpanded) _buildExpandedOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, -2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                      icon: Icons.home,
                      label: 'Accueil',
                      targetIndex: 0,
                      activeColor: Colors.black),
                  const SizedBox(width: 60),
                  _buildNavItem(
                      icon: Icons.person,
                      label: 'Profil',
                      targetIndex: 6,
                      activeColor: Colors.grey),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(child: _buildCentralButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralButton() {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _buttonAnimation.value * 0.25 * math.pi,
          child: GestureDetector(
            onTap: _toggleExpanded,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isExpanded
                      ? const Icon(Icons.close, color: Colors.white, size: 30)
                      : const Icon(Icons.menu, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedOptions() {
    const double menuHeight = 220;
    const double centerY = 120;
    const double radius = 110;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 100,
      child: Center(
        child: AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width,
              height: menuHeight,
              child: CustomPaint(
                painter: _ArcPainter(centerY: centerY, radius: radius),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildExpandedOptionItems(
                      width: width, centerY: centerY, radius: radius),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildExpandedOptionItems(
      {required double width,
      required double centerY,
      required double radius}) {
    final centerX = width / 2;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    return List.generate(_expandedOptions.length, (i) {
      final progress = _expandedOptions.length == 1
          ? 0.5
          : i / (_expandedOptions.length - 1);
      final angle = startAngle + (sweepAngle * progress);
      final x = centerX + (radius * math.cos(angle));
      final y = centerY + (radius * math.sin(angle));

      // ⚠️ Clamp pour éviter opacité négative
      final itemAnimation =
          (_expandAnimation.value - (i * 0.1)).clamp(0.0, 1.0);
      final scale = Curves.elasticOut.transform(itemAnimation);

      return Positioned(
        left: x - 40,
        top: y - 40,
        child: Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                _selectPageByType(_expandedOptions[i].pageType);
                _toggleExpanded();
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _expandedOptions[i].color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_expandedOptions[i].icon,
                        color: Colors.white, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      _expandedOptions[i].label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
      {required IconData icon,
      required String label,
      required int targetIndex,
      required Color activeColor}) {
    final isActive = _selectedIndex == targetIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (_isExpanded) _toggleExpanded();
          _onItemTapped(targetIndex);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isActive ? activeColor : activeColor.withOpacity(0.5),
                  size: 28),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          isActive ? activeColor : activeColor.withOpacity(0.5),
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedOption {
  final IconData icon;
  final String label;
  final Color color;
  final Type pageType;

  ExpandedOption(this.icon, this.label, this.color, this.pageType);
}

class _ArcPainter extends CustomPainter {
  final double centerY;
  final double radius;

  _ArcPainter({required this.centerY, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, centerY), radius: radius);
    canvas.drawArc(rect, math.pi, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.centerY != centerY || oldDelegate.radius != radius;
}

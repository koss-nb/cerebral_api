import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 && width <= 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  // Obtenir la largeur de l'écran
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Obtenir la hauteur de l'écran
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Padding adaptatif
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  // Taille de police adaptative
  static double getAdaptiveFontSize(
    BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Nombre de colonnes pour GridView adaptatif
  static int getAdaptiveCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  // Aspect ratio adaptatif pour les cartes
  static double getAdaptiveAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.2;
    if (isTablet(context)) return 1.5;
    return 2.0;
  }

  // Espacement adaptatif
  static double getAdaptiveSpacing(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 16;
    return 20;
  }

  // Largeur de sidebar pour desktop
  static double getSidebarWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isDesktop(context)) {
      return screenWidth * 0.25; // 25% de la largeur
    }
    return 0;
  }

  // Hauteur d'en-tête adaptative
  static double getHeaderHeight(BuildContext context) {
    if (isMobile(context)) return 60;
    if (isTablet(context)) return 70;
    return 80;
  }

  // Taille d'icône adaptative
  static double getAdaptiveIconSize(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 22;
    return 24;
  }

  // Construire un layout responsive
  static Widget buildResponsiveLayout({
    required BuildContext context,
    required Widget mobileLayout,
    Widget? tabletLayout,
    Widget? desktopLayout,
  }) {
    if (isDesktop(context) && desktopLayout != null) {
      return desktopLayout;
    } else if (isTablet(context) && tabletLayout != null) {
      return tabletLayout;
    } else {
      return mobileLayout;
    }
  }

  // Construire une grille responsive
  static Widget buildResponsiveGrid({
    required BuildContext context,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    double? childAspectRatio,
  }) {
    final crossCount = getAdaptiveCrossAxisCount(context);
    final spacing = crossAxisSpacing ?? getAdaptiveSpacing(context);
    final aspectRatio = childAspectRatio ?? getAdaptiveAspectRatio(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: mainAxisSpacing ?? spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  // Construire une liste responsive
  static Widget buildResponsiveList({
    required BuildContext context,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
    bool useGrid = false,
  }) {
    if (useGrid && !isMobile(context)) {
      return buildResponsiveGrid(
        context: context,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      );
    } else {
      return ListView.builder(itemCount: itemCount, itemBuilder: itemBuilder);
    }
  }
}

// Mixin pour les widgets qui ont besoin de responsivité
mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  bool get isMobile => ResponsiveHelper.isMobile(context);
  bool get isTablet => ResponsiveHelper.isTablet(context);
  bool get isDesktop => ResponsiveHelper.isDesktop(context);
  bool get isWeb => ResponsiveHelper.isWeb(context);

  double get screenWidth => ResponsiveHelper.getScreenWidth(context);
  double get screenHeight => ResponsiveHelper.getScreenHeight(context);

  EdgeInsets get adaptivePadding =>
      ResponsiveHelper.getAdaptivePadding(context);
  double get adaptiveSpacing => ResponsiveHelper.getAdaptiveSpacing(context);
  double get adaptiveIconSize => ResponsiveHelper.getAdaptiveIconSize(context);

  Widget buildResponsiveLayout({
    required Widget mobileLayout,
    Widget? tabletLayout,
    Widget? desktopLayout,
  }) {
    return ResponsiveHelper.buildResponsiveLayout(
      context: context,
      mobileLayout: mobileLayout,
      tabletLayout: tabletLayout,
      desktopLayout: desktopLayout,
    );
  }
}

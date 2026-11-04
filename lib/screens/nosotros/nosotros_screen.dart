import 'package:flutter/material.dart';

import '../../config/routes.dart';
import '../../widgets/app_bottom_navigation.dart';

class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      appBar: AppBar(
        title: const Text('Nosotros'),
        backgroundColor: const Color(0xFFFFFDFC),
        foregroundColor: const Color(0xFF241815),
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.outdoor_grill_rounded,
                color: Color(0xFF9F1D0B),
                size: 52,
              ),
              SizedBox(height: 16),
              Text(
                "Asadero Duke's",
                style: TextStyle(
                  color: Color(0xFF241815),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Buena carne, mejores momentos. Descubre nuestros '
                'platillos preparados al carbón y con leña.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF806B62),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 2,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.menu,
      2 => AppRoutes.nosotros,
      3 => AppRoutes.contacto,
      _ => null,
    };
    if (route != null && index != 2) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}
import 'package:flutter/material.dart';

import '../../config/routes.dart';
import '../../widgets/app_bottom_navigation.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      appBar: AppBar(
        title: const Text('Contacto'),
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
                Icons.contact_support_outlined,
                color: Color(0xFF9F1D0B),
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Estamos para ayudarte',
                style: TextStyle(
                  color: Color(0xFF241815),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Próximamente encontrarás aquí nuestros datos de '
                'contacto y atención a pedidos.',
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
        currentIndex: 3,
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
    if (route != null && index != 3) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

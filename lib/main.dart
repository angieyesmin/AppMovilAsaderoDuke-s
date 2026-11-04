import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'screens/contacto/contacto_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/menu/pollos_costillas_screen.dart';
import 'screens/nosotros/nosotros_screen.dart';

void main() {
  runApp(const AsaderoDukesApp());
}

class AsaderoDukesApp extends StatelessWidget {
  const AsaderoDukesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Asadero Duke's",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.menu: (context) => const PollosCostillasScreen(),
        AppRoutes.nosotros: (context) => const NosotrosScreen(),
        AppRoutes.contacto: (context) => const ContactoScreen(),
      },
      home: const LoginScreen(),
    );
  }
}
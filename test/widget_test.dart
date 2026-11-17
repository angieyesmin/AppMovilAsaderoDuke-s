import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_asadero_dukes/config/routes.dart';
import 'package:app_asadero_dukes/main.dart';

import 'package:app_asadero_dukes/screens/home/home_screen.dart';
import 'package:app_asadero_dukes/screens/menu/pollos_costillas_screen.dart';
import 'package:app_asadero_dukes/screens/nosotros/nosotros_screen.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const AsaderoDukesApp());

    expect(find.text('¡Hola de nuevo!'), findsOneWidget);
  });

  testWidgets('Home opens the chicken and ribs menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.menu: (context) => const PollosCostillasScreen(),
          AppRoutes.nosotros: (context) => const NosotrosScreen(),
       
        },
      ),
    );

    await tester.tap(find.text('Pollos Asados').first);
    await tester.pumpAndSettle();

    expect(find.text('Nuestros platillos'), findsOneWidget);
    expect(find.text('Pollo Doble'), findsOneWidget);

    await tester.tap(find.byType(ChoiceChip).at(2));
    await tester.pumpAndSettle();

    expect(find.text('Costilla Medio'), findsOneWidget);
    expect(find.text('Costilla Kilo'), findsOneWidget);
    expect(find.text('Pollo Doble'), findsNothing);

    await tester.tap(find.text('Nosotros').last);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Buena carne, mejores momentos. Descubre nuestros '
        'platillos preparados al carbón y con leña.',
      ),
      findsOneWidget,
    );

   


    await tester.tap(find.text('Inicio').last);
    await tester.pumpAndSettle();
    expect(find.text('¿Qué vas a disfrutar hoy?'), findsOneWidget);
  });
}

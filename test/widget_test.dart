import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_asadero_dukes/config/routes.dart';
import 'package:app_asadero_dukes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  testWidgets('Home profile icon opens the account profile', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(home: const HomeScreen(userEmail: 'cliente@dukes.com')),
    );

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.text('Mi perfil'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Apellido'), findsOneWidget);
    expect(find.text('Número de teléfono'), findsOneWidget);
    expect(find.text('cliente@dukes.com'), findsOneWidget);
    expect(find.text('Llave de acceso'), findsNothing);
    expect(find.text('Mis dispositivos'), findsNothing);
    expect(find.text('CURP'), findsNothing);

    await tester.ensureVisible(find.text('Actualizar información'));
    await tester.tap(find.text('Actualizar información'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).readOnly,
      isTrue,
    );
    await tester.ensureVisible(find.byType(TextFormField).first);
    await tester.enterText(find.byType(TextFormField).first, 'Valeria');
    await tester.enterText(find.byType(TextFormField).at(1), 'Ramirez');
    await tester.ensureVisible(find.text('Guardar cambios'));
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Valeria'), findsOneWidget);
    expect(find.text('Ramirez'), findsOneWidget);
  });

  testWidgets('Home displays the saved profile image', (
    WidgetTester tester,
  ) async {
    final imageBytes = (await rootBundle.load('assets/logo.png')).buffer
        .asUint8List();
    SharedPreferences.setMockInitialValues({
      'asadero_profile_cliente@dukes.com': jsonEncode({
        'name': 'Valeria',
        'surname': 'Ramirez',
        'phone': '',
        'email': 'cliente@dukes.com',
        'image': base64Encode(imageBytes),
      }),
    });

    await tester.pumpWidget(
      MaterialApp(home: const HomeScreen(userEmail: 'cliente@dukes.com')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home-profile-avatar')), findsOneWidget);
  });

  testWidgets('Dish customization updates its price and cart order', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PollosCostillasScreen()));

    await tester.tap(find.text('Pollo Doble'));
    await tester.pumpAndSettle();

    expect(find.text('¿Qué incluye tu orden?'), findsOneWidget);
    expect(find.text('Agregar orden por \$235 MXN'), findsOneWidget);

    await tester.ensureVisible(find.text('Mitad y Mitad'));
    await tester.tap(find.text('Mitad y Mitad'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('extra-1/2 Frijol Charro Extra-add')),
    );
    await tester.tap(
      find.byKey(const ValueKey('extra-1/2 Frijol Charro Extra-add')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Agregar orden por \$295 MXN'), findsOneWidget);

    await tester.tap(find.text('Agregar orden por \$295 MXN'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text('1 × Pollo Doble'), findsOneWidget);
    expect(find.textContaining('1 × 1/2 Frijol Charro Extra'), findsOneWidget);
    expect(find.text('Total: \$295 MXN'), findsOneWidget);
  });
}

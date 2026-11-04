import 'package:flutter/material.dart';

import '../config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indiceSeleccionado = 0;

  static const Color fondo = Color(0xFFFFF8F5);
  static const Color tarjeta = Color(0xFFFFF1EC);
  static const Color rojo = Color(0xFFB51E0B);
  static const Color texto = Color(0xFF171313);

  final List<Map<String, dynamic>> categorias = [
    {
      'nombre': 'Pollos Asados',
      'descripcion': "Marinado Duke's",
      'icono': Icons.outdoor_grill,
      'color': rojo,
    },
    {
      'nombre': 'Costillas a la\nLeña',
      'descripcion': 'Glaseadas & Suaves',
      'icono': Icons.dns,
      'color': rojo,
    },
    {
      'nombre': 'Marinados de\nla Casa',
      'descripcion': '4 Salsas artesanales',
      'icono': Icons.soup_kitchen,
      'color': Color(0xFFB36B00),
    },
    {
      'nombre': 'Guarniciones\n& Extras',
      'descripcion': 'Tortillas y salsas',
      'icono': Icons.ramen_dining,
      'color': rojo,
    },
    {
      'nombre': 'Refrescos &\nBebidas',
      'descripcion': 'Bien frías en vidrio',
      'icono': Icons.local_drink,
      'color': rojo,
    },
    {
      'nombre': 'Especial\nDomingo',
      'descripcion': '¡Hasta agotar!',
      'icono': Icons.local_fire_department,
      'color': Color(0xFFB36B00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _estadoAsadero(),
                    const SizedBox(height: 25),
                    _titulo(),
                    const SizedBox(height: 15),
                    _categorias(),
                    const SizedBox(height: 17),
                    _tituloMarinados(),
                    const SizedBox(height: 8),
                    _marinados(),
                    const SizedBox(height: 17),
                    _comboDestacado(),
                    const SizedBox(height: 14),
                    _promocion(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _menuInferior(),
    );
  }

  // ENCABEZADO
  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F5),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Asadero Duke's Logo",
              style: TextStyle(fontSize: 10, color: Color(0xFF55504D)),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Duke's",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: rojo,
                ),
              ),
              Text("MENÚ", style: TextStyle(fontSize: 8)),
            ],
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.local_fire_department_outlined,
            size: 17,
            color: Color(0xFF543A31),
          ),
          const SizedBox(width: 13),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: rojo,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ESTADO DEL ASADERO
  Widget _estadoAsadero() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8E9DE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 6, color: Color(0xFFE87524)),
              SizedBox(width: 5),
              Text(
                'BRASAS ENCENDIDAS',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9A410D),
                ),
              ),
            ],
          ),
        ),
        const Row(
          children: [
            Icon(Icons.access_time, size: 11, color: rojo),
            SizedBox(width: 3),
            Text(
              'Dom 12:30 - 5:00 PM',
              style: TextStyle(fontSize: 7, color: Color(0xFF4D2520)),
            ),
          ],
        ),
      ],
    );
  }

  // TÍTULO PRINCIPAL
  Widget _titulo() {
    return const Column(
      children: [
        Center(
          child: Text(
            '¿Qué vas a disfrutar hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: texto,
            ),
          ),
        ),
        SizedBox(height: 6),
        Center(
          child: Text(
            'Elige una categoría y descubre nuestras\n'
            'opciones al carbón con leña de mezquite.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.5,
              color: Color(0xFF705B54),
            ),
          ),
        ),
      ],
    );
  }

  // CATEGORÍAS
  Widget _categorias() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categorias.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.02,
      ),
      itemBuilder: (context, index) {
        final categoria = categorias[index];

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (index == 0 || index == 1) {
              Navigator.pushReplacementNamed(context, AppRoutes.menu);
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Seleccionaste ${categoria['nombre']}')),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: tarjeta,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE9DD),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoria['icono'],
                    size: 19,
                    color: categoria['color'],
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  categoria['nombre'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  categoria['descripcion'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 8, color: Color(0xFF755E55)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TÍTULO DE MARINADOS
  Widget _tituloMarinados() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'MARINADOS PARA TU ORDEN',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: texto,
          ),
        ),
        Text(
          'Base: Sal y Pimienta',
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
            color: rojo,
          ),
        ),
      ],
    );
  }

  // MARINADOS
  Widget _marinados() {
    final marinados = [
      ['Mantequilla', Icons.lunch_dining],
      ['Chimichurri', Icons.eco],
      ['BBQ Ahumada', Icons.local_fire_department],
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: marinados.map((item) {
          return Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6E8DF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(item[1] as IconData, size: 11, color: Color(0xFFB56A21)),
                const SizedBox(width: 5),
                Text(
                  item[0] as String,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // COMBO DESTACADO
  Widget _comboDestacado() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tarjeta,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: const Color(0xFFE4C3A9),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.restaurant,
              size: 28,
              color: Color(0xFF9B4A22),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Combo Duque Asa...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: texto,
                        ),
                      ),
                    ),
                    const Text(
                      '\$280',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: rojo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pollo entero asado con marinado al '
                  'gusto, 1/2 orden de costillitas, tortillas...',
                  style: TextStyle(
                    fontSize: 8,
                    height: 1.4,
                    color: Color(0xFF65534C),
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(Icons.star, size: 10, color: Color(0xFFE28B20)),
                    Text(
                      ' 4.9 (140+)  •  Rinde 3-4 personas',
                      style: TextStyle(fontSize: 8, color: Color(0xFF75513D)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PROMOCIÓN
  Widget _promocion() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF6E9E3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: rojo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#TOQUEDÉLACASA',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: rojo,
                      ),
                    ),
                    Text(
                      '¡Al carbón y hasta agotar existencias!',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Preparamos cada lote con leña '
                      'seleccionada. Reserva con anticipación '
                      'tus piezas preferidas.',
                      style: TextStyle(
                        fontSize: 8,
                        height: 1.4,
                        color: Color(0xFF705B54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.menu),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9F1605),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver platillos recomendados',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MENÚ INFERIOR
  Widget _menuInferior() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F5),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: indiceSeleccionado,
        onTap: (index) {
          final route = switch (index) {
            0 => AppRoutes.home,
            1 => AppRoutes.menu,
            2 => AppRoutes.nosotros,
            3 => AppRoutes.contacto,
            _ => null,
          };
          if (route == null || index == indiceSeleccionado) return;
          setState(() {
            indiceSeleccionado = index;
          });
          Navigator.pushReplacementNamed(context, route);
        },
        backgroundColor: const Color(0xFFFFF8F5),
        selectedItemColor: const Color(0xFF6B352B),
        unselectedItemColor: const Color(0xFF795E55),
        selectedFontSize: 8,
        unselectedFontSize: 8,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 19),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu, size: 19),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outdoor_grill, size: 19),
            label: 'Nosotros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support_outlined, size: 19),
            label: 'Contacto',
          ),
        ],
      ),
    );
  }
}

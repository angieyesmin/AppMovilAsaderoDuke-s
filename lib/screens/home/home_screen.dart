import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color fondo = Color(0xFFFFF8F5);
  static const Color rojo = Color(0xFF9F1D0B);
  static const Color naranja = Color(0xFFF36A24);
  static const Color texto = Color(0xFF241815);

  int _selectedTab = 0;
  String _selectedFilter = 'Mantequilla';

  final List<_Category> _categories = const [
    _Category(
      title: 'Pollos Asados',
      subtitle: 'Marinados Duke’s',
      icon: Icons.outdoor_grill_rounded,
    ),
    _Category(
      title: 'Costillas a la\nLeña',
      subtitle: 'Glaseadas & Suaves',
      icon: Icons.dinner_dining_rounded,
    ),
    _Category(
      title: 'Marinados de\nla Casa',
      subtitle: '4 salsas artesanales',
      icon: Icons.liquor_rounded,
    ),
    _Category(
      title: 'Guarniciones\n& Extras',
      subtitle: 'Tortillas y salsas',
      icon: Icons.soup_kitchen_rounded,
    ),
    _Category(
      title: 'Refrescos &\nBebidas',
      subtitle: 'Bien frías en vidrio',
      icon: Icons.local_drink_rounded,
    ),
    _Category(
      title: 'Especial\nDomingo',
      subtitle: '¡Hasta agotar!',
      icon: Icons.local_fire_department_rounded,
      special: true,
    ),
  ];

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: rojo,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(9, 8, 9, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvailability(),
                    const SizedBox(height: 17),
                    _buildWelcome(),
                    const SizedBox(height: 13),
                    _buildCategories(),
                    const SizedBox(height: 15),
                    _buildFilterTitle(),
                    const SizedBox(height: 8),
                    _buildFilters(),
                    const SizedBox(height: 15),
                    _buildProductCard(),
                    const SizedBox(height: 14),
                    _buildPromoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ENCABEZADO
  Widget _buildHeader() {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0E5DF)),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Asadero Duke's Logo",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF76645D),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Duke's",
                style: TextStyle(
                  color: rojo,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              Text(
                'MENÚ',
                style: TextStyle(
                  color: texto,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _message('Próximamente: favoritos.'),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 34,
            ),
            icon: const Icon(
              Icons.local_fire_department_outlined,
              color: Color(0xFF65483D),
              size: 18,
            ),
          ),
          Container(
            height: 21,
            width: 21,
            decoration: const BoxDecoration(
              color: rojo,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _message('Perfil de cliente'),
              icon: const Icon(
                Icons.person,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ESTADO DEL ASADERO
  Widget _buildAvailability() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8DE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFFFF8A24),
                    size: 6,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'BRASAS ENCENDIDAS',
                    style: TextStyle(
                      color: Color(0xFF9B4A20),
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .25,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.access_time_rounded,
              size: 10,
              color: rojo,
            ),
            const SizedBox(width: 3),
            const Text(
              'Dom 12:30 - 5:00 PM',
              style: TextStyle(
                color: Color(0xFF5E3C32),
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 27,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFF1DCD3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  // MENSAJE DE BIENVENIDA
  Widget _buildWelcome() {
    return const Column(
      children: [
        Center(
          child: Text(
            '¿Qué vas a disfrutar hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: texto,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -.45,
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Text(
            'Elige una categoría y descubre nuestras\n'
            'opciones al carbón con leña de mezquite.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF806B62),
              fontSize: 10,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  // CATEGORÍAS
  Widget _buildCategories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.27,
      ),
      itemBuilder: (context, index) {
        final category = _categories[index];

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _message(
            'Categoría: ${category.title.replaceAll('\n', ' ')}',
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EA),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: category.special
                        ? const Color(0xFFFFDCC4)
                        : const Color(0xFFFFE8DF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: category.special ? naranja : rojo,
                    size: 19,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: texto,
                    fontSize: 12,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8A746B),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TÍTULO DE MARINADOS
  Widget _buildFilterTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'MARINADOS PARA TU ORDEN',
          style: TextStyle(
            color: Color(0xFF4B3028),
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          'Base: Sal y Pimienta',
          style: TextStyle(
            color: Color(0xFF805D50),
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  // FILTROS DE MARINADOS
  Widget _buildFilters() {
    final filters = [
      ('Mantequilla', Icons.restaurant),
      ('Chimichurri', Icons.spa_outlined),
      ('BBQ Ahumada', Icons.ramen_dining),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selected = _selectedFilter == filter.$1;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _selectedFilter = filter.$1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF7E3D9)
                      : const Color(0xFFFFFDFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFEBC6B4)
                        : const Color(0xFFF0E5DF),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      filter.$2,
                      color: naranja,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      filter.$1,
                      style: const TextStyle(
                        color: Color(0xFF5D4036),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // PRODUCTO DESTACADO
  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 57,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8C7B4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Stack(
              fit: StackFit.expand,
              children: [
                Icon(
                  Icons.restaurant,
                  color: Color(0xFF9B4B25),
                  size: 29,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF66351F),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        'Top Ventas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                        'Combo Duke Asado...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: texto,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Text(
                      '\$280',
                      style: TextStyle(
                        color: rojo,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pollo entero asado con marinado al gusto, '
                  '1/2 orden de costillas, tortillas...',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF745C52),
                    fontSize: 8,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xFFE7A02A),
                      size: 10,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '4.9 (140+)  •  Rinde 3-4 personas',
                      style: TextStyle(
                        color: Color(0xFF8B5A3D),
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
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
  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EAE4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 27,
                width: 27,
                decoration: const BoxDecoration(
                  color: Color(0xFFC62E19),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#TOQUEDELACASA',
                      style: TextStyle(
                        color: rojo,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '¡Al carbón y hasta agotar existencias!',
                      style: TextStyle(
                        color: texto,
                        fontSize: 12,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Preparamos cada lote fresco con leña '
                      'seleccionada. Reserva con anticipación '
                      'tus piezas preferidas.',
                      style: TextStyle(
                        color: Color(0xFF806A60),
                        fontSize: 8,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                _message('Mostrando platillos recomendados.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: rojo,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    'Ver platillos recomendados',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BARRA DE NAVEGACIÓN INFERIOR
  Widget _buildBottomNavigation() {
    const labels = ['Inicio', 'Menú', 'Nosotros'];

    const icons = [
      Icons.home_outlined,
      Icons.restaurant_menu,
      Icons.outdoor_grill_outlined,
    ];

    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFC),
        border: Border(
          top: BorderSide(color: Color(0xFFEFE3DD)),
        ),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = _selectedTab == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });

                if (index != 0) {
                  _message('Sección: ${labels[index]}');
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    color: selected
                        ? rojo
                        : const Color(0xFF745B51),
                    size: 17,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: selected
                          ? rojo
                          : const Color(0xFF745B51),
                      fontSize: 8,
                      fontWeight: selected
                          ? FontWeight.w900
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// MODELO DE CATEGORÍAS
class _Category {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool special;

  const _Category({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.special = false,
  });
}
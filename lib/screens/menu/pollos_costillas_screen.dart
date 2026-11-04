import 'package:flutter/material.dart';

import '../../config/routes.dart';
import '../../widgets/app_bottom_navigation.dart';

class PollosCostillasScreen extends StatefulWidget {
  const PollosCostillasScreen({super.key});

  @override
  State<PollosCostillasScreen> createState() => _PollosCostillasScreenState();
}

class _PollosCostillasScreenState extends State<PollosCostillasScreen> {
  static const Color _background = Color(0xFFFFF8F5);
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _text = Color(0xFF241815);

  static const List<_Dish> _platillos = [
    _Dish(
      name: 'Pollo Doble',
      description: 'Pollo entero al carbón, ideal para compartir.',
      price: 'Consultar',
      category: 'Pollos Asados',
      image: 'assets/images/pollo_doble.jpg',
    ),
    _Dish(
      name: 'Pollo Plus',
      description: 'Pollo entero con guarnición de la casa.',
      price: 'Consultar',
      category: 'Pollos Asados',
      image: 'assets/images/pollo_plus.jpg',
    ),
    _Dish(
      name: 'Medio Pollo',
      description: 'Medio pollo asado con el sabor de Duke’s.',
      price: 'Consultar',
      category: 'Pollos Asados',
      image: 'assets/images/medio_pollo.jpg',
    ),
    _Dish(
      name: 'Costilla Medio',
      description: 'Costillas a la leña, glaseadas y suaves.',
      price: 'Consultar',
      category: 'Costillas al Carbón',
      image: 'assets/images/costilla_medio.jpg',
    ),
    _Dish(
      name: 'Costilla Kilo',
      description: 'Un kilo de costillas preparado al carbón.',
      price: 'Consultar',
      category: 'Costillas al Carbón',
      image: 'assets/images/costilla_kilo.jpg',
    ),
  ];

  static const List<String> _filters = [
    'Todos',
    'Pollos Asados',
    'Costillas al Carbón',
  ];

  String _selectedFilter = 'Todos';
  int _cartCount = 0;

  List<_Dish> get _filteredDishes {
    if (_selectedFilter == 'Todos') {
      return _platillos;
    }
    return _platillos
        .where((dish) => dish.category == _selectedFilter)
        .toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFC),
        foregroundColor: _text,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Regresar',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Nuestros platillos',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: _red),
                  if (_cartCount > 0)
                    Positioned(
                      right: -9,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: _red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$_cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Hechos al carbón, para disfrutar en grande.',
                style: TextStyle(color: Color(0xFF806B62), fontSize: 13),
              ),
            ),
            SizedBox(
              height: 58,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final selected = filter == _selectedFilter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: _red,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : _text,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: selected ? _red : const Color(0xFFEADBD3),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: _filteredDishes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final dish = _filteredDishes[index];
                  return _DishCard(
                    dish: dish,
                    onAdd: () {
                      setState(() {
                        _cartCount++;
                      });
                      _showMessage('${dish.name} agregado al carrito.');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: _navigateToTab,
      ),
    );
  }

  void _navigateToTab(int index) {
    final route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.menu,
      2 => AppRoutes.nosotros,
      3 => AppRoutes.contacto,
      _ => null,
    };
    if (route != null && index != 1) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish, required this.onAdd});

  final _Dish dish;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0E5DF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 112,
            height: 126,
            child: Image.asset(
              dish.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF8E8DE),
                  child: const Center(
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFF9F1D0B),
                      size: 36,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFB05B35),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dish.name,
                    style: const TextStyle(
                      color: Color(0xFF241815),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF806B62),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dish.price,
                          style: const TextStyle(
                            color: Color(0xFF9F1D0B),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: onAdd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9F1D0B),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Agregar',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dish {
  const _Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });

  final String name;
  final String description;
  final String price;
  final String category;
  final String image;
}

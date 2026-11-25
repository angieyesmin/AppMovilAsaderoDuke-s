import 'package:flutter/material.dart';
import 'package:app_asadero_dukes/config/routes.dart';
import 'package:app_asadero_dukes/models/menu_item.dart';
import 'package:app_asadero_dukes/screens/menu/dish_detail_screen.dart';
import 'package:app_asadero_dukes/widgets/app_bottom_navigation.dart';
class PollosCostillasScreen extends StatefulWidget {
  const PollosCostillasScreen({super.key});
  @override
  State<PollosCostillasScreen> createState() => _PollosCostillasScreenState();
}
class _PollosCostillasScreenState extends State<PollosCostillasScreen> {
  static const Color _background = Color(0xFFF8F1EE);
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _redDark = Color(0xFFB7191B);
  static const Color _orange = Color(0xFFFFB10A);
  static const Color _text = Color(0xFF241815);
  static const Color _muted = Color(0xFF7C655C);
  static const List<MenuItem> _platillos = [
    MenuItem(
      name: 'Pollo Doble',
      description: 'Incluye guarniciones: frijol, arroz, salsa artesanal y tortillas calientes.',
      price: 235,
      category: 'Pollos Asados',
      badge: 'Pollo',
    ),
    MenuItem(
      name: 'Pollo "Plus"',
      description: 'Incluye guarniciones 1/2 arroz, 1/2 frijol, 1 salsa y 1/2 de tortillas recién hechas.',
      price: 285,
      category: 'Pollos Asados',
      badge: 'Plus',
    ),
    MenuItem(
      name: '1/2 Pollo Sencillo',
      description: 'Con guarniciones frijol, arroz, salsa artesanal y tortillas calientes.',
      price: 130,
      category: 'Pollos Asados',
      badge: '1/2 Pollo',
    ),
    MenuItem(
      name: 'Costilla 1/2 kg',
      description:
          'Asada al momento al carbón, tú decides si doradito y jugoso. Con...',
      price: 260,
      category: 'Costillas al Carbón',
      badge: '1/2 Kg',
    ),
    MenuItem(
      name: 'Costilla 1 kg "Plus"',
      description: 'Costillar premium con doble guarnición (1/2 arroz, 1/2 frijol, salsa ...)',
      price: 425,
      category: 'Costillas al Carbón',
      badge: '1 Kg Plus',
    ),
  ];
  static const List<String> _filters = [
    'Todos (5)',
    'Pollos Asados',
    'Costillas al Carbón',
  ];
  String _selectedFilter = 'Todos (5)';
  final List<CustomizedDishOrder> _cartOrders = [];
  int get _cartCount =>
      _cartOrders.fold(0, (total, order) => total + order.quantity);
  int get _cartTotal =>
      _cartOrders.fold(0, (total, order) => total + order.totalPrice);
  List<MenuItem> get _filteredDishes {
    if (_selectedFilter == 'Todos (5)') {
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
  Future<void> _openDishDetails(MenuItem dish) async {
    final order = await Navigator.of(context).push<CustomizedDishOrder>(
      MaterialPageRoute(
        builder: (_) => DishDetailScreen(
          dish: dish,
          onNavigateToTab: (index) {
            if (index == 1) {
              Navigator.pop(context);
            } else {
              _navigateToTab(index);
            }
          },
        ),
      ),
    );
    if (!mounted || order == null) return;
    _addOrderToCart(order);
  }
  void _addDishToCart(MenuItem dish) {
    _addOrderToCart(
      CustomizedDishOrder(
        dish: dish,
        quantity: 1,
        marinade: 'Natural (Sal y pimienta base)',
        cooking: 'Doradito Crujiente',
        extras: const <String, int>{},
        notes: '',
        totalPrice: dish.price,
      ),
    );
  }
  void _addOrderToCart(CustomizedDishOrder order) {
    setState(() {
      _cartOrders.add(order);
    });
    _showMessage(
      '${order.quantity} ${order.dish.name} agregado(s) al carrito.',
    );
  }
  void _showCart() {
    if (_cartOrders.isEmpty) {
      _showMessage('Tu carrito está vacío.');
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu carrito ($_cartCount)',
                style: const TextStyle(
                  color: _text,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _cartOrders
                      .map(
                        (order) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${order.quantity} × ${order.dish.name}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            [
                              '${order.marinade} · ${order.cooking}',
                              if (order.extras.isNotEmpty)
                                order.extras.entries
                                    .map(
                                      (extra) =>
                                          '${extra.value} × ${extra.key}',
                                    )
                                    .join(', '),
                              if (order.notes.isNotEmpty)
                                'Nota: ${order.notes}',
                            ].join('\n'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('\$${order.totalPrice}'),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: \$$_cartTotal MXN',
                  style: const TextStyle(
                    color: _red,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _navigateToTab(int index) {
    final route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.menu,
      2 => AppRoutes.nosotros,
      _ => null,
    };
    if (route != null && index != 1) {
      Navigator.pushReplacementNamed(context, route);
      return;
    }
    if (index == 3) {
      _showMessage('Próximamente: contacto.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              _buildTopBar(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Material(
                    color: const Color(0xFFF7EDE8),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: _text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pollos & Costillas',
                          style: TextStyle(
                            color: _text,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.circle, color: _orange, size: 9),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'Al carbón • 5 opciones',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7EDE8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _showCart,
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: _text,
                            size: 20,
                          ),
                        ),
                      ),
                      if (_cartCount > 0)
                        Positioned(
                          right: -3,
                          top: -3,
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
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPromoBanner(),
              const SizedBox(height: 16),
              _buildFilterTabs(),
              const SizedBox(height: 14),
              ..._filteredDishes.map(
                (dish) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _DishCard(
                    dish: dish,
                    onTap: () => _openDishDetails(dish),
                    onAdd: () => _addDishToCart(dish),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _buildInfoCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: _navigateToTab,
      ),
    );
  }
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Asadero Duke's",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Duke's",
                style: TextStyle(
                  color: _red,
                  fontSize: 19,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'MENÚ',
                style: TextStyle(
                  color: _text,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.local_fire_department_outlined,
            color: _text,
            size: 20,
          ),
          const SizedBox(width: 16),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: _red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E8E2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _redDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    const Text(
                      '¡Sabor a la Leña!',
                      style: TextStyle(
                        color: _redDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE2A6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Marinado Artesanal',
                        style: TextStyle(
                          color: _text,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Todas nuestras órdenes incluyen guarniciones caseras calientes y salsas tatemadas al carbón.',
                  style: TextStyle(color: _muted, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final filter = _filters[index];
          final selected = filter == _selectedFilter;
          final icon = switch (filter) {
            'Pollos Asados' => '🍗',
            'Costillas al Carbón' => '🔥',
            _ => null,
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? _red : const Color(0xFFF7ECE6),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Text(icon, style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        filter,
                        style: TextStyle(
                          color: selected ? Colors.white : _text,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9C2D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_outlined, color: _red, size: 20),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Hecho al momento con pasión',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 42, top: 2),
            child: Text(
              'Las costillas se meten a cocinar al momento para garantizar la máxima frescura y jugosidad al carbón. Por favor considera un tiempo estimado de 15 a 25 min.',
              style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _infoTag('#ToqueDeLaCasa'),
                _infoTag('Carbón de Encino'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _infoTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E1D9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _text,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
class _DishCard extends StatelessWidget {
  const _DishCard({
    required this.dish,
    required this.onTap,
    required this.onAdd,
  });
  final MenuItem dish;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DishImage(dish: dish),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dish.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _PollosCostillasScreenState._text,
                                  fontSize: 17,
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF806A61),
                              size: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          dish.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF7B6760),
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\$${dish.price}',
                                      style: const TextStyle(
                                        color: Color(0xFF9F1D0B),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' MXN',
                                      style: TextStyle(
                                        color:
                                            _PollosCostillasScreenState._text,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: onAdd,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9F1D0B),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text(
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
                ],
              ),
              const SizedBox(height: 12),
              _buildChoiceBar(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildChoiceBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF1EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.palette_outlined, color: Color(0xFF783318), size: 14),
          SizedBox(width: 6),
          Text(
            'Marina...',
            style: TextStyle(
              color: _PollosCostillasScreenState._text,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mantequilla, Chimi, BBQ o Tama...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF783318),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            'A escoger',
            style: TextStyle(
              color: _PollosCostillasScreenState._text,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
class _DishImage extends StatelessWidget {
  const _DishImage({required this.dish});
  final MenuItem dish;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 98,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dish.category == 'Pollos Asados'
                      ? const [Color(0xFFCA8D55), Color(0xFF4A281C)]
                      : const [Color(0xFF755146), Color(0xFF2E211D)],
                ),
              ),
              child: Icon(
                dish.category == 'Pollos Asados'
                    ? Icons.restaurant
                    : Icons.outdoor_grill,
                color: const Color(0xFFFFD29A),
                size: 42,
              ),
            ),
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dish.badge,
                  style: const TextStyle(
                    color: _PollosCostillasScreenState._text,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
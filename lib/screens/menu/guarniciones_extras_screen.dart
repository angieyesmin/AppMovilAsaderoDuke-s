import 'package:flutter/material.dart';

import 'package:app_asadero_dukes/config/routes.dart';
import 'package:app_asadero_dukes/widgets/app_bottom_navigation.dart';

class GuarnicionesExtrasScreen extends StatefulWidget {
  const GuarnicionesExtrasScreen({super.key});

  @override
  State<GuarnicionesExtrasScreen> createState() =>
      _GuarnicionesExtrasScreenState();
}

class _GuarnicionesExtrasScreenState extends State<GuarnicionesExtrasScreen> {
  static const Color _background = Color(0xFFFFF8F5);
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _text = Color(0xFF241815);
  static const Color _muted = Color(0xFF806B62);

  static const List<_SideDish> _sideDishes = [
    _SideDish(
      name: 'Frijoles Charros / Refritos',
      description: 'Receta tradicional cocida a fuego lento con sazón de leña. Elige entre charros o refritos.',
      price: 50,
      portion: '1/2 Litro',
      category: 'Frijoles & Arroz',
      icon: Icons.soup_kitchen_rounded,
    ),
    _SideDish(
      name: 'Arroz Rojo Estilo Mexicano',
      description: 'Arroz sazonado con jitomate asado, verduras y un toque especial de la casa.',
      price: 40,
      portion: '1/2 Litro',
      category: 'Frijoles & Arroz',
      icon: Icons.rice_bowl_rounded,
    ),
    _SideDish(
      name: 'Tortillas de Maíz Calientitas',
      description: 'Recién salidas del comal, envueltas en papel térmico para mantenerlas calientitas.',
      price: 20,
      portion: '1/2 Kg',
      category: 'Tortillas',
      icon: Icons.breakfast_dining_rounded,
    ),
  ];

  static const List<String> _filters = [
    'Todos',
    'Frijoles & Arroz',
    'Salsas Tatemadas',
    'Tortillas',
  ];
  static const List<String> _marinades = [
    'Mantequilla Especial',
    'Chimichurri Criollo',
    'BBQ Ahumada',
    'Tamarindo Agridulce',
  ];

  String _selectedFilter = 'Todos';
  String _selectedSalsa = 'Roja Tatemada';
  String _selectedMarinade = _marinades.first;
  final List<_CartEntry> _cart = [];

  int get _cartCount => _cart.fold(0, (total, item) => total + item.quantity);
  int get _cartTotal =>
      _cart.fold(0, (total, item) => total + item.price * item.quantity);

  List<_SideDish> get _visibleDishes {
    if (_selectedFilter == 'Todos') return _sideDishes;
    return _sideDishes
        .where((dish) => dish.category == _selectedFilter)
        .toList();
  }

  void _addToCart(String name, int price) {
    setState(() {
      _cart.add(_CartEntry(name: name, price: price, quantity: 1));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name agregado al carrito.'),
        backgroundColor: _red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCart() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tu carrito está vacío.'),
          backgroundColor: _red,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
                  children: _cart
                      .map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${item.quantity} × ${item.name}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text('\$${item.price * item.quantity}'),
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
    if (route != null) Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildBrandBar(),
                  const SizedBox(height: 14),
                  _buildTitleBar(),
                  const SizedBox(height: 14),
                  _buildWelcomeCard(),
                  const SizedBox(height: 14),
                  _buildFilters(),
                  const SizedBox(height: 14),
                  ..._buildProductSections(),
                  _buildMarinadeCard(),
                  const SizedBox(height: 18),
                  _buildInfoCard(),
                ]),
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

  List<Widget> _buildProductSections() {
    final sections = <Widget>[];
    for (var index = 0; index < _visibleDishes.length; index++) {
      final dish = _visibleDishes[index];
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _DishCard(
            dish: dish,
            onAdd: () => _addToCart(dish.name, dish.price),
          ),
        ),
      );
      if (_selectedFilter == 'Todos' && index == 1) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildSalsaCard(),
          ),
        );
      }
    }

    if (_selectedFilter == 'Salsas Tatemadas') {
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildSalsaCard(),
        ),
      );
    }
    return sections;
  }

  Widget _buildBrandBar() {
    return Row(
      children: [
        SizedBox(
          height: 38,
          width: 38,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                backgroundColor: _red,
                child: Icon(Icons.local_fire_department, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Duke's",
              style: TextStyle(
                color: _red,
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'MENÚ',
              style: TextStyle(
                color: _text,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.local_fire_department_outlined,
          color: Color(0xFF65483D),
          size: 22,
        ),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 17,
          backgroundColor: _red,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
      ],
    );
  }

  Widget _buildTitleBar() {
    return Row(
      children: [
        Material(
          color: const Color(0xFFF7EDE8),
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: _text),
          ),
        ),
        const SizedBox(width: 4),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guarniciones & Extras',
                style: TextStyle(
                  color: _text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Salsas, arroz, frijoles y tortillas recién hechas',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
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
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EAE4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: _red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.soup_kitchen_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡El complemento perfecto de tu asado!',
                  style: TextStyle(
                    color: Color(0xFF5E3C19),
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Todas nuestras órdenes completas de pollo y costilla incluyen guarnición base. Aquí puedes ordenar porciones adicionales o para tus reuniones.',
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final selected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ChoiceChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = filter),
              selectedColor: _red,
              backgroundColor: const Color(0xFFF8EAE4),
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF5D4036),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
              showCheckmark: selected,
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSalsaCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FoodIllustration(
                icon: Icons.local_dining_rounded,
                label: '10 oz',
                color: Color(0xFF77834A),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salsa Tatemada de la Casa',
                      style: TextStyle(
                        color: _text,
                        fontSize: 15,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Verde asada martajada o roja tatemada al carbón con leña de mezquite.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$40 MXN',
                      style: TextStyle(
                        color: _red,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _salsaChoice('Roja Tatemada', '🌶️'),
              const SizedBox(width: 7),
              _salsaChoice('Verde Asada', '🥑'),
            ],
          ),
          const SizedBox(height: 10),
          _primaryButton(
            label: 'Agregar Salsa Tatemada',
            icon: Icons.shopping_cart_outlined,
            onPressed: () => _addToCart(
              'Salsa Tatemada ${_selectedSalsa.toLowerCase()}',
              40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _salsaChoice(String name, String emoji) {
    final selected = _selectedSalsa == name;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => _selectedSalsa = name),
        style: OutlinedButton.styleFrom(
          backgroundColor: selected
              ? const Color(0xFFFFF8F5)
              : const Color(0xFFF8EAE4),
          foregroundColor: _red,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          side: BorderSide(
            color: selected ? const Color(0xFFEBC6B4) : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(
          '$emoji $name',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildMarinadeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Porción Extra de Marinado  ◉',
                      style: TextStyle(
                        color: _text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Marinados insignia para bañar tu pollo o costilla. Porción individual o cambio a mitad y mitad.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$10',
                    style: TextStyle(
                      color: _red,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text('MXN C/U', style: TextStyle(color: _muted, fontSize: 9)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _marinades.map((marinade) {
              final selected = _selectedMarinade == marinade;
              return ChoiceChip(
                label: Text(marinade),
                selected: selected,
                onSelected: (_) => setState(() => _selectedMarinade = marinade),
                selectedColor: const Color(0xFFF8EAE4),
                backgroundColor: const Color(0xFFF8EAE4),
                labelStyle: const TextStyle(
                  color: Color(0xFF5D4036),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: selected
                      ? const Color(0xFFEBC6B4)
                      : Colors.transparent,
                ),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _primaryButton(
            label: 'Añadir Marinado Elegido',
            icon: Icons.add,
            onPressed: () => _addToCart('Marinado $_selectedMarinade', 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EAE4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFF2E0D6),
            child: Icon(Icons.soup_kitchen_outlined, color: _red),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ingredientes frescos de origen local preparados diariamente para acompañar tu asado al carbón con el toque auténtico de Duke’s.',
              style: TextStyle(color: _muted, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  static BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(color: Color(0x0C000000), blurRadius: 9, offset: Offset(0, 2)),
    ],
  );
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish, required this.onAdd});

  final _SideDish dish;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _GuarnicionesExtrasScreenState._cardDecoration,
      child: Row(
        children: [
          _FoodIllustration(
            icon: dish.icon,
            label: dish.portion,
            color: const Color(0xFF9B694B),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _GuarnicionesExtrasScreenState._text,
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dish.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _GuarnicionesExtrasScreenState._muted,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${dish.price} MXN',
                        style: const TextStyle(
                          color: _GuarnicionesExtrasScreenState._red,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton.icon(
                        onPressed: onAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _GuarnicionesExtrasScreenState._red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 15),
                        label: const Text(
                          'Agregar',
                          style: TextStyle(
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
          ),
        ],
      ),
    );
  }
}

class _FoodIllustration extends StatelessWidget {
  const _FoodIllustration({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      width: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFF1E4DB),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: Icon(icon, color: color, size: 48)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: const Color(0xA866351F),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideDish {
  const _SideDish({
    required this.name,
    required this.description,
    required this.price,
    required this.portion,
    required this.category,
    required this.icon,
  });

  final String name;
  final String description;
  final int price;
  final String portion;
  final String category;
  final IconData icon;
}

class _CartEntry {
  const _CartEntry({
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String name;
  final int price;
  final int quantity;
}

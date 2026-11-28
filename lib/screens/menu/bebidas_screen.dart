import 'package:flutter/material.dart';
import 'package:app_asadero_dukes/config/routes.dart';
import 'package:app_asadero_dukes/widgets/app_bottom_navigation.dart';
import 'package:app_asadero_dukes/widgets/cart_bottom_sheet.dart';
class BebidasScreen extends StatefulWidget {
  const BebidasScreen({super.key});
  @override
  State<BebidasScreen> createState() => _BebidasScreenState();
}
class _BebidasScreenState extends State<BebidasScreen> {
  static const Color _background = Color(0xFFFFF8F5);
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _text = Color(0xFF241815);
  static const Color _muted = Color(0xFF806B62);
  static const List<_Beverage> _beverages = [
    _Beverage(
      name: 'Coca-Cola 2.5 Litros',
      description: 'Para compartir en familia o con amigos. Bien fría, burbujeante y lista para servir.',
      price: 60,
      section: 'Bebidas Familiares',
      icon: Icons.liquor_rounded,
      badge: 'Favorito',
    ),
    _Beverage(
      name: 'Refresco Familiar 1.35 Litros',
      description: 'Elige tu sabor favorito: Mundet (manzana), Fanta (naranja) o Coca-Cola Original.',
      price: 35,
      section: 'Bebidas Familiares',
      icon: Icons.local_cafe_rounded,
      variants: ['Coca-Cola', 'Mundet', 'Fanta'],
    ),
    _Beverage(
      name: 'Coca-Cola Latón (460 ml)',
      description: 'Presentación en lata grande, súper fría. Gran efervescencia que combina con la costilla o el pollo.',
      price: 25,
      section: 'Individuales & Vidrio',
      icon: Icons.local_drink_rounded,
    ),
    _Beverage(
      name: 'Refresco de Vidrio (500 ml)',
      description: 'Sabor clásico e inigualable de botella de vidrio. Variedades: Coca-Cola y refrescos de sabor.',
      price: 20,
      section: 'Individuales & Vidrio',
      icon: Icons.wine_bar_rounded,
      badge: 'Clásico',
      variants: ['Coca-Cola Vidrio', 'Sabor Vidrio'],
    ),
    _Beverage(
      name: 'Té Arizona 460 ml',
      description: 'Lata clásica Arizona sabor té verde con miel o sabores frutales helados.',
      price: 22,
      section: 'Tés & Especialidades',
      icon: Icons.local_cafe_rounded,
    ),
  ];
  static const List<String> _filters = [
    'Todos',
    'Familiares (1.35L y 2.5L)',
    'Individuales (Vidrio y Lata)',
    'Tés & Especialidades',
  ];
  static const List<String> _sections = [
    'Bebidas Familiares',
    'Individuales & Vidrio',
    'Tés & Especialidades',
  ];
  static const Map<String, String> _sectionFilters = {
    'Bebidas Familiares': 'Familiares (1.35L y 2.5L)',
    'Individuales & Vidrio': 'Individuales (Vidrio y Lata)',
    'Tés & Especialidades': 'Tés & Especialidades',
  };
  String _selectedFilter = 'Todos';
  final Map<String, String> _selectedVariants = {
    'Refresco Familiar 1.35 Litros': 'Coca-Cola',
    'Refresco de Vidrio (500 ml)': 'Coca-Cola Vidrio',
  };
  final List<_CartEntry> _cart = [];
  int get _cartCount => _cart.fold(0, (total, item) => total + item.quantity);
  int get _cartTotal =>
      _cart.fold(0, (total, item) => total + item.price * item.quantity);
  void _addToCart(_Beverage beverage) {
    final variant = _selectedVariants[beverage.name];
    final itemName = variant == null
        ? beverage.name
        : '${beverage.name} · $variant';
    setState(() {
      _cart.add(_CartEntry(name: itemName, price: beverage.price, quantity: 1));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName agregado al carrito.'),
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
    showCartBottomSheet(
      context: context,
      itemCount: _cartCount,
      items: _cart
          .map(
            (item) => CartSheetItem(
              name: item.name,
              quantity: item.quantity,
              totalPrice: item.price * item.quantity,
            ),
          )
          .toList(),
      subtotal: _cartTotal,
      total: _cartTotal,
      statusLabel: 'BIEN FRÍAS 🧊',
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
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildBrandBar(),
                  const SizedBox(height: 12),
                  _buildTitleBar(),
                  const SizedBox(height: 14),
                  _buildPromoBanner(),
                  const SizedBox(height: 14),
                  _buildFilters(),
                  const SizedBox(height: 12),
                  ..._buildBeverageSections(),
                  const SizedBox(height: 4),
                  _buildServiceNote(),
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
  List<Widget> _buildBeverageSections() {
    final widgets = <Widget>[];
    for (final section in _sections) {
      final sectionFilter = _sectionFilters[section]!;
      if (_selectedFilter != 'Todos' && _selectedFilter != sectionFilter) {
        continue;
      }
      final beverages = _beverages
          .where((beverage) => beverage.section == section)
          .toList();
      if (beverages.isEmpty) continue;
      widgets.add(_buildSectionHeading(section));
      for (final beverage in beverages) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _BeverageCard(
              beverage: beverage,
              selectedVariant: _selectedVariants[beverage.name],
              onVariantSelected: (variant) {
                setState(() => _selectedVariants[beverage.name] = variant);
              },
              onAdd: () => _addToCart(beverage),
            ),
          ),
        );
      }
    }
    return widgets;
  }
  Widget _buildBrandBar() {
    return Row(
      children: [
        SizedBox(
          height: 36,
          width: 36,
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
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Duke's",
              style: TextStyle(
                color: _red,
                fontSize: 17,
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
          size: 21,
        ),
        const SizedBox(width: 14),
        const CircleAvatar(
          radius: 16,
          backgroundColor: _red,
          child: Icon(Icons.person, color: Colors.white, size: 17),
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
        const SizedBox(width: 3),
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE8DF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.local_drink_rounded, color: _red, size: 19),
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bebidas & Refrescos',
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Refrescos fríos, familiares y tés',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _showCart,
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: _text,
                  size: 19,
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
  Widget _buildPromoBanner() {
    return Container(
      height: 152,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5C382A), Color(0xFF231A18)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -20,
            child: Icon(
              Icons.local_drink_rounded,
              size: 155,
              color: Colors.white.withValues(alpha: .08),
            ),
          ),
          Positioned(
            right: 33,
            top: 16,
            child: Transform.rotate(
              angle: -.15,
              child: const Icon(
                Icons.liquor_rounded,
                size: 80,
                color: Color(0x66F4C9A6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9A341),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '❄  EXTRA HELADAS',
                    style: TextStyle(
                      color: Color(0xFF4A281A),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '¡Bien frías para\nacompañar tu asado!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Servidas a temperatura perfecta con hielo de cortesía.',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
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
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildSectionHeading(String section) {
    final (icon, caption) = switch (section) {
      'Bebidas Familiares' => (Icons.people_alt_outlined, 'PARA COMPARTIR'),
      'Individuales & Vidrio' => (Icons.wine_bar_outlined, 'TRADICIÓN FRÍA'),
      _ => (Icons.local_cafe_outlined, 'REFRESCANTE'),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 8),
      child: Row(
        children: [
          Icon(icon, color: _red, size: 16),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              section,
              style: const TextStyle(
                color: _text,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            caption,
            style: const TextStyle(
              color: _muted,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildServiceNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EAE4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFFFE2CF),
            child: Icon(Icons.icecream_outlined, color: _red, size: 19),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Servicio completo sin costo',
                  style: TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Todas nuestras bebidas se entregan con opción de hielo y vasos desechables para tu pedido para llevar o recolección.',
                  style: TextStyle(color: _muted, fontSize: 10, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _BeverageCard extends StatelessWidget {
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _text = Color(0xFF241815);
  static const Color _muted = Color(0xFF806B62);
  const _BeverageCard({
    required this.beverage,
    required this.selectedVariant,
    required this.onVariantSelected,
    required this.onAdd,
  });
  final _Beverage beverage;
  final String? selectedVariant;
  final ValueChanged<String> onVariantSelected;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  beverage.name,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (beverage.badge != null) ...[
                const SizedBox(width: 5),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7CF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    beverage.badge!,
                    style: const TextStyle(
                      color: Color(0xFF74451D),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 7),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(beverage.icon, color: _red, size: 29),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            beverage.description,
            style: const TextStyle(color: _muted, fontSize: 10, height: 1.4),
          ),
          if (beverage.variants.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              beverage.name.startsWith('Refresco Familiar')
                  ? 'ELIGE TU SABOR:'
                  : 'PRESENTACIÓN:',
              style: const TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: beverage.variants.map((variant) {
                final selected = selectedVariant == variant;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: variant == beverage.variants.last ? 0 : 6,
                    ),
                    child: OutlinedButton(
                      onPressed: () => onVariantSelected(variant),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        backgroundColor: selected
                            ? _red
                            : const Color(0xFFF8EAE4),
                        foregroundColor: selected ? Colors.white : _text,
                        side: BorderSide(
                          color: selected ? _red : const Color(0xFFF8EAE4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        variant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRECIO',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${beverage.price}',
                      style: const TextStyle(
                        color: _red,
                        fontSize: 17,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'MXN',
                      style: TextStyle(
                        color: _text,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton.icon(
                  key: ValueKey('beverage-add-${beverage.name}'),
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Agregar',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _Beverage {
  const _Beverage({
    required this.name,
    required this.description,
    required this.price,
    required this.section,
    required this.icon,
    this.badge,
    this.variants = const [],
  });
  final String name;
  final String description;
  final int price;
  final String section;
  final IconData icon;
  final String? badge;
  final List<String> variants;
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
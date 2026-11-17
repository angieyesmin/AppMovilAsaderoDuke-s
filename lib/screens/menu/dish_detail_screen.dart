import 'package:flutter/material.dart';

import 'package:app_asadero_dukes/models/menu_item.dart';
import 'package:app_asadero_dukes/widgets/app_bottom_navigation.dart';

class CustomizedDishOrder {
  const CustomizedDishOrder({
    required this.dish,
    required this.quantity,
    required this.marinade,
    required this.cooking,
    required this.extras,
    required this.notes,
    required this.totalPrice,
  });

  final MenuItem dish;
  final int quantity;
  final String marinade;
  final String cooking;
  final Map<String, int> extras;
  final String notes;
  final int totalPrice;
}

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({
    required this.dish,
    required this.onNavigateToTab,
    super.key,
  });

  final MenuItem dish;
  final ValueChanged<int> onNavigateToTab;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  static const Color _red = Color(0xFF9F1D0B);
  static const Color _text = Color(0xFF241815);
  static const Color _muted = Color(0xFF7C655C);
  static const Color _surface = Color(0xFFF5EAE4);
  static const Color _background = Color(0xFFFFF8F5);

  static const List<_MarinadeOption> _marinades = [
    _MarinadeOption(
      name: 'Natural (Sal y pimienta base)',
      description: 'La receta clásica dorada de la casa.',
    ),
    _MarinadeOption(
      name: 'Mantequilla Especial',
      description: 'Bañado en mantequilla sazonada y finas hierbas.',
    ),
    _MarinadeOption(
      name: 'Chimichurri Artesanal',
      description: 'Aceite de oliva, ajo tostado y perejil fresco.',
    ),
    _MarinadeOption(
      name: 'BBQ Ahumada',
      description: 'Salsa dulce ahumada glaseada al carbón.',
    ),
    _MarinadeOption(
      name: 'Tamarindo Agridulce al Fuego',
      description: 'Toque cítrico picante y caramelo de tamarindo.',
    ),
    _MarinadeOption(
      name: 'Mitad y Mitad',
      description: 'Prueba 2 marinados diferentes en tu orden.',
      extraPrice: 10,
    ),
  ];

  static const List<_ExtraOption> _extras = [
    _ExtraOption(
      name: '1/2 Frijol Charro Extra',
      price: 50,
      icon: Icons.soup_kitchen_outlined,
    ),
    _ExtraOption(
      name: '1/2 Arroz Rojo Extra',
      price: 40,
      icon: Icons.rice_bowl_outlined,
    ),
    _ExtraOption(
      name: 'Salsa Tatemada 10oz',
      price: 40,
      icon: Icons.local_fire_department_outlined,
    ),
    _ExtraOption(name: '1/2 Tortillas Extra', price: 20, icon: Icons.flatware),
    _ExtraOption(
      name: 'Refresco Vidrio 500ml',
      price: 20,
      icon: Icons.local_cafe_outlined,
    ),
  ];

  static const List<String> _cookingOptions = [
    'Doradito Crujiente',
    'Suave y Jugoso',
  ];

  final Map<String, int> _extraCounts = {};
  final TextEditingController _notesController = TextEditingController();
  String _selectedMarinade = _marinades.first.name;
  String _selectedCooking = _cookingOptions.first;
  int _quantity = 1;

  int get _extrasTotal => _extras.fold(
    0,
    (total, extra) => total + extra.price * (_extraCounts[extra.name] ?? 0),
  );

  int get _totalPrice {
    final marinadePrice = _marinades
        .firstWhere((option) => option.name == _selectedMarinade)
        .extraPrice;
    return (widget.dish.price + marinadePrice) * _quantity + _extrasTotal;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addOrder() {
    Navigator.of(context).pop(
      CustomizedDishOrder(
        dish: widget.dish,
        quantity: _quantity,
        marinade: _selectedMarinade,
        cooking: _selectedCooking,
        extras: Map.unmodifiable(_extraCounts),
        notes: _notesController.text.trim(),
        totalPrice: _totalPrice,
      ),
    );
  }

  void _changeExtra(_ExtraOption extra, int change) {
    setState(() {
      final nextCount = (_extraCounts[extra.name] ?? 0) + change;
      if (nextCount <= 0) {
        _extraCounts.remove(extra.name);
      } else {
        _extraCounts[extra.name] = nextCount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 8),
              _buildHeroImage(),
              const SizedBox(height: 12),
              _buildDishSummary(),
              const SizedBox(height: 14),
              _buildIncludesCard(),
              const SizedBox(height: 18),
              _buildSectionTitle(
                '1. Elige tu Marinado',
                tag: 'Obligatorio',
                trailing: 'Selecciona 1',
              ),
              const SizedBox(height: 8),
              ..._marinades.map(_buildMarinadeOption),
              const SizedBox(height: 18),
              _buildSectionTitle('2. Término de Cocción', tag: 'A tu gusto'),
              const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  'Tú decides el término de cocción de tu orden.',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ),
              Row(
                children: _cookingOptions
                    .map(
                      (option) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: option == _cookingOptions.first ? 8 : 0,
                          ),
                          child: _buildCookingOption(option),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildSectionTitle(
                '3. Guarniciones Extras y Bebidas',
                tag: 'Opcional',
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  'Completa tu mesa con porciones adicionales.',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ),
              ..._extras.map(_buildExtraOption),
              const SizedBox(height: 16),
              const Text(
                'Notas para la cocina',
                style: TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '¿Alguna especificación sobre empaque o salsas?',
                style: TextStyle(color: _muted, fontSize: 10),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Ej. Salsa aparte, bien sellado el empaque...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA48F86),
                    fontSize: 11,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOrderBar(),
            AppBottomNavigation(currentIndex: 1, onTap: widget.onNavigateToTab),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        _circleButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        _circleButton(
          icon: Icons.share_outlined,
          onPressed: () => _showMessage('Compartir estará disponible pronto.'),
        ),
        const SizedBox(width: 8),
        _circleButton(
          icon: Icons.favorite_border,
          onPressed: () => _showMessage('Guardaremos tus favoritos pronto.'),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: _surface,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: _text),
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildHeroImage() {
    final isChicken = widget.dish.category == 'Pollos Asados';
    return Container(
      height: 202,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isChicken
              ? const [Color(0xFFDAA56F), Color(0xFF633722), Color(0xFF271C19)]
              : const [Color(0xFF88634F), Color(0xFF482B21), Color(0xFF211916)],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.outdoor_grill,
              color: Color(0xFFFFD29A),
              size: 82,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _heroLabel(
              Icons.local_fire_department,
              'AL CARBÓN DE ENCINO',
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: _heroLabel(Icons.star, '#ToqueDeLaCasa'),
          ),
        ],
      ),
    );
  }

  Widget _heroLabel(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _red, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: _text,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.dish.name == 'Pollo Doble')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0A1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Más Pedido',
                  style: TextStyle(
                    color: _text,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.access_time, size: 12, color: _muted),
            const SizedBox(width: 3),
            const Text(
              '15 - 20 min',
              style: TextStyle(color: _muted, fontSize: 10),
            ),
            const Spacer(),
            Text(
              '\$${widget.dish.price}',
              style: const TextStyle(
                color: _red,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 3),
            const Text('MXN', style: TextStyle(color: _text, fontSize: 8)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          widget.dish.name,
          style: const TextStyle(
            color: _text,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.dish.description,
          style: const TextStyle(color: _muted, fontSize: 11, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildIncludesCard() {
    const items = [
      (Icons.soup_kitchen_outlined, 'Frijoles Charros', 'Caseros calientes'),
      (Icons.rice_bowl_outlined, 'Arroz Rojo', 'Tradicional'),
      (Icons.local_dining_outlined, 'Salsa Tatemada', 'Al carbón artesanal'),
      (Icons.flatware, 'Tortillas (Trad.)', 'Recién hechas'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lunch_dining, color: Color(0xFFFF9C2D), size: 18),
              SizedBox(width: 6),
              Text(
                '¿Qué incluye tu orden?',
                style: TextStyle(
                  color: _text,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              'Sin costo adicional • Receta Duke’s',
              style: TextStyle(color: _muted, fontSize: 9),
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 2.8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(item.$1, size: 15, color: _red),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                item.$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(
            widget.dish.category == 'Pollos Asados'
                ? 'Todas nuestras órdenes de pollo incluyen guarniciones completas.'
                : 'Tu orden incluye guarniciones completas.',
            style: const TextStyle(color: _muted, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? tag, String? trailing}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (tag != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1DED3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: _red,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          Text(
            trailing,
            style: const TextStyle(
              color: _text,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMarinadeOption(_MarinadeOption option) {
    final selected = _selectedMarinade == option.name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedMarinade = option.name),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? _red : const Color(0xFFF4EAE5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? _red : const Color(0xFFAA9B95),
                  size: 18,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.name,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        option.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  option.extraPrice == 0
                      ? 'Incluido'
                      : '+\$${option.extraPrice} MXN',
                  style: TextStyle(
                    color: option.extraPrice == 0 ? _muted : _red,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCookingOption(String option) {
    final selected = _selectedCooking == option;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => setState(() => _selectedCooking = option),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 84,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? _red : const Color(0xFFF4EAE5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    option == _cookingOptions.first
                        ? Icons.outdoor_grill
                        : Icons.water_drop_outlined,
                    color: _red,
                    size: 16,
                  ),
                  const Spacer(),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected ? _red : const Color(0xFFAA9B95),
                    size: 15,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                option,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                selected ? 'Piel bien tostada' : 'Cocción estándar',
                style: const TextStyle(color: _muted, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtraOption(_ExtraOption extra) {
    final count = _extraCounts[extra.name] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(extra.icon, color: _red, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  extra.name,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '+\$${extra.price} MXN',
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
              ],
            ),
          ),
          if (count > 0) ...[
            _extraCountButton(
              icon: Icons.remove,
              key: ValueKey('extra-${extra.name}-remove'),
              onPressed: () => _changeExtra(extra, -1),
            ),
            SizedBox(
              width: 22,
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _text,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          _extraCountButton(
            icon: Icons.add,
            key: ValueKey('extra-${extra.name}-add'),
            onPressed: () => _changeExtra(extra, 1),
          ),
        ],
      ),
    );
  }

  Widget _extraCountButton({
    required IconData icon,
    required Key key,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        key: key,
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        color: _red,
        style: IconButton.styleFrom(
          backgroundColor: _surface,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildOrderBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: _background,
        border: Border(top: BorderSide(color: Color(0xFFEFE3DD))),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove, size: 16),
                  constraints: const BoxConstraints.tightFor(width: 32),
                  padding: EdgeInsets.zero,
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add, size: 16),
                  constraints: const BoxConstraints.tightFor(width: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: _addOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 15),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Agregar orden por \$$_totalPrice MXN',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _red,
      ),
    );
  }
}

class _MarinadeOption {
  const _MarinadeOption({
    required this.name,
    required this.description,
    this.extraPrice = 0,
  });

  final String name;
  final String description;
  final int extraPrice;
}

class _ExtraOption {
  const _ExtraOption({
    required this.name,
    required this.price,
    required this.icon,
  });

  final String name;
  final int price;
  final IconData icon;
}

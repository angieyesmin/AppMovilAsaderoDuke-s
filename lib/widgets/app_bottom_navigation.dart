
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _labels = [
    'Inicio',
    'Menú',
    'Nosotros',
  ];

  static const _icons = [
    Icons.home_outlined,
    Icons.restaurant_menu,
    Icons.outdoor_grill_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF9F1D0B);
    const inactiveColor = Color(0xFF745B51);

    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFC),
        border: Border(
          top: BorderSide(
            color: Color(0xFFEFE3DD),
          ),
        ),
      ),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final selected = currentIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _icons[index],
                    color: selected ? activeColor : inactiveColor,
                    size: 18,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: selected ? activeColor : inactiveColor,
                      fontSize: 9,
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

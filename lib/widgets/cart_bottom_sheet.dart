import 'package:flutter/material.dart';

class CartSheetItem {
  const CartSheetItem({
    required this.name,
    required this.quantity,
    required this.totalPrice,
    this.details = '',
  });

  final String name;
  final int quantity;
  final int totalPrice;
  final String details;
}

void showCartBottomSheet({
  required BuildContext context,
  required int itemCount,
  required List<CartSheetItem> items,
  required int subtotal,
  required int total,
  required String statusLabel,
  String? additionalLabel,
  int? additionalAmount,
}) {
  const textColor = Color(0xFF241815);
  const mutedColor = Color(0xFF7C655C);
  const redColor = Color(0xFF9F1D0B);
  const buttonColor = Color(0xFFB7191B);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.sizeOf(sheetContext).height * .74,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD8CCC6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          const TextSpan(text: 'Tu carrito '),
                          TextSpan(
                            text: '($itemCount)',
                            style: const TextStyle(color: redColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5DD),
                      border: Border.all(color: const Color(0xFFFFD98A)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                        color: Color(0xFF8A5A00),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 22),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.quantity} × ${item.name}',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (item.details.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.details,
                                style: const TextStyle(
                                  color: mutedColor,
                                  fontSize: 12,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${item.totalPrice}',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 4),
              child: Column(
                children: [
                  _summaryRow(
                    'Subtotal platillos',
                    '\$${subtotal.toStringAsFixed(2)}',
                    mutedColor,
                  ),
                  if (additionalLabel != null) ...[
                    const SizedBox(height: 6),
                    _summaryRow(
                      additionalLabel,
                      additionalAmount == null || additionalAmount == 0
                          ? 'Incluido gratis'
                          : '\$${additionalAmount.toStringAsFixed(2)}',
                      mutedColor,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total a pagar:',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        'Total: \$$total MXN',
                        style: const TextStyle(
                          color: redColor,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: sheetContext,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Pedidos no disponibles'),
                        content: const Text(
                          'La confirmación de pedidos aún no está disponible.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Entendido'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 25),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CONFIRMAR PEDIDO',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Recoger en sucursal Duke's",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$$total MXN',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, size: 22),
                    ],
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(sheetContext),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar más platillos al carrito'),
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(sheetContext).bottom + 4),
          ],
        ),
      ),
    ),
  );
}

Widget _summaryRow(String label, String value, Color color) {
  return Row(
    children: [
      Expanded(
        child: Text(label, style: TextStyle(color: color, fontSize: 12)),
      ),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

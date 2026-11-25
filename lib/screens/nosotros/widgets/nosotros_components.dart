import 'package:flutter/material.dart';

const _nosotrosPaper = Color(0xFFFFFEFC);
const _nosotrosPale = Color(0xFFF8EDE7);
const _nosotrosDeepRed = Color(0xFF7D170B);
const _nosotrosInk = Color(0xFF211815);
const _nosotrosMuted = Color(0xFF806B62);

class NosotrosSectionCard extends StatelessWidget {
  const NosotrosSectionCard({
    super.key,
    required this.child,
    this.color = _nosotrosPaper,
    this.padding = const EdgeInsets.all(17),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class NosotrosFactChip extends StatelessWidget {
  const NosotrosFactChip({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: _nosotrosPale,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _nosotrosDeepRed, size: 17),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _nosotrosInk,
              fontSize: 10,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class NosotrosInfoRow extends StatelessWidget {
  const NosotrosInfoRow({
    super.key,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.detail,
    this.note,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: _nosotrosPale,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _nosotrosDeepRed, size: 19),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(color: _nosotrosMuted, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: _nosotrosInk,
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(
                  color: _nosotrosMuted,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              if (note != null) ...[
                const SizedBox(height: 5),
                Text(
                  note!,
                  style: const TextStyle(
                    color: _nosotrosDeepRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class NosotrosSocialButton extends StatelessWidget {
  const NosotrosSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAEEE8),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: Column(
            children: [
              Icon(icon, color: _nosotrosDeepRed, size: 21),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _nosotrosInk,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _nosotrosMuted, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NosotrosMapPreview extends StatelessWidget {
  const NosotrosMapPreview({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE9E7D9),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: SizedBox(
          height: 166,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _MapPainter()),
              const Positioned(
                left: 16,
                bottom: 14,
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: _nosotrosDeepRed, size: 17),
                    SizedBox(width: 4),
                    Text(
                      "Asadero Duke's · Col. Asaderos",
                      style: TextStyle(
                        color: _nosotrosInk,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Icon(
                  Icons.location_on,
                  color: _nosotrosDeepRed,
                  size: 42,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 12,
                        color: _nosotrosDeepRed,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Abrir mapa',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE8E8DA);
    canvas.drawRect(Offset.zero & size, background);

    final park = Paint()..color = const Color(0xFFD3E2C5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .68,
          size.height * .48,
          size.width * .28,
          size.height * .35,
        ),
        const Radius.circular(14),
      ),
      park,
    );

    final roadEdge = Paint()
      ..color = const Color(0xFFD4C9B9)
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
    final road = Paint()
      ..color = const Color(0xFFFFFCF4)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    final paths = <Path>[
      Path()
        ..moveTo(-10, size.height * .72)
        ..cubicTo(
          size.width * .22,
          size.height * .67,
          size.width * .53,
          size.height * .78,
          size.width + 10,
          size.height * .58,
        ),
      Path()
        ..moveTo(size.width * .29, -10)
        ..cubicTo(
          size.width * .34,
          size.height * .25,
          size.width * .14,
          size.height * .66,
          size.width * .2,
          size.height + 10,
        ),
      Path()
        ..moveTo(size.width * .77, -10)
        ..cubicTo(
          size.width * .7,
          size.height * .21,
          size.width * .91,
          size.height * .47,
          size.width * .82,
          size.height + 10,
        ),
      Path()
        ..moveTo(-10, size.height * .27)
        ..cubicTo(
          size.width * .28,
          size.height * .35,
          size.width * .57,
          size.height * .16,
          size.width + 10,
          size.height * .29,
        ),
    ];

    for (final path in paths) {
      canvas.drawPath(path, roadEdge);
      canvas.drawPath(path, road);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
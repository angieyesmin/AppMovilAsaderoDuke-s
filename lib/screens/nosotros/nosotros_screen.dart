import 'package:flutter/material.dart';

const Color kRojo = Color(0xFF8B1A0E);
const Color kRojoClaro = Color(0xFFB5301F);
const Color kCafe = Color(0xFF7A3E00);
const Color kTexto = Color(0xFF1F1B18);
const Color kTextoSuave = Color(0xFF5C4D47);
const Color kBeige = Color(0xFFFBEDE6);
const Color kCirculo = Color(0xFFF6E3DA);

class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _TopBar(),
      backgroundColor: const Color(0xFFFFF8F4),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _Encabezado(),
            _HistoriaCard(),
            _BannerTradicion(),
            _UbicacionCard(),
            _MarinadosCard(),
            _RedesCard(),
            _Pie(),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopBar();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 120,
              height: 36,
              color: const Color(0xFFE0E0E0),
              alignment: Alignment.center,
              child: const Text(
                'img',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Duke's",
                  style: TextStyle(
                    color: kRojo,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'NOSOTROS',
                  style: TextStyle(
                    color: kTextoSuave,
                    fontSize: 9,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.local_fire_department_outlined,
              color: kRojo,
              size: 22,
            ),
            const SizedBox(width: 14),
            const CircleAvatar(
              radius: 16,
              backgroundColor: kRojo,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: kCirculo,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.outdoor_grill, color: kRojo, size: 52),
          ),
          const SizedBox(height: 8),
          const Text(
            'TRADICIÓN A LA LEÑA',
            style: TextStyle(
              color: kCafe,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nuestra Historia',
            style: TextStyle(
              color: kTexto,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '#ToqueDeLaCasa · Sabor de Familia',
            style: TextStyle(color: kTextoSuave, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const _Tarjeta({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HistoriaCard extends StatelessWidget {
  const _HistoriaCard();

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: kTexto, fontSize: 14, height: 1.6),
              children: [
                TextSpan(text: 'En '),
                TextSpan(
                  text: "Asadero Duke's",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' creemos en el poder del fuego lento, las brasas vivas y el sazón hecho con amor de familia. Nuestro chimichurri lo preparamos con reposo artesanal para alcanzar el balance perfecto. Cada corte y pollo se marina con receta de la casa y se dora al carbón para llevarte el asado más tierno y crujiente.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBeige,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '99',
                  style: TextStyle(
                    color: kCafe,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"Todo lo puedo en Cristo que me fortalece"',
                        style: TextStyle(
                          color: kTexto,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Josué 1:9 · Duke's Familia",
                        style: TextStyle(color: kTextoSuave, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _Dato(
                  icono: Icons.timer_outlined,
                  texto: 'Reposo de 48h en marinados',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Dato(
                  icono: Icons.local_fire_department_outlined,
                  texto: '100% Carbón de encino',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _Dato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: kCirculo,
          child: Icon(icono, color: kRojo, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(color: kTexto, fontSize: 12, height: 1.3),
          ),
        ),
      ],
    );
  }
}

class _BannerTradicion extends StatelessWidget {
  const _BannerTradicion();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [kRojo, kRojoClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEL ASADOR A TU MESA',
                  style: TextStyle(
                    color: Color(0xFFFFD9CC),
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Ven a probar la tradición',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Sigue el aroma del carbón hasta nuestro fogón',
                  style: TextStyle(color: Color(0xFFFFE3DA), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0x33FFFFFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_downward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _UbicacionCard extends StatelessWidget {
  const _UbicacionCard();

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Espacio reservado para agregar la ubicación cuando se compartan los datos.
          const SizedBox(height: 140, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _FilaInfo(
                  icono: Icons.access_time,
                  etiqueta: 'Horario de Brasas',
                  titulo: 'Domingos: 12:30 PM - 5:00 PM',
                  detalle: '¡Hasta agotar existencias del día!',
                  detalleColor: kRojo,
                  detalleBold: true,
                  extra: 'Lunes de descanso (preparación y reposo de salsas)',
                ),
                const Divider(height: 28, color: Color(0xFFEFE3DD)),
                const _FilaInfo(
                  icono: Icons.two_wheeler,
                  etiqueta: 'Servicio a Domicilio',
                  titulo: 'Envío exprés disponible',
                  detalle: 'Costo calculado según kilometraje en zona cercana',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaInfo extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String titulo;
  final String detalle;
  final Color detalleColor;
  final bool detalleBold;
  final String? extra;

  const _FilaInfo({
    required this.icono,
    required this.etiqueta,
    required this.titulo,
    required this.detalle,
    this.detalleColor = kTextoSuave,
    this.detalleBold = false,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: kCirculo,
          child: Icon(icono, color: kRojo, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(color: kTextoSuave, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                titulo,
                style: const TextStyle(
                  color: kTexto,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detalle,
                style: TextStyle(
                  color: detalleColor,
                  fontSize: 12,
                  fontWeight: detalleBold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              if (extra != null) ...[
                const SizedBox(height: 4),
                Text(
                  extra!,
                  style: const TextStyle(
                    color: kRojo,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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

class _MarinadosCard extends StatelessWidget {
  const _MarinadosCard();

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      color: kBeige,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.indeterminate_check_box_outlined,
                color: kCafe,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Marinados por Encargo',
                style: TextStyle(
                  color: kTexto,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Llévate el secreto de Duke's a casa. Presentación de 1/2 Litro: Chimichurri de la casa, Salsa BBQ ahumada y Tamarindo agridulce.",
            style: TextStyle(color: kTextoSuave, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ANTICIPAR 2 DÍAS PREVIOS',
                style: TextStyle(
                  color: kCafe,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: kTexto,
                  side: const BorderSide(color: Color(0xFFE8D5CC)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cotizar Salsas',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RedesCard extends StatelessWidget {
  const _RedesCard();

  @override
  Widget build(BuildContext context) {
    return const _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comunidad del Fuego',
            style: TextStyle(color: kTextoSuave, fontSize: 12),
          ),
          SizedBox(height: 4),
          Text(
            'Síguenos en Redes Sociales',
            style: TextStyle(
              color: kTexto,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Publicamos el menú especial de cada domingo y el encendido de fogón desde temprano.',
            style: TextStyle(color: kTextoSuave, fontSize: 12, height: 1.4),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Red(
                  icono: Icons.camera_alt_outlined,
                  titulo: 'Instagram',
                  subtitulo: '',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _Red(
                  icono: Icons.share_outlined,
                  titulo: 'Facebook',
                  subtitulo: '',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _Red(
                  icono: Icons.chat_outlined,
                  titulo: 'WhatsApp',
                  subtitulo: '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Red extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;

  const _Red({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: kBeige,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icono, color: kRojo, size: 24),
          const SizedBox(height: 6),
          Text(
            titulo,
            style: const TextStyle(
              color: kTexto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: const TextStyle(color: kTextoSuave, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _Pie extends StatelessWidget {
  const _Pie();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          Icon(Icons.local_fire_department_outlined, color: kCafe, size: 22),
          SizedBox(height: 8),
          Text(
            "ASADERO DUKE'S · LA CAPITAL DEL SABOR A LA LEÑA",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextoSuave,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFE3DD))),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icono: Icons.home_outlined,
                texto: 'Inicio',
                onTap: () => Navigator.of(context).pop(),
              ),
              _NavItem(
                icono: Icons.restaurant_menu,
                texto: 'Menú',
                onTap: () => Navigator.of(context).pop(),
              ),
              _NavItem(
                icono: Icons.outdoor_grill,
                texto: 'Nosotros',
                activo: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icono,
    required this.texto,
    this.activo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = activo ? kRojo : kTextoSuave;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: activo ? kBeige : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              texto,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

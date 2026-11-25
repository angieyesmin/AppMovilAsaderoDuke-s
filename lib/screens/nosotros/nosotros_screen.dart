import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/nosotros_components.dart';
import '../../config/routes.dart';
import '../../widgets/app_bottom_navigation.dart';
class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});
  static const _phone = '9983244530';
  static const _address =
      'Av. Principal del Sabor #142, Col. Asaderos, Ciudad de México, CDMX';
  static const _facebookUrl = 'https://share.google/1lnngu9kXjaWgGZ0D';
  static const _instagramUrl = 'https://share.google/pmMiAQQOJE8HVcmjN';
  static const _cream = Color(0xFFFFF8F4);
  static const _paper = Color(0xFFFFFEFC);
  static const _red = Color(0xFF9F1D0B);
  static const _deepRed = Color(0xFF7D170B);
  static const _orange = Color(0xFFC63820);
  static const _ink = Color(0xFF211815);
  static const _muted = Color(0xFF806B62);
  static const _line = Color(0xFFF0E5DF);
  static const _pale = Color(0xFFF8EDE7);
  Future<void> _openLink(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
    }
  }
  void _navigateToTab(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.menu,
      2 => AppRoutes.nosotros,
      _ => null,
    };
    if (route != null && index != 2) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHero(),
                    const SizedBox(height: 20),
                    _buildStoryCard(),
                    const SizedBox(height: 18),
                    _buildFireBanner(context),
                    const SizedBox(height: 18),
                    _buildLocationCard(context),
                    const SizedBox(height: 18),
                    _buildMarinadesCard(context),
                    const SizedBox(height: 18),
                    _buildSocialCard(context),
                    const SizedBox(height: 22),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 2,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: _paper,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              'assets/logo.png',
              width: 42,
              height: 34,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stackTrace) => const Icon(
                Icons.local_fire_department_rounded,
                color: _red,
                size: 28,
              ),
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
                  color: _red,
                  fontSize: 17,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'NOSOTROS',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Llamar al asadero',
            onPressed: () =>
                _openLink(context, Uri(scheme: 'tel', path: '+52$_phone')),
            icon: const Icon(Icons.person_outline, color: _red),
          ),
        ],
      ),
    );
  }
  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(color: _pale, shape: BoxShape.circle),
          child: const Icon(Icons.outdoor_grill_rounded, size: 36, color: _red),
        ),
        const SizedBox(height: 10),
        const Text(
          'TRADICIÓN A LA LEÑA',
          style: TextStyle(
            color: Color(0xFF8C642C),
            fontSize: 10,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Nuestra Historia',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '#ToqueDeLaCasa · Sabor de Familia',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 13),
        ),
      ],
    );
  }
  Widget _buildStoryCard() {
    return NosotrosSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "En Asadero Duke's creemos en el poder del fuego lento, las brasas "
            'vivas y el sazón hecho con amor de familia. Nuestro chimichurri lo '
            'preparamos con reposo artesanal para alcanzar el balance perfecto. '
            'Cada corte y pollo se marina con receta de la casa y se dora al '
            'carbón para llevarte el asado más tierno y crujiente.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.58),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF0E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_quote_rounded, color: _orange, size: 23),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Todo lo puedo en Cristo que me fortalece.',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Josué 1:9 · Duke's Familia",
                        style: TextStyle(
                          color: _ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: NosotrosFactChip(
                  icon: Icons.timelapse_rounded,
                  text: 'Reposo de 48 h\nen marinados',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: NosotrosFactChip(
                  icon: Icons.local_fire_department_outlined,
                  text: '100% carbón\nde encino',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildFireBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_deepRed, _orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x229F1D0B),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
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
                    color: Color(0xFFFFD7B8),
                    fontSize: 9,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Ven a probar la tradición',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Sigue el aroma del carbón hasta nuestro fogón.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white.withValues(alpha: .18),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _openLink(context, _mapsUri),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.south_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
  static final Uri _mapsUri = Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': _address,
  });
  Widget _buildLocationCard(BuildContext context) {
    return NosotrosSectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NosotrosMapPreview(onTap: () => _openLink(context, _mapsUri)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
            child: Column(
              children: [
                NosotrosInfoRow(
                  icon: Icons.location_on_outlined,
                  eyebrow: 'Ubicación del Fogón',
                  title: 'Av. Principal del Sabor #142',
                  detail: 'Col. Asaderos, Ciudad de México, CDMX',
                ),
                const Divider(height: 25, color: _line),
                const NosotrosInfoRow(
                  icon: Icons.access_time_rounded,
                  eyebrow: 'Horario de Brasas',
                  title: 'Domingos · 12:30 PM – 5:00 PM',
                  detail: 'Lunes de descanso (preparación y reposo de salsas)',
                  note: '¡Hasta agotar existencias del día!',
                ),
                const Divider(height: 25, color: _line),
                const NosotrosInfoRow(
                  icon: Icons.delivery_dining_rounded,
                  eyebrow: 'Servicio a Domicilio',
                  title: 'Envíos disponibles',
                  detail: 'Costo calculado según kilometraje en zona cercana.',
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openLink(context, _mapsUri),
                    icon: const Icon(Icons.near_me_outlined, size: 18),
                    label: const Text('Cómo llegar (Maps / Waze)'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openLink(
                      context,
                      Uri(scheme: 'tel', path: '+52$_phone'),
                    ),
                    icon: const Icon(Icons.call_outlined, size: 17),
                    label: const Text('Llamar al Asadero · +52 998 324 4530'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _deepRed,
                      side: const BorderSide(color: _line),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMarinadesCard(BuildContext context) {
    return NosotrosSectionCard(
      color: const Color(0xFFFCF1E9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: _deepRed, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Marinados por Encargo',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Llévate el secreto de Duke’s a casa. Presentación de 1/2 litro: '
            'chimichurri de la casa, salsa BBQ ahumada y tamarindo agridulce.',
            style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'ANTICIPAR 2 DÍAS PREVIOS',
                  style: TextStyle(
                    color: Color(0xFF8B642E),
                    fontSize: 9,
                    letterSpacing: .4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _openLink(
                  context,
                  Uri.parse(
                    'https://wa.me/52$_phone?text=Hola%2C%20quiero%20cotizar%20marinados',
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: _deepRed,
                  backgroundColor: _paper,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                ),
                child: const Text('Cotizar salsas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildSocialCard(BuildContext context) {
    return NosotrosSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comunidad del Fuego',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 3),
          const Text(
            'Síguenos en Redes Sociales',
            style: TextStyle(
              color: _ink,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Publicamos el menú especial de cada domingo y el encendido del fogón desde temprano.',
            style: TextStyle(color: _muted, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: NosotrosSocialButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  detail: '@asaderodukes',
                  onTap: () => _openLink(context, Uri.parse(_instagramUrl)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NosotrosSocialButton(
                  icon: Icons.share_outlined,
                  label: 'Facebook',
                  detail: "Asadero Duke's",
                  onTap: () => _openLink(context, Uri.parse(_facebookUrl)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NosotrosSocialButton(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  detail: 'Hacer pedido',
                  onTap: () =>
                      _openLink(context, Uri.parse('https://wa.me/52$_phone')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildFooter() {
    return const Column(
      children: [
        Icon(
          Icons.local_fire_department_outlined,
          color: Color(0xFF8B642E),
          size: 23,
        ),
        SizedBox(height: 7),
        Text(
          "ASADERO DUKE'S · LA CAPITAL DEL SABOR A LA LEÑA",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _muted,
            fontSize: 9,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
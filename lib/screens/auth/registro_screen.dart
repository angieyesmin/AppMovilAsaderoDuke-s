
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  bool mostrarPassword = false;
  bool mostrarConfirmarPassword = false;
  bool aceptarTerminos = false;
  bool recibirPromociones = true;

  final Color rojo = const Color(0xFFB52B1C);
  final Color naranja = const Color(0xFFFF9800);

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  void crearCuenta() {
    if (!_formKey.currentState!.validate()) return;

    if (!aceptarTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes aceptar los términos y condiciones.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Datos validados correctamente!'),
        backgroundColor: Colors.green,
      ),
    );

    // Aquí posteriormente conectarás el registro con tu API.
  }

  Widget campoTexto({
    required String titulo,
    required String hint,
    required IconData icono,
    required TextEditingController controller,
    bool password = false,
    bool confirmar = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF292929),
          ),
        ),
        const SizedBox(height: 5),

        SizedBox(
          height: 42,
          child: TextFormField(
            controller: controller,
            obscureText: password
                ? (confirmar
                    ? !mostrarConfirmarPassword
                    : !mostrarPassword)
                : false,
            keyboardType: tipo,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF333333),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                icono,
                size: 15,
                color: Colors.grey,
              ),
              suffixIcon: password
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 15,
                      onPressed: () {
                        setState(() {
                          if (confirmar) {
                            mostrarConfirmarPassword =
                                !mostrarConfirmarPassword;
                          } else {
                            mostrarPassword = !mostrarPassword;
                          }
                        });
                      },
                      icon: Icon(
                        (confirmar
                                ? mostrarConfirmarPassword
                                : mostrarPassword)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  color: rojo,
                  width: 1.3,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }

              if (controller == correoController &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                      .hasMatch(value.trim())) {
                return 'Ingresa un correo válido';
              }

              if (controller == passwordController &&
                  value.length < 6) {
                return 'Mínimo 6 caracteres';
              }

              if (controller == confirmarPasswordController &&
                  value != passwordController.text) {
                return 'Las contraseñas no coinciden';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ENCABEZADO
              Container(
                width: double.infinity,
                height: 165,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF100D0B),
                      Color(0xFF29201A),
                      Color(0xFF120F0D),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFFF9800),
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'TRADICIÓN AL CARBÓN',
                        style: TextStyle(
                          color: Color(0xFFFFB52E),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: naranja,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 7),

                        const Text(
                          'ASADERO',
                          style: TextStyle(
                            color: Color(0xFFFFA51E),
                            fontSize: 9,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "DUKE'S",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),

                    const Text(
                      'BUENA CARNE, MEJORES MOMENTOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // FORMULARIO
              Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    14, 17, 14, 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'SISTEMA DE CLIENTES & PEDIDOS',
                          style: TextStyle(
                            color: rojo,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.7,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          '¡Crea tu cuenta!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF171717),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Regístrate para ordenar cortes al carbón, acumular puntos y recibir promociones exclusivas.',
                          style: TextStyle(
                            fontSize: 9,
                            height: 1.5,
                            color: Color(0xFF777777),
                          ),
                        ),

                        const SizedBox(height: 15),

                        campoTexto(
                          titulo: 'Nombre completo',
                          hint: 'Juan Pérez',
                          icono: Icons.person_outline,
                          controller: nombreController,
                        ),

                        const SizedBox(height: 9),

                        campoTexto(
                          titulo: 'Correo Electrónico',
                          hint: 'ejemplo@correo.com',
                          icono: Icons.mail_outline,
                          controller: correoController,
                          tipo: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 9),

                        campoTexto(
                          titulo: 'Teléfono Celular',
                          hint: '300 123 4567',
                          icono: Icons.phone_outlined,
                          controller: telefonoController,
                          tipo: TextInputType.phone,
                        ),

                        const SizedBox(height: 9),

                        campoTexto(
                          titulo: 'Contraseña',
                          hint: '••••••••••••',
                          icono: Icons.lock_outline,
                          controller: passwordController,
                          password: true,
                        ),

                        const SizedBox(height: 9),

                        campoTexto(
                          titulo: 'Confirmar Contraseña',
                          hint: '••••••••••••',
                          icono: Icons.lock_outline,
                          controller: confirmarPasswordController,
                          password: true,
                          confirmar: true,
                        ),

                        const SizedBox(height: 9),

                        // TÉRMINOS Y CONDICIONES
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 19,
                              child: Checkbox(
                                value: aceptarTerminos,
                                activeColor: rojo,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    aceptarTerminos = value ?? false;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Wrap(
                                children: [
                                  const Text(
                                    'Acepto los ',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    'Términos y Condiciones',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: rojo,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const Text(
                                    ' y la ',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    'Política de Privacidad.',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: rojo,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // PROMOCIONES
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 19,
                              child: Checkbox(
                                value: recibirPromociones,
                                activeColor: rojo,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    recibirPromociones = value ?? false;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 5),

                            const Expanded(
                              child: Text(
                                'Deseo recibir promociones y novedades por WhatsApp o SMS.',
                                style: TextStyle(
                                  fontSize: 8,
                                  height: 1.4,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 11),

                        // BOTÓN CREAR CUENTA
                        SizedBox(
                          width: double.infinity,
                          height: 43,
                          child: ElevatedButton(
                            onPressed: crearCuenta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rojo,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: rojo.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.person_add_alt_1,
                                  size: 15,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 13),

                        // SEPARADOR
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'O REGÍSTRATE CON',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Colors.grey[600],
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 11),

                        // GOOGLE Y WHATSAPP
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 33,
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Próximamente: registro con Google.',
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.g_mobiledata,
                                        color: Color(0xFF4285F4),
                                        size: 19,
                                      ),
                                      Text(
                                        'Google',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: SizedBox(
                                height: 33,
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Próximamente: registro con WhatsApp.',
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF0FFF8),
                                    side: const BorderSide(
                                      color: Color(0xFF9BE8C3),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        color: Color(0xFF07945B),
                                        size: 13,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'WhatsApp',
                                        style: TextStyle(
                                          color: Color(0xFF078B56),
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // INICIAR SESIÓN
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                '¿Ya tienes una cuenta? ',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: rojo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 17),

                        const Divider(
                          color: Color(0xFFF0F0F0),
                        ),

                        const SizedBox(height: 7),

                        // PIE DE PÁGINA
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'Cortes Premium • Costillas BBQ • Ahumados',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "© 2026 Asadero Duke's. Todos los derechos reservados.",
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

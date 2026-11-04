
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  static const Color rojo = Color(0xFFB7191B);
  static const Color naranja = Color(0xFFFF5A0A);

  bool ocultarPassword = true;

  // INICIAR SESIÓN
  void iniciarSesion() {
    final String correo = correoController.text.trim();
    final String password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: rojo,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  // ENTRAR COMO INVITADO
  void entrarComoInvitado() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ENCABEZADO
              Stack(
                children: [
                  Container(
                    height: 265,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF3A120D),
                          Color(0xFFB7191B),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 265,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.black.withOpacity(0.65),
                          Colors.black.withOpacity(0.95),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    left: 20,
                    bottom: 29,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                color: naranja,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 9),
                            const Text(
                              'ASADERO',
                              style: TextStyle(
                                color: Color(0xFFFF963C),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "DUKE'S",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'BUENA CARNE, MEJORES MOMENTOS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // FORMULARIO
              Transform.translate(
                offset: const Offset(0, -8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20, 18, 20, 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDFCFB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'SISTEMA DE CLIENTES & PEDIDOS',
                        style: TextStyle(
                          color: rojo,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Text(
                        '¡Hola de nuevo!',
                        style: TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Inicia sesión para pedir cortes al carbón, '
                        'acumular puntos y reservar mesa.',
                        style: TextStyle(
                          color: Color(0xFF686868),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // CORREO
                      const Text(
                        'Correo o Teléfono Celular',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: correoController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText:
                              'ejemplo@correo.com o 300 123 4567',
                          hintStyle: const TextStyle(
                            color: Color(0xFFA4A0A0),
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            size: 18,
                            color: Color(0xFF777777),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE7E3E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE7E3E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: rojo,
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // CONTRASEÑA
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contraseña',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Recuperación de contraseña',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: rojo,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: passwordController,
                        obscureText: ocultarPassword,
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          hintStyle: const TextStyle(
                            color: Color(0xFFA4A0A0),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 17,
                            color: Color(0xFF777777),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                ocultarPassword =
                                    !ocultarPassword;
                              });
                            },
                            icon: Icon(
                              ocultarPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 19,
                              color: Colors.grey,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE7E3E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE7E3E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: rojo,
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // BOTÓN INICIAR SESIÓN
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: rojo,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor:
                                rojo.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.login,
                                  size: 19,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const Spacer(),

                              const Icon(
                                Icons.arrow_forward,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                      // SEPARADOR
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFE8E3DF),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Text(
                              'O CONÉCTATE CON',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Divider(
                              color: Color(0xFFE8E3DF),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      // GOOGLE Y WHATSAPP
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 41,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFFE7E3E0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(11),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'G',
                                      style: TextStyle(
                                        color: Color(0xFF4285F4),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Google',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 9),

                          Expanded(
                            child: SizedBox(
                              height: 41,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFE8F8F0),
                                  side: const BorderSide(
                                    color: Color(0xFF9BEAC7),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(11),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_outlined,
                                      color: Color(0xFF009B72),
                                      size: 16,
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      'WhatsApp',
                                      style: TextStyle(
                                        color: Color(0xFF007F62),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      // PEDIR COMO INVITADO
                      SizedBox(
                        height: 53,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: entrarComoInvitado,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: naranja,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 11,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 31,
                                width: 31,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 18,
                                ),
                              ),

                              const SizedBox(width: 9),

                              const Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pedir a Domicilio como Invitado',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Sin crear cuenta • Envío rápido',
                                      style: TextStyle(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                size: 23,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // REGISTRO
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              '¿Aún no tienes cuenta? ',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 11,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                // Conectar pantalla de registro.
                              },
                              child: const Text(
                                'Regístrate aquí',
                                style: TextStyle(
                                  color: rojo,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PIE DE PÁGINA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFECE8E5),
                    ),
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Cortes Premium  •  Costillas BBQ  •  Ahumados',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 10,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      '© 2026 Asadero Duke’s. Todos los derechos reservados.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

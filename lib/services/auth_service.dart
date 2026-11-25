import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static String? _token;
  static Map<String, dynamic>? _usuario;
  static String? get token => _token;
  static Map<String, dynamic>? get usuario => _usuario;
  static bool get sesionActiva => _token != null;
  static Future<Map<String, dynamic>> registrar({
    required String nombreCompleto,
    required String nombreUsuario,
    required String correo,
    required String password,
    String? telefono,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombreCompleto': nombreCompleto,
        'nombreUsuario': nombreUsuario,
        'correo': correo,
        'password': password,
        'telefono': telefono,
      }),
    ).timeout(const Duration(seconds: 15));
    final data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(
        data['mensaje'] ?? 'Error al registrar usuario',
      );
    }
    return data;
  }
  static Future<Map<String, dynamic>> iniciarSesion({
    required String identificador,
    required String password,
  }) async {
    cerrarSesion();
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'identificador': identificador,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));
    final data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(
        data['mensaje'] ?? 'Error al iniciar sesión',
      );
    }
    final tokenRecibido = data['token'];
    final usuarioRecibido = data['usuario'];
    if (
        tokenRecibido is! String ||
        tokenRecibido.isEmpty ||
        usuarioRecibido is! Map<String, dynamic>
    ) {
      throw Exception(
        'Respuesta inválida del servidor.',
      );
    }
    _token = tokenRecibido;
    _usuario = usuarioRecibido;
    return data;
  }
  static Future<Map<String, dynamic>> obtenerPerfil() async {
    final tokenActual = _token;
    if (tokenActual == null) {
      throw Exception('Debes iniciar sesión.');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/perfil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenActual',
      },
    ).timeout(const Duration(seconds: 15));
    if (_token != tokenActual) {
      throw Exception('La sesión ha cambiado.');
    }
    if (response.statusCode == 401) {
      cerrarSesion();
      throw Exception(
        'Tu sesión ha expirado. Inicia sesión nuevamente.',
      );
    }
    final data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(
        data['mensaje'] ?? 'Error al obtener el perfil',
      );
    }
    _usuario = data['usuario'] as Map<String, dynamic>;
    return _usuario!;
  }
  static void cerrarSesion() {
    _token = null;
    _usuario = null;
  }
}
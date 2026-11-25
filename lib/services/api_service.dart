import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static Future<Map<String, dynamic>> registrar({
    required String nombreCompleto,
    required String nombreUsuario,
    required String correo,
    required String password,
    String? telefono,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/registro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombreCompleto': nombreCompleto,
        'nombreUsuario': nombreUsuario,
        'correo': correo,
        'password': password,
        'telefono': telefono,
      }),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(data['mensaje'] ?? 'Error al registrar usuario');
    }
    return data;
  }
  static Future<Map<String, dynamic>> iniciarSesion({
    required String identificador,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identificador': identificador,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(data['mensaje'] ?? 'Error al iniciar sesión');
    }
    return data;
  }
}
import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorage {
  const ProfileStorage._();

  static const String _profileKeyPrefix = 'asadero_profile_';

  static String keyForEmail(String? email) {
    final normalizedEmail = email?.trim().toLowerCase() ?? '';
    final profileId = normalizedEmail.isEmpty ? 'guest' : normalizedEmail;
    return '$_profileKeyPrefix$profileId';
  }

  static Future<Uint8List?> loadImage(String? email) async {
    final preferences = await SharedPreferences.getInstance();
    final savedProfile = preferences.getString(keyForEmail(email));
    if (savedProfile == null) return null;

    final decoded = jsonDecode(savedProfile);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile data');
    }

    final image = decoded['image'];
    if (image == null || image == '') return null;
    if (image is! String) {
      throw const FormatException('Invalid profile image');
    }

    return base64Decode(image);
  }
}

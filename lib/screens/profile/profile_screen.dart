import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/profile_storage.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.initialEmail,
  });

  final String? initialEmail;

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ==========================================
  // COLORES
  // ==========================================

  static const Color _background = Color(0xFFFFF8F5);
  static const Color _brown = Color(0xFF3F2B24);
  static const Color _muted = Color(0xFF8A756D);
  static const Color _accent = Color(0xFFB52B1C);

  // ==========================================
  // INFORMACIÓN DEL USUARIO
  // ==========================================

  String _name = '';
  String _username = '';
  String _phone = '';
  String _email = '';
  String _rol = '';
  String _estado = '';
  String _fechaRegistro = '';

  String? _error;

  Uint8List? _profileImage;

  bool _isLoading = true;
  bool _isPickingImage = false;

  final ImagePicker _imagePicker = ImagePicker();

  // ==========================================
  // INICIALIZAR PANTALLA
  // ==========================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ==========================================
  // CARGAR PERFIL DESDE POSTGRESQL
  // ==========================================

  Future<void> _loadProfile() async {

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {

      final usuario = await AuthService.obtenerPerfil();

      if (!mounted) return;

      final nombre =
          usuario['nombre_completo']?.toString() ?? '';

      final username =
          usuario['nombre_usuario']?.toString() ?? '';

      final telefono =
          usuario['telefono']?.toString() ?? '';

      final correo =
          usuario['correo']?.toString() ?? '';

      final rol =
          usuario['rol']?.toString() ?? '';

      final estado =
          usuario['estado']?.toString() ?? '';

      final fecha = DateTime.tryParse(
        usuario['fecha_creacion']?.toString() ?? '',
      );

      final fechaRegistro = fecha == null
          ? ''
          : '${fecha.day}/${fecha.month}/${fecha.year}';

      Uint8List? image;

      try {
        image = await ProfileStorage.loadImage(correo);
      } catch (_) {
        image = null;
      }

      if (!mounted) return;

      setState(() {
        _name = nombre;
        _username = username;
        _phone = telefono;
        _email = correo;
        _rol = rol;
        _estado = estado;
        _fechaRegistro = fechaRegistro;
        _profileImage = image;
        _isLoading = false;
      });

    } catch (error) {

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = error.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });

    }
  }

  // ==========================================
  // GUARDAR FOTO DE PERFIL LOCALMENTE
  // ==========================================

  Future<bool> _persistProfileImage(
    Uint8List? image,
  ) async {

    if (_email.isEmpty || !AuthService.sesionActiva) {
      return false;
    }

    final profileKey =
        ProfileStorage.keyForEmail(_email);

    final profile = jsonEncode({
      'name': _name,
      'surname': '',
      'phone': _phone,
      'email': _email,
      'image': image == null
          ? ''
          : base64Encode(image),
    });

    try {

      final preferences =
          await SharedPreferences.getInstance();

      return await preferences.setString(
        profileKey,
        profile,
      );

    } on PlatformException {
      return false;
    }
  }

  // ==========================================
  // OPCIONES DE FOTOGRAFÍA
  // ==========================================

  Future<void> _showPhotoOptions() async {

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
              ),
              title: Text(
                _profileImage == null
                    ? 'Elegir foto'
                    : 'Cambiar foto',
              ),
              onTap: () {
                Navigator.pop(context, 'choose');
              },
            ),

            if (_profileImage != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                ),
                title: const Text('Quitar foto'),
                onTap: () {
                  Navigator.pop(context, 'remove');
                },
              ),

            const SizedBox(height: 8),

          ],
        ),
      ),
    );

    if (!mounted) return;

    if (action == 'choose') {
      await _pickImage();
    } else if (action == 'remove') {
      await _removeImage();
    }
  }

  // ==========================================
  // SELECCIONAR FOTO
  // ==========================================

  Future<void> _pickImage() async {

    setState(() {
      _isPickingImage = true;
    });

    try {

      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (file == null) return;

      final image = await file.readAsBytes();

      if (!mounted) return;

      final saved = await _persistProfileImage(image);

      if (!mounted) return;

      if (saved) {

        setState(() {
          _profileImage = image;
        });

        _showMessage(
          'Foto de perfil guardada correctamente.',
        );

      } else {

        _showMessage(
          'No se pudo guardar la foto.',
        );

      }

    } catch (_) {

      if (mounted) {
        _showMessage(
          'No se pudo seleccionar la fotografía.',
        );
      }

    } finally {

      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }

    }
  }

  // ==========================================
  // ELIMINAR FOTO
  // ==========================================

  Future<void> _removeImage() async {

    final saved = await _persistProfileImage(null);

    if (!mounted) return;

    if (saved) {

      setState(() {
        _profileImage = null;
      });

      _showMessage(
        'Foto de perfil eliminada.',
      );

    } else {

      _showMessage(
        'No se pudo eliminar la fotografía.',
      );

    }
  }

  // ==========================================
  // AVISO DE CAMBIO DE CONTRASEÑA
  // ==========================================

  void _showPasswordNotice() {

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(

        icon: const Icon(
          Icons.lock_outline_rounded,
          color: _accent,
        ),

        title: const Text(
          'Cambiar mi contraseña',
        ),

        content: const Text(
          'El cambio de contraseña estará disponible '
          'próximamente.',
        ),

        actions: [

          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Entendido'),
          ),

        ],
      ),
    );
  }

  // ==========================================
  // MENSAJES
  // ==========================================

  void _showMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _brown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // INTERFAZ PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: _background,

      appBar: AppBar(

        backgroundColor: _background,
        foregroundColor: _brown,
        elevation: 0,

        title: const Text(
          'Mi perfil',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [

          IconButton(
            onPressed: _isLoading
                ? null
                : _loadProfile,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            tooltip: 'Actualizar perfil',
          ),

        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: _accent,
              ),
            )
          : _error != null
              ? _buildError()
              : SafeArea(

                  top: false,

                  child: RefreshIndicator(

                    color: _accent,

                    onRefresh: _loadProfile,

                    child: ListView(

                      physics:
                          const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),

                      padding: const EdgeInsets.fromLTRB(
                        18,
                        8,
                        18,
                        28,
                      ),

                      children: [

                        _buildIdentityCard(),

                        const SizedBox(height: 16),

                        _buildDetailsSection(),

                        const SizedBox(height: 16),

                        _buildSecurityCard(),

                      ],
                    ),
                  ),
                ),
    );
  }

  // ==========================================
  // PANTALLA DE ERROR
  // ==========================================

  Widget _buildError() {

    return Center(
      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.error_outline_rounded,
              color: _accent,
              size: 48,
            ),

            const SizedBox(height: 16),

            Text(
              _error ?? 'No se pudo cargar el perfil.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _brown,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            FilledButton.icon(

              style: FilledButton.styleFrom(
                backgroundColor: _accent,
              ),

              onPressed: AuthService.sesionActiva
                  ? _loadProfile
                  : () => Navigator.pop(context),

              icon: Icon(
                AuthService.sesionActiva
                    ? Icons.refresh
                    : Icons.arrow_back,
              ),

              label: Text(
                AuthService.sesionActiva
                    ? 'Reintentar'
                    : 'Regresar',
              ),

            ),

          ],
        ),
      ),
    );
  }

  // ==========================================
  // TARJETA DE IDENTIDAD
  // ==========================================

  Widget _buildIdentityCard() {

    return Container(

      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(

        children: [

          Semantics(

            button: true,
            label: 'Cambiar foto de perfil',

            child: InkWell(

              customBorder: const CircleBorder(),

              onTap: _isPickingImage
                  ? null
                  : _showPhotoOptions,

              child: Stack(

                children: [

                  CircleAvatar(

                    radius: 43,

                    backgroundColor:
                        const Color(0xFFF9E8DF),

                    backgroundImage:
                        _profileImage == null
                            ? null
                            : MemoryImage(_profileImage!),

                    child: _profileImage == null
                        ? const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFB16A4D),
                            size: 44,
                          )
                        : null,

                  ),

                  Positioned(

                    right: 0,
                    bottom: 0,

                    child: Container(

                      width: 28,
                      height: 28,

                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),

                      child: _isPickingImage

                          ? const Padding(
                              padding: EdgeInsets.all(7),
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )

                          : const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 15,
                            ),

                    ),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(

            _name.isEmpty
                ? 'Tu perfil Duke'
                : _name,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: _brown,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),

          ),

          const SizedBox(height: 5),

          Text(

            _rol.isEmpty
                ? 'Usuario registrado'
                : _rol,

            style: const TextStyle(
              color: _accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),

          ),

          const SizedBox(height: 5),

          const Text(

            'Toca la foto para cambiarla',

            style: TextStyle(
              color: _muted,
              fontSize: 13,
            ),

          ),

        ],
      ),
    );
  }

  // ==========================================
  // INFORMACIÓN PERSONAL
  // ==========================================

  Widget _buildDetailsSection() {

    return Column(

      children: [

        const Align(

          alignment: Alignment.centerLeft,

          child: Padding(

            padding: EdgeInsets.only(
              left: 4,
              bottom: 10,
            ),

            child: Text(

              'Información personal',

              style: TextStyle(
                color: _brown,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),

            ),
          ),
        ),

        _ProfileCard(

          children: [

            _ProfileRow(
              title: 'Nombre completo',
              value: _valueOrHint(
                _name,
                'Sin nombre',
              ),
            ),

            _ProfileRow(
              title: 'Nombre de usuario',
              value: _valueOrHint(
                _username,
                'Sin usuario',
              ),
            ),

            _ProfileRow(
              title: 'Número de teléfono',
              value: _valueOrHint(
                _phone,
                'Sin teléfono',
              ),
            ),

            _ProfileRow(
              title: 'Correo electrónico',
              value: _valueOrHint(
                _email,
                'Sin correo',
              ),
            ),

            _ProfileRow(
              title: 'Tipo de cuenta',
              value: _valueOrHint(
                _rol,
                'Sin información',
              ),
            ),

            _ProfileRow(
              title: 'Estado de cuenta',
              value: _valueOrHint(
                _estado,
                'Sin información',
              ),
            ),

            _ProfileRow(
              title: 'Miembro desde',
              value: _valueOrHint(
                _fechaRegistro,
                'Sin fecha',
              ),
            ),

          ],
        ),

        const SizedBox(height: 12),

        SizedBox(

          width: double.infinity,
          height: 50,

          child: OutlinedButton.icon(

            onPressed: () {

              _showMessage(
                'La edición de datos estará disponible '
                'próximamente.',
              );

            },

            icon: const Icon(
              Icons.edit_outlined,
            ),

            label: const Text(
              'Actualizar información',
            ),

            style: OutlinedButton.styleFrom(

              foregroundColor: _accent,

              side: const BorderSide(
                color: Color(0xFFE7C7B9),
              ),

              backgroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),

            ),
          ),
        ),

      ],
    );
  }

  // ==========================================
  // SEGURIDAD
  // ==========================================

  Widget _buildSecurityCard() {

    return _ProfileCard(

      children: [

        _ProfileRow(

          title: 'Cambiar mi contraseña',

          value: '',

          onTap: _showPasswordNotice,

          showValue: false,

        ),

      ],
    );
  }

  String _valueOrHint(
    String value,
    String hint,
  ) {
    return value.isEmpty ? hint : value;
  }
}

// ==========================================
// TARJETA DEL PERFIL
// ==========================================

class _ProfileCard extends StatelessWidget {

  const _ProfileCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

      ),

      child: Column(
        children: children,
      ),

    );
  }
}

// ==========================================
// FILAS DE INFORMACIÓN
// ==========================================

class _ProfileRow extends StatelessWidget {

  const _ProfileRow({
    required this.title,
    required this.value,
    this.onTap,
    this.showValue = true,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool showValue;

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      child: Container(

        constraints: const BoxConstraints(
          minHeight: 68,
        ),

        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),

        decoration: const BoxDecoration(

          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF1EAE6),
            ),
          ),

        ),

        child: Row(

          children: [

            Expanded(

              child: Text(

                title,

                style: const TextStyle(
                  color: Color(0xFF241815),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),

              ),
            ),

            if (showValue) ...[

              const SizedBox(width: 8),

              Flexible(

                child: Text(

                  value,

                  textAlign: TextAlign.end,

                  style: const TextStyle(
                    color: Color(0xFF8A756D),
                    fontSize: 14,
                  ),

                ),
              ),

            ],

            if (onTap != null) ...[

              const SizedBox(width: 5),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFAA9A93),
                size: 22,
              ),

            ],

          ],
        ),
      ),
    );
  }
}
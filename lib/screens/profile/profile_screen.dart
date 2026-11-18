import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/profile_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _background = Color(0xFFFFF8F5);
  static const Color _brown = Color(0xFF3F2B24);
  static const Color _muted = Color(0xFF8A756D);
  static const Color _accent = Color(0xFFB52B1C);

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  late final String _profileKey;
  String _name = '';
  String _surname = '';
  String _phone = '';
  String _email = '';
  Uint8List? _profileImage;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    final accountEmail = widget.initialEmail?.trim() ?? '';
    _profileKey = ProfileStorage.keyForEmail(accountEmail);
    _email = accountEmail;
    _emailController.text = accountEmail;
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedProfile = preferences.getString(_profileKey);

      if (savedProfile != null) {
        final decoded = jsonDecode(savedProfile);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Invalid profile data');
        }

        _name = _readProfileString(decoded, 'name');
        _surname = _readProfileString(decoded, 'surname');
        _phone = _readProfileString(decoded, 'phone');
        _email = _readProfileString(
          decoded,
          'email',
          fallback: widget.initialEmail?.trim() ?? '',
        );
        final imageData = _readProfileString(decoded, 'image');
        _profileImage = imageData.isEmpty ? null : base64Decode(imageData);
      }

      _updateControllers();
      if (mounted) setState(() => _isLoading = false);
    } on FormatException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('No se pudo leer la información guardada del perfil.');
    } on PlatformException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('No se pudo cargar el perfil en este dispositivo.');
    }
  }

  String _readProfileString(
    Map<String, dynamic> profile,
    String key, {
    String fallback = '',
  }) {
    final value = profile[key];
    if (value == null) return fallback;
    if (value is String) return value;
    throw FormatException('Invalid profile field: $key');
  }

  void _updateControllers() {
    _nameController.text = _name;
    _surnameController.text = _surname;
    _phoneController.text = _phone;
    _emailController.text = _email;
  }

  Future<bool> _persistProfile({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required Uint8List? image,
  }) async {
    final profile = jsonEncode({
      'name': name,
      'surname': surname,
      'phone': phone,
      'email': email,
      'image': image == null ? '' : base64Encode(image),
    });

    try {
      return await (await SharedPreferences.getInstance()).setString(
        _profileKey,
        profile,
      );
    } on PlatformException {
      return false;
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final saved = await _persistProfile(
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      image: _profileImage,
    );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (saved) {
        _name = name;
        _surname = surname;
        _phone = phone;
        _email = email;
        _isEditing = false;
      }
    });
    _showMessage(
      saved
          ? 'Información guardada en este dispositivo.'
          : 'No se pudieron guardar los cambios. Inténtalo de nuevo.',
    );
  }

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
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(
                _profileImage == null ? 'Elegir foto' : 'Cambiar foto',
              ),
              onTap: () => Navigator.pop(context, 'choose'),
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Quitar foto'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (action == 'choose') {
      await _pickImage();
    } else if (action == 'remove') {
      await _removeImage();
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (file == null) return;

      final image = await file.readAsBytes();
      final saved = await _persistProfile(
        name: _name,
        surname: _surname,
        phone: _phone,
        email: _email,
        image: image,
      );
      if (!mounted) return;
      if (saved) {
        setState(() => _profileImage = image);
        _showMessage('Foto de perfil guardada en este dispositivo.');
      } else {
        _showMessage('No se pudo guardar la foto. Inténtalo de nuevo.');
      }
    } on PlatformException {
      if (mounted) {
        _showMessage('No se pudo seleccionar la foto.');
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _removeImage() async {
    final saved = await _persistProfile(
      name: _name,
      surname: _surname,
      phone: _phone,
      email: _email,
      image: null,
    );
    if (!mounted) return;
    if (saved) {
      setState(() => _profileImage = null);
      _showMessage('Foto de perfil eliminada.');
    } else {
      _showMessage('No se pudo quitar la foto. Inténtalo de nuevo.');
    }
  }

  void _showPasswordNotice() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock_outline_rounded, color: _accent),
        title: const Text('Cambiar mi contraseña'),
        content: const Text(
          'La cuenta todavía no tiene un servicio de autenticación conectado '
          'para guardar este cambio.',
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _accent),
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _brown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : SafeArea(
              top: false,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  _buildIdentityCard(),
                  const SizedBox(height: 16),
                  if (_isEditing) _buildEditForm() else _buildDetailsSection(),
                  const SizedBox(height: 16),
                  _buildSecurityCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
              onTap: _isPickingImage ? null : _showPhotoOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 43,
                    backgroundColor: const Color(0xFFF9E8DF),
                    backgroundImage: _profileImage == null
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
                              child: CircularProgressIndicator(
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
            _name.isEmpty && _surname.isEmpty
                ? 'Tu perfil Duke'
                : '$_name $_surname'.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _brown,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Toca la foto para cambiarla',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        _ProfileCard(
          children: [
            _ProfileRow(
              title: 'Nombre',
              value: _valueOrHint(_name, 'Agregar nombre'),
            ),
            _ProfileRow(
              title: 'Apellido',
              value: _valueOrHint(_surname, 'Agregar apellido'),
            ),
            _ProfileRow(
              title: 'Número de teléfono',
              value: _valueOrHint(_phone, 'Agregar teléfono'),
            ),
            _ProfileRow(
              title: 'Correo electrónico',
              value: _valueOrHint(_email, 'Agregar correo'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Actualizar información'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _accent,
              side: const BorderSide(color: Color(0xFFE7C7B9)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return _ProfileCard(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actualizar información',
                style: TextStyle(
                  color: _brown,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Edita tus datos y guarda los cambios.',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                title: 'Nombre',
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (value) => _required(value, 'Ingresa tu nombre'),
              ),
              _buildInput(
                title: 'Apellido',
                controller: _surnameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (value) => _required(value, 'Ingresa tu apellido'),
              ),
              _buildInput(
                title: 'Número de teléfono',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildInput(
                title: 'Correo electrónico',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: _muted,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          _updateControllers();
                          setState(() => _isEditing = false);
                        },
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: FilledButton.styleFrom(backgroundColor: _accent),
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Tus datos se guardan en este dispositivo.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required String title,
    required TextEditingController controller,
    required TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        readOnly: readOnly,
        showCursor: !readOnly,
        enableInteractiveSelection: !readOnly,
        decoration: InputDecoration(
          labelText: title,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFFFFBF9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8DDD7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8DDD7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _accent, width: 1.4),
          ),
        ),
      ),
    );
  }

  String? _required(String? value, String message) =>
      (value?.trim().isEmpty ?? true) ? message : null;

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

  String _valueOrHint(String value, String hint) =>
      value.isEmpty ? hint : value;
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

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
        constraints: const BoxConstraints(minHeight: 68),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF1EAE6))),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

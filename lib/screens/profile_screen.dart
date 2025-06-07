import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:luxnewyork_flutter_app/screens/login_screen.dart';
import 'package:luxnewyork_flutter_app/screens/preferences_screen.dart';
import 'package:luxnewyork_flutter_app/screens/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text("Confirm Logout", style: textTheme.titleLarge),
        content: Text("Are you sure you want to log out?",
            style: textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // NOTE Remove token and user data from SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              final email = prefs.getString('user_email');
              await prefs.remove('auth_token');
              await prefs.remove('user_name');
              if (email != null) {
                await prefs.remove('user_email');
                await prefs.remove('profile_photo_$email');
              }

              // NOTE Navigate to login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text("Logout",
                style:
                    textTheme.labelLarge?.copyWith(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Profile", style: textTheme.headlineSmall)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const _UserProfileSection(),
              const SizedBox(height: 30),
              const _ProfileMenu(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: textTheme.labelLarge,
                ),
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileSection extends StatefulWidget {
  const _UserProfileSection();

  @override
  State<_UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<_UserProfileSection> {
  File? _profileImage;
  String? _email;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final name = prefs.getString('user_name');
    String? imagePath;
    if (email != null) {
      imagePath = prefs.getString('profile_photo_$email');
    }
    setState(() {
      _email = email;
      _name = name;
      if (imagePath != null && File(imagePath).existsSync()) {
        _profileImage = File(imagePath);
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (picked == null) return;
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/profile_photo_$email.png';

    final savedImage = await File(picked.path).copy(path);
    await prefs.setString('profile_photo_$email', savedImage.path);

    setState(() {
      _profileImage = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final avatar = _profileImage != null
        ? CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: FileImage(_profileImage!),
          )
        : CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              _name != null && _name!.isNotEmpty
                  ? _name![0].toUpperCase()
                  : '?',
              style: textTheme.headlineMedium,
            ),
          );

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: avatar,
        ),
        const SizedBox(height: 10),
        if (_name != null) Text(_name!, style: textTheme.titleMedium),
        if (_email != null)
          Text(_email!,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _buildMenuItem(Icons.language, "Preferences", textTheme, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PreferencesScreen(),
            ),
          );
        }),
        _buildMenuItem(Icons.info, "About", textTheme, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AboutScreen(),
            ),
          );
        }),
        _buildMenuItem(Icons.settings, "Account Settings", textTheme, () {}),
      ],
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, TextTheme textTheme, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/screens/login_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   void _showLogoutDialog(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final textTheme = theme.textTheme;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: colorScheme.surface,
//         title: Text("Confirm Logout", style: textTheme.titleLarge),
//         content: Text("Are you sure you want to log out?",
//             style: textTheme.bodyMedium),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel", style: textTheme.labelLarge),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//               );
//             },
//             child: Text("Logout",
//                 style:
//                     textTheme.labelLarge?.copyWith(color: colorScheme.error)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(title: Text("Profile", style: textTheme.headlineSmall)),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(), // Adds smooth scrolling effect
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const _UserProfileSection(),
//               const SizedBox(height: 30),
//               const _ProfileMenu(),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () => _showLogoutDialog(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colorScheme.error,
//                   foregroundColor: colorScheme.onError,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   textStyle: textTheme.labelLarge,
//                 ),
//                 child: const Text("Logout"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _UserProfileSection extends StatelessWidget {
//   const _UserProfileSection();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     final colorScheme = theme.colorScheme;

//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: colorScheme.primaryContainer,
//           backgroundImage: const AssetImage("assets/images/user.webp"),
//         ),
//         const SizedBox(height: 10),
//         Text("Hirusha Gunasena", style: textTheme.headlineSmall),
//         Text("hirushagunasena@gmail.com",
//             style: textTheme.bodyMedium
//                 ?.copyWith(color: colorScheme.onSurfaceVariant)),
//       ],
//     );
//   }
// }

// class _ProfileMenu extends StatelessWidget {
//   const _ProfileMenu();

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Column(
//       children: [
//         _buildMenuItem(Icons.shopping_bag, "My Orders", textTheme, () {}),
//         _buildMenuItem(Icons.language, "Preferences", textTheme, () {}),
//         _buildMenuItem(Icons.credit_card, "Payment Methods", textTheme, () {}),
//         _buildMenuItem(Icons.settings, "Account Settings", textTheme, () {}),
//       ],
//     );
//   }

//   Widget _buildMenuItem(
//       IconData icon, String title, TextTheme textTheme, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 28),
//       title: Text(title, style: textTheme.bodyLarge),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//       onTap: onTap,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/login_screen.dart';
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

              // ✅ Remove token from SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');

              // ✅ Navigate to login
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

class _UserProfileSection extends StatelessWidget {
  const _UserProfileSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: const AssetImage("assets/images/user.webp"),
        ),
        const SizedBox(height: 10),
        Text("Hirusha Gunasena", style: textTheme.headlineSmall),
        Text("hirushagunasena@gmail.com",
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
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
        _buildMenuItem(Icons.shopping_bag, "My Orders", textTheme, () {}),
        _buildMenuItem(Icons.language, "Preferences", textTheme, () {}),
        _buildMenuItem(Icons.credit_card, "Payment Methods", textTheme, () {}),
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

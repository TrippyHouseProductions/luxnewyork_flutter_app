import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/utils/snackbar_service.dart';
import 'package:luxnewyork_flutter_app/utils/validators.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      showAppSnackBar(
        const SnackBar(content: Text('Password Reset Email Sent!')),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: theme.colorScheme.surface),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(theme),
                _buildEmailField(),
                _buildResetButton(),
                _buildBackToLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Title & Instructions
  Widget _buildTitle(ThemeData theme) {
    return Column(
      children: [
        Text("Forgot Password", style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          "Enter your email to receive a password reset link",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Email Field
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 0),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) return "Please enter your email";
            return isValidEmail(value) ? null : "Enter a valid email";
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Send Reset Link Button
  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _resetPassword,
        child: const Text("Send Reset Link"),
      ),
    );
  }

  // Back to Login
  Widget _buildBackToLogin() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Back to Login",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

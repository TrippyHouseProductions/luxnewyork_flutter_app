import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;

  //ANCHOR - Use of notifications
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up Successful! Please Login')),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle(theme),
                _buildTextField("Full Name", _nameController,
                    "Please enter your full name"),
                _buildEmailField(),
                _buildPasswordField("Password", _passwordController),
                _buildPasswordField(
                    "Confirm Password", _confirmPasswordController,
                    confirm: true),
                const SizedBox(height: 20),
                _buildSignupButton(),
                _buildLoginOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Title
  Widget _buildTitle(ThemeData theme) {
    return Column(
      children: [
        Text("Sign Up", style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text("Create an account to get started",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
      ],
    );
  }

  // Text Field
  Widget _buildTextField(
      String label, TextEditingController controller, String errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 0),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(),
          validator: (value) => value!.isEmpty ? errorMessage : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Email Field //ANCHOR - Use of simple validation
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email"),
        const SizedBox(height: 0),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            }
            // email validation //ANCHOR - Use of email validation
            final emailRegex =
                RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
            if (!emailRegex.hasMatch(value)) {
              return "Enter a valid email";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Password Field
  Widget _buildPasswordField(String label, TextEditingController controller,
      {bool confirm = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 0),
        TextFormField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          //ANCHOR - Use of password validation
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a password";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            if (confirm && value != _passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Sign Up Button
  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text("Sign Up"),
      ),
    );
  }

  // Login Option //ANCHOR - Use of linking
  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Login",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

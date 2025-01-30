import 'package:flutter/material.dart';
import 'package:luxnewyorkapp/screens/main_screen.dart';
import 'package:luxnewyorkapp/screens/signup_screen.dart';
import 'package:luxnewyorkapp/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle(theme),
                _buildEmailField(),
                _buildPasswordField(),
                _buildForgotPassword(),
                _buildLoginButton(),
                _buildSignupOption(),
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
        Text("Sign In", style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text("Hi! Welcome back, you’ve been missed",
            style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
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
            // email validation
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

  // Password Field //ANCHOR - Use of simple validation
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password"),
        const SizedBox(height: 0), //5 looked good
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Forgot Password //ANCHOR - Use of linking
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToForgotPassword,
        child: const Text("Forgot Password?"),
      ),
    );
  }

  // Login Button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text("Login"),
      ),
    );
  }

  // Signup Option //ANCHOR - Use of linking
  Widget _buildSignupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don’t have an account?",
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        TextButton(
          onPressed: _navigateToSignup,
          child: const Text("Sign Up",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/auth_services.dart'; // Fixed import - removed 's'

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() =>
      ForgotPasswordScreenState(); // Made public
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _message = 'Please enter your email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final success = await _authService.resetPassword(_emailController.text);

    setState(() {
      _isLoading = false;
      _message = success
          ? 'Password reset email sent! Check your inbox.'
          : 'Failed to send reset email. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Send Reset Link'),
              ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.contains('Failed')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

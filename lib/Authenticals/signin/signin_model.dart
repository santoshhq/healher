import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    // Validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Please enter both email and password';
      notifyListeners();
      return;
    }

    // Email validation
    if (!_isValidEmail(emailController.text)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call - Replace with your actual authentication logic
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual sign-in logic here
      // Example: await authService.signIn(emailController.text, passwordController.text);

      _isLoading = false;
      notifyListeners();

      // Navigate to home on success
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign in failed. Please try again.';
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate Google Sign In - Replace with your actual Google authentication logic
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual Google Sign-In logic here
      // Example: await authService.signInWithGoogle();

      _isLoading = false;
      notifyListeners();

      // Navigate to home on success
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Google sign in failed. Please try again.';
      notifyListeners();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

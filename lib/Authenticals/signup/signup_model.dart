import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  bool _acceptTerms = false;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  String? get errorMessage => _errorMessage;
  bool get acceptTerms => _acceptTerms;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void toggleAcceptTerms(bool? value) {
    _acceptTerms = value ?? false;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    // Validate inputs
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      notifyListeners();
      return;
    }

    // Name validation
    if (nameController.text.length < 2) {
      _errorMessage = 'Please enter a valid name';
      notifyListeners();
      return;
    }

    // Email validation
    if (!_isValidEmail(emailController.text)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return;
    }

    // Password validation
    if (passwordController.text.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return;
    }

    // Confirm password validation
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return;
    }

    // Terms acceptance validation
    if (!_acceptTerms) {
      _errorMessage = 'Please accept the terms and conditions';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call - Replace with your actual registration logic
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual sign-up logic here
      // Example: await authService.signUp(
      //   nameController.text,
      //   emailController.text,
      //   passwordController.text
      // );

      _isLoading = false;
      notifyListeners();

      // Navigate to sign in or home on success
      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please sign in.'),
            backgroundColor: Color(0xFFD81B60),
          ),
        );
        // Navigate to sign in page
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign up failed. Please try again.';
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

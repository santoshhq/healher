import 'package:flutter/material.dart';

class PasswordResetModel extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String email = '';
  String otp = '';

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  String? get errorMessage => _errorMessage;

  void setCredentials(String email, String otp) {
    this.email = email;
    this.otp = otp;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    // Validate inputs
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _errorMessage = 'Please enter both password fields';
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

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to reset password
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual password reset logic here
      // Example: await authService.resetPassword(email, otp, passwordController.text);

      _isLoading = false;
      notifyListeners();

      // Navigate to sign in page
      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully! Please sign in.'),
            backgroundColor: Color(0xFFD81B60),
          ),
        );
        // Navigate to sign in page and clear all previous routes
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to reset password. Please try again.';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

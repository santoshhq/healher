import 'package:flutter/material.dart';

class ForgotPasswordModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendOTP(BuildContext context) async {
    // Validate email
    if (emailController.text.isEmpty) {
      _errorMessage = 'Please enter your email address';
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
      // Simulate API call to send OTP
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual send OTP logic here
      // Example: await authService.sendPasswordResetOTP(emailController.text);

      _isLoading = false;
      notifyListeners();

      // Navigate to OTP verification screen
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          '/otp-verify',
          arguments: emailController.text,
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send OTP. Please try again.';
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
    super.dispose();
  }
}

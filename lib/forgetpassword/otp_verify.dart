import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPVerifyModel extends ChangeNotifier {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;
  String email = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String email) {
    this.email = email;
  }

  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP(BuildContext context) async {
    final otp = getOTP();

    // Validate OTP
    if (otp.length != 4) {
      _errorMessage = 'Please enter the 4-digit OTP';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to verify OTP
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual OTP verification logic here
      // Example: await authService.verifyOTP(email, otp);

      _isLoading = false;
      notifyListeners();

      // Navigate to password reset screen
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          '/password-reset',
          arguments: {'email': email, 'otp': otp},
        );
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid OTP. Please try again.';
      notifyListeners();
    }
  }

  Future<void> resendOTP() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to resend OTP
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your actual resend OTP logic here
      // Example: await authService.resendOTP(email);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to resend OTP. Please try again.';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

class OTPVerifyWidget extends StatelessWidget {
  const OTPVerifyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return ChangeNotifierProvider(
      create: (_) => OTPVerifyModel()..setEmail(email),
      child: const OTPVerifyScreen(),
    );
  }
}

class OTPVerifyScreen extends StatelessWidget {
  const OTPVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OTPVerifyModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFC1E3), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD81B60)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        size: 50,
                        color: Color(0xFFD81B60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  Text(
                    'Verify OTP',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD81B60),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 4-digit code sent to\n${model.email}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.pink[700],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: model.otpControllers[index],
                            focusNode: model.focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (value) {
                              model.clearError();
                              if (value.isNotEmpty && index < 3) {
                                model.focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                model.focusNodes[index - 1].requestFocus();
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD81B60),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Resend OTP
                  Center(
                    child: TextButton(
                      onPressed: model.isLoading
                          ? null
                          : () => model.resendOTP(),
                      child: Text(
                        'Resend OTP',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD81B60),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error Message
                  if (model.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              model.errorMessage!,
                              style: GoogleFonts.poppins(
                                color: Colors.red[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Submit Button
                  ElevatedButton(
                    onPressed: model.isLoading
                        ? null
                        : () => model.verifyOTP(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD81B60), // Dark pink
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.pink.withOpacity(0.5),
                    ),
                    child: model.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

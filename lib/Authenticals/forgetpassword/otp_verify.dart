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

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    const bgGradient = LinearGradient(
      colors: [Color(0xFFFFF1F6), Color(0xFFFFDCE7)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.pink.shade700),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.28,
                          height: width * 0.28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.shade100,
                                blurRadius: 20,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mail_outline,
                            size: 50,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        Text(
                          'Verify OTP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter the 4-digit code sent to\n${model.email}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.pink.shade900.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.pink.shade100,
                                  ),
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
                                      model.focusNodes[index + 1]
                                          .requestFocus();
                                    }
                                    if (value.isEmpty && index > 0) {
                                      model.focusNodes[index - 1]
                                          .requestFocus();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade700,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: model.isLoading
                              ? null
                              : () => model.resendOTP(),
                          child: Text(
                            'Resend OTP',
                            style: GoogleFonts.poppins(
                              color: Colors.pink.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (model.errorMessage != null)
                          const SizedBox(height: 10),
                        if (model.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    model.errorMessage!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: model.isLoading
                                ? null
                                : () => model.verifyOTP(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                            child: model.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    'Submit',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

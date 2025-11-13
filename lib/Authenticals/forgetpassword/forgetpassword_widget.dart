import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgetpassword_model.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordModel(),
      child: const ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ForgotPasswordModel>(context);

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
              // Back Button
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
                        // Icon
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
                            Icons.lock_reset,
                            size: 50,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        // Title
                        Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter your registered email to receive OTP',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.pink.shade900.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        // Email Field
                        _inputField(
                          controller: model.emailController,
                          hint: "Email",
                          icon: Icons.email_outlined,
                          model: model,
                        ),

                        // Error message if any
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

                        const SizedBox(height: 20),

                        // Next Button
                        _primaryButton(
                          label: "Next",
                          loading: model.isLoading,
                          onTap: model.isLoading
                              ? null
                              : () => model.sendOTP(context),
                        ),

                        const SizedBox(height: 25),

                        // Back to Sign In
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Remember your password? ',
                              style: GoogleFonts.poppins(
                                color: Colors.pink.shade900.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.pink.shade700,
                                ),
                              ),
                            ),
                          ],
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ForgotPasswordModel model,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => model.clearError(),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.pink.shade600),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.pink.shade900),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required bool loading,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

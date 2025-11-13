import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passwordreset_model.dart';

class PasswordResetWidget extends StatelessWidget {
  const PasswordResetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ??
        {};
    final email = args['email'] ?? '';
    final otp = args['otp'] ?? '';

    return ChangeNotifierProvider(
      create: (_) => PasswordResetModel()..setCredentials(email, otp),
      child: const PasswordResetScreen(),
    );
  }
}

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PasswordResetModel>(context);

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
                            Icons.lock_open,
                            size: 50,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        Text(
                          'Set New Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Create a strong password for your account',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.pink.shade900.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: height * 0.04),

                        _inputField(
                          controller: model.passwordController,
                          hint: "New Password",
                          icon: Icons.lock_outline,
                          model: model,
                          obscure: model.obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              model.obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.pink.shade700,
                            ),
                            onPressed: model.togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _inputField(
                          controller: model.confirmPasswordController,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                          model: model,
                          obscure: model.obscureConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              model.obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.pink.shade700,
                            ),
                            onPressed: model.toggleConfirmPasswordVisibility,
                          ),
                        ),

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

                        _primaryButton(
                          label: "Confirm",
                          loading: model.isLoading,
                          onTap: model.isLoading
                              ? null
                              : () => model.resetPassword(context),
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
    required PasswordResetModel model,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: (_) => model.clearError(),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.pink.shade600),
          suffixIcon: suffix,
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

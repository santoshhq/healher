import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_model.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpModel(),
      child: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignUpModel>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // 🌸 Soft Wellness Gradient
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
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🌺 Logo
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
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/healhericon.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  // 🌸 Clean Title
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Sign up to start your wellness journey",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.pink.shade900.withOpacity(0.7),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  // 📌 Name Field
                  _inputField(
                    controller: model.nameController,
                    hint: "Full Name",
                    icon: Icons.person_outline,
                    model: model,
                  ),
                  const SizedBox(height: 18),

                  // 📌 Email Field
                  _inputField(
                    controller: model.emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    model: model,
                  ),
                  const SizedBox(height: 18),

                  // 🔒 Password Field
                  _inputField(
                    controller: model.passwordController,
                    hint: "Password",
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

                  // 🔒 Confirm Password Field
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

                  const SizedBox(height: 12),

                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: model.acceptTerms,
                        onChanged: model.toggleAcceptTerms,
                        activeColor: Colors.pink.shade600,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              model.toggleAcceptTerms(!model.acceptTerms),
                          child: Text(
                            'I agree to Terms and Conditions',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.pink.shade900.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Error message if any
                  if (model.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
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
                    const SizedBox(height: 15),
                  ],

                  const SizedBox(height: 10),

                  // 🌺 Sign Up Button
                  _primaryButton(
                    label: "Sign Up",
                    loading: model.isLoading,
                    onTap: model.isLoading ? null : () => model.signUp(context),
                  ),

                  const SizedBox(height: 25),

                  // Sign In Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.pink.shade900.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/'),
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
      ),
    );
  }

  // 🌸 Modern Input Field
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required SignUpModel model,
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

  // 🌺 Primary Button
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

import 'package:flutter/material.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/core/resources/color_manager.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isOtpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _showSnack("Please enter your phone number");
      return;
    }
    setState(() => isLoading = true);
    await _authService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (id) {
        setState(() {
          isLoading = false;
          isOtpSent = true;
        });
      },
      onVerificationFailed: (err) {
        setState(() => isLoading = false);
        _showSnack(err);
      },
    );
  }

  void _resetPassword() async {
    String otp = otpController.text.trim();
    String newPass = newPasswordController.text.trim();
    if (otp.isEmpty || newPass.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }
    setState(() => isLoading = true);
    final result = await _authService.updatePasswordWithOtp(
      otp: otp,
      newPassword: newPass,
    );
    setState(() => isLoading = false);
    if (result == "success") {
      _showSnack("Password reset successfully!");
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      _showSnack(result ?? "An error occurred");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: ColorManager.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorManager.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Forget Password', style: TextStyle(color: ColorManager.yellow)),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: ColorManager.yellow))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/forgot_password_img.png", height: height * 0.3),
              const SizedBox(height: 25),
              if (!isOtpSent) ...[
                _buildTextField(phoneController, "Phone Number", Icons.phone, TextInputType.phone),
                const SizedBox(height: 25),
                _buildButton("Send Code", _sendOtp),
              ] else ...[
                _buildTextField(otpController, "6-digit Code", Icons.lock_clock, TextInputType.number),
                const SizedBox(height: 20),
                _buildTextField(newPasswordController, "New Password", Icons.lock, TextInputType.text, isObscure: true),
                const SizedBox(height: 25),
                _buildButton("Reset Password", _resetPassword),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, TextInputType type, {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: ColorManager.white),
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: ColorManager.darkGrey,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.yellow,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: ColorManager.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}
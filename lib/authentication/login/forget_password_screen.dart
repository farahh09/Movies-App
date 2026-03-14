import 'package:flutter/material.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/utils/app_colors.dart';

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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellowColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Forget Password',
          style: TextStyle(color: AppColors.yellowColor),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellowColor))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/forgot-password.png", height: height * 0.3),
              const SizedBox(height: 25),
              if (!isOtpSent) ...[
                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone Number (e.g., +20...)",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF282A28),
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      padding: EdgeInsets.symmetric(vertical: height * 0.0175),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: _sendOtp,
                    child: const Text(
                      "Send Code",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ] else ...[
                TextFormField(
                  controller: otpController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "6-digit Code",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF282A28),
                    prefixIcon: const Icon(Icons.lock_clock, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF282A28),
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      padding: EdgeInsets.symmetric(vertical: height * 0.0175),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: _resetPassword,
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
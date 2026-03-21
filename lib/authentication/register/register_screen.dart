import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/core/routes_manager/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final AuthService _authService = AuthService();

  String selectedAvatar = "assets/images/gamer (1) (1).png";
  final List<String> avatars = [
    "assets/images/gamer (1) (2).png",
    "assets/images/gamer (1) (1).png",
    "assets/images/gamer (1) (3).png",
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirm = confirmPasswordController.text.trim();
    final String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty || phone.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }

    if (password != confirm) {
      _showSnack("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    final result = await _authService.registerWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
      imagePath: selectedAvatar,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result == "success") {
      _showSnack("Account created successfully");
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    } else {
      _showSnack(result ?? "An error occurred");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellowColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Register",
          style: TextStyle(color: AppColors.yellowColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellowColor))
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: avatars.map((path) {
                bool isSelected = selectedAvatar == path;
                return GestureDetector(
                  onTap: () => setState(() => selectedAvatar = path),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.yellowColor : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: isSelected ? 40 : 30,
                      backgroundImage: AssetImage(path),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text("Select Avatar", style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTextField(
                    controller: nameController,
                    hint: "Name",
                    image: "assets/images/icon _Identification_.png",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: emailController,
                    hint: "Email",
                    image: "assets/images/Vector.png",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    hint: "Password",
                    image: "assets/images/passsword.png",
                    obscure: _obscurePassword,
                    showSuffix: true,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    image: "assets/images/passsword.png",
                    obscure: _obscureConfirmPassword,
                    showSuffix: true,
                    onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: phoneController,
                    hint: "Phone Number",
                    image: "assets/images/phon.png",
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: _registerUser,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: "Already Have Account ? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(color: AppColors.yellowColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String image,
    bool obscure = false,
    bool showSuffix = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(image, width: 20, height: 20),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: showSuffix
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          onPressed: onToggle,
        )
            : null,
      ),
    );
  }
}
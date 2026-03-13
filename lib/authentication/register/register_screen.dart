import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/services/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isEnglish = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellowColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Register",
          style: TextStyle(
            color: AppColors.yellowColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
              children: [
                _buildAvatar("assets/images/gamer (1) (2).png", 60),
                _buildAvatar("assets/images/gamer (1) (1).png", 100),
                _buildAvatar("assets/images/gamer (1) (3).png", 60),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Avatar",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
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
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    image: "assets/images/passsword.png",
                    obscure: _obscureConfirmPassword,
                    showSuffix: true,
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: _registerUser,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                          style: const TextStyle(
                            color: AppColors.yellowColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 100,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.yellowColor, width: 2),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          alignment: isEnglish
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEnglish = true;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage('assets/images/LR.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEnglish = false;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage('assets/images/EG.png'),
                              ),
                            ),
                          ],
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

  void _registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmPasswordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty || name.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }

    if (password != confirm) {
      _showSnack("Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await _authService.registerWithEmail(
      email: email,
      password: password,
      name: name,
    );

    setState(() {
      isLoading = false;
    });

    if (result == "success") {
      _showSnack("Account created successfully");
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    } else {
      _showSnack(result ?? "An error occurred");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildAvatar(String imagePath, double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(imagePath),
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
          child: Image.asset(
            image,
            width: 20,
            height: 20,
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: showSuffix
            ? IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: onToggle,
        )
            : null,
      ),
    );
  }
}
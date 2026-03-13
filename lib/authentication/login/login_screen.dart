import 'package:flutter/material.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/home/widgets/custom_elevated_button.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellowColor))
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(AppAssets.loginImage),
              ),
              SizedBox(height: height * 0.065),

              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              TextFormField(
                controller: passwordController,
                obscureText: isObscured,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.forgetPasswordRoute);
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.yellowColor,
                          fontWeight: FontWeight.w600, // semi-bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              CustomElevatedButton(
                text: "Login",
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.blackColor,
                ),
                onPressed: _login,
              ),

              SizedBox(height: height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t Have Account ?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.signUpRoute);
                    },
                    child: const Text(
                      "Create One",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.yellowColor,
                        fontWeight: FontWeight.w600, // semi-bold
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.yellowColor,
                      thickness: 0.8,
                      indent: width * 0.09,
                      endIndent: width * 0.06,
                    ),
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.yellowColor,
                      fontWeight: FontWeight.w600, // semi-bold
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.yellowColor,
                      thickness: 0.8,
                      indent: width * 0.06,
                      endIndent: width * 0.09,
                    ),
                  )
                ],
              ),

              SizedBox(height: height * 0.02),

              SizedBox(
                width: width * 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowColor,
                    padding: EdgeInsets.symmetric(vertical: height * 0.0175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  onPressed: _loginWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.googleIcon),
                      SizedBox(width: width * 0.03),
                      const Text(
                        "Login With Google",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.blackColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    setState(() {
      isLoading = false;
    });

    if (result == "success") {
      Navigator.pushReplacementNamed(context, Routes.mainRoute);
    } else {
      _showSnack(result ?? "Login failed");
    }
  }

  void _loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    final result = await _authService.signInWithGoogle();

    setState(() {
      isLoading = false;
    });

    if (result == "success") {
      Navigator.pushReplacementNamed(context, Routes.mainRoute);
    } else if (result != "Cancelled") {
      _showSnack(result ?? "Google Login failed");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
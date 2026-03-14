import 'package:flutter/material.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/home/widgets/custom_elevated_button.dart';
import 'package:movies/home/widgets/custom_text_field.dart';
import 'package:movies/utils/app_colors.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  int selectedIndex = 0;
  bool showAvatars = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  final List<String> avatars = [
    "assets/images/gamer (1) (1).png",
    "assets/images/gamer (1) (2).png",
    "assets/images/gamer (1) (3).png",
    "assets/images/gamer (1) (4).png",
    "assets/images/gamer (1) (5).png",
    "assets/images/gamer (1) (6).png",
    "assets/images/gamer (1) (7).png",
    "assets/images/gamer (1) (8).png",
    "assets/images/gamer (1) (9).png",
  ];

  @override
  void initState() {
    super.initState();
    nameController.text = _authService.currentUser?.displayName ?? "";

    String? currentPhoto = _authService.currentUser?.photoURL;
    if (currentPhoto != null && avatars.contains(currentPhoto)) {
      selectedIndex = avatars.indexOf(currentPhoto);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.yellowColor,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellowColor))
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              GestureDetector(
                onTap: () => setState(() => showAvatars = !showAvatars),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color(0xFF282828),
                  backgroundImage: AssetImage(avatars[selectedIndex]),
                ),
              ),
              if (showAvatars) ...[
                SizedBox(height: height * 0.03),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: avatars.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: isSelected ? AppColors.yellowColor : Colors.transparent, 
                                width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.asset(
                              avatars[index], 
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[900],
                                child: const Icon(Icons.person, color: Colors.white24),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
              SizedBox(height: height * 0.04),
              CustomTextField(
                controller: nameController,
                hintText: "Full Name",
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                icon: const Icon(Icons.person, color: AppColors.whiteColor),
                color: AppColors.whiteColor,
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: phoneController,
                hintText: "Phone Number",
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                icon: const Icon(Icons.call, color: AppColors.whiteColor),
                color: AppColors.whiteColor,
              ),
              SizedBox(height: height * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _showPhoneResetDialog,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              CustomElevatedButton(
                text: "Update Data",
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.blackColor,
                ),
                color: AppColors.yellowColor,
                onPressed: _handleUpdate,
              ),
              const SizedBox(height: 15),
              CustomElevatedButton(
                text: "Delete Account",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                color: AppColors.redColor,
                onPressed: _handleDelete,
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhoneResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF212121),
        title: const Text("Reset Password", style: TextStyle(color: AppColors.yellowColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: phoneController,
              hintText: "Phone Number (e.g., +20...)",
              hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
              icon: const Icon(Icons.phone, color: Colors.white),
              color: Colors.white,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendOtp();
            },
            child: const Text("Send Code"),
          ),
        ],
      ),
    );
  }

  void _sendOtp() async {
    setState(() => isLoading = true);
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      onCodeSent: (id) {
        setState(() => isLoading = false);
        _showOtpDialog();
      },
      onVerificationFailed: (err) {
        setState(() => isLoading = false);
        _showSnack(err);
      },
    );
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF212121),
        title: const Text("Enter Code", style: TextStyle(color: AppColors.yellowColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: otpController,
              hintText: "6-digit Code",
              hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
              icon: const Icon(Icons.lock_clock, color: Colors.white),
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: newPasswordController,
              hintText: "New Password",
              hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
              icon: const Icon(Icons.lock, color: Colors.white),
              color: Colors.white,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _verifyAndReset();
            },
            child: const Text("Reset Password"),
          ),
        ],
      ),
    );
  }

  void _verifyAndReset() async {
    setState(() => isLoading = true);
    final res = await _authService.updatePasswordWithOtp(
      otp: otpController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );
    setState(() => isLoading = false);
    if (res == "success") {
      _showSnack("Password reset successfully!");
    } else {
      _showSnack(res!);
    }
  }

  void _handleUpdate() async {
    String newName = nameController.text.trim();

    setState(() => isLoading = true);

    final res = await _authService.updateProfile(
      name: newName,
      photoUrl: avatars[selectedIndex],
    );

    setState(() => isLoading = false);

    if (res == "success") {
      _showSnack("Profile updated successfully!");
    } else {
      _showSnack(res!);
    }
  }

  void _handleDelete() async {
    setState(() => isLoading = true);
    final res = await _authService.deleteAccount();
    setState(() => isLoading = false);
    if (res == "success") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginRoute,
            (route) => false,
      );
    } else if (res == "re-authenticate") {
      _showSnack("Please login again to confirm deletion");
    } else {
      _showSnack(res!);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.greyColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}

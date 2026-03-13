import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextStyle hintStyle;
  final Color color;
  final Icon icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlignVertical? textAlignVertical;
  final TextEditingController? controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.hintStyle,
    required this.icon,
    required this.color,
    this.prefixIcon,
    this.suffixIcon,
    this.textAlignVertical,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlignVertical: textAlignVertical,
        cursorColor: AppColors.whiteColor,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          icon: icon,
          hintText: hintText,
          hintStyle: hintStyle,
        ),
      ),
    );
  }
}
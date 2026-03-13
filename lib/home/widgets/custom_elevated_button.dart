import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final void Function() onPressed;
  final Color color;
  final Image? image;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.style,
    required this.onPressed,
    this.color = AppColors.yellowColor,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: height * 0.0175,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              image!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
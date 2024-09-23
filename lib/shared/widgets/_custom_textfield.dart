import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.width,
    this.height,
    this.isPasswordField = false,
    this.enabled = true,
    this.expand = false,
    required this.controller,
    this.obscuringCharacter = '•', required this.bgColor, required this.hintColor, required this.textColor, // Default obscuring character
  });

  final bool enabled;
  final String hint;
  final bool expand;
  final double width;
  final double? height;
  final TextEditingController controller;
  final bool isPasswordField;
  final String obscuringCharacter;
  final Color bgColor;
  final Color hintColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // Apply height only if expand is false, otherwise allow dynamic height
      height: expand ? null : height,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: expand ? 10 : 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          cursorColor: textColor,
          expands: expand,
          enabled: enabled,
          maxLines: expand ? null : 1,
          obscureText: isPasswordField,
          obscuringCharacter:
          obscuringCharacter, // Customize the obscuring character
          controller: controller,
          style: TextStyle(color: textColor, fontSize: 12),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
                color:
                hintColor, // Use hintColor instead of theme.onPrimary  for hint text ),
          ),
        ),)
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.width,
      this.height,
      this.isPasswordField = false,
      this.enabled = true,
      this.expand = false,
      required this.controller,
      this.obscuringCharacter = '•',
      required this.bgColor,
      required this.hintColor,
      required this.textColor // Default obscuring character
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
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color:
                hintColor, // Use hintColor instead of theme.onPrimary  for hint text ),
          ),
        ),
      )),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({
    super.key,
    required this.hint,
    required this.width,
    this.height,
    this.isPasswordField = false,
    this.enabled = true,
    this.expand = false,
    required this.controller,
    this.obscuringCharacter = '•',
    required this.bgColor,
    required this.hintColor,
    required this.textColor,
    this.hasBorder,
    this.borderColor, // Default obscuring character
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
  final bool? hasBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // Apply height only if expand is false, otherwise allow dynamic height
      height: expand ? null : height,
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: expand ? 10 : 0),
      decoration: hasBorder!
          ? BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            )
          : null,
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
          enabledBorder: hasBorder!
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor!, width: 2),
                  borderRadius: BorderRadius.circular(10),
                )
              : InputBorder.none,
          focusedBorder: hasBorder!
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor!, width: 2),
                  borderRadius: BorderRadius.circular(10),
                )
              : InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color:
                hintColor, // Use hintColor instead of theme.onPrimary  for hint text ),
          ),
        ),
      )),
    );
  }
}

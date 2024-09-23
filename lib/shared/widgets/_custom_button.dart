import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.width,
    required this.height,
  });

  final VoidCallback onTap;
  final String label;
  final Color bgColor;
  final Color fgColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: bgColor,
              foregroundColor: fgColor),
          child: Text(
            label,
            style: TextStyle(fontSize: 13),
          )),
    );
  }
}
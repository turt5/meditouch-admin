import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.width,
    required this.height,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final String label;
  final Color bgColor;
  final Color fgColor;
  final double width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: bgColor,
              foregroundColor: fgColor),
          child: isLoading
              ? LoadingAnimationWidget.threeArchedCircle(
                  color: bgColor, size: 18)
              : Text(
                  label,
                  style: TextStyle(fontSize: 13),
                )),
    );
  }
}

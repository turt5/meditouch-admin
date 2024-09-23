import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.width, required this.height});

  final double width;
  final double height;


  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo2.png',
      width: width,
      height: height,
    );
  }
}

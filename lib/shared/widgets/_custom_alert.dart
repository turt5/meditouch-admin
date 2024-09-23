
import 'package:flutter/material.dart';

void showCustomAlert(BuildContext context, String label, Color bgColor, Color fgColor) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: fgColor,
    elevation: 10,
    duration: Duration(seconds: 5),
    content: Text(label,style: TextStyle(
        color: fgColor
    ),),
    behavior: SnackBarBehavior.floating,
    backgroundColor: bgColor,
    margin: const EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
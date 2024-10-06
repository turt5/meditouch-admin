import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                radius: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Please wait",
                style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.7)),
              )
            ],
          ),
        ),
      ).frosted(
        blur: 15,
        frostColor: Theme.of(context).colorScheme.onSurface,
      ));
}

void hideCustomLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
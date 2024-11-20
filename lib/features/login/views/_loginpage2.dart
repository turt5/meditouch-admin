import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/login/views/_logincontainer.dart';
import 'package:rive/rive.dart';

class LoginPage2 extends StatelessWidget {
  const LoginPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Rive animation
          const RiveAnimation.asset(
            'assets/rive/gradient.riv',
            fit: BoxFit.cover,
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final h = constraints.maxHeight;
              final isWide =
                  width > 600; // Define a breakpoint for responsiveness
              final containerWidth =
                  isWide ? 400.0 : width * 0.6; // Width adjusts to screen size
              final containerHeight =
                  isWide ? 400.0 : h * .5; // Height adjusts to screen size

              final regularTextSize = isWide ? 16.0 : 13.0;

              if (width < 300) {
                return const Center(
                  child: Text("Unable to display content"),
                );
              }

              return Center(
                  child: LoginContainer(
                      width: containerWidth,
                      height: containerHeight,
                      regularTextSize: regularTextSize));
            },
          ),
        ],
      ),
    );
  }
}

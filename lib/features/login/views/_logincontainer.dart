import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

import '../../../shared/widgets/_custom_alert.dart';
import '../../../shared/widgets/_custom_loading.dart';
import '../../dashboard_navigation/views/_admin_dashboard.dart';
import '../services/_auth_service.dart';

class LoginContainer extends StatelessWidget {
  LoginContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.regularTextSize});

  final double width;
  final double height;
  final double regularTextSize;

  @override
  Widget build(BuildContext context) {
    // Get theme
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primary.withOpacity(.1), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo2.png',
                width: 80,
                height: 80,
                color: theme.primary,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'Login to your account',
            style: TextStyle(
              fontSize: regularTextSize,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),

          const SizedBox(height: 20),

          //Email

          CustomTextField(
              hint: 'Email Address',
              width: width * .7,
              height: 45,
              controller: _emailController,
              bgColor: Colors.transparent,
              hintColor: theme.onSurface.withOpacity(.5),
              hasBorder: true,
              borderColor: theme.primary.withOpacity(.2),
              textColor: theme.onSurface),

          const SizedBox(height: 10),

          //Password

          CustomTextField(
              hint: 'Password',
              width: width * .7,
              height: 45,
              controller: _passwordController,
              bgColor: Colors.transparent,
              hintColor: theme.onSurface.withOpacity(.5),
              hasBorder: true,
              borderColor: theme.primary.withOpacity(.2),
              textColor: theme.onSurface,
              isPasswordField: true),

          const SizedBox(height: 15),

          CustomButton(
              onTap: () async {
                // Perform login
                String email = _emailController.text.toString().trim();
                String password = _passwordController.text.toString().trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  // Perform login

                  LoginService loginService = LoginService();
                  showCustomLoadingDialog(context);
                  Map<String, dynamic>? response =
                      await loginService.loginUser(email, password);

                  if (response != null && response.containsKey('error')) {
                    hideCustomLoadingDialog(context);
                    showCustomAlert(
                        context, response['error'], Colors.red, Colors.white);
                  } else {
                    hideCustomLoadingDialog(context);

                    if (response!['role'] == 'u' || response['role'] == 'd') {
                      showCustomAlert(context, 'Wrong email/Password',
                          theme.error, theme.onError);
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminDashboard()));
                    }
                  }
                } else {
                  // Show error message
                  showCustomAlert(context, "Email or Password cannot be empty!",
                      theme.error, theme.onError);
                }
              },
              label: "Login",
              bgColor: theme.primary,
              fgColor: theme.onPrimary,
              width: width * .7,
              height: 40),

          const SizedBox(height: 20),
        ],
      ),
    ).frosted(
      blur: 10,
      frostColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
}

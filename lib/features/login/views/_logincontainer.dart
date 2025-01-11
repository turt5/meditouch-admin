import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch_admin/features/login/controller/login_controller.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

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

    // find the login controller
    final LoginController loginController = Get.find<LoginController>();

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

          CustomTextField2(
              hint: 'Email Address',
              width: width * .7,
              height: 45,
              controller: loginController.emailController,
              bgColor: Colors.transparent,
              hintColor: theme.onSurface.withOpacity(.5),
              hasBorder: true,
              borderColor: theme.primary.withOpacity(.2),
              textColor: theme.onSurface),

          const SizedBox(height: 10),

          //Password

          CustomTextField2(
              hint: 'Password',
              width: width * .7,
              height: 45,
              controller: loginController.passwordController,
              bgColor: Colors.transparent,
              hintColor: theme.onSurface.withOpacity(.5),
              hasBorder: true,
              borderColor: theme.primary.withOpacity(.2),
              textColor: theme.onSurface,
              isPasswordField: true),

          const SizedBox(height: 15),

          GetX<LoginController>(
              init: LoginController(),
              builder: (controller) {
                return CustomButton(
                    onTap: () async => await controller.loginUser(),
                    label: "Login",
                    isLoading: controller.isLoading.value,
                    bgColor: theme.primary,
                    fgColor: theme.onPrimary,
                    width: width * .7,
                    height: 40);
              }),

          const SizedBox(height: 20),
        ],
      ),
    ).frosted(
      blur: 10,
      frostColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
    );
  }
}

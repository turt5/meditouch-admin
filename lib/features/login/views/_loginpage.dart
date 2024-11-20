// import 'package:blur/blur.dart';
// import 'package:flutter/material.dart';
// import 'package:meditouch_admin/shared/widgets/_applogo.dart';
// import 'package:meditouch_admin/shared/widgets/_custom_alert.dart';
// import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
// import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';
// import 'package:meditouch_admin/shared/widgets/_gradient_bg.dart';

// import '../../../shared/widgets/_custom_loading.dart';
// import '../../dashboard_navigation/views/_admin_dashboard.dart';
// import '../services/_auth_service.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;
//     return Scaffold(
//       body: Stack(
//         children: [
//           GradientBackground(),
//           Center(
//             child: Container(
//               height: 350,
//               width: 350,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       AppLogo(width: 100, height: 100),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Login to your account!',
//                         style: TextStyle(color: theme.onPrimary, height: 1),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomTextField(
//                           bgColor: theme.primary.withOpacity(.4),
//                           hintColor: theme.onPrimary.withOpacity(.5),
//                           textColor: theme.onPrimary,
//                           height: 45,
//                           hint: 'Email',
//                           width: 280,
//                           controller: _emailController),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomTextField(
//                           bgColor: theme.primary.withOpacity(.4),
//                           hintColor: theme.onPrimary.withOpacity(.5),
//                           textColor: theme.onPrimary,
//                           height: 45,
//                           hint: 'Password',
//                           isPasswordField: true,
//                           width: 280,
//                           controller: _passwordController),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomButton(
//                           onTap: ()async {
//                             // Perform login
//                             String email = _emailController.text.toString().trim();
//                             String password = _passwordController.text.toString().trim();

//                             if(email.isNotEmpty && password.isNotEmpty) {
//                               // Perform login


//                               LoginService loginService = LoginService();
//                               showCustomLoadingDialog(context);
//                               Map<String, dynamic>? response =
//                                   await loginService.loginUser(email, password);

//                               if (response != null &&
//                                   response.containsKey('error')) {
//                                 hideCustomLoadingDialog(context);
//                                 showCustomAlert(context, response['error'],
//                                     Colors.red, Colors.white);
//                               } else {
//                                 hideCustomLoadingDialog(context);

//                                 if (response!['role'] == 'u' || response['role'] == 'd') {
//                                   showCustomAlert(context, 'Wrong email/Password', theme.error, theme.onError);
//                                 } else{
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AdminDashboard()));
//                                 }
//                               }

//                             }else{
//                               // Show error message
//                               showCustomAlert(context, "Email or Password cannot be empty!", theme.error, theme.onError);
//                             }
//                           },
//                           label: 'Log in',
//                           bgColor: theme.primary,
//                           fgColor: theme.onPrimary,
//                           width: 280,
//                           height: 45)
//                     ],
//                   )
//                 ],
//               ),
//             ).frosted(
//               blur: 100,
//               borderRadius: BorderRadius.circular(15),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch_admin/features/dashboard_navigation/views/_admin_dashboard.dart';

import '../core/theming/_theme.dart';
import '../features/login/views/_loginpage2.dart';
import '../shared/local_db/person.dart';

class MeditouchAdmin extends StatelessWidget {
  const MeditouchAdmin({super.key, required this.person});

  final Person? person;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
        title: 'Flutter Demo',
        theme: AppTheme().getTheme(),
        initialRoute:
            person != null && person!.id.isNotEmpty ? '/dashboard' : '/login',
        getPages: [
          GetPage(
            name: '/login',
            page: () => const LoginPage2(),
          ),
          GetPage(
            name: '/dashboard',
            page: () => AdminDashboard(),
          ),
        ]);
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/dashboard_navigation/widgets/_dashboard_bridge.dart';
import 'package:meditouch_admin/features/dashboard_navigation/widgets/_drawer.dart';
import 'package:meditouch_admin/features/dashboard_navigation/widgets/_sidebar.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final isSmallScreen = width <= 1000;

          return Row(
            children: [
              isSmallScreen
                  ? const SizedBox.shrink()
                  : const DashboardSidebar(),
              Expanded(
                  child: DashboardBridge(
                    isSmallScreen: isSmallScreen,
                    width: width,
              ))
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: MediaQuery.of(context).size.width <= 1000
          ? FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.menu),
            )
          : null,
    );
  }
}

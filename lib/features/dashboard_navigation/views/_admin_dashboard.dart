import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/dashboard_navigation/widgets/_sidebar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DashboardSidebar(),
          Expanded(child: Container())
        ],
      ),
    );
  }
}

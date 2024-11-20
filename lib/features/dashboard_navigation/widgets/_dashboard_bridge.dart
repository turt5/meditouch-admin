import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/add_agent/views/_add_agent_page.dart';
import 'package:meditouch_admin/features/add_doctor/views/_add_doctor_page.dart';
import 'package:meditouch_admin/features/add_emergency_doctor/views/_add_emergency_doctor_page.dart';
import 'package:meditouch_admin/features/add_nurse/views/_add_nurse.dart';
import 'package:meditouch_admin/features/dashboard_navigation/viewmodels/_nav_viewmodel.dart';
import 'package:meditouch_admin/features/manage_agents/views/_manage_agent.dart';
import 'package:meditouch_admin/features/manage_nurses/views/_manage_nurse.dart';
import 'package:meditouch_admin/features/order_history/views/_order_history.dart';
import '../../emergency/views/_emergency_requests.dart';
import '../../home/views/_dashboard_home.dart';
import '../../manage_doctors/views/_manage_doctors.dart';
import '../../manage_emergency_doctors/views/_manage_emergency_doctors.dart';
import '../../orders/views/_dashboard_orders.dart';
import '../../settings/views/_settings.dart';

class DashboardBridge extends ConsumerWidget {
  const DashboardBridge({
    super.key,
    required this.isSmallScreen,
    required this.width,
  });

  final bool isSmallScreen;
  final double width;

  List<Widget> get pages => [
        DashboardHome(
          isSmallScreen: isSmallScreen,
          width: width,
        ),
        EmergencyRequests(
          width: width,
        ),
        const DashboardOrders(),
        const OrderHistoryPage(),
        AddDoctorPage(),
        ManageDoctor(
          width: width,
        ),
        AddEmergencyDoctorPage(),
        ManageEmergencyDoctor(),
        AddNursePage(),
        ManageNurse(),
        AddAgentPage(),
        ManageAgent(),
        // const DashboardSettings(),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final read = ref.watch(navigationViewModelProvider);
    return pages[read.selectedIndex];
  }
}

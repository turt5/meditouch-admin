import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/add_doctor/views/_add_doctor_page.dart';
import 'package:meditouch_admin/features/dashboard_navigation/viewmodels/_nav_viewmodel.dart';
import 'package:meditouch_admin/features/doctors/views/_manage_doctors.dart';
import 'package:meditouch_admin/features/order_history/views/_order_history.dart';

import '../../home/views/_dashboard_home.dart';
import '../../orders/views/_dashboard_orders.dart';
import '../../settings/views/_settings.dart';

class DashboardBridge extends ConsumerWidget {
  DashboardBridge({super.key});

  final List<Widget> pages = [
    const DashboardHome(),
    const DashboardOrders(),
    const OrderHistoryPage(),
    AddDoctorPage(),
    ManageDoctor(),
    const DashboardSettings(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final read = ref.watch(navigationViewModelProvider);
    return pages[read.selectedIndex];
  }
}

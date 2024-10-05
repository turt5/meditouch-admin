import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/emergency/services/_emergency_services.dart';
import 'package:meditouch_admin/features/login/services/_auth_service.dart';
import 'package:meditouch_admin/shared/widgets/_applogo.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_gradient_bg.dart';

import '../viewmodels/_nav_viewmodel.dart';
import '_sidebar_item.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: 250,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Stack(
        children: [
          const GradientBackground(),
          const SizedBox(height: 20),
          Column(
            children: [
              const AppLogo(width: double.infinity, height: 100),
              Expanded(
                  child: ListView(
                padding: const EdgeInsets.only(left: 15),
                children: [
                  const SizedBox(height: 20),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Home',
                        iconpath: 'assets/icons/home.png',
                        onTap: () {
                          write.updateIndex(0);
                        },
                        isSelected: read.selectedIndex == 0);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return StreamBuilder<int>(
                      stream: EmergencyServices().getPendingEmergencyRequests(),
                      builder: (context, snapshot) {
                        // Check if snapshot has data and if it is greater than 0
                        bool hasDot = snapshot.hasData && snapshot.data! > 0;

                        return DashboardSidebarItem(
                          hasDot: hasDot, // Pass the hasDot value to the DashboardSidebarItem
                          label: 'Emergency',
                          iconpath: 'assets/icons/emergency.png',
                          onTap: () {
                            write.updateIndex(1);
                          },
                          isSelected: read.selectedIndex == 1,
                        );
                      },
                    );
                  }),

                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Pending Orders',
                        iconpath: 'assets/icons/order.png',
                        onTap: () {
                          write.updateIndex(2);
                        },
                        isSelected: read.selectedIndex == 2);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Order-History',
                        iconpath: 'assets/icons/order-history.png',
                        onTap: () {
                          write.updateIndex(3);
                        },
                        isSelected: read.selectedIndex == 3);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Register doctor',
                        iconpath: 'assets/icons/register.png',
                        onTap: () {
                          write.updateIndex(4);
                        },
                        isSelected: read.selectedIndex == 4);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Doctors',
                        iconpath: 'assets/icons/doctor-32.png',
                        onTap: () {
                          write.updateIndex(5);
                        },
                        isSelected: read.selectedIndex == 5);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Add Emergency Doctor',
                        iconpath: 'assets/icons/register.png',
                        onTap: () {
                          write.updateIndex(6);
                        },
                        isSelected: read.selectedIndex == 6);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Emergency Doctors',
                        iconpath: 'assets/icons/doctor-32.png',
                        onTap: () {
                          write.updateIndex(7);
                        },
                        isSelected: read.selectedIndex == 7);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Add Nurse',
                        iconpath: 'assets/icons/register.png',
                        onTap: () {
                          write.updateIndex(8);
                        },
                        isSelected: read.selectedIndex == 8);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Nurses',
                        iconpath: 'assets/icons/nurse2.png',
                        onTap: () {
                          write.updateIndex(9);
                        },
                        isSelected: read.selectedIndex == 9);
                  }),
                  Consumer(builder: (context, ref, child) {
                    final read = ref.watch(navigationViewModelProvider);
                    final write = ref.watch(navigationViewModelProvider);

                    return DashboardSidebarItem(
                        label: 'Settings',
                        iconpath: 'assets/icons/settings.png',
                        onTap: () {
                          write.updateIndex(10);
                        },
                        isSelected: read.selectedIndex == 10);
                  }),
                ],
              )),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomButton(
                    onTap: () {
                      LoginService().logoutUser(context);
                    },
                    label: 'Log out',
                    bgColor: theme.error,
                    fgColor: theme.onError,
                    width: double.infinity,
                    height: 45),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch_admin/features/dashboard_navigation/controller/navigation_controller.dart';
import 'package:meditouch_admin/features/emergency/services/_emergency_services.dart';
import 'package:meditouch_admin/shared/widgets/_applogo.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_gradient_bg.dart';
import '../../login/controller/login_controller.dart';
import '_sidebar_item.dart';

class DashboardSidebar extends StatelessWidget {
  final NavigationController navigationController =
      Get.find<NavigationController>();

  DashboardSidebar({super.key});

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
                    Obx(() => DashboardSidebarItem(
                          label: 'Home',
                          iconpath: 'assets/icons/home.png',
                          onTap: () {
                            navigationController.changeIndex(0);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 0,
                        )),
                    StreamBuilder<int>(
                      stream: EmergencyServices().getPendingEmergencyRequests(),
                      builder: (context, snapshot) {
                        bool hasDot = snapshot.hasData && snapshot.data! > 0;
                        return Obx(() => DashboardSidebarItem(
                              hasDot: hasDot,
                              label: 'Emergency',
                              iconpath: 'assets/icons/emergency.png',
                              onTap: () {
                                navigationController.changeIndex(1);
                              },
                              isSelected:
                                  navigationController.selectedIndex.value == 1,
                            ));
                      },
                    ),
                    Obx(() => DashboardSidebarItem(
                          label: 'Pending Orders',
                          iconpath: 'assets/icons/order.png',
                          onTap: () {
                            navigationController.changeIndex(2);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 2,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Order-History',
                          iconpath: 'assets/icons/order-history.png',
                          onTap: () {
                            navigationController.changeIndex(3);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 3,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Register doctor',
                          iconpath: 'assets/icons/register.png',
                          onTap: () {
                            navigationController.changeIndex(4);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 4,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Doctors',
                          iconpath: 'assets/icons/doctor-32.png',
                          onTap: () {
                            navigationController.changeIndex(5);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 5,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Add Emergency Doctor',
                          iconpath: 'assets/icons/register.png',
                          onTap: () {
                            navigationController.changeIndex(6);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 6,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Emergency Doctors',
                          iconpath: 'assets/icons/doctor-32.png',
                          onTap: () {
                            navigationController.changeIndex(7);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 7,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Add Nurse',
                          iconpath: 'assets/icons/register.png',
                          onTap: () {
                            navigationController.changeIndex(8);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 8,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Nurses',
                          iconpath: 'assets/icons/nurse2.png',
                          onTap: () {
                            navigationController.changeIndex(9);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 9,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Add Agent',
                          iconpath: 'assets/icons/register.png',
                          onTap: () {
                            navigationController.changeIndex(10);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 10,
                        )),
                    Obx(() => DashboardSidebarItem(
                          label: 'Agents',
                          iconpath: 'assets/icons/agent.png',
                          onTap: () {
                            navigationController.changeIndex(11);
                          },
                          isSelected:
                              navigationController.selectedIndex.value == 11,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomButton(
                  onTap: () async {
                    await Get.find<LoginController>().logoutUser();
                  },
                  label: 'Log out',
                  bgColor: theme.error,
                  fgColor: theme.onError,
                  width: double.infinity,
                  height: 45,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/core/utils/_greeting.dart';
import 'package:meditouch_admin/shared/local_db/_db_helper.dart';
import 'package:meditouch_admin/shared/local_db/person.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

import '../services/_orderservice.dart';
import '../services/_userservice.dart';
import '../widgets/_revenue_graph.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome(
      {super.key, required this.isSmallScreen, required this.width});

  final bool isSmallScreen;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth - 250,
        height: constraints.maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(theme, width),
            const SizedBox(height: 20),
            Expanded(
                child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: [
                SizedBox(
                    // height: 200,
                    width: double.infinity,
                    child: _buildGridWidget(theme, width)),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 340,
                    child: _buildGraphWidget(theme)),
                const SizedBox(height: 20),
              ],
            ))
          ],
        ),
      );
    });
  }

  Widget _buildGraphWidget(ColorScheme theme) {
    return StreamBuilder(
        stream: OrderService().getDailyRevenueForCurrentMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator(
              color: theme.primary,
              radius: 12,
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return RevenueChart(revenueData: snapshot.data!);
        });
  }

  Widget _buildGridWidget(ColorScheme theme, double width) {
    // Calculate responsive values for grid
    int crossAxisCount =
        (width ~/ 300).clamp(1, 4); // Minimum 1, maximum 4 columns
    double mainAxisExtent =
        (width / crossAxisCount) * 0.6; // Adjust card height

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(.2),
                    offset: const Offset(5, 5),
                    blurRadius: 100,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 0)
                    StreamBuilder<double>(
                      stream: OrderService().getTotalRevenue(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "৳ ${snapshot.data!.toStringAsFixed(2)}",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 15,
                          );
                        }
                        return CupertinoActivityIndicator(color: theme.primary);
                      },
                    ),
                  if (index == 1)
                    StreamBuilder(
                      stream: OrderService().getTotalAgents(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 15,
                          );
                        }
                        return CupertinoActivityIndicator(color: theme.primary);
                      },
                    ),
                  if (index == 2)
                    StreamBuilder(
                      stream: UserService().getUserCountWithRoleU(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 15,
                          );
                        }
                        return CupertinoActivityIndicator(color: theme.primary);
                      },
                    ),
                  if (index == 3)
                    StreamBuilder(
                      stream: UserService().getUserCountWithRoleD(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 15,
                          );
                        }
                        return CupertinoActivityIndicator(color: theme.primary);
                      },
                    ),
                  const SizedBox(height: 10),
                  Text(
                    index == 0
                        ? 'Revenues Earned'
                        : index == 1
                            ? 'Total Agents'
                            : index == 2
                                ? "Total Users"
                                : "Total Doctors",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.onSurface.withOpacity(.6),
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Opacity(
                opacity: .3,
                child: Image.asset(
                  index == 0
                      ? 'assets/icons/icons8-money-50.png'
                      : index == 1
                          ? 'assets/icons/icons8-package-50.png'
                          : index == 2
                              ? 'assets/icons/icons8-users-50.png'
                              : 'assets/icons/icons8-doctors-50.png',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(ColorScheme theme, double width) {
    final DBHelper dbHelper = DBHelper();
    Person? person = dbHelper.getUser();

    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(.1),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side with greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${generateGreeting()}!",
                style: TextStyle(
                  color: theme.onSurface.withOpacity(.7),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          width >= 850
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                          hint: 'Search ',
                          width: 300,
                          height: 50,
                          controller: TextEditingController(),
                          bgColor: theme.primary.withOpacity(.1),
                          hintColor: theme.onSurface.withOpacity(.3),
                          textColor: theme.onSurface),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: IconButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              foregroundColor: theme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.search)),
                      )
                    ],
                  ),
                )
              : SizedBox.shrink(),

          // Right side with user name
          Row(
            children: [
              Text(
                person!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  person.imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, color: Colors.red);
                  },
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

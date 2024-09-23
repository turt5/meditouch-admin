import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/core/utils/_greeting.dart';
import 'package:meditouch_admin/shared/local_db/_db_helper.dart';
import 'package:meditouch_admin/shared/local_db/person.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth - 250,
        height: constraints.maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopBar(theme)],
        ),
      );
    });
  }

  Widget _buildTopBar(ColorScheme theme) {
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

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                    hint: 'Search ',
                    width: 400,
                    height: 50,
                    controller: TextEditingController(),
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.3),
                    textColor: theme.onSurface),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),icon: const Icon(Icons.search)),
                )
              ],
            ),
          ),

          // Right side with user name
          Row(
            children: [
              Text(
                person!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 20),
              AvatarGlow(
                glowColor: theme.primary,
                glowRadiusFactor: .4,
                duration: const Duration(milliseconds: 2000),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: person.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

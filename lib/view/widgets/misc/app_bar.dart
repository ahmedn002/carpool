import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:provider/provider.dart';

import '../../global/constants.dart';

class CarpoolAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool enableNavigation;
  final bool userLoggedIn;
  const CarpoolAppBar({super.key, this.enableNavigation = true, this.userLoggedIn = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/logo_image.png',
        height: 50.h,
      ),
      leading: enableNavigation
          ? Consumer<DriverDataProvider>(
              builder: (context, driverDataProvider, _) => IconButton(
                icon: badges.Badge(
                  showBadge: driverDataProvider.pendingRequests > 0,
                  badgeContent: Text(
                    driverDataProvider.pendingRequests.toString(),
                    style: TextStyles.tiny.copyWith(color: AppColors.text),
                  ),
                  child: const Icon(Icons.menu_rounded),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )
          : null,
      actions: [
        if (userLoggedIn)
          StatefulBuilder(builder: (context, setState) {
            return Row(
              children: [
                Text(
                  'Bybass Constraints',
                  style: TextStyles.tiny.copyWith(color: AppColors.text),
                ),
                Switch(
                  value: Constants.bybassTimeConstraints,
                  onChanged: (value) {
                    setState(() {
                      Constants.bybassTimeConstraints = value;
                    });
                  },
                  activeTrackColor: AppColors.accent1,
                  activeColor: AppColors.elevationOne,
                  inactiveTrackColor: AppColors.elevationOne,
                ),
              ],
            );
          })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/action/main_button.dart';
import 'package:milestoneone/view/widgets/misc/gradient_avatar.dart';
import 'package:provider/provider.dart';

class CarpoolNavigationDrawer extends StatefulWidget {
  const CarpoolNavigationDrawer({super.key});

  @override
  State<CarpoolNavigationDrawer> createState() => _CarpoolNavigationDrawerState();
}

class _CarpoolNavigationDrawerState extends State<CarpoolNavigationDrawer> {
  late NavigationProvider _navigationProvider;
  late DriverDataProvider _driverDataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthenticationProvider, NavigationProvider, DriverDataProvider>(
      builder: (context, authenticationProvider, navigationProvider, driverDataProvider, _) {
        _navigationProvider = navigationProvider;
        _driverDataProvider = driverDataProvider;
        return NavigationDrawer(
          backgroundColor: AppColors.elevationOne,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: double.infinity,
              color: AppColors.darkElevation,
              child: Center(
                child: Column(
                  children: [
                    GradientAvatar(
                      radius: 60.r,
                      imageUrl: auth.currentUser!.photoURL!,
                    ),
                    10.verticalSpace,
                    Text(
                      auth.currentUser!.displayName!,
                      style: TextStyles.title,
                    ),
                    5.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '@${GeneralUtilities.getCode(auth.currentUser!.email!).toUpperCase()}',
                          style: TextStyles.tiny,
                        ),
                        5.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            gradient: const LinearGradient(
                              colors: [AppColors.accent1, AppColors.accent2],
                            ),
                          ),
                          child: Text(
                            authenticationProvider.isDriver ? 'Driver' : 'Passenger',
                            style: TextStyles.tiny.apply(
                              color: AppColors.text,
                              fontSizeFactor: 0.9,
                              fontWeightDelta: 3,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            10.verticalSpace,
            if (authenticationProvider.isDriver) ..._getDriverItems() else ..._getPassengerItems(),
            Divider(
              endIndent: 20.w,
              indent: 20.w,
            ),
            25.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: MainButton(
                text: 'Logout',
                icon: Icon(Icons.logout_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(context, '/authentication', (route) => false);
                  await auth.signOut();
                  navigationProvider.changeIndex(0);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required int index,
    int? notificationCount,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: Material(
          color: _navigationProvider.currentIndex == index ? AppColors.accent1.withOpacity(0.1) : Colors.transparent,
          child: InkWell(
            onTap: () => _navigationProvider.changeIndex(index),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15.r,
                    backgroundColor: _navigationProvider.currentIndex == index ? AppColors.accent1.withOpacity(0.3) : Colors.transparent,
                    child: badges.Badge(
                      showBadge: notificationCount != null && notificationCount > 0,
                      badgeContent: Text(
                        notificationCount.toString(),
                        style: TextStyles.tiny.apply(color: AppColors.text),
                      ),
                      child: Icon(icon, color: AppColors.text, size: 20.r),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(title, style: TextStyles.body),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getDriverItems() {
    return [
      _buildDrawerItem(title: 'Home', icon: Icons.home_rounded, index: 0),
      _buildDrawerItem(title: 'Requests', icon: Icons.pending_actions_rounded, index: 1, notificationCount: _driverDataProvider.pendingRequests),
      _buildDrawerItem(title: 'Order History', icon: Icons.history_rounded, index: 2),
      _buildDrawerItem(title: 'Profile', icon: Icons.person_rounded, index: 3),
    ];
  }

  List<Widget> _getPassengerItems() {
    return [
      _buildDrawerItem(title: 'Home', icon: Icons.home_rounded, index: 0),
      _buildDrawerItem(title: 'Requests', icon: Icons.pending_actions_rounded, index: 1),
      _buildDrawerItem(title: 'Order History', icon: Icons.history_rounded, index: 2),
      _buildDrawerItem(title: 'Profile', icon: Icons.person_rounded, index: 3),
    ];
  }
}

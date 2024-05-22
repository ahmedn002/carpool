import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:milestoneone/model/classes/user.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/lookups.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/screens/passenger/components/ride_card.dart';
import 'package:milestoneone/view/utilities/extensions.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/misc/gradient_avatar.dart';
import 'package:milestoneone/view/widgets/misc/gradient_icon.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../../services/user_services.dart';
import '../../../global/text_styles.dart';
import '../../../widgets/action/main_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: RequestWidget<List<AppUser>>(
            request: UserServices.getAppUsersFromIds([auth.currentUser!.uid]),
            successWidgetBuilder: (List<AppUser> users) {
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientIcon(
                        icon: Icons.error_rounded,
                        size: 200.r,
                      ),
                      20.verticalSpace,
                      Text(
                        'User info not found.',
                        style: TextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final AppUser user = users.first;
              return Column(
                children: [
                  20.verticalSpace,
                  GradientAvatar(
                    radius: 85.r,
                    imageUrl: user.profilePictureUrl,
                  ),
                  20.verticalSpace,
                  Container(
                    padding: EdgeInsets.only(left: 13.w, top: 15.h, bottom: 15.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.r),
                      color: AppColors.darkElevation,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return _buildItem('Name', '${user.firstName} ${user.lastName}', Icons.edit_rounded);
                          case 1:
                            return _buildItem('Email', GeneralUtilities.parseEmail(user.email), Icons.email_rounded);
                          case 2:
                            return _buildItem('Code', '@${GeneralUtilities.getCode(user.email).toUpperCase()}', Icons.alternate_email_rounded);
                          case 3:
                            return _buildItem(
                                'Account Type', (GeneralUtilities.isDriver(user.email) ? Lookups.driver : Lookups.passenger).capitalize, Icons.account_circle_rounded);
                        }
                        return null;
                      },
                      separatorBuilder: (context, index) => Divider(
                        indent: 50.w,
                        height: 20.h,
                        color: AppColors.elevationOne,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      color: AppColors.darkElevation,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.background,
                          child: GradientIcon(
                            icon: Icons.attach_money_rounded,
                            size: 20.r,
                          ),
                        ),
                        10.horizontalSpace,
                        // intl formatting
                        Text(
                          NumberFormat.currency(
                            locale: 'en_EG',
                            symbol: 'EGP ',
                            decimalDigits: 0,
                          ).format(user.balance),
                          style: TextStyles.title.apply(color: AppColors.green),
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  MainButton(
                    text: 'Logout',
                    icon: Icon(Icons.logout_rounded, color: AppColors.text, size: 18.r),
                    hollow: true,
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(context, '/authentication', (route) => false);
                      await auth.signOut();
                      navigationProvider.changeIndex(0);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buildItem(String title, String value, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.background,
          child: GradientIcon(
            icon: icon,
            size: 20.r,
          ),
        ),
        10.horizontalSpace,
        buildRichText('$title: ', value, 1.1),
      ],
    );
  }
}

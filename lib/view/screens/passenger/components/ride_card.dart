import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/model/classes/user.dart';
import 'package:milestoneone/services/request_services.dart';
import 'package:milestoneone/tools/request_handler.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/lookups.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_requests_provider.dart';
import 'package:milestoneone/view/utilities/date_utilities.dart';
import 'package:milestoneone/view/utilities/extensions.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/misc/custom_expansion_tile.dart';
import 'package:milestoneone/view/widgets/misc/gradient_avatar.dart';
import 'package:milestoneone/view/widgets/misc/mini_map.dart';
import 'package:milestoneone/view/widgets/misc/status_bar.dart';
import 'package:provider/provider.dart';

import '../../../global/constants.dart';
import '../../../widgets/action/main_button.dart';
import '../../../widgets/dialog/error_dialog.dart';

class RideCard extends StatefulWidget {
  final Ride ride;
  const RideCard({super.key, required this.ride});

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      upper: Row(
        children: [
          GradientAvatar(
            radius: 43.r,
            imageUrl: widget.ride.driverPhotoUrl,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.ride.driverName, style: TextStyles.subtitle),
                Text('@${widget.ride.driverStudentCode.toUpperCase()}', style: TextStyles.tiny),
                5.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14.r),
                    2.horizontalSpace,
                    Expanded(child: buildRichText('From: ', widget.ride.from.name)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14.r),
                    2.horizontalSpace,
                    Expanded(child: buildRichText('To: ', widget.ride.to.name)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timer_rounded, size: 14.r),
                    2.horizontalSpace,
                    Expanded(child: buildRichText('', DateUtilities.getFormattedDateTime(widget.ride.departureTime))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  10.verticalSpace,
                  Text('From', style: TextStyles.body),
                  5.verticalSpace,
                  SizedBox(
                    width: 0.32.sw,
                    child: MiniMap(
                      latitude: widget.ride.from.latitude,
                      longitude: widget.ride.from.longitude,
                      launchGoogleMapsOnTap: true,
                    ),
                  ),
                ],
              ),
              20.horizontalSpace,
              Column(
                children: [
                  10.verticalSpace,
                  Text('To', style: TextStyles.body),
                  5.verticalSpace,
                  SizedBox(
                    width: 0.32.sw,
                    child: MiniMap(
                      latitude: widget.ride.to.latitude,
                      longitude: widget.ride.to.longitude,
                      launchGoogleMapsOnTap: true,
                    ),
                  ),
                ],
              )
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                selectedIndex: RideStatus.values.indexOf(widget.ride.status),
                bubbleNames: RideStatus.values.map((e) => e.capitalize).toList(),
              ),
            ],
          ),
          20.verticalSpace,
          if (widget.ride.passengers.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.darkElevation,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                children: [
                  Text('Passengers', style: TextStyles.subtitle),
                  ...widget.ride.passengers.map(
                    (passenger) => ListTile(
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: AppColors.elevationOne,
                        backgroundImage: CachedNetworkImageProvider(passenger.profilePictureUrl),
                      ),
                      title: Text('${passenger.firstName} ${passenger.lastName}', style: TextStyles.body),
                      subtitle: Text('@${GeneralUtilities.getCode(passenger.email)}', style: TextStyles.tiny),
                      trailing: CircleAvatar(radius: 15.r, backgroundColor: AppColors.background, child: Icon(Icons.person_rounded, color: AppColors.secondaryText, size: 15.r)),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
      lower: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: AppColors.darkElevation,
              ),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car_rounded, size: 18.r),
                      5.horizontalSpace,
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 0.2.sw),
                        child: Text(
                          widget.ride.car,
                          style: TextStyles.smallBody.apply(fontSizeFactor: 0.85),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  10.horizontalSpace,
                  CircleAvatar(
                    radius: 3.r,
                    backgroundColor: AppColors.secondaryText,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        if (widget.ride.hasFreeSeats()) ...[
                          SvgPicture.asset(
                            'assets/icons/seat_green.svg',
                            height: 15.r,
                          ),
                          5.horizontalSpace,
                        ],
                        Expanded(
                          child: Text(
                            widget.ride.hasFreeSeats() ? '${widget.ride.carCapacity - widget.ride.reservedSeats}/${widget.ride.carCapacity} Free' : 'Full',
                            style: TextStyles.smallBody.apply(
                              color: widget.ride.carCapacity == widget.ride.reservedSeats ? AppColors.red : AppColors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        color: AppColors.green.withOpacity(0.1),
                      ),
                      child: Text(
                        '${widget.ride.price} EGP',
                        style: TextStyles.body.apply(color: AppColors.green, fontWeightDelta: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!auth.currentUser!.email!.contains(Lookups.driver)) 20.verticalSpace,
            if (!auth.currentUser!.email!.contains(Lookups.driver) && (widget.ride.status == RideStatus.completed || widget.ride.status == RideStatus.active))
              MainButton(
                text: widget.ride.status.capitalize,
                icon: Icon(Icons.check_circle_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
              )
            else if (widget.ride.requestedPassengers.any((element) => element.id == auth.currentUser!.uid))
              MainButton(
                text: 'Requested',
                icon: Icon(Icons.pending_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
              )
            else if (widget.ride.passengers.any((element) => element.id == auth.currentUser!.uid))
              MainButton(
                text: 'Reserved',
                icon: Icon(Icons.check_circle_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
              )
            else if (widget.ride.rejectedPassengers.any((element) => element.id == auth.currentUser!.uid))
              MainButton(
                text: 'Rejected',
                icon: Icon(Icons.cancel_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
              )
            else if (widget.ride.carCapacity != widget.ride.reservedSeats && !auth.currentUser!.email!.contains(Lookups.driver))
              MainButton(
                text: 'Reserve',
                icon: Icon(Icons.edit_rounded, color: AppColors.text, size: 18.r),
                onPressed: _requestRide,
                hollow: true,
              )
            else if (widget.ride.carCapacity == widget.ride.reservedSeats && !auth.currentUser!.email!.contains(Lookups.driver))
              MainButton(
                text: 'Full',
                icon: Icon(Icons.error_rounded, color: AppColors.text, size: 18.r),
                hollow: true,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestRide() {
    if (!_canRequestRide() && !Constants.bybassTimeConstraints) {
      return showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Cannot Request Ride',
          message: 'You can only request a ride after 10PM for rides to university and after 1PM for rides from university.',
        ),
      );
    }

    return RequestHandler.handleRequest(
      context: context,
      service: () => RequestServices.addRideRequest(
        RideRequest(
          driverId: widget.ride.driverId,
          user: AppUser.fromAuth(),
          rideId: widget.ride.id,
          status: RideRequest.pending,
        ),
      ),
      enableSuccessDialog: false,
      onSuccess: () {
        setState(() {
          widget.ride.requestedPassengers.add(AppUser.fromAuth());
        });
        Provider.of<PassengerRequestsProvider>(context, listen: false).refresh();
      },
    );
  }

  bool _canRequestRide() {
    final Duration difference = widget.ride.departureTime.difference(DateTime.now());
    if (widget.ride.type == Lookups.rideToUniversity) {
      // Can only request if before 10PM so 9 and a half hours
      return difference.inHours > 10 || (difference.inHours == 10 && difference.inMinutes.remainder(60) > 30);
    } else {
      // Can only request if before 1PM so 4 and a half hours
      return difference.inHours > 5 || (difference.inHours == 4 && difference.inMinutes.remainder(60) > 30);
    }
  }
}

RichText buildRichText(String key, String value, [double scale = 1]) {
  return RichText(
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      children: [
        TextSpan(text: key, style: TextStyles.smallBody.apply(fontSizeFactor: scale)),
        TextSpan(text: value, style: TextStyles.smallBodyThin.apply(fontSizeFactor: scale)),
      ],
    ),
  );
}

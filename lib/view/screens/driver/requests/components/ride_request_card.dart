import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/services/request_services.dart';
import 'package:milestoneone/tools/request_handler.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:milestoneone/view/screens/passenger/components/ride_card.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_data_provider.dart';
import 'package:milestoneone/view/utilities/date_utilities.dart';
import 'package:milestoneone/view/widgets/action/main_button.dart';
import 'package:milestoneone/view/widgets/dialog/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../global/colors.dart';
import '../../../../global/text_styles.dart';
import '../../../../utilities/general_utilities.dart';
import '../../../../widgets/misc/gradient_avatar.dart';

class RideRequestCard extends StatefulWidget {
  final RideRequest request;
  const RideRequestCard({super.key, required this.request});

  @override
  State<RideRequestCard> createState() => _RideRequestCardState();
}

class _RideRequestCardState extends State<RideRequestCard> {
  late Ride ride;
  @override
  Widget build(BuildContext context) {
    return Consumer3<DriverDataProvider, PassengerDataProvider, AuthenticationProvider>(
      builder: (context, driverDataProvider, passengerDataProvider, authenticationProvider, _) {
        try {
          if (authenticationProvider.isDriver) {
            ride = driverDataProvider.driverRides.firstWhere((ride) => ride.id == widget.request.rideId);
          } else {
            ride = passengerDataProvider.availableRides.firstWhere((ride) => ride.id == widget.request.rideId);
          }
        } catch (e) {
          return Container();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: AppColors.elevationOne,
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ride Request', style: TextStyles.subtitle),
              10.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.darkElevation,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14.r),
                        3.horizontalSpace,
                        buildRichText('From: ', ride.from.name),
                      ],
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14.r),
                        buildRichText('To: ', ride.to.name),
                      ],
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.timer_rounded, size: 14.r),
                        3.horizontalSpace,
                        buildRichText('', DateUtilities.getFormattedDateTime(ride.departureTime)),
                      ],
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              ListTile(
                leading: GradientAvatar(
                  radius: 30.r,
                  imageUrl: widget.request.user.profilePictureUrl,
                ),
                title: Text('${widget.request.user.firstName} ${widget.request.user.lastName}', style: TextStyles.body),
                subtitle: Text('@${GeneralUtilities.getCode(widget.request.user.email)}', style: TextStyles.tiny),
                trailing: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    color: AppColors.green.withOpacity(0.1),
                  ),
                  child: Text(
                    '${ride.price} EGP',
                    style: TextStyles.body.apply(color: AppColors.green, fontWeightDelta: 2),
                  ),
                ),
              ),
              10.verticalSpace,
              if (widget.request.status == RideRequest.pending && authenticationProvider.isDriver)
                Row(
                  children: [
                    Expanded(
                      child: MainButton(
                        text: 'Accept',
                        icon: Icon(Icons.check_circle_rounded, color: AppColors.text, size: 18.r),
                        onPressed: _acceptRideRequest,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: MainButton(
                        text: 'Decline',
                        icon: Icon(Icons.cancel_rounded, color: AppColors.text, size: 18.r),
                        hollow: true,
                        onPressed: _declineRideRequest,
                      ),
                    ),
                  ],
                )
              else if (widget.request.status == RideRequest.accepted)
                MainButton(
                  text: 'Accepted',
                  icon: Icon(Icons.check_circle_rounded, color: AppColors.text, size: 18.r),
                  hollow: true,
                )
              else if (widget.request.status == RideRequest.rejected)
                MainButton(
                  text: 'Rejected',
                  icon: Icon(Icons.cancel_rounded, color: AppColors.text, size: 18.r),
                  hollow: true,
                )
              else if (widget.request.status == RideRequest.pending)
                MainButton(
                  text: 'Pending',
                  icon: Icon(Icons.pending_rounded, color: AppColors.text, size: 18.r),
                  hollow: true,
                ),
            ],
          ),
        );
      },
    );
  }

  void _acceptRideRequest() async {
    if (!ride.hasFreeSeats()) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          title: 'No Free Seats',
          message: 'You can no longer accept this ride request because your ride has no free seats.',
        ),
      );
      return;
    }

    if (!(ride.status == RideStatus.pending)) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          title: 'Unable to Accept',
          message: 'You can no longer accept this ride request because your ride is active or completed.',
        ),
      );
      return;
    }

    await RequestHandler.handleRequest(
      context: context,
      service: () => RequestServices.acceptRideRequest(widget.request, ride.price),
      onSuccess: () {
        Provider.of<DriverRequestProvider>(context, listen: false)
          ..reloadRides()
          ..reloadRideRequests();
      },
    );
  }

  void _declineRideRequest() async {
    await RequestHandler.handleRequest(
      context: context,
      service: () => RequestServices.declineRideRequest(widget.request),
      onSuccess: () {
        Provider.of<DriverRequestProvider>(context, listen: false).reloadRideRequests();
      },
    );
  }
}

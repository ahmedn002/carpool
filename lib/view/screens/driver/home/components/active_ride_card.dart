import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/services/ride_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/screens/passenger/components/ride_card.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/action/main_button.dart';
import 'package:milestoneone/view/widgets/dialog/error_dialog.dart';
import 'package:milestoneone/view/widgets/misc/status_bar.dart';
import 'package:provider/provider.dart';

class ActiveRideCard extends StatefulWidget {
  final Ride ride;
  final Function() onStatusChanged;
  const ActiveRideCard({super.key, required this.ride, required this.onStatusChanged});

  @override
  State<ActiveRideCard> createState() => _ActiveRideCardState();
}

class _ActiveRideCardState extends State<ActiveRideCard> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: AppColors.darkElevation.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: AppColors.text, size: 15.r),
                        5.horizontalSpace,
                        Expanded(child: buildRichText('From: ', widget.ride.from.name)),
                      ],
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: AppColors.text, size: 15.r),
                        5.horizontalSpace,
                        Expanded(child: buildRichText('To: ', widget.ride.to.name)),
                      ],
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.timer_rounded, color: AppColors.text, size: 15.r),
                        5.horizontalSpace,
                        Expanded(child: buildRichText('Departs in: ', GeneralUtilities.getDuration(widget.ride.departureTime))),
                      ],
                    ),
                  ],
                ),
              ),
              5.horizontalSpace,
              Container(
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
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                width: 1.sw - 80.w,
                bubbleNames: const [RideStatus.pending, RideStatus.active, RideStatus.completed],
                selectedIndex: [RideStatus.pending, RideStatus.active, RideStatus.completed].indexOf(widget.ride.status),
              ),
            ],
          ),
          if (widget.ride.status != RideStatus.completed) 20.verticalSpace,
          if (widget.ride.status != RideStatus.completed)
            MainButton(
              text: widget.ride.status == RideStatus.pending ? 'Start Ride' : 'End Ride',
              icon: Icon(widget.ride.status == RideStatus.pending ? Icons.play_circle_rounded : Icons.check_circle_rounded, color: AppColors.text, size: 20.r),
              onPressed: _progressRideStatus,
              loading: _loading,
            )
        ],
      ),
    );
  }

  void _progressRideStatus() async {
    if (widget.ride.status != RideStatus.completed) {
      setState(() => _loading = true);
      String newStatus = widget.ride.status == RideStatus.pending ? RideStatus.active : RideStatus.completed;
      final FirebaseResponseWrapper<bool> changedSuccessfully = await RideServices.changeRideStatus(widget.ride.id, newStatus);
      if (changedSuccessfully.data) {
        setState(() {
          widget.ride.status = newStatus;
          _loading = false;
          Provider.of<DriverRequestProvider>(context, listen: false).rereadRides = false;
          widget.onStatusChanged();
        });
      } else {
        setState(() => _loading = false);
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error',
            message: changedSuccessfully.message ?? 'An error occurred while changing the ride status',
          ),
        );
      }
    }
  }
}

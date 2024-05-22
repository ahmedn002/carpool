import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/services/request_services.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_requests_provider.dart';
import 'package:provider/provider.dart';

import '../../../global/text_styles.dart';
import '../../../widgets/misc/gradient_icon.dart';
import '../../driver/requests/components/ride_request_card.dart';

class PassengerRequestsScreen extends StatefulWidget {
  const PassengerRequestsScreen({super.key});

  @override
  State<PassengerRequestsScreen> createState() => _PassengerRequestsScreenState();
}

class _PassengerRequestsScreenState extends State<PassengerRequestsScreen> {
  late final Future<FirebaseResponseWrapper<List<RideRequest>>> _rideRequestsRequest;

  @override
  void initState() {
    _rideRequestsRequest = RequestServices.getRideRequests(userId: auth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PassengerRequestsProvider, NavigationProvider>(
      builder: (context, passengerRequestsProvider, navigationProvider, _) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RequestWidget<List<RideRequest>>(
            request: passengerRequestsProvider.requestsFuture,
            successWidgetBuilder: (List<RideRequest> rideRequests) {
              rideRequests = rideRequests.where((rideRequest) => rideRequest.status == RideRequest.pending).toList();

              if (rideRequests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientIcon(
                        icon: Icons.check_circle_rounded,
                        size: 200.r,
                      ),
                      20.verticalSpace,
                      Text(
                        'No Pending Requests',
                        style: TextStyles.title,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: rideRequests
                      .map(
                        (rideRequest) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: RideRequestCard(request: rideRequest),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

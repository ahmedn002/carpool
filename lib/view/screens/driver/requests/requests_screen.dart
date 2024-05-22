import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/driver_data_provider.dart';
import '../../../widgets/misc/gradient_icon.dart';
import 'components/ride_request_card.dart';

class DriverRequestsScreen extends StatefulWidget {
  const DriverRequestsScreen({super.key});

  @override
  State<DriverRequestsScreen> createState() => _DriverRequestsScreenState();
}

class _DriverRequestsScreenState extends State<DriverRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Consumer3<DriverRequestProvider, DriverDataProvider, NavigationProvider>(
        builder: (context, driverRequestProvider, driverDataProvider, navigationProvider, _) {
          return RequestWidget<List<RideRequest>>(
            request: driverRequestProvider.rideRequestsRequest,
            successWidgetBuilder: (List<RideRequest> requests) {
              requests = requests.where((request) => request.status == RideRequest.pending).toList();

              if (requests.isEmpty) {
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

              return Column(
                children: [
                  20.verticalSpace,
                  Expanded(
                    child: ListView.separated(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final RideRequest request = requests[index];
                        return RideRequestCard(request: request);
                      },
                      separatorBuilder: (context, index) => 20.verticalSpace,
                    ),
                  ),
                ],
              );
            },
            failWidgetBuilder: (String message) {
              return Center(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

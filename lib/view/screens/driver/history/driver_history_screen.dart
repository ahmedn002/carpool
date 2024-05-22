import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/utilities/extensions.dart';
import 'package:milestoneone/view/widgets/input/multi_select_button.dart';
import 'package:provider/provider.dart';

import '../../../global/constants.dart';
import '../../../global/text_styles.dart';
import '../../../providers/driver_data_provider.dart';
import '../../../widgets/misc/gradient_icon.dart';
import '../requests/components/ride_request_card.dart';

class DriverOrderHistoryScreen extends StatefulWidget {
  const DriverOrderHistoryScreen({super.key});

  @override
  State<DriverOrderHistoryScreen> createState() => _DriverOrderHistoryScreenState();
}

class _DriverOrderHistoryScreenState extends State<DriverOrderHistoryScreen> {
  String _selectedStatus = '';
  final List<MultiSelectItem> _items = Constants.requestStatuses.keys.map((status) => MultiSelectItem(title: status.capitalize, icon: Constants.requestStatuses[status]!)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Consumer3<DriverRequestProvider, DriverDataProvider, NavigationProvider>(
        builder: (context, driverRequestProvider, driverDataProvider, navigationProvider, _) {
          return RequestWidget<List<RideRequest>>(
            request: driverRequestProvider.rideRequestsRequest,
            successWidgetBuilder: (List<RideRequest> requests) {
              requests = requests.where((request) => request.status != RideRequest.pending).toList();

              if (requests.isEmpty) {
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
                        'You haven\'t received any orders yet',
                        style: TextStyles.title,
                      ),
                    ],
                  ),
                );
              }

              if (_selectedStatus.isNotEmpty) {
                requests = requests.where((request) => request.status == _selectedStatus).toList();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Text(
                    'Order History',
                    style: TextStyles.title,
                  ),
                  10.verticalSpace,
                  MultiSelectButton(
                    items: _items,
                    onChanged: (item) {
                      setState(() {
                        _selectedStatus = item?.title.toLowerCase() ?? '';
                      });
                    },
                    initialIndex: _selectedStatus.isNotEmpty ? _items.indexWhere((item) => item.title.toLowerCase() == _selectedStatus) : -1,
                    emptySelectionAllowed: true,
                  ),
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

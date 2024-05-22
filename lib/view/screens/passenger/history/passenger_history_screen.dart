import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/utilities/extensions.dart';

import '../../../../main.dart';
import '../../../../model/classes/ride_request.dart';
import '../../../../services/request_services.dart';
import '../../../../tools/request_widget.dart';
import '../../../../tools/response_wrapper.dart';
import '../../../global/constants.dart';
import '../../../global/text_styles.dart';
import '../../../widgets/input/multi_select_button.dart';
import '../../../widgets/misc/gradient_icon.dart';
import '../../driver/requests/components/ride_request_card.dart';

class PassengerHistoryScreen extends StatefulWidget {
  const PassengerHistoryScreen({super.key});

  @override
  State<PassengerHistoryScreen> createState() => _PassengerHistoryScreenState();
}

class _PassengerHistoryScreenState extends State<PassengerHistoryScreen> {
  String _selectedStatus = '';
  final List<MultiSelectItem> _items = Constants.requestStatuses.keys.map((status) => MultiSelectItem(title: status.capitalize, icon: Constants.requestStatuses[status]!)).toList();

  late final Future<FirebaseResponseWrapper<List<RideRequest>>> _rideRequestsRequest;

  @override
  void initState() {
    _rideRequestsRequest = RequestServices.getRideRequests(userId: auth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RequestWidget<List<RideRequest>>(
        request: _rideRequestsRequest,
        successWidgetBuilder: (List<RideRequest> rideRequests) {
          rideRequests = rideRequests.where((rideRequest) => rideRequest.status != RideRequest.pending).toList();

          if (rideRequests.isEmpty) {
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
                    'You haven\'t completed any orders yet',
                    style: TextStyles.title,
                  ),
                ],
              ),
            );
          }

          if (_selectedStatus.isNotEmpty) {
            rideRequests = rideRequests.where((rideRequest) => rideRequest.status == _selectedStatus).toList();
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
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
                  initialIndex: _selectedStatus.isEmpty ? -1 : _items.indexWhere((item) => item.title.toLowerCase() == _selectedStatus),
                  emptySelectionAllowed: true,
                ),
                20.verticalSpace,
                ...rideRequests.map(
                  (rideRequest) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: RideRequestCard(request: rideRequest),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

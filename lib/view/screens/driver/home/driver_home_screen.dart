import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/view/global/constants.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/screens/driver/home/components/active_ride_card.dart';
import 'package:milestoneone/view/screens/passenger/components/ride_card.dart';
import 'package:milestoneone/view/utilities/extensions.dart';
import 'package:milestoneone/view/widgets/input/multi_select_button.dart';
import 'package:provider/provider.dart';

import '../../../global/colors.dart';
import '../../../widgets/action/main_button.dart';
import '../../../widgets/misc/gradient_icon.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String _selectedStatus = '';
  final List<MultiSelectItem> _items = Constants.rideStatuses.keys.map((status) => MultiSelectItem(title: status.capitalize, icon: Constants.rideStatuses[status]!)).toList();

  List<Ride> _rides = [];
  List<Ride> _filteredRides = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: MainButton(
          text: 'Create Ride',
          onPressed: () => Navigator.pushNamed(context, '/create-ride'),
          icon: Icon(Icons.directions_car_rounded, color: AppColors.text, size: 20.r),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            20.verticalSpace,
            Expanded(
              child: Consumer2<DriverRequestProvider, DriverDataProvider>(
                builder: (context, driverRequestProvider, driverDataProvider, child) {
                  return RequestWidget<List<Ride>>(
                    request: driverRequestProvider.ridesRequest,
                    successWidgetBuilder: (List<Ride> data) {
                      if (driverRequestProvider.rereadRides) {
                        _rides = data;
                        driverRequestProvider.rereadRides = false;
                      }
                      driverDataProvider.driverRides = _rides;
                      driverDataProvider.checkForActiveRide();

                      if (_rides.isEmpty) {
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
                                'You haven\'t created any rides yet',
                                style: TextStyles.title,
                              ),
                            ],
                          ),
                        );
                      }

                      if (_selectedStatus.isNotEmpty) {
                        _filteredRides = _rides.where((ride) => ride.status == _selectedStatus).toList();
                      } else {
                        _filteredRides = _rides;
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (driverDataProvider.currentlyActiveRide != null) ...[
                              Text('Active Ride', style: TextStyles.title),
                              10.verticalSpace,
                              ActiveRideCard(ride: driverDataProvider.currentlyActiveRide!, onStatusChanged: () => setState(() {})),
                              20.verticalSpace,
                            ],
                            Text('Recent Rides', style: TextStyles.title),
                            10.verticalSpace,
                            MultiSelectButton(
                              items: _items,
                              onChanged: (MultiSelectItem? item) {
                                setState(() {
                                  _selectedStatus = item?.title.toLowerCase() ?? '';
                                });
                              },
                              scale: 0.9,
                              initialIndex: _selectedStatus.isEmpty ? -1 : _items.indexWhere((item) => item.title.toLowerCase() == _selectedStatus),
                              emptySelectionAllowed: true,
                            ),
                            20.verticalSpace,
                            ..._filteredRides
                                .map(
                                  (ride) => Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: RideCard(ride: ride),
                                  ),
                                )
                                .toList(),
                            40.verticalSpace,
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}

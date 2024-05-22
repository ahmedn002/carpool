import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/services/ride_services.dart';
import 'package:milestoneone/tools/request_widget.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_data_provider.dart';
import 'package:milestoneone/view/widgets/misc/gradient_icon.dart';
import 'package:provider/provider.dart';

import '../../../global/lookups.dart';
import '../../../widgets/input/multi_select_button.dart';
import '../components/ride_card.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  final Future<FirebaseResponseWrapper<List<Ride>>> _ridesRequest = RideServices.getRides();

  String _selectedDirection = '';
  final List<MultiSelectItem> _items = [
    MultiSelectItem(title: Lookups.rideToUniversity, icon: SvgPicture.asset('assets/logobw.svg', width: 20.r)),
    const MultiSelectItem(title: Lookups.rideFromUniversity, icon: Icon(Icons.arrow_back_rounded)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Consumer<PassengerDataProvider>(
          builder: (context, passengerDataProvider, _) {
            return RequestWidget<List<Ride>>(
              request: _ridesRequest,
              successWidgetBuilder: (List<Ride> rides) {
                passengerDataProvider.setAvailableRides(rides);
                if (rides.isEmpty) {
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
                          'There are no available rides at the moment.',
                          style: TextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                rides = rides.where((ride) => ride.status == RideStatus.pending).toList();

                if (_selectedDirection.isNotEmpty) {
                  rides = rides.where((ride) => ride.type.toLowerCase() == _selectedDirection).toList();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        'Available Rides',
                        style: TextStyles.title,
                      ),
                      10.verticalSpace,
                      MultiSelectButton(
                        items: _items,
                        onChanged: (item) {
                          setState(() {
                            _selectedDirection = item?.title.toLowerCase() ?? '';
                          });
                        },
                        emptySelectionAllowed: true,
                        initialIndex: _selectedDirection.isNotEmpty ? _items.indexWhere((item) => item.title.toLowerCase() == _selectedDirection) : -1,
                      ),
                      20.verticalSpace,
                      ...rides.map(
                        (ride) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: RideCard(ride: ride),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

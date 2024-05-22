import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/ride_location.dart';
import 'package:milestoneone/services/ride_services.dart';
import 'package:milestoneone/tools/request_handler.dart';
import 'package:milestoneone/view/global/lookups.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/utilities/date_utilities.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/utilities/location_utilities.dart';
import 'package:milestoneone/view/widgets/dialog/error_dialog.dart';
import 'package:milestoneone/view/widgets/input/app_text_field.dart';
import 'package:milestoneone/view/widgets/input/map.dart';
import 'package:milestoneone/view/widgets/input/multi_select_button.dart';
import 'package:milestoneone/view/widgets/misc/mini_map.dart';
import 'package:provider/provider.dart';

import '../../../global/colors.dart';
import '../../../global/constants.dart';
import '../../../widgets/action/main_button.dart';
import '../../../widgets/input/number_wheel.dart';
import '../../../widgets/misc/app_bar.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late List<MultiSelectItem> _items;
  late MultiSelectItem _selectedItem;

  RideLocation? _selectedGateLocation;
  double? _selectedMapLatitude;
  double? _selectedMapLongitude;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Key _gatesKey = UniqueKey();

  final int _maxPrice = 40;
  int _currentPrice = 25;

  final int _maxSeats = 6;
  int _currentSeats = 3;

  late DateTime _rideDate;
  final TextEditingController _rideDateController = TextEditingController();

  @override
  void initState() {
    _items = _getItems();
    _selectedItem = _items.first;

    // Initially tomorrow at 7:30 AM
    _rideDate = _getRideDate();
    _rideDateController.text = DateUtilities.getFormattedDateTime(_rideDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      20.verticalSpace,
      Text(
        'Choose Ride Type',
        style: TextStyles.title,
      ),
      10.verticalSpace,
      MultiSelectButton(
        items: _items,
        onChanged: (MultiSelectItem? item) {
          setState(() {
            _selectedItem = item!;
            _selectedGateLocation = null;
            _rideDate = _getRideDate();
            _rideDateController.text = DateUtilities.getFormattedDateTime(_rideDate);
          });
        },
      ),
      20.verticalSpace,
      Text(
        'Choose Pickup Location',
        style: TextStyles.title,
      ),
      10.verticalSpace,

      // Animated list that should animate gate selection and the google map to switch between them when the user selects a different ride type
      ListView.builder(
        key: _listKey,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          if (_selectedItem.title == Lookups.rideToUniversity) {
            return _buildPositionOne()[index];
          } else {
            return _buildPositionTwo()[index];
          }
        },
      ),

      20.verticalSpace,
      Text(
        'Choose Ride Price',
        style: TextStyles.title,
      ),
      NumberWheel(
        range: _maxPrice,
        initialNumber: _currentPrice,
        currentIndex: _currentPrice,
        onNumberChanged: (dynamic number) => setState(() => _currentPrice = number),
      ),
      20.verticalSpace,
      Text(
        'Choose number of available seats',
        style: TextStyles.title,
      ),
      NumberWheel(
        range: _maxSeats,
        initialNumber: _currentSeats,
        currentIndex: _currentSeats,
        onNumberChanged: (dynamic number) => setState(() => _currentSeats = number),
      ),
      20.verticalSpace,
      Text(
        'Enter your car model',
        style: TextStyles.title,
      ),
      10.verticalSpace,
      AppTextField(
        controller: _carModelController,
        hintText: 'Car Model',
        prefixIcon: const Icon(Icons.directions_car_rounded),
        validator: _notEmptyValidator,
      ),
      20.verticalSpace,
      Text(
        'Choose Ride Date',
        style: TextStyles.title,
      ),
      10.verticalSpace,
      GestureDetector(
        onTap: () async {
          final DateTime? date = await showDatePicker(
            context: context,
            initialDate: _rideDate,
            firstDate: _canCreateToday() ? DateTime.now() : DateTime.now().add(1.days),
            lastDate: DateTime.now().add(30.days),
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.accent1,
                    onPrimary: AppColors.background,
                    surface: AppColors.darkElevation,
                    onSurface: AppColors.text,
                  ),
                  dialogBackgroundColor: AppColors.elevationOne,
                  dialogTheme: DialogTheme(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                    actionsPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                    ),
                  ),
                  buttonTheme: ButtonThemeData(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.r))),
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: child!,
                ),
              );
            },
          );
          if (date != null) {
            setState(() {
              if (_selectedItem.title == Lookups.rideToUniversity) {
                _rideDate = date.copyWith(hour: 7, minute: 30);
              } else {
                _rideDate = date.copyWith(hour: 17, minute: 30);
              }
              _rideDateController.text = DateUtilities.getFormattedDateTime(_rideDate);
            });
          }
        },
        child: AppTextField(
          controller: _rideDateController,
          hintText: 'Ride Date',
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          validator: _notEmptyValidator,
          enabled: false,
          suffix: Icon(
            Icons.edit_rounded,
            color: AppColors.text,
            size: 18.r,
          ),
        ),
      ),
      20.verticalSpace,
      MainButton(
        text: 'Create Ride',
        onPressed: _createRide,
        icon: Icon(Icons.directions_car_rounded, color: AppColors.text, size: 20.r),
      ),
      20.verticalSpace,
    ];
    return Scaffold(
      appBar: const CarpoolAppBar(enableNavigation: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPositionOne() {
    return [
      _buildGatesSelectionSection(),
      _buildTitleSection(),
      _buildMapSection(),
    ];
  }

  List<Widget> _buildPositionTwo() {
    return [
      _buildMapSection(),
      _buildTitleSection(),
      _buildGatesSelectionSection(),
    ];
  }

  Widget _buildMapSection() {
    return Column(
      children: [
        MapWidget(
          onLocationSelected: (double latitude, double longitude) {
            setState(() {
              _selectedMapLatitude = latitude;
              _selectedMapLongitude = longitude;
            });
          },
        ),
        10.verticalSpace,
        AppTextField(
          controller: _addressController,
          hintText: 'Address Details',
          prefixIcon: const Icon(Icons.location_on_rounded),
          validator: _notEmptyValidator,
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Text(
          'Choose Drop-off Location',
          style: TextStyles.title,
          textAlign: TextAlign.center,
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildGatesSelectionSection() {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        key: _gatesKey,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const RideLocation(
            name: 'Gate Two',
            latitude: Constants.gateTwoLatitude,
            longitude: Constants.gateTwoLongitude,
          ),
          const RideLocation(
            name: 'Gate Three',
            latitude: Constants.gateThreeLatitude,
            longitude: Constants.gateThreeLongitude,
          ),
        ]
            .map(
              (location) => GestureDetector(
                onTap: () => setState(() {
                  _selectedGateLocation = _selectedGateLocation == location ? null : location;
                }),
                child: AnimatedContainer(
                  duration: 750.ms,
                  curve: Curves.easeOutExpo,
                  width: 0.4.sw,
                  height: 0.3.sw,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.elevationOne,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: _selectedGateLocation == location ? AppColors.accent1 : Colors.transparent,
                      width: 2.r,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      MiniMap(
                        latitude: location.latitude,
                        longitude: location.longitude,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: 750.ms,
                          curve: Curves.easeOutExpo,
                          width: 0.3.sw,
                          padding: EdgeInsets.all(5.r),
                          margin: EdgeInsets.only(bottom: 5.r),
                          decoration: BoxDecoration(
                            color: _selectedGateLocation == location ? AppColors.accent1 : AppColors.elevationOne,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: 750.ms,
                                curve: Curves.easeOutExpo,
                                style: TextStyles.body.copyWith(
                                  color: _selectedGateLocation != location ? AppColors.text : AppColors.elevationOne,
                                  fontFamily: 'Outfit',
                                ),
                                child: Text(location.name),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }

  String? _notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  List<MultiSelectItem> _getItems() {
    return [
      MultiSelectItem(title: Lookups.rideToUniversity, icon: SvgPicture.asset('assets/logobw.svg', width: 20.r)),
      const MultiSelectItem(title: Lookups.rideFromUniversity, icon: Icon(Icons.home_rounded)),
    ];
  }

  DateTime _getRideDate() {
    if (_selectedItem.title == Lookups.rideToUniversity) {
      if (_canCreateToday()) {
        return DateTime.now().add(1.days).copyWith(hour: 7, minute: 30);
      } else {
        return DateTime.now().add(2.days).copyWith(hour: 7, minute: 30);
      }
    } else {
      if (_canCreateToday()) {
        return DateTime.now().copyWith(hour: 17, minute: 30);
      } else {
        return DateTime.now().add(1.days).copyWith(hour: 17, minute: 30);
      }
    }
  }

  bool _canCreateToday() {
    if (_selectedItem.title == Lookups.rideToUniversity) {
      // if we are before 10 PM and after 7:30 AM
      return DateTime.now().hour < 22 && (DateTime.now().hour > 7 || (DateTime.now().hour == 7 && DateTime.now().minute >= 30));
    } else {
      // if we are before 1 PM and after 5:30 PM
      return DateTime.now().hour < 13 && (DateTime.now().hour > 17 || (DateTime.now().hour == 17 && DateTime.now().minute >= 30));
    }
  }

  void _createRide() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMapLatitude == null || _selectedMapLongitude == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Invalid Location',
          message: 'Please select a location on the map.',
        ),
      );
      return;
    }

    if (_selectedGateLocation == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Invalid Gate',
          message: 'Please select a gate.',
        ),
      );
      return;
    }

    final Ride? ride = _getRide();
    if (ride == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Invalid Information',
          message: 'Please fill in all the required information and make sure they are valid.',
        ),
      );
    } else {
      RequestHandler.handleRequest(
        context: context,
        service: () => RideServices.addRide(ride),
        loadingMessage: 'Please wait while we create your ride',
        successTitle: 'Ride Created',
        successMessage: 'Your will be redirected in a second.',
        onSuccess: () {
          context.read<DriverRequestProvider>().reloadRides();
        },
        redirect: true,
        redirection: () => Navigator.pop(context),
      );
    }
    debugPrint('Ride created: $ride');
  }

  Ride? _getRide() {
    try {
      final String rideType = _selectedItem.title;
      final String carModel = _carModelController.text;
      final String addressDescription = _addressController.text;
      final int price = _currentPrice;
      final int seats = _currentSeats;
      final DateTime rideDate = _rideDate;

      final RideLocation firstLocation;
      final RideLocation secondLocation;
      if (_selectedItem.title == Lookups.rideToUniversity) {
        firstLocation = RideLocation(
          name: addressDescription,
          latitude: _selectedMapLatitude!,
          longitude: _selectedMapLongitude!,
        );
        secondLocation = LocationUtilities.getGateRideLocation(_selectedGateLocation!.latitude, _selectedGateLocation!.longitude);
      } else {
        firstLocation = LocationUtilities.getGateRideLocation(_selectedGateLocation!.latitude, _selectedGateLocation!.longitude);
        secondLocation = RideLocation(
          name: addressDescription,
          latitude: _selectedMapLatitude!,
          longitude: _selectedMapLongitude!,
        );
      }

      return Ride(
        status: RideStatus.pending,
        type: rideType,
        driverName: auth.currentUser!.displayName ?? 'User',
        driverId: auth.currentUser!.uid,
        driverStudentCode: GeneralUtilities.getCode(FirebaseAuth.instance.currentUser!.email ?? '', parse: true),
        driverPhotoUrl: auth.currentUser!.photoURL ?? '',
        car: carModel,
        carCapacity: seats,
        reservedSeats: 0,
        from: firstLocation,
        to: secondLocation,
        departureTime: rideDate,
        passengers: [],
        requestedPassengers: [],
        rejectedPassengers: [],
        price: price,
      );
    } catch (e) {
      return null;
    }
  }
}

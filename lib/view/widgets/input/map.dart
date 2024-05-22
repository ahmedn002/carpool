import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:milestoneone/view/global/colors.dart';

class MapWidget extends StatefulWidget {
  final void Function(double, double) onLocationSelected;
  const MapWidget({super.key, required this.onLocationSelected});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  late String _darkMapStyle;

  late final Future<LocationData> _locationFinder;

  LocationData? _currentUserLocation;

  CameraPosition? _currentCameraPosition;

  Future<void> checkLocationServices() async {
    await Geolocator.checkPermission();
    await Geolocator.isLocationServiceEnabled();
  }

  @override
  void initState() {
    checkLocationServices();

    _loadMapStyle();
    _locationFinder = _getCurrentUserLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        height: 200.h,
        width: 1.sw - 40.w,
        child: FutureBuilder(
          future: _locationFinder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: AppColors.elevationOne,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              _currentUserLocation = snapshot.data as LocationData;

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentUserLocation!.latitude!,
                        _currentUserLocation!.longitude!,
                      ),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      controller.setMapStyle(_darkMapStyle);
                      widget.onLocationSelected(_currentUserLocation!.latitude!, _currentUserLocation!.longitude!);
                    },
                    onCameraMove: (CameraPosition position) {
                      _currentCameraPosition = position;
                    },
                    onCameraIdle: () async {
                      if (_currentCameraPosition == null) return;
                      widget.onLocationSelected(_currentCameraPosition!.target.latitude, _currentCameraPosition!.target.longitude);
                    },
                    gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
                  ),
                  // Central Marker
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.r),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.accent1,
                        size: 25.r,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.w, bottom: 15.w),
                      child: FloatingActionButton(
                        onPressed: () async {
                          final GoogleMapController controller = await _controller.future;
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(_currentUserLocation!.latitude!, _currentUserLocation!.longitude!),
                                zoom: 14,
                              ),
                            ),
                          );
                        },
                        backgroundColor: AppColors.accent1,
                        child: const Icon(Icons.gps_fixed, color: AppColors.elevationOne),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<LocationData> _getCurrentUserLocation() async {
    return await Location().getLocation();
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/maps/dark.json');
  }

  @override
  bool get wantKeepAlive => true;
}

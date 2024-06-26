import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/constants.dart';
import 'package:milestoneone/view/utilities/map_utilities.dart';

class MiniMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool launchGoogleMapsOnTap;
  const MiniMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.launchGoogleMapsOnTap = false,
  });

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late final Image _image;

  @override
  void initState() {
    _image = Image.network(
      'https://maps.googleapis.com/maps/api/staticmap?center=${widget.latitude},${widget.longitude}&zoom=16&size=400x300&maptype=roadmap&key=${Constants.googleMapsApiKey}&style=element%3Ageometry%7Ccolor%3A0x242f3e&style=element%3Alabels.text.stroke%7Ccolor%3A0x242f3e&style=element%3Alabels.text.fill%7Ccolor%3A0x746855&style=feature%3Aadministrative.locality%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi.park%7Celement%3Ageometry%7Ccolor%3A0x263c3f&style=feature%3Apoi.park%7Celement%3Alabels.text.fill%7Ccolor%3A0x6b9a76&style=feature%3Aroad%7Celement%3Ageometry%7Ccolor%3A0x38414e&style=feature%3Aroad%7Celement%3Ageometry.stroke%7Ccolor%3A0x212a37&style=feature%3Aroad%7Celement%3Alabels.text.fill%7Ccolor%3A0x9ca5b3&style=feature%3Aroad.highway%7Celement%3Ageometry%7Ccolor%3A0x746855&style=feature%3Aroad.highway%7Celement%3Ageometry.stroke%7Ccolor%3A0x1f2835&style=feature%3Aroad.highway%7Celement%3Alabels.text.fill%7Ccolor%3A0xf3d19c&style=feature%3Atransit%7Celement%3Ageometry%7Ccolor%3A0x2f3948&style=feature%3Atransit.station%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Awater%7Celement%3Ageometry%7Ccolor%3A0x17263c&style=feature%3Awater%7Celement%3Alabels.text.fill%7Ccolor%3A0x515c6d&style=feature%3Awater%7Celement%3Alabels.text.stroke%7Ccolor%3A0x17263c',
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(_image.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: AspectRatio(
        aspectRatio: 400 / 300,
        child: Stack(
          children: [
            Image.network(
              'https://maps.googleapis.com/maps/api/staticmap?center=${widget.latitude},${widget.longitude}&zoom=16&size=400x300&maptype=roadmap&key=${Constants.googleMapsApiKey}&style=element%3Ageometry%7Ccolor%3A0x242f3e&style=element%3Alabels.text.stroke%7Ccolor%3A0x242f3e&style=element%3Alabels.text.fill%7Ccolor%3A0x746855&style=feature%3Aadministrative.locality%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Apoi.park%7Celement%3Ageometry%7Ccolor%3A0x263c3f&style=feature%3Apoi.park%7Celement%3Alabels.text.fill%7Ccolor%3A0x6b9a76&style=feature%3Aroad%7Celement%3Ageometry%7Ccolor%3A0x38414e&style=feature%3Aroad%7Celement%3Ageometry.stroke%7Ccolor%3A0x212a37&style=feature%3Aroad%7Celement%3Alabels.text.fill%7Ccolor%3A0x9ca5b3&style=feature%3Aroad.highway%7Celement%3Ageometry%7Ccolor%3A0x746855&style=feature%3Aroad.highway%7Celement%3Ageometry.stroke%7Ccolor%3A0x1f2835&style=feature%3Aroad.highway%7Celement%3Alabels.text.fill%7Ccolor%3A0xf3d19c&style=feature%3Atransit%7Celement%3Ageometry%7Ccolor%3A0x2f3948&style=feature%3Atransit.station%7Celement%3Alabels.text.fill%7Ccolor%3A0xd59563&style=feature%3Awater%7Celement%3Ageometry%7Ccolor%3A0x17263c&style=feature%3Awater%7Celement%3Alabels.text.fill%7Ccolor%3A0x515c6d&style=feature%3Awater%7Celement%3Alabels.text.stroke%7Ccolor%3A0x17263c',
              fit: BoxFit.cover,
            ),
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
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.launchGoogleMapsOnTap
                      ? () {
                          MapUtilities.openMapsOnLocation(widget.latitude, widget.longitude);
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

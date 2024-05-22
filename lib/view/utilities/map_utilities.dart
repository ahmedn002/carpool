import 'package:url_launcher/url_launcher.dart';

class MapUtilities {
  static Future<void> openMapsOnLocation(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await launchUrl(Uri.parse(googleUrl));
  }
}

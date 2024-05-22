import 'package:flutter/material.dart';
import 'package:milestoneone/view/utilities/extensions.dart';

import '../global/constants.dart';
import '../widgets/input/multi_select_button.dart';

class GeneralUtilities {
  static List<MultiSelectItem> getItems() {
    return [
      MultiSelectItem(
        icon: const Icon(Icons.directions_car_rounded),
        title: Constants.driver.capitalize,
      ),
      MultiSelectItem(
        icon: const Icon(Icons.directions_walk_rounded),
        title: Constants.passenger.capitalize,
      ),
    ];
  }

  static String parseEmail(String email) {
    // 19P7926@eng.asu.edu.eg.driver or 19P7926@eng.asu.edu.eg.passenger
    return email.split('.').sublist(0, 4).join('.');
  }

  static String getCode(String email, {bool parse = true}) {
    try {
      if (parse) {
        email = parseEmail(email);
      }
      return email.substring(0, email.indexOf('@'));
    } catch (e) {
      return 'User';
    }
  }

  static bool isDriver(String email) {
    final String prefix = email.split('.').last;
    return prefix == Constants.driver;
  }

  static String getDuration(DateTime departureTime) {
    final Duration duration = departureTime.difference(DateTime.now());
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ${duration.inHours.remainder(24)} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }
}

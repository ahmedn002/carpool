import 'package:flutter/material.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:milestoneone/view/screens/driver/history/driver_history_screen.dart';
import 'package:milestoneone/view/screens/driver/home/driver_home_screen.dart';
import 'package:milestoneone/view/screens/driver/profile/profile_screen.dart';
import 'package:milestoneone/view/screens/driver/requests/requests_screen.dart';
import 'package:milestoneone/view/screens/passenger/history/passenger_history_screen.dart';
import 'package:milestoneone/view/screens/passenger/home/passenger_home_screen.dart';
import 'package:milestoneone/view/screens/passenger/requests/passenger_requests_screen.dart';
import 'package:milestoneone/view/widgets/input/navigation_drawer.dart';
import 'package:milestoneone/view/widgets/misc/app_bar.dart';
import 'package:provider/provider.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, NavigationProvider>(
      builder: (context, authenticationProvider, navigationProvider, _) => Scaffold(
        appBar: const CarpoolAppBar(),
        drawer: const CarpoolNavigationDrawer(),
        body: IndexedStack(
          index: navigationProvider.currentIndex,
          children: authenticationProvider.isDriver ? _getDriverScreens() : _getPassengerScreens(),
        ),
      ),
    );
  }

  List<Widget> _getDriverScreens() {
    return [
      const DriverHomeScreen(),
      const DriverRequestsScreen(),
      const DriverOrderHistoryScreen(),
      const ProfileScreen(),
    ];
  }

  List<Widget> _getPassengerScreens() {
    return [
      const PassengerHomeScreen(),
      const PassengerRequestsScreen(),
      const PassengerHistoryScreen(),
      const ProfileScreen(),
    ];
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context.read<AuthenticationProvider>();
    final DriverDataProvider dataProvider = context.read<DriverDataProvider>();
    final DriverRequestProvider requestProvider = context.read<DriverRequestProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, '/authentication');
        } else {
          print('Found User: ${user.uid}');
          authProvider.rememberUser(user);
          requestProvider.initialize(dataProvider);
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

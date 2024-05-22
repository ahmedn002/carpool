import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';
import 'package:milestoneone/view/providers/driver_request_provider.dart';
import 'package:milestoneone/view/providers/navigation_provider.dart';
import 'package:milestoneone/view/screens/authentication/authentication_screen.dart';
import 'package:milestoneone/view/screens/authentication/gate.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:milestoneone/view/screens/authentication/registration_screen.dart';
import 'package:milestoneone/view/screens/driver/create/create_ride_screen.dart';
import 'package:milestoneone/view/screens/navigation_wrapper.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_data_provider.dart';
import 'package:milestoneone/view/screens/passenger/providers/passenger_requests_provider.dart';
import 'package:provider/provider.dart';

import 'tools/firebase_options.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final Reference storage = FirebaseStorage.instance.ref();

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.background));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => DriverRequestProvider()),
          ChangeNotifierProvider(create: (_) => DriverDataProvider()),
          ChangeNotifierProvider(create: (_) => PassengerRequestsProvider()),
          ChangeNotifierProvider(create: (_) => PassengerDataProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(430, 932),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/gate',
            routes: {
              '/gate': (_) => const GateScreen(),
              '/authentication': (_) => const AuthenticationScreen(),
              '/registration': (_) => const RegistrationScreen(),
              '/home': (_) => const NavigationWrapper(),
              '/create-ride': (_) => const CreateRideScreen(),
            },
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.background,
              dialogBackgroundColor: AppColors.elevationOne,
              dialogTheme: const DialogTheme(
                backgroundColor: AppColors.elevationOne,
                surfaceTintColor: Colors.transparent,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.background,
                surfaceTintColor: AppColors.background,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.text),
              ),
              iconTheme: const IconThemeData(color: AppColors.secondaryText),
              splashColor: AppColors.accent1.withOpacity(0.1),
              fontFamily: 'Outfit',
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: AppColors.text,
                    displayColor: AppColors.text,
                    fontFamily: 'Outfit',
                  ),
              useMaterial3: true,
            ),
          ),
        ),
      ),
    );
  }

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final int alpha = color.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };

    return MaterialColor(color.value, shades);
  }
}

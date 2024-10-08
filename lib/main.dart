import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdw_app/providers/location_provider.dart';
import 'package:mdw_app/providers/main_screen_index_provider.dart';
import 'package:mdw_app/screens/code_verification_screen.dart';
import 'package:mdw_app/screens/main_screen.dart';
import 'package:mdw_app/screens/onboarding_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => MainScreenIndexProvider()),
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool signInStatus = false, attendStatus = false;

  getData() async {
    signInStatus = await AppFunctions.getSignInStatus();
    attendStatus = await AppFunctions.getAttendanceStatus();
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: getData(),
        builder: ((ctx, snapshot) {
          if (signInStatus == true) {
            if (attendStatus) {
              return MainScreen();
            } else {
              return CodeVerificationScreen(
                head: "Attendance",
                upperText:
                    "Ask your admin to enter his code to confirm your attendance.",
                type: 0,
                btnText: "Confirm Attendance",
              );
            }
          } else {
            return OnboardingScreen();
          }
        }),
      ),
    );
  }
}

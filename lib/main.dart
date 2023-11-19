import 'package:beyond_seoul/routes/routes.dart';
import 'package:beyond_seoul/routes/routes_name.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 840),
      builder: (BuildContext context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const OnboardingScreen(),
        home: const App(),
      ),
    );
  }
}

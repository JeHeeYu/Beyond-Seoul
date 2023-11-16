import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'controlleres/bottom_navigation.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            return false;
          }
          return true;
        },
        child: const BottomNavigationController(),
      ),
    );
  }
}

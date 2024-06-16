import 'package:flutter/material.dart';
import 'controlleres/bottom_navigation.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  DateTime? currentBackPressTime;
  final GlobalKey<BottomNavigationControllerState> _bottomNavigationKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          return false;
        }
        return true;
      },
      child: BottomNavigationController(key: _bottomNavigationKey),
    );
  }

  void changeTab(int index) {
    _bottomNavigationKey.currentState?.setPageIndex(index);
  }
}

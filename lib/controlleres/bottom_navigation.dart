import 'package:beyond_seoul/view/screens/contents_screen.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/profile_screen.dart';
import 'package:beyond_seoul/view/screens/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../statics/images.dart';
import '../statics/strings.dart';

class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({super.key});

  @override
  State<BottomNavigationController> createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  int _selectIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const ContentsScreen(),
    const RecordScreen(),
    const ProfileScreen(),
  ];

  void _onBottomTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectIndex,
          onTap: _onBottomTapped,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(Images.homeDisable),
              activeIcon: Image.asset(Images.homeEnable),
              label: Strings.home,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(Images.contentsDisable),
              activeIcon: Image.asset(Images.contentsEnable),
              label: Strings.contents,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(Images.recordDisable),
              activeIcon: Image.asset(Images.recordEnable),
              label: Strings.record,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(Images.profileDisable),
              activeIcon: Image.asset(Images.profileEnable),
              label: Strings.profile,
            ),
          ],
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

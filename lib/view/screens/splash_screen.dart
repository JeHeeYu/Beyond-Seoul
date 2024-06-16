import 'dart:math';

import 'package:beyond_seoul/view/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../routes/routes_name.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/login_view_model.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  LoginViewModel _loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    Future.delayed(const Duration(seconds: 3), _checkLoginStatus);
  }

  void _checkLoginStatus() async {
    String? loginInfo = await _storage.read(key: Strings.loginKey);
    String? uidInfo = await _storage.read(key: Strings.uidKey);

    if (!mounted) return;

    if (uidInfo != null && uidInfo.isNotEmpty) {
      _loginViewModel.setUid(uidInfo);
    }

    if (loginInfo == 'true' && uidInfo != null && uidInfo.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(RoutesName.app);
    } else {
      Navigator.of(context).pushReplacementNamed(RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(const Duration(seconds: 3)).then((_) async {
      Navigator.of(context).pushNamed(RoutesName.login);
    });

    double iconSize =
        min(ScreenUtil().screenWidth, ScreenUtil().screenHeight) * 0.6;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 244, 246, 1.0),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              Images.bgLogin,
              width: iconSize,
              height: iconSize,
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              "Ver. 1.0.4 240610",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

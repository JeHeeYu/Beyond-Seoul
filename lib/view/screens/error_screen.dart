import 'package:beyond_seoul/statics/colors.dart';
import 'package:flutter/material.dart';

import '../../statics/images.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(UserColors.mainBackGround),
      child: Center(
        child: Image.asset(Images.errorScreenBg),
      ),
    );
  }
}
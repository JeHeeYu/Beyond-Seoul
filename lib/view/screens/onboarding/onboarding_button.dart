import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../statics/colors.dart';

class OnboardingButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final bool enable;

  const OnboardingButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(width),
      height: ScreenUtil().setHeight(height),
      decoration: BoxDecoration(
        color: enable
            ? const Color(UserColors.enable).withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),
        border: Border.all(
          color: enable == true ? const Color(UserColors.enable) : Colors.white,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: enable == true ? const Color(UserColors.enable) : Colors.black,
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

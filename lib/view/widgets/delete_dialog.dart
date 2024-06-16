import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../statics/Colors.dart';
import '../../../statics/strings.dart';

class DeleteDialog extends StatelessWidget {
  final String titleText;
  final String guideText;
  final VoidCallback yesCallback;
  final VoidCallback noCallback;

  const DeleteDialog({
    Key? key,
    required this.titleText,
    required this.guideText,
    this.yesCallback = _yesCallback,
    this.noCallback = _noCallback,
  }) : super(key: key);

  static void _yesCallback() {}

  static void _noCallback() {}

  Widget _buildButtonWidget(String title) {
    return GestureDetector(
      onTap: () {
        (title == Strings.yes) ? yesCallback() : noCallback();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: ScreenUtil().setWidth(150.0),
            height: ScreenUtil().setHeight(41.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().radius(5.0)),
              color: (title == Strings.yes)
                  ? const Color(UserColors.enable)
                  : const Color(UserColors.disable),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(50.0),
        left: ScreenUtil().setWidth(25.0),
        right: ScreenUtil().setWidth(25.0),
      ),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(228.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(10.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(14.0),
              vertical: ScreenUtil().setHeight(22.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                titleText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(24.0)),
              Text(
                guideText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(24.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButtonWidget(Strings.no),
                  _buildButtonWidget(Strings.yes),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
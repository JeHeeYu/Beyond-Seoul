import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../statics/colors.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';

class ProfileDialogWidget {
  static Widget bgTextRectangle(double width, double height, double radius,
      String text, Color backgroundColor, double fontSize) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: backgroundColor,
            border:
                Border.all(width: 1, color: const Color(UserColors.disable)),
          ),
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: fontSize),
        ),
      ],
    );
  }

  static Future<void> show(
      BuildContext context, HomeViewModel homeViewModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: ScreenUtil().setWidth(294),
            height: ScreenUtil().setHeight(431),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ScreenUtil().setHeight(10)),
                Text(
                  homeViewModel.getHomeData.data?.data.profile.userName ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(25)),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            homeViewModel
                                    .getHomeData.data?.data.profile.userImage ??
                                "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17)),
                      const Text(
                        "googleEmail",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(UserColors.disable),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(22)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              Strings.gender,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            bgTextRectangle(
                                ScreenUtil().setWidth(80),
                                ScreenUtil().setHeight(35),
                                8,
                                "여",
                                Colors.white,
                                16),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              Strings.birthday,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            bgTextRectangle(
                                ScreenUtil().setWidth(80),
                                ScreenUtil().setHeight(35),
                                8,
                                "20",
                                Colors.white,
                                16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: InfinityButton(
                    height: ScreenUtil().setHeight(32),
                    radius: 4,
                    backgroundColor: const Color(UserColors.enable),
                    text: Strings.editComplete,
                    textSize: 13,
                    textWeight: FontWeight.w700,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: InfinityButton(
                    height: ScreenUtil().setHeight(32),
                    radius: 4,
                    backgroundColor: const Color(UserColors.disable),
                    text: Strings.close,
                    textSize: 13,
                    textWeight: FontWeight.w700,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

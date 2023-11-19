import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../routes/routes_name.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../widgets/flexible_text.dart';
import '../widgets/infinity_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget bgRectangle(double height, double radius) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(radius)),
          color: Colors.white,
        ),
        child: SizedBox(
          height: ScreenUtil().setHeight(height),
        ),
      ),
    );
  }

  Widget bgTextRectangle(double width, double height, double radius,
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
          ),
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: fontSize),
        ),
      ],
    );
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy.MM.dd');
    String today = format.format(now);

    return today;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
          child: Column(
            children: [
              SizedBox(
                  height: ScreenUtil().statusBarHeight +
                      ScreenUtil().setHeight(20)),
              Stack(
                children: [
                  bgRectangle(94, 12),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(16),
                      left: ScreenUtil().setWidth(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(42),
                          height: ScreenUtil().setHeight(42),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              Images.goodStamp,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                  "안녕하세요, 최정아님",
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  "부산 여행 중",
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "2023-1109 ~ 2023-1116",
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          ],
                        ),
                        SizedBox(width: ScreenUtil().setWidth(80)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                  Strings.withText,
                                  style: TextStyle(
                                    color: Color(UserColors.guideText),
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Image.asset(Images.add),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  bgRectangle(63, 16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(Images.bus),
                        const FlexibleText(
                          text: '부산행/BUSAN',
                          textSize: 14,
                          textWeight: FontWeight.w600,
                          textColor: Color(UserColors.enable),
                        ),
                        const FlexibleText(
                          text: '2023/11/09',
                          textSize: 11,
                          textWeight: FontWeight.w600,
                        ),
                        const FlexibleText(
                          text: 'AM 10:42',
                          textSize: 11,
                          textWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  bgRectangle(152, 12),
                  Column(
                    children: [
                      const Text(
                        Strings.missionProgress,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image.asset(Images.goodStamp),
                                const Text(
                                  Strings.personalMission,
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(Images.goodStamp),
                                const Text(
                                  Strings.teamMission,
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(Images.goodStamp),
                                const Text(
                                  Strings.dailyChallenge,
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: ScreenUtil().setHeight(134),
                child: Stack(
                  children: [
                    bgRectangle(134, 12),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(7),
                              left: ScreenUtil().setWidth(7),
                              bottom: ScreenUtil().setHeight(7),
                            ),
                            child: bgTextRectangle(
                                71,
                                22,
                                8,
                                Strings.togetherMission,
                                const Color(UserColors.enable),
                                12),
                          ),
                        ),
                        const Text(
                          '해운대에서 모래찜질',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(12)),
                          child: const InfinityButton(
                            height: 40,
                            radius: 4,
                            backgroundColor: Color(UserColors.disable),
                            text: Strings.findFriend,
                            textSize: 16,
                            textWeight: FontWeight.w700,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: ScreenUtil().setHeight(64),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    bgRectangle(64, 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(12)),
                      child: Row(
                        children: [
                          bgTextRectangle(61, 22, 8, Strings.personalMission,
                              const Color(UserColors.enable), 12),
                          SizedBox(width: ScreenUtil().setWidth(12)),
                          const FlexibleText(
                            text: '해운대에서 모래찜질해운대에서 모래찜질해운대에서 모래찜질',
                            textSize: 16,
                            textWeight: FontWeight.w700,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(24)),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  bgRectangle(214, 12),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                      left: ScreenUtil().setWidth(7),
                      bottom: ScreenUtil().setHeight(7),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            bgTextRectangle(71, 22, 8, Strings.dailyChallenge,
                                const Color(UserColors.enable), 12),
                            SizedBox(width: ScreenUtil().setWidth(12)),
                            const Text(
                              '0 / 3',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(23)),
                        Row(
                          children: [
                            Image.asset(Images.checkBox),
                            SizedBox(width: ScreenUtil().setWidth(9)),
                            const FlexibleText(
                              text: '해운대에서 모래찜질해운대에서 모래찜질해운대에서 모래찜질',
                              textSize: 16,
                              textWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(28)),
                        Row(
                          children: [
                            Image.asset(Images.checkBox),
                            SizedBox(width: ScreenUtil().setWidth(9)),
                            const FlexibleText(
                              text: '해운대에서 모래찜질해운대에서 모래찜질해운대에서 모래찜질',
                              textSize: 16,
                              textWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(28)),
                        Row(
                          children: [
                            Image.asset(Images.checkBox),
                            SizedBox(width: ScreenUtil().setWidth(9)),
                            const FlexibleText(
                              text: '해운대에서 모래찜질해운대에서 모래찜질해운대에서 모래찜질',
                              textSize: 16,
                              textWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(73)),
            ],
          ),
        ),
      ),
    );
  }
}

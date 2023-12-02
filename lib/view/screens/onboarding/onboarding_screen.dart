import 'dart:ui';

import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app.dart';
import '../../../statics/colors.dart';
import '../../../statics/images.dart';
import '../../../statics/strings.dart';
import '../../widgets/image_button.dart';
import '../home_screen.dart';
import 'onboarding_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 6);
  int _selectedIndex = -1;
  final _birthdayController = TextEditingController();
  final _koreanArrivalController = TextEditingController();
  final _returnHomewtownController = TextEditingController();

  Widget buildOnboardingButton(int index, String text, double height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: OnboardingButton(
        width: 160,//ScreenUtil().setWidth(160),
        height: height,//ScreenUtil().setHeight(height),
        text: text,
        enable: _selectedIndex == index,
      ),
    );
  }

  // final int selectedIndex;
  // final int enableIndex;
  // final String enabledImage;
  // final String disabledImage;
  // final double width;
  // final double height;

  //   ImageButton(
  //   selectedIndex: _selectedIndex,
  //   enableIndex: 1,
  //   enabledImage: Images.themaHistoryEnable,
  //   disabledImage: Images.themaHistoryDisable,
  //   width: 168,
  //   height: 160,
  // ),

  Widget buildImageButton(int index, double width, double height,
      String enabledImage, String disabledImage) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: ImageButton(
        enabledImage: enabledImage,
        disabledImage: disabledImage,
        width: width,
        height: height,
        enable: _selectedIndex == index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: (_selectedIndex == -1 || _birthdayController.text.isEmpty)
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      children: [
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress1)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseGender,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(32)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                0, Strings.man, ScreenUtil().setHeight(54)),
                            buildOnboardingButton(
                                1, Strings.girl, ScreenUtil().setHeight(54)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(131)),
                        const Text(
                          Strings.pleaseBirthday,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(32)),
                        TextField(
                          controller: _birthdayController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(10),
                                horizontal: ScreenUtil().setHeight(15)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(4)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedIndex == -1 ||
                          _birthdayController.text.isEmpty) {
                        return;
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: (_selectedIndex == -1 ||
                                _birthdayController.text.isEmpty)
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 2nd page
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress2)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseLanguage,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(32)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                0, Strings.korean, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(
                                1, Strings.english, ScreenUtil().setHeight(78)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                2, Strings.chinese, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(3, Strings.japanese,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                4, Strings.german, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(
                                5, Strings.spanish, ScreenUtil().setHeight(78)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                6, Strings.french, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(7, Strings.vietnamese,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 3rd page
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress3)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.howManyMate,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(198)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                0, Strings.alone, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(1, Strings.withTravelMate,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 4th pages
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress4)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.whatRole,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        const Text(
                          Strings.whatRoleGuide,
                          style: TextStyle(
                            color: Color(UserColors.guideText),
                            fontFamily: "Pretendard",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(154)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(
                                0, Strings.alone, ScreenUtil().setHeight(78)),
                            buildOnboardingButton(1, Strings.withTravelMate,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 5th pages
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress5)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseSchedule,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(75)),
                        const Text(
                          Strings.koreanArrivalDate,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(12)),
                        TextField(
                          controller: _koreanArrivalController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(10),
                                horizontal: ScreenUtil().setHeight(15)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(4)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(75)),
                        const Text(
                          Strings.returnHomewtownDate,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(12)),
                        TextField(
                          controller: _returnHomewtownController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(10),
                                horizontal: ScreenUtil().setHeight(15)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(4)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 6th page
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress6)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseAirport,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(32)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(0, Strings.incheonAirport,
                                ScreenUtil().setHeight(78)),
                            buildOnboardingButton(1, Strings.kimpoAirport,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(2, Strings.kimhaeAirport,
                                ScreenUtil().setHeight(78)),
                            buildOnboardingButton(3, Strings.jejuAirport,
                                ScreenUtil().setHeight(78)),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildOnboardingButton(4, Strings.daeguAirport,
                                ScreenUtil().setHeight(78)),
                            buildOnboardingButton(
                                5, Strings.etc, ScreenUtil().setHeight(78)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 7th page
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress7)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseTravelThema,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        const Text(
                          Strings.pleaseTravelThemaGuide,
                          style: TextStyle(
                            color: Color(UserColors.guideText),
                            fontFamily: "Pretendard",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildImageButton(
                                0,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaFoodEnable,
                                Images.themaFoodDisable),
                            //SizedBox(width: ScreenUtil().setWidth(4)),
                            buildImageButton(
                                1,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaMountainEnable,
                                Images.themaMountainDisable),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildImageButton(
                                2,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaMountainEnable,
                                Images.themaMountainDisable),
                            buildImageButton(
                                3,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaOceanEnable,
                                Images.themaOceanDisable),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildImageButton(
                                4,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaLeisureEnable,
                                Images.themaLeisureDisable),
                            buildImageButton(
                                5,
                                ScreenUtil().setWidth(168),
                                ScreenUtil().setHeight(160),
                                Images.themaShowppingEnable,
                                Images.themaShowppingDisable),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.next,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 8th page
        Scaffold(
          backgroundColor: const Color(UserColors.mainBackGround),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(64)),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset(Images.onboardingProgress8)),
                        SizedBox(height: ScreenUtil().setHeight(65)),
                        const Text(
                          Strings.pleaseDestination,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        const Text(
                          Strings.pleaseDestinationGuide,
                          style: TextStyle(
                            color: Color(UserColors.guideText),
                            fontFamily: "Pretendard",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(25)),
                        buildImageButton(
                          0,
                          ScreenUtil().setWidth(340),
                          ScreenUtil().setHeight(157),
                          Images.busanEnable,
                          Images.busanDisable,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        buildImageButton(
                          1,
                          ScreenUtil().setWidth(340),
                          ScreenUtil().setHeight(157),
                          Images.jeonjuEnable,
                          Images.jeonjuDisable,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        buildImageButton(
                          2,
                          ScreenUtil().setWidth(340),
                          ScreenUtil().setHeight(157),
                          Images.yeosuEnable,
                          Images.yeosuDisable,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                      );
                    },
                    child: InfinityButton(
                        height: 40,
                        radius: 4,
                        backgroundColor: _selectedIndex == -1
                            ? const Color(UserColors.disable)
                            : const Color(UserColors.enable),
                        text: Strings.leaveHere,
                        textColor: Colors.white,
                        textSize: 16,
                        textWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

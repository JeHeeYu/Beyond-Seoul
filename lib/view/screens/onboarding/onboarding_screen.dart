import 'package:beyond_seoul/network/network_manager.dart';
import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../app.dart';
import '../../../network/api_url.dart';
import '../../../statics/colors.dart';
import '../../../statics/images.dart';
import '../../../statics/strings.dart';
import '../../widgets/image_button.dart';
import 'onboarding_button.dart';

Map<int, String> genderMap = {0: "남", 1: "여"};

Map<int, String> withTravelMap = {0: "혼자 여행", 1: "같이 여행"};

Map<int, String> roleMap = {0: "reader", 1: "member"};

Map<int, String> airportMap = {
  0: "인천공항",
  1: "김포공항",
  2: "김해공항",
  3: "제주공항",
  4: "대구공항",
  5: "기타"
};

Map<int, String> themaMap = {
  0: "음식",
  1: "산림",
  2: "역사/문화",
  3: "바다",
  4: "레저",
  5: "쇼핑"
};

Map<int, String> destinationMap = {0: "부산", 1: "전주", 2: "여수"};

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = -1;
  final _birthdayController = TextEditingController();
  final _travelStartDateController = TextEditingController();
  final _travelEndDateController = TextEditingController();
  String _gender = "";
  String _withTravel = "";
  String _role = "";
  String _airport = "";
  String _thema = "";
  String _destination = "";

  Widget buildOnboardingButton(int index, String text, double height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: OnboardingButton(
        width: ScreenUtil().setWidth(160),
        height: ScreenUtil().setHeight(height),
        text: text,
        enable: _selectedIndex == index,
      ),
    );
  }

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

  void sendOnboardingComplete() async {
    Map<String, dynamic> data = {
      "gender": _gender,
      "age": "20",
      "uid": "0",
      "birth": _birthdayController.text.toString(),
      "lang": "EN",
      "travelWith": _withTravel,
      "role": _role,
      "travelStartDate": _travelStartDateController.text.toString(),
      "travelEndDate": _travelEndDateController.text.toString(),
      "thema": _thema,
      "transport": _airport,
      "destination": _destination,
    };

    NetworkManager.instance.post(ApiUrl.onboardingComplete, data);
  }

  void _nextClickEvent(int pageIndex) async {
    _selectedIndex = -1;

    FocusManager.instance.primaryFocus?.unfocus();

    switch (pageIndex) {
      case 0:
        _gender = genderMap[_selectedIndex] ?? "";
        break;
      case 1:
        _withTravel = withTravelMap[_selectedIndex] ?? "";
        break;
      case 2:
        _role = roleMap[_selectedIndex] ?? "";
        break;
      case 3:
        break;
      case 4:
        _airport = airportMap[_selectedIndex] ?? "";
        break;
      case 5:
        _thema = themaMap[_selectedIndex] ?? "";
        break;
      case 6:
        _destination = destinationMap[_selectedIndex] ?? "";

        sendOnboardingComplete();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const App()),
        // );
        break;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  _buildAgeBirthdayPage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(4)),
                            borderSide: BorderSide.none),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (text) {
                        setState(() {
                          if (_birthdayController.text.isNotEmpty) {
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
              child: GestureDetector(
                onTap: () {
                  _nextClickEvent(0);
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
    );
  }

  Widget _buildLanguageSelectPage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                        buildOnboardingButton(
                            3, Strings.japanese, ScreenUtil().setHeight(78)),
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
                        buildOnboardingButton(
                            7, Strings.vietnamese, ScreenUtil().setHeight(78)),
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
                  _nextClickEvent(1);
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
    );
  }

  _buildWithTravelMatePage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                  _nextClickEvent(1);
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
    );
  }

  _buildWhatRolePage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                            0, Strings.isReader, ScreenUtil().setHeight(78)),
                        buildOnboardingButton(1, Strings.togetherMage,
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
                  _nextClickEvent(2);
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
    );
  }

  _buildSchedulePage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                      controller: _travelStartDateController,
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
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(4)),
                            borderSide: BorderSide.none),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
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
                      controller: _travelEndDateController,
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
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(4)),
                            borderSide: BorderSide.none),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
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
                  _nextClickEvent(3);
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
    );
  }

  _buildAirportPage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                        buildOnboardingButton(
                            3, Strings.jejuAirport, ScreenUtil().setHeight(78)),
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
                  _nextClickEvent(4);
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
    );
  }

  _buildThemaPage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                  _nextClickEvent(5);
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
    );
  }

  Widget _buildDestinationPage() {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                  _nextClickEvent(6);
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
        _buildAgeBirthdayPage(),
        //_buildLanguageSelectPage(),
        _buildWithTravelMatePage(),
        _buildWhatRolePage(),
        _buildSchedulePage(),
        _buildAirportPage(),
        _buildThemaPage(),
        _buildDestinationPage(),
      ],
    );
  }
}

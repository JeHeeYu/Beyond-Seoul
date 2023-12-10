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
import '../../widgets/schedule_widget.dart';
import 'onboarding_button.dart';

enum Page {
  infoPage,
  withTravelPage,
  rolePage,
  travelDatePage,
  themaPage,
  destionPage
}

Map<int, String> genderMap = {0: "남", 1: "여"};

Map<int, String> withTravelMap = {0: "혼자 여행", 1: "같이 여행"};

Map<int, String> roleMap = {0: "reader", 1: "member"};

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
  final PageController _pageController = PageController(initialPage: 5);
  int _selectedIndex = -1;
  String _birthday = "";
  String _gender = "";
  String _withTravel = "";
  String _travelStartDate = "";
  String _travelEndDate = "";
  String _role = "";
  String _thema = "";
  String _destination = "";

  String dateToStringFormat(DateTime time) {
    DateFormat format = DateFormat('yyyy-MM-dd');
    return format.format(time);
  }

  void _setBirthday(DateTime time) {
    _birthday = dateToStringFormat(time);

    setState(() {});
  }

  void _setTravelStartDate(DateTime time) {
    _travelStartDate = dateToStringFormat(time);

    setState(() {});
  }

  void _setTravelEndDate(DateTime time) {
    _travelEndDate = dateToStringFormat(time);

    setState(() {});
  }

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
      "uid": "0",
      "birth": _birthday,
      "travelWith": _withTravel,
      "role": _role,
      "travelStartDate": _travelStartDate,
      "travelEndDate": _travelEndDate,
      "thema": _thema,
      "destination": _destination,
    };

    NetworkManager.instance.post(ApiUrl.onboardingComplete, data);
  }

  void _nextClickEvent(Page page) async {
    FocusManager.instance.primaryFocus?.unfocus();

    switch (page) {
      case Page.infoPage:
        _gender = genderMap[_selectedIndex] ?? "";
        break;
      case Page.withTravelPage:
        _withTravel = withTravelMap[_selectedIndex] ?? "";
        break;
      case Page.rolePage:
        _role = roleMap[_selectedIndex] ?? "";
        break;
      case Page.travelDatePage:
        break;
      case Page.themaPage:
        _thema = themaMap[_selectedIndex] ?? "";
        break;
      case Page.destionPage:
        _destination = destinationMap[_selectedIndex] ?? "";
        sendOnboardingComplete();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const App()),
        );
        break;
    }

    setState(() {
      _selectedIndex = -1;
    });

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
                    GestureDetector(
                      onTap: () {
                        showScheduleBottomSheet(
                          context,
                          _setBirthday,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(58),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(29)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _birthday,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Pretendard",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(29)),
                              ],
                            ),
                          ),
                        ],
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
                  _nextClickEvent(Page.infoPage);
                },
                child: InfinityButton(
                    height: 40,
                    radius: 4,
                    backgroundColor: (_selectedIndex == -1 || _birthday.isEmpty)
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
                  _nextClickEvent(Page.withTravelPage);
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
                  _nextClickEvent(Page.rolePage);
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
                    GestureDetector(
                      onTap: () {
                        showScheduleBottomSheet(
                          context,
                          _setTravelStartDate,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(58),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(29)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _travelStartDate,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Pretendard",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(29)),
                              ],
                            ),
                          ),
                        ],
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
                    GestureDetector(
                      onTap: () {
                        showScheduleBottomSheet(
                          context,
                          _setTravelEndDate,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(58),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(29)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _travelEndDate,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Pretendard",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(29)),
                              ],
                            ),
                          ),
                        ],
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
                  _nextClickEvent(Page.travelDatePage);
                },
                child: InfinityButton(
                    height: 40,
                    radius: 4,
                    backgroundColor:
                        (_travelStartDate.isEmpty || _travelEndDate.isEmpty)
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
                  _nextClickEvent(Page.themaPage);
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
                  _nextClickEvent(Page.destionPage);
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
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildAgeBirthdayPage(),
        _buildWithTravelMatePage(),
        _buildWhatRolePage(),
        _buildSchedulePage(),
        _buildThemaPage(),
        _buildDestinationPage(),
      ],
    );
  }
}

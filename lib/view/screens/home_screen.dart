import 'package:beyond_seoul/view/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../widgets/flexible_text.dart';
import '../widgets/infinity_button.dart';
import 'mate_code_screen.dart';
import 'mission_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel _homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.fetchTravelListApi();
  }

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

  Widget _buildMissionComplete(int index, int complete) {
    String mission = "";

    if (index == 0) {
      mission = Strings.foodMission;
    } else if (index == 1) {
      mission = Strings.tourMission;
    } else {
      mission = Strings.sosoMission;
    }

    return Column(
      children: [
        Stack(
          children: [
            complete == 0
                ? Column(
                    children: [
                      Image.asset(Images.emptyStamp),
                      SizedBox(height: ScreenUtil().setHeight(16)),
                    ],
                  )
                : Image.asset(Images.goodStamp),
            if (complete > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Text(
                  '+$complete',
                  style: const TextStyle(
                    color: Color(0xFF6C4FA4),
                    fontSize: 11,
                    fontFamily: "PottaOne-Regular",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        Text(
          mission,
          style: const TextStyle(
            fontFamily: "Pretendard",
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => _homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, value, _) {
          switch (value.homeData.status) {
            case Status.loading:
              return _buildLoadingWidget();
            case Status.complete:
              return _buildCompleteWidget(value);
            case Status.error:
            default:
              return const ErrorScreen();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBeforeTravelWidget(HomeViewModel value) {
    return Column(
      children: [
        _buildUserInfoWidget(value),
        _buildBeforeBodyWidget(value),
      ],
    );
  }

  Widget _buildAfterTravelWidget(HomeViewModel value) {
    return Column(
      children: [
        _buildUserInfoWidget(value),
        _buildAfterBodyWidget(value),
      ],
    );
  }

  Widget _buildCompleteWidget(HomeViewModel value) {
    switch (value.homeData.data?.data.travelStatus) {
      case "BEFORE_TRAVEL_START":
        return _buildBeforeTravelWidget(value);
      case "DURING_TRAVEL":
        return _buildDuringTravelWidget(value);
      case "AFTER_TRAVEL":
      default:
        return _buildAfterTravelWidget(value);
    }
  }

  Widget _buildDuringTravelWidget(HomeViewModel value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfoWidget(value),
        _buildMissionProgressWidget(value),
        SizedBox(height: ScreenUtil().setHeight(30)),
        _buildMissionTitleWidget(Strings.foodMission),
        SizedBox(height: ScreenUtil().setHeight(7)),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MissionDetailScreen(
                        title: value
                            .homeData.data?.data.mission.personMission?.title)),
              );
            },
            child: _buildMissionWidget(Strings.foodMission)),
        SizedBox(height: ScreenUtil().setHeight(12)),
        _buildMissionTitleWidget(Strings.tourMission),
        SizedBox(height: ScreenUtil().setHeight(7)),
        _buildMissionWidget(Strings.tourMission),
        SizedBox(height: ScreenUtil().setHeight(12)),
        _buildMissionTitleWidget(Strings.sosoMission),
        SizedBox(height: ScreenUtil().setHeight(7)),
        _buildMissionWidget(Strings.sosoMission),
      ],
    );
  }

  Widget _buildMissionTitleWidget(String title) {
    return Row(
      children: [
        bgTextRectangle(71, 22, 8, title, const Color(UserColors.enable), 12),
        SizedBox(width: ScreenUtil().setWidth(10)),
        const Icon(
          Icons.refresh,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildUserInfoWidget(HomeViewModel value) {
    return Stack(
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
                  child: Image.network(
                    value.homeData.data?.data.profile.userImage ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.helloName(
                        value.homeData.data?.data.profile.userName ?? ""),
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    value.homeData.data?.data.travel.travelName ?? "",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    value.homeData.data?.data.travel.travelDate ?? "",
                    style: const TextStyle(
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
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MateReCodeScreen()),
                        );
                      },
                      child: Image.asset(Images.add)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionWidget(String mission) {
    return Stack(
      alignment: Alignment.center,
      children: [
        bgRectangle(54, 8),
        Padding(
          padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(5),
              left: ScreenUtil().setWidth(24),
              right: ScreenUtil().setWidth(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlexibleText(
                text: mission,
                textSize: 16,
                textWeight: FontWeight.w700,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionProgressWidget(HomeViewModel value) {
    return Stack(
      children: [
        bgRectangle(152, 12),
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(11),
              right: ScreenUtil().setWidth(17)),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              getToday(),
              style: const TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(UserColors.disable)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
          child: Column(
            children: [
              const Text(
                Strings.missionProgress,
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMissionComplete(
                        0,
                        value.homeData.data?.data.mission.missionComplete
                                ?.person ??
                            0),
                    _buildMissionComplete(
                        1,
                        value.homeData.data?.data.mission.missionComplete
                                ?.team ??
                            0),
                    _buildMissionComplete(
                        2,
                        value.homeData.data?.data.mission.missionComplete
                                ?.daily ??
                            0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBeforeBodyWidget(HomeViewModel value) {
    return Column(
      children: [
        Image.asset(Images.beforeTravelIcon),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(77)),
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
    );
  }

  Widget _buildAfterBodyWidget(HomeViewModel value) {
    return Column(
      children: [
        Image.asset(Images.afterTravelIcon),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(77)),
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
    );
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
              _buildMainContent(),
              SizedBox(height: ScreenUtil().setHeight(73)),
            ],
          ),
        ),
      ),
    );
  }
}

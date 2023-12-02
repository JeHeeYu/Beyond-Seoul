import 'dart:ui';

import 'package:beyond_seoul/view/screens/mission_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../network/network_manager.dart';
import '../../routes/routes_name.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../widgets/flexible_text.dart';
import '../widgets/infinity_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();

    homeViewModel.fetchTravelListApi();
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
      mission = Strings.personalMission;
    } else if (index == 1) {
      mission = Strings.teamMission;
    } else {
      mission = Strings.dailyChallenge;
    }

    return Column(
      children: [
        complete == 0
            ? Column(
                children: [
                  Image.asset(Images.emptyStamp),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                ],
              )
            : Image.asset(Images.goodStamp),
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

  Widget _buildDailyChallengeContent(String complete, String challenge) {
    return Row(
      children: [
        complete == "SUCCESS"
            ? Image.asset(Images.checkBox)
            : Image.asset(Images.uncheckBox),
        SizedBox(width: ScreenUtil().setWidth(9)),
        FlexibleText(
          text: challenge,
          textSize: 16,
          textWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, value, _) {
          switch (value.homeData.status) {
            case Status.loading:
              return _buildLoadingWidget();
            case Status.error:
              return const Text("에러");
            case Status.complete:
              return _buildCompleteWidget(value);
            default:
              return const Text("오류");
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
      children: [
        _buildUserInfoWidget(value),
        _buildBusInfoWidget(value),
        _buildMissionProgressWidget(value),
        _buildTeamMissionWidget(value),
        _buildPersonalMissionWidget(value),
        _buildDailyChallengeWidget(value),
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
                  Text(
                    value.homeData.data?.data.travel.travelName ?? "",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                  Image.asset(Images.add),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusInfoWidget(HomeViewModel value) {
    return Stack(
      alignment: Alignment.center,
      children: [
        bgRectangle(63, 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
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
    );
  }

  Widget _buildTeamMissionWidget(HomeViewModel value) {
    return SizedBox(
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
                  child: bgTextRectangle(71, 22, 8, Strings.togetherMission,
                      const Color(UserColors.enable), 12),
                ),
              ),
              Text(
                value.homeData.data?.data.mission.teamMission?.title ?? "",
                style: const TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
                child: GestureDetector(
                  onTap: () async {},
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionProgressWidget(HomeViewModel value) {
    return Stack(
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
                      value.homeData.data?.data.mission.missionComplete?.team ??
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
      ],
    );
  }

  Widget _buildPersonalMissionWidget(HomeViewModel value) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MissionDetailScreen(title: value.homeData.data?.data.mission.personMission?.title)),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          bgRectangle(54, 8),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
            child: Row(
              children: [
                bgTextRectangle(61, 22, 8, Strings.personalMission,
                    const Color(UserColors.enable), 12),
                SizedBox(width: ScreenUtil().setWidth(12)),
                FlexibleText(
                  text:
                      value.homeData.data?.data.mission.personMission?.title ??
                          "",
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
    );
  }

  Widget _buildDailyChallengeWidget(HomeViewModel value) {
    return Stack(
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
                  Text(
                    value.homeData.data?.data.mission.dailyMissionCount ?? "",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(23)),
              _buildDailyChallengeContent(
                value.homeData.data?.data.mission.dailyMissions?[0].status ??
                    "",
                value.homeData.data?.data.mission.dailyMissions?[0].title ?? "",
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              _buildDailyChallengeContent(
                value.homeData.data?.data.mission.dailyMissions?[1].status ??
                    "",
                value.homeData.data?.data.mission.dailyMissions?[1].title ?? "",
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
              _buildDailyChallengeContent(
                value.homeData.data?.data.mission.dailyMissions?[2].status ??
                    "",
                value.homeData.data?.data.mission.dailyMissions?[2].title ?? "",
              ),
              SizedBox(height: ScreenUtil().setHeight(28)),
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

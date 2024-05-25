import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:beyond_seoul/view/widgets/profile_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../models/home/home_screen_model.dart';
import '../../network/api_response.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeViewModel _homeViewModel = HomeViewModel();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
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

  Widget _buildEmptyInfoWidget() {
    return const Text(
      Strings.profileGuide,
      style: TextStyle(
          fontFamily: "Pretendard",
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(UserColors.disable)),
    );
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider.value(
      value: _homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, value, _) {
          switch (value.homeData.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
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

  Widget _buildCompleteWidget(HomeViewModel value) {
    return Column(
      children: [
        _buildUserInfoWidget(value),
        _buildOtherTravelWidget(),
      ],
    );
  }

  Widget _buildUserInfoWidget(HomeViewModel value) {
    return Stack(
      children: [
        bgRectangle(89, 12),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(16),
            left: ScreenUtil().setWidth(16),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // ProfileDialogWidget.show(context, _homeViewModel);
                },
                child: Container(
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setHeight(60),
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
              ),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.homeData.data?.data.profile.userName ?? "",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Row(
                    children: [
                      // _buildEmptyInfoWidget(),
                      SizedBox(width: ScreenUtil().setWidth(5)),
                      // Icon(
                      //   Icons.edit,
                      //   size: ScreenUtil().setWidth(15),
                      //   color: Colors.grey,
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   top: 35,
        //   right: 28,
        //   child: Text(
        //     "총 2회의 여행",
        //     style: const TextStyle(
        //         fontFamily: "Pretendard",
        //         fontSize: 11,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.grey),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOtherTravelWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        bgRectangle(92, 12),
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingScreen()),
                    );
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(185),
                    height: ScreenUtil().setHeight(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(UserColors.disable),
                    ),
                  ),
                ),
                const Text(
                  Strings.startOtherTravel,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            const Text(
              Strings.myProfileGuild,
              style: TextStyle(
                color: Color(UserColors.guideText),
                fontFamily: "Pretendard",
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: ScreenUtil().statusBarHeight +
                      ScreenUtil().setHeight(20)),
              const Text(
                Strings.profile,
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
              _buildMainContent(),
              SizedBox(height: ScreenUtil().setHeight(34)),
              Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: GestureDetector(
                  onTap: () {
                    _storage.deleteAll();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        Strings.logout,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              // const Text(
              //   Strings.travelInformation,
              //   style: TextStyle(
              //     fontFamily: "Pretendard",
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // SizedBox(height: ScreenUtil().setHeight(19)),
              // Padding(
              //   padding: const EdgeInsets.only(right: 35.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: const [
              //       Text(
              //         Strings.editTravelInformation,
              //         style: TextStyle(
              //           fontFamily: "Pretendard",
              //           fontSize: 14,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       Icon(
              //         Icons.arrow_forward_ios,
              //         color: Colors.black,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: ScreenUtil().setHeight(56)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  Images.travelIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

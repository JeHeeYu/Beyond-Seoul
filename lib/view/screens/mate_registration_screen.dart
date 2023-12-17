import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../network/api_url.dart';
import '../../network/network_manager.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../widgets/infinity_button.dart';

class MateRegistrationScreen extends StatefulWidget {
  const MateRegistrationScreen({super.key});

  @override
  State<MateRegistrationScreen> createState() => _MateRegistrationScreenState();
}

class _MateRegistrationScreenState extends State<MateRegistrationScreen> {
  HomeViewModel homeViewModel = HomeViewModel();

  int _second = 0;
  int _minute = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    homeViewModel.fetchMateCodetApi();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_second == 0) {
          _minute--;
          _second = 59;
        } else {
          _second--;
        }

        if (_second == 0 && _minute == 0) {
          _timer.cancel();
        }
      });
    });
  }

  String formatTime() {
    Duration duration = Duration(minutes: _minute, seconds: _second);
    DateFormat formatter = DateFormat('mm:ss');
    String formattedTime = formatter.format(DateTime(0).add(duration));

    return formattedTime;
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => homeViewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, value, _) {
          switch (value.mateCodeData.status) {
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

  Widget _buildGuideTextWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          Strings.mateRegistration,
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8)),
        const Text(
          Strings.mateRegistrationGuide,
          style: TextStyle(
            color: Color(UserColors.guideText),
            fontFamily: "Pretendard",
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(166)),
      ],
    );
  }

  Widget _buildMateCodeWidget(HomeViewModel value) {
    return Column(
      children: [
        Stack(
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
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(29)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (_minute == 0 && _second == 0)
                        ? Strings.newCode
                        : value.mateCodeData.data?.data.code ??
                            Strings.codeExpire,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(29)),
                  GestureDetector(
                    onTap: () async {
                      if (_minute == 0 && _second == 0) {
                        Map<String, dynamic> queryParams = {
                          'travelId': "3",
                        };

                        Map<String, dynamic> postData = {'key': 'value'};

                        NetworkManager.instance
                            .postQuery(
                                ApiUrl.newMateCode, postData, queryParams)
                            .then((response) {
                          if (response == 200) {
                            setState(() {
                              homeViewModel.fetchMateCodetApi();
                              _startTimer();
                              _minute = 30;
                              _second = 0;
                            });
                          }
                        }).catchError((error) {
                          print('포스트 실패: $error');
                        });
                      } else {
                        Clipboard.setData(ClipboardData(
                            text: value.mateCodeData.data?.data.code));
                      }
                    },
                    child: Icon(
                      (_minute == 0 && _second == 0)
                          ? Icons.refresh
                          : Icons.content_copy,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(24)),
        Align(
          alignment: Alignment.center,
          child: Text(
            (_minute == 0 && _second == 0)
                ? Strings.codeExpire
                : Strings.codeValidGuide,
            style: const TextStyle(
              color: Color(UserColors.guideText),
              fontFamily: "Pretendard",
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(14)),
        Align(
          alignment: Alignment.center,
          child: Text(
            (_minute == 0 && _second == 0) ? "" : formatTime(),
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Pretendard",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const InfinityButton(
            height: 40,
            radius: 4,
            backgroundColor: Color(UserColors.enable),
            text: Strings.complete,
            textColor: Colors.white,
            textSize: 16,
            textWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCompleteWidget(HomeViewModel value) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setHeight(121)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideTextWidget(),
                _buildMateCodeWidget(value),
              ],
            ),
          ),
        ),
        _buildButtonWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
        child: _buildMainContent(),
      ),
    );
  }
}

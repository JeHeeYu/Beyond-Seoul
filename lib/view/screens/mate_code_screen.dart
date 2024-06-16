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
import 'error_screen.dart';

class MateReCodeScreen extends StatefulWidget {
  const MateReCodeScreen({super.key});

  @override
  State<MateReCodeScreen> createState() => _MateCodeScreenState();
}

class _MateCodeScreenState extends State<MateReCodeScreen> {
  late HomeViewModel _homeViewModel;
  final mateCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, String> data = {
        'travelId': _homeViewModel.homeData.data?.data.travel.travelId.toString() ?? ''
      };
      _homeViewModel.fetchMateCodetApi(data);
    });
  }

  Widget _buildMainContent() {
    return Consumer<HomeViewModel>(
      builder: (context, value, _) {
        switch (value.mateCodeData.status) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.complete:
            return _buildCompleteWidget(value);
          case Status.error:
          default:
            return const ErrorScreen();
        }
      },
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
            TextField(
              controller: mateCodeController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: Strings.mateCodeInput,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCodeNextTimeWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(11)),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Text(
          Strings.codeNextTime,
          style: TextStyle(
              color: Color(UserColors.guideText),
              fontFamily: "Pretendard",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline),
        ),
      ),
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
        _buildCodeNextTimeWidget(),
        _buildButtonWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _homeViewModel,
      child: Scaffold(
        backgroundColor: const Color(UserColors.mainBackGround),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
          child: _buildMainContent(),
        ),
      ),
    );
  }
}

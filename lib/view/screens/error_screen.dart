import 'package:beyond_seoul/statics/colors.dart';
import 'package:beyond_seoul/view/widgets/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../../statics/images.dart';
import '../../statics/strings.dart';

class ErrorScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const ErrorScreen({Key? key, this.onRetry}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: () {
        if (widget.onRetry != null) {
          widget.onRetry!();
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(120.0),
        height: ScreenUtil().setHeight(40.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: const Center(
          child: Text(
            Strings.retry,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        title: '',
      ),
      body: Container(
        color: const Color(UserColors.mainBackGround),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.bgError),
              SizedBox(height: ScreenUtil().setHeight(20.0)),
              _buildRetryButton(),
            ],
          ),
        ),
      ),
    );
  }
}

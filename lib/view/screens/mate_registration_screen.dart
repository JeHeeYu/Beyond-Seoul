import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../widgets/infinity_button.dart';

class MateRegistrationScreen extends StatefulWidget {
  const MateRegistrationScreen({super.key});

  @override
  State<MateRegistrationScreen> createState() => _MateRegistrationScreenState();
}

class _MateRegistrationScreenState extends State<MateRegistrationScreen> {
  final _codeController = TextEditingController();

  int _second = 3;
  int _minute = 0;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_second == 0) {
          _minute--;
          _second = 60;
        } else {
          _second--;
        }

        if (_second == 0 && _minute == 0) {
          _timer.cancel();
          _codeController.text = Strings.newCode;
        }
      });
    });
  }

  String formatTime() {
    String result = "${_minute.toString()}:${_second.toString()}";

    return result;
  }

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(height: ScreenUtil().setHeight(121)),
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
                    TextField(
                      controller: _codeController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: _codeController.text));
                          },
                          child: Icon(
                            (_minute == 0 && _second == 0)
                                ? Icons.refresh
                                : Icons.content_copy,
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(10),
                            horizontal: ScreenUtil().setHeight(15)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(4)),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        Strings.codeValidGuide,
                        style: TextStyle(
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
                        (_minute == 0 && _second == 0)
                            ? Strings.codeExpire
                            : formatTime(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Pretendard",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}

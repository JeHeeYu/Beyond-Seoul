import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteDialog extends StatefulWidget {
  final String title;

  const CompleteDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CompleteDialog> createState() => _CompleteDialogState();
}

class _CompleteDialogState extends State<CompleteDialog> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(
        top: ScreenUtil().setHeight(6.0),
        left: ScreenUtil().setWidth(22.0),
        right: ScreenUtil().setWidth(22.0),
      ),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
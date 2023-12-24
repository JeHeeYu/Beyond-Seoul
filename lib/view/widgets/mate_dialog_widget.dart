import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../statics/colors.dart';
import '../../statics/strings.dart';

class MateDialogWidget {
  static Widget _buildMateWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(17)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setHeight(40),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                "https://cdn.imweb.me/upload/S20221129c3c04fdc67a8b/964c919aac9d0.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Text(
            "정수지",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(17)),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: ScreenUtil().setWidth(29),
                height: ScreenUtil().setHeight(17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFD8D8D8),
                ),
              ),
              const Text(
                Strings.delete,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: ScreenUtil().setWidth(211),
            height: ScreenUtil().setHeight(326),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  Strings.travleMate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                        _buildMateWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: InfinityButton(
                    height: ScreenUtil().setHeight(27),
                    radius: 4,
                    backgroundColor: const Color(UserColors.enable),
                    text: Strings.addMate,
                    textSize: 13,
                    textWeight: FontWeight.w700,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

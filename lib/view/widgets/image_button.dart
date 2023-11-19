import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget {
  final String enabledImage;
  final String disabledImage;
  final double width;
  final double height;
  final bool enable;

  const ImageButton({
    Key? key,
    required this.enabledImage,
    required this.disabledImage,
    required this.width,
    required this.height,
    required this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      enable ? enabledImage : disabledImage,
      width: ScreenUtil().setWidth(width),
      height: ScreenUtil().setHeight(height),
      // fit: BoxFit.fill,
    );
  }
}
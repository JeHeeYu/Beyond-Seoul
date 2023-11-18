import 'package:flutter/material.dart';

class FlexibleText extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color textColor;

  const FlexibleText({
    Key? key,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: "Pretendard",
          fontSize: textSize,
          fontWeight: textWeight,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

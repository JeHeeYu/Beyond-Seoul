import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InfinityButton extends StatelessWidget {
  final double height;
  final double radius;
  final Color backgroundColor;
  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color textColor;

  const InfinityButton({
    Key? key,
    required this.height,
    required this.radius,
    required this.backgroundColor,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textColor = Colors.black,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: backgroundColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
              color: textColor,
              fontFamily: "Pretendard",
              fontWeight: textWeight,
              fontSize: textSize),
        ),
      ],
    );
  }
}

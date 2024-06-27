import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final Color backgroundColor;
  final double borderRadius;
  final Widget child;
  final VoidCallback? callback;

  const UserContainer({
    Key? key,
    required this.width,
    required this.height,
    this.borderColor = Colors.transparent,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

import 'package:beyond_seoul/statics/colors.dart';
import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? callBack;
  final Color backgroundColor;

  const BackAppBar({
    Key? key,
    required this.title,
    this.callBack,
    this.backgroundColor = const Color(UserColors.mainBackGround),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          if (callBack != null) {
            callBack!();
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

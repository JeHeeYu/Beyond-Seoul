import 'package:flutter/material.dart';

class PageRouter<T> extends MaterialPageRoute<T> {
  PageRouter({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  bool get gestureEnabled => false;
}

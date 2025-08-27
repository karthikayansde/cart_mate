import 'package:flutter/material.dart';

class AppRoutes{
  static PageRouteBuilder<void> transparentRoute(Widget page) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => page,
    );
  }
}
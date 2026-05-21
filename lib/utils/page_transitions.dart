import 'package:flutter/material.dart';

Route createSmoothRoute(Widget targetScreen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,

    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final tween = Tween<Offset>(
        begin: const Offset(1.0, 0.0), 
        end: Offset.zero
      ).chain(CurveTween(curve: Curves.easeInOutCubic));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500), 
  );
}
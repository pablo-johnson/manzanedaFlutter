import 'package:flutter/material.dart';
import 'main.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String screenTitle,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        _screenTitle = screenTitle,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final String _screenTitle;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  String get screenTitle => _screenTitle;

  FadeTransition transition(BuildContext context, Widget widget) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: Container(
          child: Center(
            child: widget,
          ),
          color: primarySwatch['background'],
        ),
      ),
    );
  }
}

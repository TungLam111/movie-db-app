import 'package:flutter/material.dart';

class CustomBottomNavigationItem {
  CustomBottomNavigationItem({
    required this.icon,
    this.label,
    Widget? activeIcon,
  }) {
    if (activeIcon == null) {
      this.activeIcon = icon;
    }
  }
  final Widget icon;
  String? label;
  Widget? activeIcon;
}

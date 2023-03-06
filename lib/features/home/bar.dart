import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/widgets/navigation_bar.dart';

const double _kTabBarHeight = 50.0;

const Color _kDefaultTabBarBackgroundColor = Color(0xCCF8F8F8);

class OBCupertinoTabBar extends StatelessWidget implements PreferredSizeWidget {
  const OBCupertinoTabBar({
    Key? key,
    required this.items,
    required this.onTap,
    this.currentIndex = 0,
    this.backgroundColor = _kDefaultTabBarBackgroundColor,
    this.activeColor = Colors.redAccent,
    this.inactiveColor = Colors.blueGrey,
    this.iconSize = 30.0,
  })  : assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length),
        super(key: key);

  final List<CustomBottomNavigationItem> items;
  final ChangeIndexAllowed<int> onTap;

  final int currentIndex;

  final Color? backgroundColor;

  final Color? activeColor;

  final Color? inactiveColor;

  final double? iconSize;

  bool get opaque => backgroundColor?.alpha == 0xFF;

  @override
  Size get preferredSize => const Size.fromHeight(_kTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    Widget result = SizedBox(
      height: _kTabBarHeight + bottomPadding,
      child: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _buildTabItems(),
        ),
      ),
    );

    return result;
  }

  List<Widget> _buildTabItems() {
    final List<Widget> result = <Widget>[];

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: Container(
              color: active
                  ? (activeColor ?? Colors.redAccent)
                  : (inactiveColor ?? ColorConstant.kRichBlack),
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child:
                          active ? items[index].activeIcon : items[index].icon,
                    ),
                  ),
                  items[index].label?.isNotEmpty == true
                      ? Text(items[index].label ?? '')
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return result;
  }

  OBCupertinoTabBar copyWith({
    Key? key,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    required int currentIndex,
    required ChangeIndexAllowed<int> onTap,
  }) {
    return OBCupertinoTabBar(
      key: key,
      items: items,
      backgroundColor: backgroundColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      iconSize: iconSize,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}

typedef ChangeIndexAllowed<T> = bool Function(T value);

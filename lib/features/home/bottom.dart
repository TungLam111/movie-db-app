import 'bar.dart';
import 'package:flutter/widgets.dart';

class OBCupertinoTabScaffold extends StatefulWidget {
  const OBCupertinoTabScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
  }) : super(key: key);

  final OBCupertinoTabBar tabBar;

  final IndexedWidgetBuilder tabBuilder;

  @override
  State<OBCupertinoTabScaffold> createState() => _OBCupertinoTabScaffoldState();
}

class _OBCupertinoTabScaffoldState extends State<OBCupertinoTabScaffold> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.tabBar.currentIndex;
  }

  @override
  void didUpdateWidget(OBCupertinoTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabBar.currentIndex != oldWidget.tabBar.currentIndex) {
      _currentPage = widget.tabBar.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stacked = <Widget>[];

    Widget content = _TabSwitchingView(
      currentTabIndex: _currentPage,
      tabNumber: widget.tabBar.items.length,
      tabBuilder: widget.tabBuilder,
    );

    final MediaQueryData existingMediaQuery = MediaQuery.of(context);

    final double bottomPadding =
        widget.tabBar.preferredSize.height + existingMediaQuery.padding.bottom;

    if (widget.tabBar.opaque) {
      content = Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: content,
      );
    } else {
      content = MediaQuery(
        data: existingMediaQuery.copyWith(
          padding: existingMediaQuery.padding.copyWith(
            bottom: bottomPadding,
          ),
        ),
        child: content,
      );
    }

    stacked.add(content);

    stacked.add(
      Align(
        alignment: Alignment.bottomCenter,
        child: widget.tabBar.copyWith(
          currentIndex: _currentPage,
          onTap: (int newIndex) {
            bool changeIndex = true;
            bool changeIndexAllowed = widget.tabBar.onTap(newIndex);
            if (!changeIndexAllowed) {
              changeIndex = false;
            }

            if (changeIndex) {
              setState(() {
                _currentPage = newIndex;
              });
            }

            return changeIndex;
          },
        ),
      ),
    );

    return Stack(
      children: stacked,
    );
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabNumber,
    required this.tabBuilder,
  }) : assert(tabNumber > 0);

  final int currentTabIndex;
  final int tabNumber;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  late List<Widget> tabs;
  late List<FocusScopeNode> tabFocusNodes;

  @override
  void initState() {
    super.initState();
    tabs = List<Widget>.generate(
      widget.tabNumber,
      (int index) => const SizedBox(),
    );
    tabFocusNodes = List<FocusScopeNode>.generate(
      widget.tabNumber,
      (int index) => FocusScopeNode(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusActiveTab();
  }

  void _focusActiveTab() {
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(widget.tabNumber, (int index) {
        final bool active = index == widget.currentTabIndex;

        // ignore: unnecessary_null_comparison
        if (active || tabs[index] != null) {
          tabs[index] = widget.tabBuilder(context, index);
        }

        return Offstage(
          offstage: !active,
          child: TickerMode(
            enabled: active,
            child: FocusScope(
              node: tabFocusNodes[index],
              child: tabs[index],
            ),
          ),
        );
      }),
    );
  }
}

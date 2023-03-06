import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/base/app_bloc.dart';
import 'package:mock_bloc_stream/core/config/env/logger_config.dart';
import 'package:mock_bloc_stream/features/home/bar.dart';
import 'package:mock_bloc_stream/features/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/features/home/bottom.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/main_movie_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/main_tv_page.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with RouteAware, SingleTickerProviderStateMixin<HomePage> {
  late HomeBloc _homeBloc;
  late int _currentIndex;
  late int _lastIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.didChangeDependencies();

    _currentIndex = 0;
    _lastIndex = 0;
  }

  void disposeStream() {
    BlocProvider.of<AppBloc>(context).dispose();
    _homeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logg('rebuild --- watchlist');
    return OBCupertinoTabScaffold(
      tabBuilder: (BuildContext context, int index) {
        return _getPageForTabIndex(index);
      },
      tabBar: _createTabBar(),
    );
  }

  Widget _getPageForTabIndex(int index) {
    Widget? page;
    switch (HomePageTab.values[index]) {
      case HomePageTab.movie:
        page = const MainMoviePage();
        break;
      case HomePageTab.tv:
        page = const MainTvPage();
        break;
      default:
        page = const SizedBox();
        break;
    }

    return page;
  }

  OBCupertinoTabBar _createTabBar() {
    return OBCupertinoTabBar(
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (int index) {
        HomePageTab tappedTab = HomePageTab.values[index];
        HomePageTab currentTab = HomePageTab.values[_lastIndex];

        if (tappedTab == HomePageTab.movie &&
            currentTab == HomePageTab.movie) {}

        if (tappedTab == HomePageTab.tv && currentTab == HomePageTab.tv) {}
        _lastIndex = index;
        return true;
      },
      items: <CustomBottomNavigationItem>[
        CustomBottomNavigationItem(
          icon: Text(
            'Movie',
            style: StylesConstant.ts16w400,
          ),
        ),
        CustomBottomNavigationItem(
          icon: Text(
            'Tv',
            style: StylesConstant.ts16w400,
          ),
        ),
      ],
    );
  }
}

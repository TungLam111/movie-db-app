import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/home/bar.dart';
import 'package:mock_bloc_stream/features/home/bottom.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/movie_watchlist_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/tv_watchlist_page.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);
  static const String routeName = '/watchlist';

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with RouteAware, SingleTickerProviderStateMixin<WatchlistPage> {
  late WatchlistMovieBloc _movieBloc;
  late WatchlistTvBloc _tvBloc;
  ValueNotifier<int> valueTabView = ValueNotifier<int>(0);
  late int _currentIndex;
  late int _lastIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentIndex = 0;
    _lastIndex = 0;

    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _movieBloc = BlocProvider.of<WatchlistMovieBloc>(context);
    _tvBloc = BlocProvider.of<WatchlistTvBloc>(context);

    Future<void>.microtask(
      () => _movieBloc.loadMovies(),
    );
    Future<void>.microtask(
      () => _tvBloc.loadTvs(),
    );
  }

  @override
  void didPopNext() {
    // reload when pop from Detail page
    _movieBloc.loadMovies();
    _tvBloc.loadTvs();
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    _tvBloc.dispose();
    valueTabView.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: OBCupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return _getPageForTabIndex(index);
            },
          );
        },
        tabBar: _createTabBar(),
      ),
    );
  }

  Widget _getPageForTabIndex(int index) {
    Widget? page;
    switch (OBHomePageTabs.values[index]) {
      case OBHomePageTabs.movie:
        page = const MovieWatchlist();
        break;
      case OBHomePageTabs.tv:
        page = const TvWatchlist();
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
        OBHomePageTabs tappedTab = OBHomePageTabs.values[index];
        OBHomePageTabs currentTab = OBHomePageTabs.values[_lastIndex];

        if (tappedTab == OBHomePageTabs.movie &&
            currentTab == OBHomePageTabs.movie) {}

        if (tappedTab == OBHomePageTabs.tv &&
            currentTab == OBHomePageTabs.tv) {}
        _lastIndex = index;
        return true;
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Text(
            'Movie',
            style: StylesConstant.ts16w400,
          ),
        ),
        BottomNavigationBarItem(
          icon: Text(
            'Tv',
            style: StylesConstant.ts16w400,
          ),
        ),
      ],
    );
  }
}

enum OBHomePageTabs { movie, tv }

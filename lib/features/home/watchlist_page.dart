import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/config/env/logger_config.dart';
import 'package:mock_bloc_stream/features/home/bar.dart';
import 'package:mock_bloc_stream/features/home/bottom.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/movie_watchlist_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/tv_watchlist_page.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/widgets/navigation_bar.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});
  static const String routeName = '/watch-list';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<BaseBloc>>[
        BlocProvider<WatchlistMovieBloc>(
          bloc: locator<WatchlistMovieBloc>(),
        ),
        BlocProvider<WatchlistTvBloc>(
          bloc: locator<WatchlistTvBloc>(),
        ),
      ],
      child: const _WatchlistPage(),
    );
  }
}

class _WatchlistPage extends StatefulWidget {
  const _WatchlistPage({Key? key}) : super(key: key);
  @override
  State<_WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<_WatchlistPage>
    with RouteAware, SingleTickerProviderStateMixin<_WatchlistPage> {
  late WatchlistMovieBloc _movieBloc;
  late WatchlistTvBloc _tvBloc;
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
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logg('rebuild --- watchlist');
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: OBCupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          return _getPageForTabIndex(index);
        },
        tabBar: _createTabBar(),
      ),
    );
  }

  Widget _getPageForTabIndex(int index) {
    Widget? page;
    switch (WatchListTabType.values[index]) {
      case WatchListTabType.movie:
        page = const MovieWatchlist();
        break;
      case WatchListTabType.tv:
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
        WatchListTabType tappedTab = WatchListTabType.values[index];
        WatchListTabType currentTab = WatchListTabType.values[_lastIndex];

        if (tappedTab == WatchListTabType.movie &&
            currentTab == WatchListTabType.movie) {}

        if (tappedTab == WatchListTabType.tv &&
            currentTab == WatchListTabType.tv) {}
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

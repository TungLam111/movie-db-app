import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/movie_watchlist_page.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/tv_watchlist_page.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);
  static const String routeName = '/watchlist';

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  late WatchlistMovieBloc _movieBloc;
  late WatchlistTvBloc _tvBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _movieBloc = BlocProvider.of<WatchlistMovieBloc>(context);
    _tvBloc = BlocProvider.of<WatchlistTvBloc>(context);

    Future<void>.microtask(
      () => _movieBloc.fetchWatchlistMovies(),
    );
    Future<void>.microtask(
      () => _tvBloc.fetchWatchlistTvs(),
    );
  }

  @override
  void didPopNext() {
    _movieBloc.fetchWatchlistMovies();
    _tvBloc.fetchWatchlistTvs();
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                key: Key('movieWatchlistTab'),
                text: 'Movie',
              ),
              Tab(
                key: Key('tvWatchlistTab'),
                text: 'Tv',
              ),
            ],
            indicatorColor: Colors.redAccent,
            indicatorWeight: 4.0,
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            MovieWatchlist(),
            TvWatchlist(),
          ],
        ),
      ),
    );
  }
}

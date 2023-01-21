import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/movie_watchlist_page.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/tv_watchlist_page.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);
  static const String routeName = '/watchlist';

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => Provider.of<WatchlistMovieBloc>(context, listen: false)
          .fetchWatchlistMovies(),
    );
    Future<void>.microtask(
      () => Provider.of<WatchlistTvBloc>(context, listen: false)
          .fetchWatchlistTvs(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieBloc>(context, listen: false)
        .fetchWatchlistMovies();
    Provider.of<WatchlistTvBloc>(context, listen: false).fetchWatchlistTvs();
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/about/about_page.dart';
import 'package:mock_bloc_stream/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/features/auth/presentation/pages/login_page.dart';
import 'package:mock_bloc_stream/features/home/home_page.dart';
import 'package:mock_bloc_stream/features/home/watchlist_page.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:mock_bloc_stream/features/search/presentation/bloc/search_bloc.dart';
import 'package:mock_bloc_stream/features/search/presentation/pages/movie_search_page.dart';
import 'package:mock_bloc_stream/features/search/presentation/pages/tv_search_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/popular_tvs_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:mock_bloc_stream/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log('Screen Name: ${settings.name}');
    switch (settings.name) {
      case LoginPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<AuthBloc>(
            bloc: locator<AuthBloc>(),
            child: const LoginPage(),
          ),
        );

      case HomePage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );

      case PopularMoviesPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<PopularMoviesBloc>(
            bloc: locator<PopularMoviesBloc>(),
            child: const PopularMoviesPage(),
          ),
        );

      case TopRatedMoviesPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<TopRatedMoviesBloc>(
            bloc: locator<TopRatedMoviesBloc>(),
            child: const TopRatedMoviesPage(),
          ),
        );

      case MovieDetailPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<MovieDetailBloc>(
            bloc: locator<MovieDetailBloc>(),
            child: MovieDetailPage(
              id: settings.arguments as int,
            ),
          ),
          settings: settings,
        );

      case PopularTvsPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<PopularTvsBloc>(
            bloc: locator<PopularTvsBloc>(),
            child: const PopularTvsPage(),
          ),
        );

      case TopRatedTvsPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<TopRatedTvsBloc>(
            bloc: locator<TopRatedTvsBloc>(),
            child: const TopRatedTvsPage(),
          ),
        );

      case TvDetailPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => MultiBlocProvider(
            providers: <BlocProvider<BaseBloc>>[
              BlocProvider<TvDetailBloc>(
                bloc: locator<TvDetailBloc>(),
              ),
              BlocProvider<TvSeasonEpisodesBloc>(
                bloc: locator<TvSeasonEpisodesBloc>(),
              )
            ],
            child: TvDetailPage(id: settings.arguments as int),
          ),
          settings: settings,
        );

      case MovieSearchPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<MovieSearchBloc>(
            bloc: locator<MovieSearchBloc>(),
            child: const MovieSearchPage(),
          ),
        );

      case TvSearchPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<TvSearchBloc>(
            bloc: locator<TvSearchBloc>(),
            child: const TvSearchPage(),
          ),
        );

      case WatchlistPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => MultiBlocProvider(
            providers: <BlocProvider<BaseBloc>>[
              BlocProvider<WatchlistMovieBloc>(
                bloc: locator<WatchlistMovieBloc>(),
              ),
              BlocProvider<WatchlistTvBloc>(
                bloc: locator<WatchlistTvBloc>(),
              ),
            ],
            child: const WatchlistPage(),
          ),
        );

      case AboutPage.routeName:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AboutPage(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(
      builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}

class GeneratePageRoute extends PageRouteBuilder<dynamic> {
  GeneratePageRoute({
    required this.widget,
    required this.routeName,
  }) : super(
          settings: RouteSettings(
            name: routeName,
          ),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              textDirection: TextDirection.rtl,
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
  final Widget widget;
  final String? routeName;
}

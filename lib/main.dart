import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mock_bloc_stream/about/about_page.dart';
import 'package:mock_bloc_stream/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/auth/presentation/pages/login_page.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/core/app_bloc.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart' as di;
import 'package:mock_bloc_stream/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/home/home_page.dart';
import 'package:mock_bloc_stream/home/watchlist_page.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/movie_detail_page.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/popular_movies_page.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:mock_bloc_stream/search/presentation/bloc/search_bloc.dart';
import 'package:mock_bloc_stream/search/presentation/pages/movie_search_page.dart';
import 'package:mock_bloc_stream/search/presentation/pages/tv_search_page.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/popular_tvs_page.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/tv_detail_page.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use shared blocs

    return MultiBlocProvider(
      providers: <BlocProvider<BaseBloc>>[
        BlocProvider<AppBloc>(
          bloc: di.locator<AppBloc>(),
        ),

        /// General
        BlocProvider<HomeBloc>(
          bloc: di.locator<HomeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: ColorConstant.kRichBlack,
          scaffoldBackgroundColor: ColorConstant.kRichBlack,
          textTheme: StylesConstant.kTextTheme,
          colorScheme: ColorConstant.kColorScheme.copyWith(
            secondary: Colors.redAccent,
          ),
        ),
        builder: EasyLoading.init(),
        home: const HomePage(),
        navigatorObservers: <NavigatorObserver>[routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case LoginPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<AuthBloc>(
                  bloc: di.locator<AuthBloc>(),
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
                  bloc: di.locator<PopularMoviesBloc>(),
                  child: const PopularMoviesPage(),
                ),
              );

            case TopRatedMoviesPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<TopRatedMoviesBloc>(
                  bloc: di.locator<TopRatedMoviesBloc>(),
                  child: const TopRatedMoviesPage(),
                ),
              );

            case MovieDetailPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<MovieDetailBloc>(
                  bloc: di.locator<MovieDetailBloc>(),
                  child: MovieDetailPage(
                    id: settings.arguments as int,
                  ),
                ),
                settings: settings,
              );

            case PopularTvsPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<PopularTvsBloc>(
                  bloc: di.locator<PopularTvsBloc>(),
                  child: const PopularTvsPage(),
                ),
              );

            case TopRatedTvsPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<TopRatedTvsBloc>(
                  bloc: di.locator<TopRatedTvsBloc>(),
                  child: const TopRatedTvsPage(),
                ),
              );

            case TvDetailPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => MultiBlocProvider(
                  providers: <BlocProvider<BaseBloc>>[
                    BlocProvider<TvDetailBloc>(
                      bloc: di.locator<TvDetailBloc>(),
                    ),
                    BlocProvider<TvSeasonEpisodesBloc>(
                      bloc: di.locator<TvSeasonEpisodesBloc>(),
                    )
                  ],
                  child: TvDetailPage(id: settings.arguments as int),
                ),
                settings: settings,
              );

            case MovieSearchPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<MovieSearchBloc>(
                  bloc: di.locator<MovieSearchBloc>(),
                  child: const MovieSearchPage(),
                ),
              );

            case TvSearchPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => BlocProvider<TvSearchBloc>(
                  bloc: di.locator<TvSearchBloc>(),
                  child: const TvSearchPage(),
                ),
              );

            case WatchlistPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => MultiBlocProvider(
                  providers: <BlocProvider<BaseBloc>>[
                    BlocProvider<WatchlistMovieBloc>(
                      bloc: di.locator<WatchlistMovieBloc>(),
                    ),
                    BlocProvider<WatchlistTvBloc>(
                      bloc: di.locator<WatchlistTvBloc>(),
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
              return MaterialPageRoute<dynamic>(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mock_bloc_stream/about/about_page.dart';
import 'package:mock_bloc_stream/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/auth/presentation/pages/login_page.dart';
import 'package:mock_bloc_stream/core/app_bloc.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart' as di;
import 'package:mock_bloc_stream/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/home/home_page.dart';
import 'package:mock_bloc_stream/home/watchlist_page.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_images_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/movie_detail_page.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/popular_movies_page.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:mock_bloc_stream/search/presentation/bloc/search_bloc.dart';
import 'package:mock_bloc_stream/search/presentation/pages/movie_search_page.dart';
import 'package:mock_bloc_stream/search/presentation/pages/tv_search_page.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_images_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_list_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/popular_tvs_page.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/tv_detail_page.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AppBloc>(create: (_) => di.locator<AppBloc>()),
        Provider<AuthBloc>(
          create: (_) => di.locator<AuthBloc>(),
        ),
        // /// General
        Provider<HomeBloc>(
          create: (_) => di.locator<HomeBloc>(),
        ),

        /// Movie
        Provider<MovieListBloc>(
          create: (_) => di.locator<MovieListBloc>(),
        ),
        Provider<PopularMoviesBloc>(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        Provider<TopRatedMoviesBloc>(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        Provider<MovieDetailBloc>(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        Provider<MovieImagesBloc>(
          create: (_) => di.locator<MovieImagesBloc>(),
        ),

        Provider<WatchlistMovieBloc>(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),

        /// Tv
        Provider<TvListBloc>(
          create: (_) => di.locator<TvListBloc>(),
        ),
        Provider<PopularTvsBloc>(
          create: (_) => di.locator<PopularTvsBloc>(),
        ),
        Provider<TopRatedTvsBloc>(
          create: (_) => di.locator<TopRatedTvsBloc>(),
        ),
        Provider<TvDetailBloc>(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        Provider<TvSeasonEpisodesBloc>(
          create: (_) => di.locator<TvSeasonEpisodesBloc>(),
        ),
        Provider<TvImagesBloc>(
          create: (_) => di.locator<TvImagesBloc>(),
        ),
        Provider<WatchlistTvBloc>(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
        BlocProvider<MovieSearchBloc>(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider<TvSearchBloc>(
          create: (_) => di.locator<TvSearchBloc>(),
        ),
      ],
      // client: di.locator.get<Client>(),
      // tvDatabaseHelper: di.locator.get<TvDatabaseHelper>(),
      // movieDatabaseHelper: di.locator.get<MovieDatabaseHelper>(),
      child: MaterialApp(
        title: 'Movie Database App',
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
        home: const LoginPage(),
        navigatorObservers: <NavigatorObserver>[routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute<dynamic>(
                builder: (_) => const LoginPage(),
              );
            case '/home':
              return MaterialPageRoute<dynamic>(
                builder: (_) => const HomePage(),
              );
            case PopularMoviesPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MovieDetailPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => MovieDetailPage(id: settings.arguments as int),
                settings: settings,
              );
            case PopularTvsPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const PopularTvsPage(),
              );
            case TopRatedTvsPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const TopRatedTvsPage(),
              );
            case TvDetailPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => TvDetailPage(id: settings.arguments as int),
                settings: settings,
              );
            case MovieSearchPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const MovieSearchPage(),
              );
            case TvSearchPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const TvSearchPage(),
              );
            case WatchlistPage.routeName:
              return MaterialPageRoute<dynamic>(
                builder: (_) => const WatchlistPage(),
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

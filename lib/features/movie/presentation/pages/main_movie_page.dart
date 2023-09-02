import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_view.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_images/movie_images_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/shimmer_playing_widget.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:mock_bloc_stream/widgets/shimmer_loading_widget.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/horizontal_item_list.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/minimal_detail.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/sub_heading.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/top_rated_movies_page.dart';

class MainMovieArgs extends BaseArguments {}

class MainMoviePage extends BaseViewMultiProvider<MainMovieArgs> {
  const MainMoviePage({
    super.key,
    required super.args,
  });

  @override
  List<BlocProvider<BaseBloc>> setBlocs() {
    return <BlocProvider<BaseBloc>>[
      BlocProvider<MovieListBloc>(
        bloc: locator<MovieListBloc>(),
      ),
      BlocProvider<MovieImagesBloc>(
        bloc: locator<MovieImagesBloc>(),
      )
    ];
  }

  @override
  BaseView<MainMovieArgs> setChild(BaseArguments argument) {
    return _MainMoviePage(
      args: argument as MainMovieArgs,
      blocTypes: const <Type>[
        MovieListBloc,
        MovieImagesBloc,
      ],
    );
  }
}

class _MainMoviePage extends BaseView<MainMovieArgs> {
  const _MainMoviePage({required super.args, required super.blocTypes});

  @override
  BaseViewState<BaseView<MainMovieArgs>, MainMovieArgs> createState() {
    return _MainMoviePageState();
  }
}

class _MainMoviePageState extends BaseViewState<_MainMoviePage, MainMovieArgs> {
  @override
  void didChangeDependenciesApp(
    Map<Type, BaseBloc> controller,
    BuildContext context,
  ) {
    Future<void>.microtask(() {
      getBloc<MovieListBloc>().fetchNowPlayingMovies().whenComplete(
            () => getBloc<MovieImagesBloc>().fetchMovieImages(
              getBloc<MovieListBloc>().nowPlayingMoviesF()[0].id,
            ),
          );
      getBloc<MovieListBloc>().fetchPopularMovies();
      getBloc<MovieListBloc>().fetchTopRatedMovies();
    });
  }

  @override
  void didposeBag() {}

  @override
  Widget buildUI(
    Map<Type, BaseBloc> controller,
    MainMovieArgs? args,
    BuildContext context,
  ) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNowPlaying(),
            SubHeading(
              valueKey: 'seePopularMovies',
              text: 'Popular',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                PopularMoviesPage.routeName,
              ),
            ),
            _buildPopularMovie(),
            SubHeading(
              valueKey: 'seeTopRatedMovies',
              text: 'Top Rated',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                TopRatedMoviesPage.routeName,
              ),
            ),
            _buildTopRatedMovie(),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlaying() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc<MovieListBloc>().nowPlayingStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snap1,
      ) {
        if (!snap1.hasData) {
          return const SizedBox();
        }

        if (snap1.data == RequestState.loading) {
          return const ShimmerPlayingWidget();
        }
        if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: getBloc<MovieListBloc>().nowPlayingMoviesStream,
            builder: (_, AsyncSnapshot<List<Movie>> snap2) {
              if (!snap2.hasData) {
                return const ShimmerPlayingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 575.0,
                    viewportFraction: 1.0,
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      getBloc<MovieImagesBloc>().fetchMovieImages(
                        snap2.data![index].id,
                      );
                    },
                  ),
                  items: snap2.data!.map(
                    (Movie item) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return MinimalDetail(
                                movie: item,
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            ShaderMask(
                              shaderCallback: (Rect rect) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: <double>[0, 0.3, 0.5, 1],
                                ).createShader(
                                  Rect.fromLTRB(
                                    0,
                                    0,
                                    rect.width,
                                    rect.height,
                                  ),
                                );
                              },
                              blendMode: BlendMode.dstIn,
                              child: CachedNetworkImage(
                                height: 560.0,
                                imageUrl: Urls.imageUrl(item.backdropPath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.redAccent,
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'Now Playing'.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: RequiredStreamBuilder<RequestState>(
                                      stream: getBloc<MovieImagesBloc>()
                                          .getMovieImagesStateStream,
                                      builder: (
                                        _,
                                        AsyncSnapshot<RequestState> snapshot,
                                      ) {
                                        if (snapshot.data ==
                                            RequestState.loaded) {
                                          return RequiredStreamBuilder<
                                              MediaImage?>(
                                            stream: getBloc<MovieImagesBloc>()
                                                .getMediaImageStream,
                                            builder: (
                                              __,
                                              AsyncSnapshot<MediaImage?>
                                                  snapshot2,
                                            ) {
                                              if (snapshot2.data == null) {
                                                return const Center(
                                                  child: Text(
                                                    'Load data failed',
                                                  ),
                                                );
                                              }
                                              if (snapshot2.data!.logoPaths
                                                      ?.isEmpty ==
                                                  true) {
                                                return Text(
                                                  item.title!,
                                                );
                                              }
                                              return CachedNetworkImage(
                                                width: 200.0,
                                                imageUrl: Urls.imageUrl(
                                                  snapshot2.data!.logoPaths![0]
                                                      .filePath!,
                                                ),
                                              );
                                            },
                                          );
                                        } else if (snapshot.data ==
                                            RequestState.error) {
                                          return const Center(
                                            child: Text(
                                              'Load data failed',
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          );
        }
        if (snap1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildPopularMovie() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc<MovieListBloc>().popularMoviesStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot1,
      ) {
        if (snapshot1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: getBloc<MovieListBloc>().popularMoviesStream,
            builder: (__, AsyncSnapshot<List<Movie>> snapshot2) {
              if (!snapshot2.hasData) {
                return const ShimmerLoadingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: HorizontalItemList(
                  movies: snapshot2.data,
                ),
              );
            },
          );
        }
        if (snapshot1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        }

        return const ShimmerLoadingWidget();
      },
    );
  }

  Widget _buildTopRatedMovie() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc<MovieListBloc>().topRatedMoviesStateStream,
      builder: (
        _,
        AsyncSnapshot<RequestState> snapRated1,
      ) {
        if (snapRated1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: getBloc<MovieListBloc>().topRatedMoviesStream,
            builder: (__, AsyncSnapshot<List<Movie>> snapRated2) {
              if (!snapRated2.hasData) {
                return const ShimmerLoadingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: HorizontalItemList(
                  movies: snapRated2.data,
                ),
              );
            },
          );
        } else if (snapRated1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerLoadingWidget();
        }
      },
    );
  }
}

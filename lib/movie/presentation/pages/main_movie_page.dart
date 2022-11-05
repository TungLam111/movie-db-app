import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/movie/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_images_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/shimmer_playing_widget.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:mock_bloc_stream/widgets/shimmer_loading_widget.dart';
import 'package:provider/provider.dart';

import 'package:mock_bloc_stream/movie/presentation/widgets/horizontal_item_list.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/minimal_detail.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/sub_heading.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/popular_movies_page.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/top_rated_movies_page.dart';

class MainMoviePage extends StatefulWidget {
  const MainMoviePage({Key? key}) : super(key: key);

  @override
  State<MainMoviePage> createState() => _MainMoviePageState();
}

class _MainMoviePageState extends State<MainMoviePage> {
  @override
  void initState() {
    super.initState();

    Future<void>.microtask(() {
      Provider.of<MovieListBloc>(context, listen: false)
          .fetchNowPlayingMovies()
          .whenComplete(
            () => Provider.of<MovieImagesBloc>(context, listen: false)
                .fetchMovieImages(
              Provider.of<MovieListBloc>(context, listen: false)
                  .nowPlayingMovies[0]
                  .id,
            ),
          );
      Provider.of<MovieListBloc>(context, listen: false).fetchPopularMovies();
      Provider.of<MovieListBloc>(context, listen: false).fetchTopRatedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        key: const Key('movieScrollView'),
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
      stream: Provider.of<MovieListBloc>(context).nowPlayingStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snap1,
      ) {
        if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: Provider.of<MovieListBloc>(context).nowPlayingMoviesStream,
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
                      Provider.of<MovieImagesBloc>(
                        context,
                        listen: false,
                      ).fetchMovieImages(
                        snap2.data![index].id,
                      );
                    },
                  ),
                  items: snap2.data!.map(
                    (Movie item) {
                      return GestureDetector(
                        key: const Key('openMovieMinimalDetail'),
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
                                keyValue: 'goToMovieDetail',
                                closeKeyValue: 'closeMovieMinimalDetail',
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
                                      stream: Provider.of<MovieImagesBloc>(
                                        context,
                                      ).getMovieImagesStateStream,
                                      builder: (
                                        _,
                                        AsyncSnapshot<RequestState> snapshot,
                                      ) {
                                        if (snapshot.data ==
                                            RequestState.loaded) {
                                          return RequiredStreamBuilder<
                                              MediaImage?>(
                                            stream:
                                                Provider.of<MovieImagesBloc>(
                                              context,
                                            ).getMediaImageStream,
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
                                              if (snapshot2
                                                  .data!.logoPaths.isEmpty) {
                                                return Text(
                                                  item.title!,
                                                );
                                              }
                                              return CachedNetworkImage(
                                                width: 200.0,
                                                imageUrl: Urls.imageUrl(
                                                  snapshot2.data!.logoPaths[0],
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
        } else if (snap1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerPlayingWidget();
        }
      },
    );
  }

  Widget _buildPopularMovie() {
    return RequiredStreamBuilder<RequestState>(
      stream: Provider.of<MovieListBloc>(context).popularMoviesStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot1,
      ) {
        if (snapshot1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: Provider.of<MovieListBloc>(context).popularMoviesStream,
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
        } else if (snapshot1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopRatedMovie() {
    return RequiredStreamBuilder<RequestState>(
      stream: Provider.of<MovieListBloc>(context).topRatedMoviesStateStream,
      builder: (
        _,
        AsyncSnapshot<RequestState> snapRated1,
      ) {
        if (snapRated1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: Provider.of<MovieListBloc>(context).topRatedMoviesStream,
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

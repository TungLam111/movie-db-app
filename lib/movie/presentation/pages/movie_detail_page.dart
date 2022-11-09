import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mock_bloc_stream/movie/domain/entities/genre.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie_detail.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/minimal_detail.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart' as di;

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);
  static const String routeName = '/movie-detail';

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProviderLamcute<MovieDetailBloc>(
      bloc: di.locator<MovieDetailBloc>()
        ..fetchMovieDetail(id)
        ..loadWatchlistStatus(id),
      child: _MovieDetailPage(
        id: id,
      ),
    );
  }
}

class _MovieDetailPage extends StatefulWidget {
  const _MovieDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<_MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<_MovieDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequiredStreamBuilder<RequestState>(
        stream:
            BlocProviderLamcute.of<MovieDetailBloc>(context).movieStateStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<RequestState> snapshot,
        ) {
          if (snapshot.data == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == RequestState.loaded) {
            return RequiredStreamBuilder<MovieDetail?>(
              stream: BlocProviderLamcute.of<MovieDetailBloc>(context)
                  .getMovieDetailStream,
              builder: (_, AsyncSnapshot<MovieDetail?> asyncSnapshot2) {
                if (!asyncSnapshot2.hasData) {
                  return const SizedBox();
                }
                final MovieDetail movie = asyncSnapshot2.data!;
                return MovieDetailContent(
                  movie: movie,
                  recommendations:
                      BlocProviderLamcute.of<MovieDetailBloc>(context)
                          .recommendationsValue,
                  isAddedToWatchlist:
                      BlocProviderLamcute.of<MovieDetailBloc>(context)
                          .isAddedToWatchlistValue,
                );
              },
            );
          } else {
            return Text(
              BlocProviderLamcute.of<MovieDetailBloc>(context).getMessage,
            );
          }
        },
      ),
    );
  }
}

class MovieDetailContent extends StatefulWidget {
  const MovieDetailContent({
    Key? key,
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
  }) : super(key: key);
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;

  @override
  State<MovieDetailContent> createState() => _MovieDetailContentState();
}

class _MovieDetailContentState extends State<MovieDetailContent> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const Key('movieDetailScrollView'),
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: ShaderMask(
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
                    stops: <double>[0.0, 0.5, 1.0, 1.0],
                  ).createShader(
                    Rect.fromLTRB(0.0, 0.0, rect.width, rect.height),
                  );
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: Urls.imageUrl(widget.movie.backdropPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInUp(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.movie.title,
                    style: StylesConstant.kHeading5.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.kGrey800,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          widget.movie.releaseDate.split('-')[0],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            (widget.movie.voteAverage / 2).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '(${widget.movie.voteAverage})',
                            style: const TextStyle(
                              fontSize: 1.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        _showDuration(widget.movie.runtime),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    key: const Key('movieToWatchlist'),
                    onPressed: () async {
                      if (!widget.isAddedToWatchlist) {
                        await BlocProviderLamcute.of<MovieDetailBloc>(
                          context,
                        ).addToWatchlist(widget.movie);
                      } else {
                        await BlocProviderLamcute.of<MovieDetailBloc>(
                          context,
                        ).removeFromWatchlist(widget.movie);
                      }
                      if (!mounted) {
                        return;
                      }
                      final String message =
                          BlocProviderLamcute.of<MovieDetailBloc>(
                        context,
                      ).watchlistMessageValue;

                      if (message ==
                              MovieDetailBloc.watchlistAddSuccessMessage ||
                          message ==
                              MovieDetailBloc.watchlistRemoveSuccessMessage) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(message),
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAddedToWatchlist
                          ? ColorConstant.kGrey850
                          : Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        42.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        widget.isAddedToWatchlist
                            ? const Icon(Icons.check, color: Colors.white)
                            : const Icon(Icons.add, color: Colors.black),
                        const SizedBox(width: 16.0),
                        Text(
                          widget.isAddedToWatchlist
                              ? 'Added to watchlist'
                              : 'Add to watchlist',
                          style: TextStyle(
                            color: widget.isAddedToWatchlist
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Genres: ${_showGenres(widget.movie.genres)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          sliver: SliverToBoxAdapter(
            child: FadeInUp(
              from: 20,
              duration: const Duration(milliseconds: 500),
              child: Text(
                'More like this'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
        // Tab(text: 'More like this'.toUpperCase()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
          sliver: _showRecommendations(),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (Genre genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _showRecommendations() {
    return RequiredStreamBuilder<RequestState>(
      stream: BlocProviderLamcute.of<MovieDetailBloc>(context)
          .recommendationsStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot,
      ) {
        if (snapshot.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: BlocProviderLamcute.of<MovieDetailBloc>(context)
                .recommendationStream,
            builder: (_, AsyncSnapshot<List<Movie>> snapshot2) {
              if (!snapshot2.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final Movie recommendation = snapshot2.data![index];
                    return FadeInUp(
                      from: 20,
                      duration: const Duration(milliseconds: 500),
                      child: GestureDetector(
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
                                movie: recommendation,
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          child: CachedNetworkImage(
                            imageUrl: Urls.imageUrl(recommendation.posterPath!),
                            placeholder: (BuildContext context, String url) =>
                                Shimmer.fromColors(
                              baseColor: ColorConstant.kGrey850,
                              highlightColor: ColorConstant.kGrey800,
                              child: Container(
                                height: 170.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (
                              BuildContext context,
                              String url,
                              dynamic error,
                            ) =>
                                const Icon(Icons.error),
                            height: 180.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: snapshot2.data!.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 3
                      : 4,
                ),
              );
            },
          );
        } else if (snapshot.data == RequestState.error) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                BlocProviderLamcute.of<MovieDetailBloc>(context).getMessage,
              ),
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

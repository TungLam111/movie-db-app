import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mock_bloc_stream/features/movie/domain/entities/genre.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie_detail.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/minimal_detail.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);
  static const String routeName = '/movie-detail';

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailBloc _bloc;
  late StreamSubscription<String> messageListener;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<MovieDetailBloc>(context)
      ..fetchMovieDetail(widget.id)
      ..loadWatchlistStatus(widget.id);

    messageListener = _bloc.messageStream.listen((String event) {
      if (event.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(event)));
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    messageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequiredStreamBuilder<RequestState>(
        stream: _bloc.movieStateStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<RequestState> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          if (snapshot.data == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == RequestState.loaded) {
            return RequiredStreamBuilder<MovieDetail?>(
              stream: _bloc.getMovieDetailStream,
              builder: (_, AsyncSnapshot<MovieDetail?> asyncSnapshot2) {
                if (!asyncSnapshot2.hasData) {
                  return const SizedBox();
                }
                final MovieDetail movie = asyncSnapshot2.data!;
                return MovieDetailContent(
                  movie: movie,
                  isAddedToWatchlist: _bloc.isAddedToWatchlistValue,
                );
              },
            );
          }

          return const Text(
            'Cannot get movie detail',
          );
        },
      ),
    );
  }
}

class MovieDetailContent extends StatefulWidget {
  const MovieDetailContent({
    Key? key,
    required this.movie,
    required this.isAddedToWatchlist,
  }) : super(key: key);
  final MovieDetail movie;
  final bool isAddedToWatchlist;

  @override
  State<MovieDetailContent> createState() => _MovieDetailContentState();
}

class _MovieDetailContentState extends State<MovieDetailContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                        await BlocProvider.of<MovieDetailBloc>(
                          context,
                        ).addToWatchlist(widget.movie);
                      } else {
                        await BlocProvider.of<MovieDetailBloc>(
                          context,
                        ).removeFromWatchlist(widget.movie);
                      }
                      if (!mounted) {
                        return;
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
      stream: BlocProvider.of<MovieDetailBloc>(
        context,
      ).recommendationsStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: BlocProvider.of<MovieDetailBloc>(
              context,
            ).recommendationStream,
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
        }
        if (snapshot.data == RequestState.error) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Cannot get recommendation',
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

import 'package:mock_bloc_stream/features/movie/domain/entities/genre.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie_detail.dart';

class MovieDetailContent extends StatelessWidget {
  const MovieDetailContent({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        from: 20,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title ?? '',
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
                      movie.releaseDate != null
                          ? movie.releaseDate!.split('-')[0]
                          : '',
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
                        movie.voteAverage != null
                            ? (movie.voteAverage! / 2).toStringAsFixed(1)
                            : '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '(${movie.voteAverage})',
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
                    movie.runtime != null ? _showDuration(movie.runtime!) : '',
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
              RequiredStreamBuilder<TupleEx2<bool, RequestState>>(
                stream: BlocProvider.of<MovieDetailBloc>(context).statusStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<TupleEx2<bool, RequestState>> snapWatchList,
                ) {
                  if (!snapWatchList.hasData || snapWatchList.data == null) {
                    return const SizedBox();
                  }
                  bool isAddedToWatchlist = snapWatchList.data!.value1;
                  if (snapWatchList.data!.value2 == RequestState.loading) {
                    return const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      if (isAddedToWatchlist) {
                        await BlocProvider.of<MovieDetailBloc>(
                          context,
                        ).removeFromWatchlist(movie);
                      } else {
                        await BlocProvider.of<MovieDetailBloc>(
                          context,
                        ).addToWatchlist(movie);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAddedToWatchlist
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
                        isAddedToWatchlist
                            ? const Icon(Icons.check, color: Colors.white)
                            : const Icon(Icons.add, color: Colors.black),
                        const SizedBox(width: 16.0),
                        Text(
                          isAddedToWatchlist
                              ? 'Added to watchlist'
                              : 'Add to watchlist',
                          style: TextStyle(
                            color: isAddedToWatchlist
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                movie.overview ?? '',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                movie.genres != null
                    ? 'Genres: ${_showGenres(movie.genres!)}'
                    : '',
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
}

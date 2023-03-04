import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/features/movie/presentation/widgets/item_card_list.dart';

class MovieWatchlist extends StatelessWidget {
  const MovieWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequiredStreamBuilder<TupleEx2<List<Movie>, RequestState>>(
      stream: BlocProvider.of<WatchlistMovieBloc>(context).tupleStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<TupleEx2<List<Movie>, RequestState>> asyncSnapshot,
      ) {
        if (!asyncSnapshot.hasData) {
          return const SizedBox();
        }
        final TupleEx2<List<Movie>, RequestState>? data = asyncSnapshot.data;
        List<Movie> movies = data?.value1 ?? <Movie>[];
        return FadeInUp(
          from: 20,
          duration: const Duration(milliseconds: 500),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (data == null) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return index < movies.length
                  ? ItemCard(
                      movie: movies[index],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
            },
            itemCount: data == null
                ? 1
                : data.value2 == RequestState.loading
                    ? movies.length + 1
                    : movies.length,
          ),
        );
      },
    );
  }
}

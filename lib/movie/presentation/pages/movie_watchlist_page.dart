import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/item_card_list.dart';

class MovieWatchlist extends StatelessWidget {
  const MovieWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequiredStreamBuilder<RequestState>(
      stream: BlocProvider.of<WatchlistMovieBloc>(context).watchlistStateStream,
      builder: (_, AsyncSnapshot<RequestState> snapshot) {
        if (snapshot.data == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Movie>>(
            stream: BlocProvider.of<WatchlistMovieBloc>(context)
                .watchlistMoviesStream,
            builder: (__, AsyncSnapshot<List<Movie>> snapshot2) {
              if (!snapshot2.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                key: const Key('movieWatchlist'),
                itemCount: snapshot2.data!.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int index) {
                  final Movie movie = snapshot2.data![index];
                  return ItemCard(
                    movie: movie,
                  );
                },
              );
            },
          );
        }
        return Center(
          key: const Key('error_message'),
          child: Text(
            BlocProvider.of<WatchlistMovieBloc>(context).getMessage,
          ),
        );
      },
    );
  }
}

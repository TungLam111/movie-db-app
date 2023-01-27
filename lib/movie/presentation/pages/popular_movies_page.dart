import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import 'package:mock_bloc_stream/movie/presentation/widgets/item_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({Key? key}) : super(key: key);
  static const String routeName = '/popular-movies';

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  late PopularMoviesBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<PopularMoviesBloc>(context);
    _bloc.fetchPopularMovies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RequiredStreamBuilder<RequestState>(
          stream: _bloc.getWatchlistMovieStateStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<RequestState> asyncSnapshot,
          ) {
            if (asyncSnapshot.data == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (asyncSnapshot.data == RequestState.loaded) {
              return RequiredStreamBuilder<List<Movie>>(
                stream: _bloc.getMoviesStream,
                builder: (__, AsyncSnapshot<List<Movie>> asyncSnapshot2) {
                  if (!asyncSnapshot2.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: ListView.builder(
                      key: const Key('popularMoviesListView'),
                      itemBuilder: (BuildContext context, int index) {
                        final Movie movie = asyncSnapshot2.data![index];
                        return ItemCard(
                          movie: movie,
                        );
                      },
                      itemCount: asyncSnapshot2.data!.length,
                    ),
                  );
                },
              );
            }
            return Center(
              key: const Key('error_message'),
              child: Text(
                _bloc.currentMessage,
              ),
            );
          },
        ),
      ),
    );
  }
}

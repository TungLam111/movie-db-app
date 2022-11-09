import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:provider/provider.dart';

import '../widgets/item_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({Key? key}) : super(key: key);
  static const String routeName = '/top-rated-movies';

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => Provider.of<TopRatedMoviesBloc>(context, listen: false)
          .fetchTopRatedMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RequiredStreamBuilder<RequestState>(
          stream: Provider.of<TopRatedMoviesBloc>(context).stateStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<RequestState> snap1,
          ) {
            if (snap1.data == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap1.data == RequestState.loaded) {
              return RequiredStreamBuilder<List<Movie>>(
                stream: Provider.of<TopRatedMoviesBloc>(context).moviesStream,
                builder: (__, AsyncSnapshot<List<Movie>> snap2) {
                  if (!snap2.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: ListView.builder(
                      key: const Key('topRatedMoviesListView'),
                      itemBuilder: (BuildContext context, int index) {
                        final Movie movie = snap2.data![index];
                        return ItemCard(
                          movie: movie,
                        );
                      },
                      itemCount: snap2.data!.length,
                    ),
                  );
                },
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child:
                    Text(Provider.of<TopRatedMoviesBloc>(context).getMessage),
              );
            }
          },
        ),
      ),
    );
  }
}
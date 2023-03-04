import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import 'package:mock_bloc_stream/features/movie/presentation/widgets/item_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({Key? key}) : super(key: key);
  static const String routeName = '/top-rated-movies';

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  late TopRatedMoviesBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<TopRatedMoviesBloc>(context);
    _bloc.loadMovies();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels + 100 >=
            _scrollController.position.maxScrollExtent) {
          _bloc.loadMovies();
        }
      });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _scrollController.dispose();
    super.dispose();
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
        child: RequiredStreamBuilder<TupleEx2<List<Movie>, RequestState>>(
          stream: _bloc.tupleStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<TupleEx2<List<Movie>, RequestState>> asyncSnapshot,
          ) {
            if (!asyncSnapshot.hasData) {
              return const SizedBox();
            }
            final TupleEx2<List<Movie>, RequestState>? data =
                asyncSnapshot.data;
            List<Movie> movies = data?.value1 ?? <Movie>[];

            return FadeInUp(
              from: 20,
              duration: const Duration(milliseconds: 500),
              child: ListView.builder(
                controller: _scrollController,
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
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/presentation/widgets/item_card_list.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../bloc/search_bloc.dart';

class MovieSearchPage extends StatelessWidget {
  const MovieSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/movie-search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              key: const Key('enterMovieQuery'),
              onChanged: (String query) {
                BlocProvider.of<MovieSearchBloc>(context)
                    .add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search movies',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              textInputAction: TextInputAction.search,
              cursorColor: Colors.white,
            ),
            RequiredStreamBuilder<SearchState>(
              stream: BlocProvider.of<MovieSearchBloc>(context).state,
              builder: (
                BuildContext context,
                AsyncSnapshot<SearchState> snap1,
              ) {
                if (!snap1.hasData) {
                  return const SizedBox();
                }

                if (snap1.data is MovieSearchHasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Search result',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
            RequiredStreamBuilder<SearchState>(
              stream: BlocProvider.of<MovieSearchBloc>(context).state,
              builder: (
                BuildContext context,
                AsyncSnapshot<SearchState> snap1,
              ) {
                if (!snap1.hasData) {
                  return const SizedBox();
                }

                if (snap1.data is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snap1.data is MovieSearchHasData) {
                  final List<Movie> result =
                      (snap1.data as MovieSearchHasData).result;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final Movie movie = result[index];
                        return ItemCard(
                          movie: movie,
                        );
                      },
                    ),
                  );
                } else if (snap1.data is SearchError) {
                  return Expanded(
                    child: Center(
                      child: Text((snap1.data as SearchError).message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

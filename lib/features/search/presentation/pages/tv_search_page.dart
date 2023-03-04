import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/search/presentation/bloc/search_state.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/presentation/widgets/item_card_list.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import '../bloc/search_bloc.dart';

class TvSearchPage extends StatelessWidget {
  const TvSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/tv-search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              onChanged: (String query) {
                BlocProvider.of<TvSearchBloc>(context)
                    .add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search tv shows',
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
              stream: BlocProvider.of<TvSearchBloc>(context).stateStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<SearchState> snap1,
              ) {
                if (!snap1.hasData) {
                  return const SizedBox();
                }

                if (snap1.data?.searchTvState == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snap1.data?.searchMovieState == RequestState.loaded ||
                    snap1.data?.searchMovieState == RequestState.error) {
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
              stream: BlocProvider.of<MovieSearchBloc>(context).stateStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<SearchState> snap1,
              ) {
                if (!snap1.hasData) {
                  return const SizedBox();
                }

                if (snap1.data?.searchTvState == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snap1.data?.searchMovieState == RequestState.loaded) {
                  final List<Tv> result = snap1.data?.tvs ?? <Tv>[];
                  return Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final Tv tv = result[index];
                        return ItemCard(
                          tv: tv,
                        );
                      },
                    ),
                  );
                }

                if (snap1.data?.searchTvState == RequestState.error) {
                  return Expanded(
                    child: Center(
                      child: Text(snap1.data?.msgTv ?? ''),
                    ),
                  );
                }
                return Expanded(
                  child: Container(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
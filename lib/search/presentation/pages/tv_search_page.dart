import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/presentation/widgets/item_card_list.dart';
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
          children:<Widget> [
            TextField(
              key: const Key('enterTvQuery'),
              onChanged: (String query) {
                context.read<TvSearchBloc>().add(OnQueryChanged(query));
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
            BlocBuilder<TvSearchBloc, SearchState>(
              builder: (BuildContext context, SearchState state) {
                if (state is TvSearchHasData) {
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
                } else {
                  return const SizedBox();
                }
              },
            ),
            BlocBuilder<TvSearchBloc, SearchState>(
              builder: (BuildContext context, SearchState state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSearchHasData) {
                  final List<Tv> result = state.result;
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
                } else if (state is SearchError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
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

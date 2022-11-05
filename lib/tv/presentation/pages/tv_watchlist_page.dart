import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:provider/provider.dart';

import '../widgets/item_card_list.dart';

class TvWatchlist extends StatelessWidget {
  const TvWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequiredStreamBuilder<RequestState>(
      stream: Provider.of<WatchlistTvBloc>(context).watchlistStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot,
      ) {
        if (snapshot.data == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Tv>>(
            stream: Provider.of<WatchlistTvBloc>(context).watchlistTvsStream,
            builder: (__, AsyncSnapshot<List<Tv>> snapshot2) {
              if (!snapshot2.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                key: const Key('tvWatchlist'),
                itemCount: snapshot2.data!.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int index) {
                  final Tv tv = snapshot2.data![index];
                  return ItemCard(
                    tv: tv,
                  );
                },
              );
            },
          );
        }
        return Center(
          key: const Key('error_message'),
          child: Text(Provider.of<WatchlistTvBloc>(context).message.value),
        );
      },
    );
  }
}

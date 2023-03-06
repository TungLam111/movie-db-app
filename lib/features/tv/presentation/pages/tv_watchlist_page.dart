import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../widgets/item_card_list.dart';

class TvWatchlist extends StatelessWidget {
  const TvWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('rebuild movie watch');
    return RequiredStreamBuilder<TupleEx2<List<Tv>, RequestState>>(
      stream: BlocProvider.of<WatchlistTvBloc>(context).tupleStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<TupleEx2<List<Tv>, RequestState>> asyncSnapshot,
      ) {
        if (!asyncSnapshot.hasData) {
          return const SizedBox();
        }
        final TupleEx2<List<Tv>, RequestState>? data = asyncSnapshot.data;
        List<Tv> tvs = data?.value1 ?? <Tv>[];
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
              return index < tvs.length
                  ? ItemCard(
                      tv: tvs[index],
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
                    ? tvs.length + 1
                    : tvs.length,
          ),
        );
      },
    );
  }
}

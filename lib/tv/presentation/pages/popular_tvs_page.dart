import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:provider/provider.dart';

import 'package:mock_bloc_stream/tv/presentation/widgets/item_card_list.dart';

class PopularTvsPage extends StatefulWidget {
  const PopularTvsPage({Key? key}) : super(key: key);
  static const String routeName = '/popular-tvs';

  @override
  State<PopularTvsPage> createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () =>
          Provider.of<PopularTvsBloc>(context, listen: false).fetchPopularTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Popular Tvs'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RequiredStreamBuilder<RequestState>(
          stream: Provider.of<PopularTvsBloc>(context).state,
          builder: (
            BuildContext context,
            AsyncSnapshot<RequestState> snap1,
          ) {
            if (snap1.data == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap1.data == RequestState.loaded) {
              return RequiredStreamBuilder<List<Tv>>(
                stream: Provider.of<PopularTvsBloc>(context).tvs,
                builder: (__, AsyncSnapshot<List<Tv>> snap2) {
                  if (!snap2.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 500),
                    child: ListView.builder(
                      key: const Key('popularTvsListView'),
                      itemCount: snap2.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Tv tv = snap2.data![index];
                        return ItemCard(tv: tv);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(Provider.of<PopularTvsBloc>(context).getMessage),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/widgets/item_card_list.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

class PopularTvsPage extends StatefulWidget {
  const PopularTvsPage({Key? key}) : super(key: key);
  static const String routeName = '/popular-tvs';

  @override
  State<PopularTvsPage> createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  late PopularTvsBloc _bloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<PopularTvsBloc>(context);
    Future<void>.microtask(() => _bloc.fetchPopularTvs());

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
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
          stream: _bloc.state,
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
                stream: _bloc.tvs,
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
              return const Center(
                key: Key('error_message'),
                child: Text('Cannot get popular tvs'),
              );
            }
          },
        ),
      ),
    );
  }
}

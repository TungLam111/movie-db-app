import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../widgets/item_card_list.dart';

class TopRatedTvsPage extends StatefulWidget {
  const TopRatedTvsPage({Key? key}) : super(key: key);
  static const String routeName = '/top-rated-tvs';

  @override
  State<TopRatedTvsPage> createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  late TopRatedTvsBloc _bloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<TopRatedTvsBloc>(context);
    Future<void>.microtask(
      () => _bloc.fetchTopRatedTvs(),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Top Rated Tvs'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomizedStreamBuilder<Tv>(
          streamLoadState: _bloc.state,
          streamLoadData: _bloc.tvs,
          loadingWidget: const Center(
            child: CircularProgressIndicator(),
          ),
          itemBuilder: (_, Tv tv, ___) {
            return ItemCard(
              tv: tv,
            );
          },
          otherWidget: Center(
            key: const Key('error_message'),
            child: Text(_bloc.getMessage),
          ),
        ),
      ),
    );
  }
}

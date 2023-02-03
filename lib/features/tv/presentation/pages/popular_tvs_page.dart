import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<PopularTvsBloc>(context)..loadTvs(LoadType.load);

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels + 100 >=
            _scrollController.position.maxScrollExtent) {
          _bloc.loadTvs(LoadType.load);
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
        title: const Text('Popular Tvs'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RequiredStreamBuilder<TupleEx2<List<Tv>, RequestState>>(
          stream: _bloc.tupleStream,
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
              child: RefreshIndicator(
                onRefresh: () async {
                  _bloc.loadTvs(LoadType.refresh);
                },
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
              ),
            );
          },
        ),
      ),
    );
  }
}

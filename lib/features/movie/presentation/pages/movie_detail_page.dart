import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie_detail.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/widgets/detail_movie.dart';
import 'package:mock_bloc_stream/features/movie/presentation/pages/widgets/recommendation_movie.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/urls.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);
  static const String routeName = '/movie-detail';

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailBloc _bloc;
  late StreamSubscription<String> messageListener;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<MovieDetailBloc>(context)
      ..loadDetailMovie()
      ..loadStatus()
      ..loadSuggest(LoadType.load);

    messageListener = _bloc.messageStream.listen((String event) {
      if (event.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(event)));
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    messageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.loadDetailMovie();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            RequiredStreamBuilder<TupleEx2<MovieDetail, RequestState>>(
              stream: _bloc.detailStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<TupleEx2<MovieDetail, RequestState>> snapshot,
              ) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
                if (snapshot.data!.value2 != RequestState.loaded) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return SliverAppBar(
                  pinned: true,
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: <double>[0.0, 0.5, 1.0, 1.0],
                          ).createShader(
                            Rect.fromLTRB(0.0, 0.0, rect.width, rect.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          imageUrl: Urls.imageUrl(
                            snapshot.data!.value1.backdropPath!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            RequiredStreamBuilder<TupleEx2<MovieDetail, RequestState>>(
              stream: _bloc.detailStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<TupleEx2<MovieDetail, RequestState>> snapshot,
              ) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
                if (snapshot.data!.value2 != RequestState.loaded) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return MovieDetailContent(
                  movie: snapshot.data!.value1,
                );
              },
            ),

            // suggestion
            RequiredStreamBuilder<TupleEx2<List<Movie>, RequestState>>(
              stream: _bloc.suggestStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<TupleEx2<List<Movie>, RequestState>> snapshot,
              ) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  sliver: SliverToBoxAdapter(
                    child: FadeInUp(
                      from: 20,
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        'More like this'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
              sliver: MovieRecommendation(),
            ),
          ],
        ),
      ),
    );
  }
}

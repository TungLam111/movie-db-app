import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_view.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_list_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/widgets/shimmer_playing_tv_loading_widget.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:mock_bloc_stream/widgets/shimmer_loading_widget.dart';
import '../widgets/horizontal_item_list.dart';
import '../widgets/minimal_detail.dart';
import '../widgets/sub_heading.dart';
import 'popular_tvs_page.dart';
import 'top_rated_tvs_page.dart';

class MainTvArgs extends BaseArguments {}

class MainTvPage extends BaseViewProvider<TvListBloc, MainTvArgs> {
  const MainTvPage({
    super.key,
    required super.args,
  });

  @override
  BaseView<TvListBloc, MainTvArgs> setChild(BaseArguments argument) {
    return _MainTvPage(
      args: argument as MainTvArgs,
      blocTypes: const <Type>[
        TvListBloc,
      ],
    );
  }

  @override
  TvListBloc setBlocs() {
    return locator<TvListBloc>();
  }
}

class _MainTvPage extends BaseView<TvListBloc, MainTvArgs> {
  const _MainTvPage({required super.args, required super.blocTypes});

  @override
  BaseViewState<BaseView<TvListBloc, MainTvArgs>, TvListBloc, MainTvArgs>
      createState() {
    return _MainTvPageState();
  }
}

class _MainTvPageState
    extends BaseViewState<_MainTvPage, TvListBloc, MainTvArgs> {
  @override
  void didChangeDependenciesApp(
    BuildContext context,
  ) {
    Future<void>.microtask(() {
      getBloc().fetchOnTheAirTvs().whenComplete(
            () => getBloc().fetchTvImages(
              getBloc().onTheAirTvs[0].id,
            ),
          );
      getBloc().fetchPopularTvs();
      getBloc().fetchTopRatedTvs();
    });
  }

  @override
  void didposeBag() {}

  @override
  Widget buildUI(MainTvArgs? args, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTheAirTvsWidget(),
            SubHeading(
              text: 'Popular',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                PopularTvsPage.routeName,
              ),
            ),
            _buildPopularTvsWidget(),
            SubHeading(
              text: 'Top Rated',
              onSeeMoreTapped: () => Navigator.pushNamed(
                context,
                TopRatedTvsPage.routeName,
              ),
            ),
            _buildTopRatedTvsWidget(),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTheAirTvsWidget() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc().onTheAirTvsStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snap1,
      ) {
        if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Tv>>(
            stream: getBloc().onTheAirTvsStream,
            builder: (__, AsyncSnapshot<List<Tv>> snap2) {
              if (!snap2.hasData) {
                return const ShimmerPlayingTvLoadingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 575.0,
                    viewportFraction: 1.0,
                    onPageChanged: (int index, _) {
                      getBloc().fetchTvImages(
                        getBloc().onTheAirTvs[index].id,
                      );
                    },
                  ),
                  items: snap2.data!.map(
                    (Tv item) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return MinimalDetail(
                                tv: item,
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            ShaderMask(
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
                                  stops: <double>[0, 0.3, 0.5, 1],
                                ).createShader(
                                  Rect.fromLTRB(
                                    0,
                                    0,
                                    rect.width,
                                    rect.height,
                                  ),
                                );
                              },
                              blendMode: BlendMode.dstIn,
                              child: CachedNetworkImage(
                                height: 560.0,
                                imageUrl: Urls.imageUrl(item.backdropPath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.redAccent,
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'On The Air'.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: RequiredStreamBuilder<RequestState>(
                                      stream: getBloc().tvImagesStateStream,
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot<RequestState> imageSnap1,
                                      ) {
                                        if (imageSnap1.data ==
                                            RequestState.loaded) {
                                          return RequiredStreamBuilder<
                                              MediaImage?>(
                                            stream: getBloc().tvImagesStream,
                                            builder: (
                                              __,
                                              AsyncSnapshot<MediaImage?>
                                                  imageSnap2,
                                            ) {
                                              if (imageSnap2.data == null) {
                                                return const SizedBox();
                                              }
                                              if (imageSnap2.data!.logoPaths
                                                      ?.isEmpty ==
                                                  true) {
                                                return Text(
                                                  item.name!,
                                                );
                                              }
                                              return CachedNetworkImage(
                                                width: 200.0,
                                                imageUrl: Urls.imageUrl(
                                                  imageSnap2.data!.logoPaths![0]
                                                          .filePath ??
                                                      '',
                                                ),
                                              );
                                            },
                                          );
                                        } else if (imageSnap1.data ==
                                            RequestState.error) {
                                          return const Center(
                                            child: Text(
                                              'Load data failed',
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          );
        } else if (snap1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerPlayingTvLoadingWidget();
        }
      },
    );
  }

  Widget _buildPopularTvsWidget() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc().popularTvsStateStream,
      builder: (
        _,
        AsyncSnapshot<RequestState> data,
      ) {
        if (data.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Tv>>(
            stream: getBloc().popularTvsStream,
            builder: (
              __,
              AsyncSnapshot<List<Tv>> snap2,
            ) {
              if (!snap2.hasData) {
                return const ShimmerLoadingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: HorizontalItemList(
                  tvs: snap2.data!,
                ),
              );
            },
          );
        } else if (data.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopRatedTvsWidget() {
    return RequiredStreamBuilder<RequestState>(
      stream: getBloc().topRatedTvsStateStream,
      builder: (BuildContext context, AsyncSnapshot<RequestState> snap1) {
        if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Tv>>(
            stream: getBloc().topRatedTvsStream,
            builder: (_, AsyncSnapshot<List<Tv>> snap2) {
              if (!snap2.hasData) {
                return const ShimmerLoadingWidget();
              }
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: HorizontalItemList(
                  tvs: snap2.data!,
                ),
              );
            },
          );
        } else if (snap1.data == RequestState.error) {
          return const Center(child: Text('Load data failed'));
        } else {
          return const ShimmerLoadingWidget();
        }
      },
    );
  }
}

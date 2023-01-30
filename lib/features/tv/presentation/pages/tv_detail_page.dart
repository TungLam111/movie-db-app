import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/genre.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv_detail.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv_season_episode.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/widgets/minimal_detail.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'package:mock_bloc_stream/utils/urls.dart';
import 'package:shimmer/shimmer.dart';

class TvDetailPage extends StatefulWidget {
  const TvDetailPage({Key? key, required this.id}) : super(key: key);
  static const String routeName = '/tv-detail';

  final int id;

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  late TvDetailBloc _tvDetailBloc;
  late TvSeasonEpisodesBloc _tvSeasonEpisodesBloc;
  late StreamSubscription<String> messageListener;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _tvDetailBloc = BlocProvider.of<TvDetailBloc>(context);
    _tvSeasonEpisodesBloc = BlocProvider.of<TvSeasonEpisodesBloc>(context);
    Future<void>.microtask(() {
      _tvDetailBloc.fetchTvDetail(widget.id);
      _tvDetailBloc.loadWatchlistStatus(widget.id);
      _tvSeasonEpisodesBloc.fetchTvSeasonEpisodes(widget.id, 1);
    });

    messageListener = _tvDetailBloc.messageStream.listen((String event) {
      if (event.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(event)));
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tvDetailBloc.dispose();
    _tvSeasonEpisodesBloc.dispose();
    messageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequiredStreamBuilder<RequestState>(
        stream: _tvDetailBloc.tvStateStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<RequestState> snap1,
        ) {
          if (!snap1.hasData) {
            return const SizedBox();
          }

          if (snap1.data == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap1.data == RequestState.loaded) {
            return RequiredStreamBuilder<TvDetail?>(
              stream: _tvDetailBloc.tv,
              builder: (__, AsyncSnapshot<TvDetail?> snap2) {
                final TvDetail? tv = snap2.data;
                if (tv == null) return const SizedBox();
                return TvDetailContent(
                  tv: tv,
                  seasonNumber: tv.numberOfSeasons,
                  isAddedToWatchlist: _tvDetailBloc.isAddedToWatchlist,
                );
              },
            );
          }

          return const Text('Cannot get TV detail');
        },
      ),
    );
  }
}

class TvDetailContent extends StatefulWidget {
  const TvDetailContent({
    Key? key,
    required this.tv,
    required this.seasonNumber,
    required this.isAddedToWatchlist,
  }) : super(key: key);
  final TvDetail tv;
  final int seasonNumber;
  final bool isAddedToWatchlist;

  @override
  State<TvDetailContent> createState() => _TvDetailContentState();
}

class _TvDetailContentState extends State<TvDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final List<int> _seasons = <int>[];
  int _currentSeason = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    for (int i = 1; i <= widget.seasonNumber; i++) {
      _seasons.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const Key('tvDetailScrollView'),
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeIn(
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
                  imageUrl: Urls.imageUrl(widget.tv.backdropPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInUp(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.tv.name,
                    style: StylesConstant.kHeading5.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.kGrey800,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          widget.tv.firstAirDate.split('-')[0],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            (widget.tv.voteAverage / 2).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '(${widget.tv.voteAverage})',
                            style: const TextStyle(
                              fontSize: 1.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        '${widget.tv.numberOfSeasons} Seasons',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        widget.tv.episodeRunTime.isNotEmpty
                            ? _showEpisodeDuration(widget.tv.episodeRunTime[0])
                            : '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    key: const Key('tvToWatchlist'),
                    onPressed: () async {
                      if (!widget.isAddedToWatchlist) {
                        await BlocProvider.of<TvDetailBloc>(
                          context,
                        ).addToWatchlist(widget.tv);
                      } else {
                        await BlocProvider.of<TvDetailBloc>(
                          context,
                        ).removeFromWatchlist(widget.tv);
                      }
                      if (!mounted) {
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isAddedToWatchlist
                          ? ColorConstant.kGrey850
                          : Colors.white,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        42.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        widget.isAddedToWatchlist
                            ? const Icon(Icons.check, color: Colors.white)
                            : const Icon(Icons.add, color: Colors.black),
                        const SizedBox(width: 16.0),
                        Text(
                          widget.isAddedToWatchlist
                              ? 'Added to watchlist'
                              : 'Add to watchlist',
                          style: TextStyle(
                            color: widget.isAddedToWatchlist
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.tv.overview,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Genres: ${_showGenres(widget.tv.genres)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 16.0),
          sliver: SliverToBoxAdapter(
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.redAccent,
                      style: BorderStyle.solid,
                      width: 4.0,
                    ),
                  ),
                ),
                tabs: <Widget>[
                  Tab(text: 'Episodes'.toUpperCase()),
                  Tab(text: 'More like this'.toUpperCase()),
                ],
              ),
            ),
          ),
        ),
        Builder(
          builder: (BuildContext context) {
            _tabController.addListener(() {
              if (!_tabController.indexIsChanging) {
                setState(() {
                  _selectedIndex = _tabController.index;
                });
              }
            });

            return _selectedIndex == 0
                ? SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    sliver: SliverToBoxAdapter(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.kGrey850,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<int>(
                                onChanged: (int? value) {
                                  setState(() {
                                    _currentSeason = value!;
                                  });

                                  BlocProvider.of<TvSeasonEpisodesBloc>(
                                    context,
                                  ).fetchTvSeasonEpisodes(
                                    widget.tv.id,
                                    _currentSeason,
                                  );
                                },
                                items: _seasons
                                    .map(
                                      (int item) => DropdownMenuItem<int>(
                                        value: item,
                                        child: Text(
                                          'Season $item',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: _currentSeason,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SliverToBoxAdapter();
          },
        ),
        _selectedIndex == 0
            ? SliverPadding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                sliver: _showSeasonEpisodes(),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                sliver: _showRecommendations(),
              )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (Genre genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showEpisodeDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _showRecommendations() {
    return RequiredStreamBuilder<RequestState>(
      stream: BlocProvider.of<TvDetailBloc>(context).recommendationsStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<RequestState> snapshot,
      ) {
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<Tv>>(
            stream:
                BlocProvider.of<TvDetailBloc>(context).recommendationsStream,
            builder: (
              __,
              AsyncSnapshot<List<Tv>> snapshot2,
            ) {
              if (!snapshot2.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot2.data?.isNotEmpty == true) {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Tv recommendation = snapshot2.data![index];
                      return FadeInUp(
                        from: 20,
                        duration: const Duration(milliseconds: 500),
                        child: GestureDetector(
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
                                  tv: recommendation,
                                );
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            child: CachedNetworkImage(
                              imageUrl:
                                  Urls.imageUrl(recommendation.posterPath!),
                              placeholder: (BuildContext context, String url) =>
                                  Shimmer.fromColors(
                                baseColor: ColorConstant.kGrey850,
                                highlightColor: ColorConstant.kGrey800,
                                child: Container(
                                  height: 170.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (
                                BuildContext context,
                                String url,
                                dynamic error,
                              ) =>
                                  const Icon(Icons.error),
                              height: 180.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot2.data!.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                    crossAxisCount: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? 3
                        : 4,
                  ),
                );
              }

              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }

        if (snapshot.data == RequestState.error) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Cannot get recommendation',
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _showSeasonEpisodes() {
    return RequiredStreamBuilder<RequestState>(
      stream: BlocProvider.of<TvSeasonEpisodesBloc>(context)
          .seasonEpisodesStateStream,
      builder: (BuildContext context, AsyncSnapshot<RequestState> snap1) {
        if (!snap1.hasData) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<TvSeasonEpisode>>(
            stream:
                BlocProvider.of<TvSeasonEpisodesBloc>(context).seasonEpisodes,
            builder: (__, AsyncSnapshot<List<TvSeasonEpisode>> snap2) {
              if (!snap2.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snap2.data?.isNotEmpty == true) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final TvSeasonEpisode seasonEpisode = snap2.data![index];
                      return FadeInUp(
                        from: 20,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: Urls.imageUrl(
                                          seasonEpisode.stillPath!,
                                        ),
                                        placeholder: (
                                          BuildContext context,
                                          String url,
                                        ) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (
                                          BuildContext context,
                                          String url,
                                          dynamic error,
                                        ) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 200.0,
                                          child: Text(
                                            '''${seasonEpisode.episodeNumber}. ${seasonEpisode.name}''',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(
                                              seasonEpisode.airDate,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12.0,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  seasonEpisode.overview,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.0,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: snap2.data!.length,
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Comming Soon!',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              }
            },
          );
        }
        if (snap1.data == RequestState.error) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Cannot get season episodes',
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

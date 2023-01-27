import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/about/about_page.dart';
import 'package:mock_bloc_stream/bloc_provider.dart';
import 'package:mock_bloc_stream/core/app_bloc.dart';
import 'package:mock_bloc_stream/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/pages/main_movie_page.dart';
import 'package:mock_bloc_stream/search/presentation/pages/movie_search_page.dart';
import 'package:mock_bloc_stream/search/presentation/pages/tv_search_page.dart';
import 'package:mock_bloc_stream/tv/presentation/pages/main_tv_page.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:mock_bloc_stream/utils/styles.dart';
import 'watchlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _drawerAnimationController;
  late Animation<dynamic> _drawerTween;

  late AnimationController _colorAnimationController;
  late Animation<dynamic> _colorTween;

  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _drawerTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _drawerAnimationController,
        curve: Curves.easeInOutCirc,
      ),
    );

    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    _colorTween = ColorTween(
      begin: Colors.transparent,
      end: Colors.black.withOpacity(0.7),
    ).animate(_colorAnimationController);
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    _colorAnimationController.dispose();
    disposeStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.didChangeDependencies();
  }

  void disposeStream() {
    BlocProvider.of<AppBloc>(context).dispose();
    _homeBloc.dispose();
  }

  void toggle() => _drawerAnimationController.isDismissed
      ? _drawerAnimationController.forward()
      : _drawerAnimationController.reverse();

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstant.kSpaceGrey,
      child: AnimatedBuilder(
        animation: _drawerTween,
        builder: (BuildContext context, Widget? child) {
          num drawerTweenValue = _drawerTween.value as num;
          double slide = 300.0 * drawerTweenValue;
          double scale = 1.0 - (drawerTweenValue * 0.25);
          double radius = drawerTweenValue * 30.0;
          double rotate = drawerTweenValue * -0.139626;
          double toolbarOpacity = 1.0 - drawerTweenValue;

          return Stack(
            children: <Widget>[
              SizedBox(
                width: 220.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        key: const Key('closeDrawerButton'),
                        onTap: toggle,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            color: ColorConstant.kRichBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 128.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Image(
                                image: AssetImage('assets/user.png'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Aditya',
                                  style: StylesConstant.kHeading6.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'aditya@mail.co',
                                  style: StylesConstant.kBodyText.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      RequiredStreamBuilder<GeneralContentType>(
                        stream: _homeBloc.state,
                        builder: (
                          BuildContext ctx,
                          AsyncSnapshot<GeneralContentType> snapshot,
                        ) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                key: const Key('movieListTile'),
                                onTap: () {
                                  _homeBloc.setState(GeneralContentType.movie);
                                  toggle();
                                },
                                leading: const Icon(Icons.movie),
                                title: const Text('Movies'),
                                selected:
                                    snapshot.data == GeneralContentType.movie,
                                style: ListTileStyle.drawer,
                                iconColor: Colors.white70,
                                textColor: Colors.white70,
                                selectedColor: Colors.white,
                                selectedTileColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              ListTile(
                                key: const Key('tvListTile'),
                                onTap: () {
                                  _homeBloc.setState(GeneralContentType.tv);
                                  toggle();
                                },
                                leading: const Icon(Icons.tv),
                                title: const Text('Tv Show'),
                                selected:
                                    snapshot.data == GeneralContentType.tv,
                                style: ListTileStyle.drawer,
                                iconColor: Colors.white70,
                                textColor: Colors.white70,
                                selectedColor: Colors.white,
                                selectedTileColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      ListTile(
                        key: const Key('watchlistListTile'),
                        onTap: () {
                          Navigator.pushNamed(context, WatchlistPage.routeName);
                        },
                        leading: const Icon(Icons.save_alt),
                        title: const Text('Watchlist'),
                        iconColor: Colors.white70,
                        textColor: Colors.white70,
                      ),
                      ListTile(
                        key: const Key('aboutListTile'),
                        onTap: () {
                          Navigator.pushNamed(context, AboutPage.routeName);
                        },
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About'),
                        iconColor: Colors.white70,
                        textColor: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale)
                  ..rotateZ(rotate),
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: AnimatedBuilder(
                    animation: _colorAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return Scaffold(
                        extendBodyBehindAppBar: true,
                        appBar: AppBar(
                          toolbarOpacity: toolbarOpacity,
                          leading: IconButton(
                            key: const Key('drawerButton'),
                            icon: const Icon(Icons.menu),
                            splashRadius: 20.0,
                            onPressed: toggle,
                          ),
                          title: const Text(
                            'MDB',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          actions: <Widget>[
                            RequiredStreamBuilder<GeneralContentType>(
                              stream: _homeBloc.state,
                              builder: (
                                BuildContext _,
                                AsyncSnapshot<GeneralContentType> snapshot,
                              ) {
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }
                                final GeneralContentType state = snapshot.data!;
                                return IconButton(
                                  key: const Key('searchButton'),
                                  icon: const Icon(Icons.search),
                                  splashRadius: 20.0,
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    state == GeneralContentType.movie
                                        ? MovieSearchPage.routeName
                                        : TvSearchPage.routeName,
                                  ),
                                );
                              },
                            ),
                          ],
                          backgroundColor: _colorTween.value as Color?,
                          elevation: 0.0,
                        ),
                        body: NotificationListener<ScrollNotification>(
                          onNotification: _scrollListener,
                          child: RequiredStreamBuilder<GeneralContentType>(
                            stream: _homeBloc.state,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<GeneralContentType> sns,
                            ) {
                              if (!sns.hasData) {
                                return const SizedBox();
                              }
                              final GeneralContentType state = sns.data!;
                              if (state == GeneralContentType.movie) {
                                return const MainMoviePage();
                              } else {
                                return const MainTvPage();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

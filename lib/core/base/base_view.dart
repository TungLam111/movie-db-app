import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_images/movie_images_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart';

class BaseArguments {}

// Bloc mapping
class MultiBloc {
  MultiBloc({
    required this.types,
  });

  final List<Type> types;
}

abstract class BaseViewMultiProvider<K extends BaseArguments>
    extends StatelessWidget {
  const BaseViewMultiProvider({
    super.key,
    required this.args,
  });
  final BaseArguments args;

  @mustCallSuper
  BaseView<K> setChild(BaseArguments argument);

  @mustCallSuper
  List<BlocProvider<BaseBloc>> setBlocs();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: setBlocs(),
      child: setChild(args),
    );
  }
}

abstract class BaseView<K extends BaseArguments> extends StatefulWidget {
  const BaseView({
    super.key,
    required this.args,
    required this.blocTypes,
  });

  final K args;
  final List<Type> blocTypes;

  @override
  BaseViewState<BaseView<K>, K> createState();
}

abstract class BaseViewState<T extends BaseView<K>, K extends BaseArguments>
    extends State<BaseView<K>> {
  late Map<Type, BaseBloc> _controller;

  bool isInit = false;

  K? _args;
  List<Type>? blocTypes;

  U getBloc<U extends BaseBloc>() {
    if (U == MovieListBloc) {
      return _controller[MovieListBloc] as U;
    }
    if (U == MovieImagesBloc) {
      return _controller[MovieImagesBloc] as U;
    }
    // Handle other cases or return null if needed.
    return _controller[MovieListBloc] as U;
  }

  void didChangeDependenciesApp(
    Map<Type, BaseBloc> controller,
    BuildContext context,
  );
  void didposeBag();
  Widget buildUI(Map<Type, BaseBloc> controller, K? args, BuildContext context);

  @override
  void initState() {
    super.initState();
    _args = widget.args;
    blocTypes = widget.blocTypes;
  }

  @override
  void dispose() {
    _controller.forEach(
      (_, BaseBloc value) {
        value.dispose();
      },
    );
    didposeBag();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      _controller = <Type, BaseBloc>{};
      blocTypes?.forEach(
        (Type e) {
          if (e == MovieListBloc) {
            _controller[e] = BlocProvider.of<MovieListBloc>(context);
          } else if (e == MovieImagesBloc) {
            _controller[e] = BlocProvider.of<MovieImagesBloc>(context);
          }
        },
      );
      didChangeDependenciesApp(_controller, context);
    }
  }

  // void addErrorMessage(DataError? error) {
  //   _controller.errorMessageShow.value = error;
  // }

  void handleNavigation(Function(BuildContext) p0) {
    if (context.mounted) {
      p0.call(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildUI(_controller, _args, context),
    );
  }
}

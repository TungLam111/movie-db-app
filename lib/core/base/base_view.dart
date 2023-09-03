import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';

class BaseArguments {}

abstract class BaseViewProvider<T extends BaseBloc, K extends BaseArguments>
    extends StatelessWidget {
  const BaseViewProvider({
    super.key,
    required this.args,
  });
  final K args;

  @mustCallSuper
  BaseView<T, K> setChild(BaseArguments argument);

  @mustCallSuper
  T setBlocs();


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<BaseBloc>>[
        BlocProvider<T>(
          bloc: setBlocs(),
        )
      ],
      child: setChild(args),
    );
  }
}

abstract class BaseView<T extends BaseBloc, K extends BaseArguments>
    extends StatefulWidget {
  const BaseView({
    super.key,
    required this.args,
    required this.blocTypes,
  });

  final K args;
  final List<Type> blocTypes;

  @override
  BaseViewState<BaseView<T, K>, T, K> createState();
}

abstract class BaseViewState<BV extends BaseView<T, K>, T extends BaseBloc,
    K extends BaseArguments> extends State<BaseView<T, K>> {
  late T _controller;

  bool isInit = false;

  K? _args;

  T getBloc() {
    return _controller;
  }

  void didChangeDependenciesApp(
    BuildContext context,
  );
  void didposeBag();
  Widget buildUI(K? args, BuildContext context);

  @override
  void initState() {
    super.initState();
    _args = widget.args;
  }

  @override
  void dispose() {
    _controller.dispose();
    didposeBag.call();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      _controller = BlocProvider.of<T>(context);
      didChangeDependenciesApp(context);
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
      body: buildUI(_args, context),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';

// Use for local state management.
// 0
class _BlocProvider<T> extends InheritedWidget {
  const _BlocProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);
  final _BlocProviderState<T> data;

  @override
  bool updateShouldNotify(_BlocProvider<T> old) {
    return true;
  }
}

// 1
class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  const BlocProvider({
    Key? key,
    required this.bloc,
    this.child,
  }) : super(key: key);
  final Widget? child;
  final T bloc;

  // 2
  static T of<T extends BaseBloc>(BuildContext context) {
    final _BlocProvider<T>? provider =
        context.dependOnInheritedWidgetOfExactType<_BlocProvider<T>>();
    return provider!.data.bloc;
  }

  BlocProvider<T> cloneWithChild(Widget baby) {
    return BlocProvider<T>(bloc: bloc, child: baby);
  }

  @override
  State<BlocProvider<BaseBloc>> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  // 3
  T get bloc => widget.bloc as T;

  // 4
  @override
  Widget build(BuildContext context) {
    return _BlocProvider<T>(
      data: this,
      child: widget.child ?? const SizedBox(),
    );
  }

  // 5
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class MultiBlocProvider extends StatelessWidget {
  const MultiBlocProvider({
    Key? key,
    required this.providers,
    this.child,
    this.builder,
  }) : super(key: key);

  final Widget? child;
  final List<BlocProvider<BaseBloc>> providers;
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    Widget tree = builder != null
        ? Builder(
            builder: (BuildContext context) => builder!.call(context, child),
          )
        : child!;

    for (final BlocProvider<BaseBloc> widget in providers.reversed) {
      tree = widget.cloneWithChild(tree);
    }
    return tree;
  }
}

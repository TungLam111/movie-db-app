import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';

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
class BlocProviderLamcute<T extends BaseBloc> extends StatefulWidget {
  const BlocProviderLamcute({Key? key, required this.bloc, required this.child})
      : super(key: key);
  final Widget child;
  final T bloc;

  // 2
  static T of<T extends BaseBloc>(BuildContext context) {
    final _BlocProvider<T>? provider =
        context.dependOnInheritedWidgetOfExactType<_BlocProvider<T>>();
    return provider!.data.bloc;
  }

  @override
  State<BlocProviderLamcute<BaseBloc>> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T> extends State<BlocProviderLamcute<BaseBloc>> {
  // 3
  T get bloc => widget.bloc as T;

  // 4
  @override
  Widget build(BuildContext context) {
    return _BlocProvider<T>(data: this, child: widget.child);
  }

  // 5
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

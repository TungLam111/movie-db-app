import 'package:animate_do/animate_do.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => <Object>[message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

class ServerException implements Exception {}

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
}

final RouteObserver<ModalRoute<dynamic>> routeObserver =
    RouteObserver<ModalRoute<dynamic>>();

EventTransformer<E> debounce<E>(Duration duration) {
  return (Stream<E> events, Stream<E> Function(E) mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}

class RequiredStreamBuilder<T> extends StreamBuilder<T> {
  const RequiredStreamBuilder({
    Key? key,
    required super.stream,
    required super.builder,
  }) : super(key: key);
}

class CustomizedStreamBuilder<T> extends StatelessWidget {
  const CustomizedStreamBuilder({
    Key? key,
    required this.streamLoadState, // request state
    required this.streamLoadData, // data
    required this.itemBuilder,
    required this.loadingWidget,
    required this.otherWidget,
  }) : super(key: key);
  final Stream<RequestState> streamLoadState;
  final Stream<List<T>> streamLoadData;
  final Widget loadingWidget;
  final CustomItemBuilder<T> itemBuilder;
  final Widget otherWidget;

  @override
  Widget build(BuildContext context) {
    return RequiredStreamBuilder<RequestState>(
      stream: streamLoadState,
      builder: (_, AsyncSnapshot<RequestState> snap1) {
        if (snap1.data == RequestState.loading) {
          return loadingWidget;
        } else if (snap1.data == RequestState.loaded) {
          return RequiredStreamBuilder<List<T>>(
            stream: streamLoadData,
            builder: (__, AsyncSnapshot<List<T>> snap2) {
              if (!snap2.hasData) return loadingWidget;
              return FadeInUp(
                from: 20,
                duration: const Duration(milliseconds: 500),
                child: ListView.builder(
                  itemCount: snap2.data!.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return itemBuilder(ctx, snap2.data![index], index);
                  },
                ),
              );
            },
          );
        }
        return otherWidget;
      },
    );
  }
}

typedef CustomItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

import 'package:dartz/dartz.dart';

extension StringNullExtension on String? {
  bool isEmptyOrNull() {
    if (this == null) return true;
    return this!.isEmpty;
  }
}

typedef TupleEx2<T1, T2> = Tuple2<T1, T2>;
typedef TupleEx3<T1, T2, T3> = Tuple3<T1, T2, T3>;
typedef FunctionEx0<T> = Function0<T>;
typedef FunctionEx1<T1, T2> = Function1<T1, T2>;

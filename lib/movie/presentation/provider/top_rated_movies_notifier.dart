import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_top_rated_movies_usecase.dart';

class TopRatedMoviesNotifier extends ChangeNotifier {
  TopRatedMoviesNotifier({required this.getTopRatedMovies});
  final GetTopRatedMoviesUsecase getTopRatedMovies;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Movie> _movies = <Movie>[];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedMovies() async {
    _state = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Movie>> result =
        await getTopRatedMovies.execute();

    result.fold(
      (Failure failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (List<Movie> moviesData) {
        _movies = moviesData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}

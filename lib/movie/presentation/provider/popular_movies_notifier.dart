import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';

class PopularMoviesNotifier extends ChangeNotifier {
  PopularMoviesNotifier(this.getPopularMovies);
  final GetPopularMoviesUsecase getPopularMovies;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Movie> _movies = <Movie>[];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularMovies() async {
    _state = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Movie>> result =
        await getPopularMovies.execute();

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

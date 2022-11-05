// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:mock_bloc_stream/utils/common_util.dart';
// import 'package:mock_bloc_stream/utils/enum.dart';

// import '../../domain/entities/movie.dart';
// import '../../domain/usecases/get_now_playing_movies_usecase.dart';
// import '../../domain/usecases/get_popular_movies_usecase.dart';
// import '../../domain/usecases/get_top_rated_movies_usecase.dart';

// class MovieListNotifier extends ChangeNotifier {
//   MovieListNotifier({
//     required this.getNowPlayingMovies,
//     required this.getPopularMovies,
//     required this.getTopRatedMovies,
//   });
//   List<Movie> _nowPlayingMovies = <Movie>[];
//   List<Movie> get nowPlayingMovies => _nowPlayingMovies;

//   RequestState _nowPlayingState = RequestState.empty;
//   RequestState get nowPlayingState => _nowPlayingState;

//   List<Movie> _popularMovies = <Movie>[];
//   List<Movie> get popularMovies => _popularMovies;

//   RequestState _popularMoviesState = RequestState.empty;
//   RequestState get popularMoviesState => _popularMoviesState;

//   List<Movie> _topRatedMovies = <Movie>[];
//   List<Movie> get topRatedMovies => _topRatedMovies;

//   RequestState _topRatedMoviesState = RequestState.empty;
//   RequestState get topRatedMoviesState => _topRatedMoviesState;

//   String _message = '';
//   String get message => _message;

//   final GetNowPlayingMoviesUsecase getNowPlayingMovies;
//   final GetPopularMoviesUsecase getPopularMovies;
//   final GetTopRatedMoviesUsecase getTopRatedMovies;

//   Future<void> fetchNowPlayingMovies() async {
//     _nowPlayingState = RequestState.loading;
//     notifyListeners();

//     final Either<Failure, List<Movie>> result =
//         await getNowPlayingMovies.execute();
//     result.fold(
//       (Failure failure) {
//         _nowPlayingState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (List<Movie> moviesData) {
//         _nowPlayingState = RequestState.loaded;
//         _nowPlayingMovies = moviesData;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> fetchPopularMovies() async {
//     _popularMoviesState = RequestState.loading;
//     notifyListeners();

//     final Either<Failure, List<Movie>> result =
//         await getPopularMovies.execute();
//     result.fold(
//       (Failure failure) {
//         _popularMoviesState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (List<Movie> moviesData) {
//         _popularMoviesState = RequestState.loaded;
//         _popularMovies = moviesData;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> fetchTopRatedMovies() async {
//     _topRatedMoviesState = RequestState.loading;
//     notifyListeners();

//     final Either<Failure, List<Movie>> result =
//         await getTopRatedMovies.execute();
//     result.fold(
//       (Failure failure) {
//         _topRatedMoviesState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (List<Movie> moviesData) {
//         _topRatedMoviesState = RequestState.loaded;
//         _topRatedMovies = moviesData;
//         notifyListeners();
//       },
//     );
//   }
// }

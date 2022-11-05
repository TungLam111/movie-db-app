// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:mock_bloc_stream/utils/common_util.dart';
// import 'package:mock_bloc_stream/utils/enum.dart';

// import '../../domain/entities/movie.dart';
// import '../../domain/usecases/get_watchlist_movies_usecase.dart';

// class WatchlistMovieNotifier extends ChangeNotifier {
//   WatchlistMovieNotifier({required this.getWatchlistMovies});
//   List<Movie> _watchlistMovies = <Movie>[];
//   List<Movie> get watchlistMovies => _watchlistMovies;

//   RequestState _watchlistState = RequestState.empty;
//   RequestState get watchlistState => _watchlistState;

//   String _message = '';
//   String get message => _message;

//   final GetWatchlistMoviesUsecase getWatchlistMovies;

//   Future<void> fetchWatchlistMovies() async {
//     _watchlistState = RequestState.loading;
//     notifyListeners();

//     final Either<Failure, List<Movie>> result =
//         await getWatchlistMovies.execute();
//     result.fold(
//       (Failure failure) {
//         _watchlistState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (List<Movie> moviesData) {
//         _watchlistState = RequestState.loaded;
//         _watchlistMovies = moviesData;
//         notifyListeners();
//       },
//     );
//   }
// }

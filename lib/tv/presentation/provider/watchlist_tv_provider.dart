// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:mock_bloc_stream/utils/common_util.dart';
// import 'package:mock_bloc_stream/utils/enum.dart';

// import '../../domain/entities/tv.dart';
// import '../../domain/usecases/get_watchlist_tvs_usecase.dart';

// class WatchlistTvNotifier extends ChangeNotifier {
//   WatchlistTvNotifier({required this.getWatchlistTvs});
//   final GetWatchlistTvsUsecase getWatchlistTvs;

//   List<Tv> _watchlistTvs = <Tv>[];
//   List<Tv> get watchlistTvs => _watchlistTvs;

//   RequestState _watchlistState = RequestState.empty;
//   RequestState get watchlistState => _watchlistState;

//   String _message = '';
//   String get message => _message;

//   Future<void> fetchWatchlistTvs() async {
//     _watchlistState = RequestState.loading;
//     notifyListeners();

//     final Either<Failure, List<Tv>> result = await getWatchlistTvs.execute();
//     result.fold(
//       (Failure failure) {
//         _watchlistState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (List<Tv> watchlistTvs) {
//         _watchlistState = RequestState.loaded;
//         _watchlistTvs = watchlistTvs;
//         notifyListeners();
//       },
//     );
//   }
// }

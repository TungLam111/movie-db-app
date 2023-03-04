import 'package:mock_bloc_stream/utils/common_util.dart';

import '../models/tv_table.dart';
import 'db/tv_database_helper.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable tv);
  Future<String> removeWatchlist(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  TvLocalDataSourceImpl({required this.databaseHelper});
  final TvDatabaseHelper databaseHelper;

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvWatchlist(tv);
      return 'Added to watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvWatchlist(tv);
      return 'Removed from watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final Map<String, dynamic>? result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final List<Map<String, dynamic>> result =
        await databaseHelper.getWatchlistTvs();
    return result
        .map((Map<String, dynamic> data) => TvTable.fromMap(data))
        .toList();
  }
}

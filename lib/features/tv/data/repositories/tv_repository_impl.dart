part of '../../domain/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  @override
  Future<DataState<List<Tv>>> getOnTheAirTvs() async {
    try {
      final List<TvModel> result = await remoteDataSource.getOnTheAirTvs();
      return DataSuccess<List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<Tv>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Tv>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Tv>>> getPopularTvs(int? page) async {
    try {
      final List<TvModel> result = await remoteDataSource.getPopularTvs(page);
      return DataSuccess<List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<Tv>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Tv>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Tv>>> getTopRatedTvs(int? page) async {
    try {
      final List<TvModel> result = await remoteDataSource.getTopRatedTvs(page);
      return DataSuccess<List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<Tv>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Tv>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<TvDetail>> getTvDetail(int id) async {
    try {
      final TvDetailResponse result = await remoteDataSource.getTvDetail(id);
      return DataSuccess<TvDetail>(result.toEntity());
    } on ServerException {
      return DataFailed<TvDetail>(ServerException());
    } on SocketException {
      return const DataFailed<TvDetail>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<TvSeasonEpisode>>> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  ) async {
    try {
      final List<TvSeasonEpisodeModel> result =
          await remoteDataSource.getTvSeasonEpisodes(id, seasonNumber);
      return DataSuccess<List<TvSeasonEpisode>>(
        result.map((TvSeasonEpisodeModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<TvSeasonEpisode>>(ServerException());
    } on SocketException {
      return const DataFailed<List<TvSeasonEpisode>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Tv>>> getTvRecommendations(int id) async {
    try {
      final List<TvModel> result =
          await remoteDataSource.getTvRecommendations(id);
      return DataSuccess<List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<Tv>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Tv>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Tv>>> searchTvs(String query) async {
    try {
      final List<TvModel> result = await remoteDataSource.searchTvs(query);
      return DataSuccess<List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return DataFailed<List<Tv>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Tv>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<MediaImage>> getTvImages(int id) async {
    try {
      final MediaTvImageModel result = await remoteDataSource.getTvImages(id);
      return DataSuccess<MediaImage>(result.toEntity());
    } on ServerException {
      return DataFailed<MediaImage>(ServerException());
    } on SocketException {
      return const DataFailed<MediaImage>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<String>> saveWatchlist(TvDetail tv) async {
    try {
      final String result =
          await localDataSource.insertWatchlist(TvTable.fromEntity(tv));
      return DataSuccess<String>(result);
    } on DatabaseException catch (e) {
      return DataFailed<String>(DatabaseException(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataState<String>> removeWatchlist(TvDetail tv) async {
    try {
      final String result =
          await localDataSource.removeWatchlist(TvTable.fromEntity(tv));
      return DataSuccess<String>(result);
    } on DatabaseException catch (e) {
      return DataFailed<String>(DatabaseException(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final TvTable? result = await localDataSource.getTvById(id);
    return result != null;
  }

  @override
  Future<DataState<List<Tv>>> getWatchlistTvs() async {
    final List<TvTable> result = await localDataSource.getWatchlistTvs();
    return DataSuccess<List<Tv>>(
      result.map((TvTable data) => data.toEntity()).toList(),
    );
  }
}

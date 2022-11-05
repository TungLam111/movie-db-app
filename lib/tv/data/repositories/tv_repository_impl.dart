part of '../../domain/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTvs() async {
    try {
      final List<TvModel> result = await remoteDataSource.getOnTheAirTvs();
      return Right<Failure, List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Tv>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Tv>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvs() async {
    try {
      final List<TvModel> result = await remoteDataSource.getPopularTvs();
      return Right<Failure, List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Tv>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Tv>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvs() async {
    try {
      final List<TvModel> result = await remoteDataSource.getTopRatedTvs();
      return Right<Failure, List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Tv>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Tv>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final TvDetailResponse result = await remoteDataSource.getTvDetail(id);
      return Right<Failure, TvDetail>(result.toEntity());
    } on ServerException {
      return const Left<Failure, TvDetail>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, TvDetail>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TvSeasonEpisode>>> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  ) async {
    try {
      final List<TvSeasonEpisodeModel> result =
          await remoteDataSource.getTvSeasonEpisodes(id, seasonNumber);
      return Right<Failure, List<TvSeasonEpisode>>(
        result.map((TvSeasonEpisodeModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<TvSeasonEpisode>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<TvSeasonEpisode>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final List<TvModel> result =
          await remoteDataSource.getTvRecommendations(id);
      return Right<Failure, List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Tv>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Tv>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvs(String query) async {
    try {
      final List<TvModel> result = await remoteDataSource.searchTvs(query);
      return Right<Failure, List<Tv>>(
        result.map((TvModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Tv>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Tv>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, MediaImage>> getTvImages(int id) async {
    try {
      final MediaTvImageModel result = await remoteDataSource.getTvImages(id);
      return Right<Failure, MediaImage>(result.toEntity());
    } on ServerException {
      return const Left<Failure, MediaImage>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, MediaImage>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final String result =
          await localDataSource.insertWatchlist(TvTable.fromEntity(tv));
      return Right<Failure, String>(result);
    } on DatabaseException catch (e) {
      return Left<Failure, String>(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final String result =
          await localDataSource.removeWatchlist(TvTable.fromEntity(tv));
      return Right<Failure, String>(result);
    } on DatabaseException catch (e) {
      return Left<Failure, String>(DatabaseFailure(e.message));
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
  Future<Either<Failure, List<Tv>>> getWatchlistTvs() async {
    final List<TvTable> result = await localDataSource.getWatchlistTvs();
    return Right<Failure, List<Tv>>(
      result.map((TvTable data) => data.toEntity()).toList(),
    );
  }
}

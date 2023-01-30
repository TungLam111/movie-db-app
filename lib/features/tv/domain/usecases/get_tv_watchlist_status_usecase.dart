import '../repositories/tv_repository.dart';

class GetTvWatchlistStatusUsecase {
  GetTvWatchlistStatusUsecase({
    required this.tvRepository,
  });
  final TvRepository tvRepository;

  Future<bool> execute(int id) async {
    return tvRepository.isAddedToWatchlist(id);
  }
}

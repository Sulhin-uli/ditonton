import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatusTv {
  final TVRepository repository;

  GetWatchListStatusTv(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlisttv(id);
  }
}

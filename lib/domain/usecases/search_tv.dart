import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/entities/tv.dart';

class SearchTv {
  final TVRepository repository;

  SearchTv(this.repository);

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTv(query);
  }
}

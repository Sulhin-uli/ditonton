import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.posterPath,
    required this.id,
    required this.originalName,
    required this.voteAverage,
    required this.overview,
  });

  String originalName;
  int id;
  String posterPath;
  double voteAverage;
  String overview;

  @override
  List<Object?> get props => [
        originalName,
        id,
        posterPath,
        voteAverage,
        overview,
      ];
}

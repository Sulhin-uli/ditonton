import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  final String originalName;
  final int id;
  final String posterPath;
  final double voteAverage;
  final String overview;

  TvDetailResponse({
    required this.posterPath,
    required this.id,
    required this.originalName,
    required this.voteAverage,
    required this.overview,
  });

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        posterPath: json["poster_path"],
        id: json["id"],
        originalName: json["original_name"],
        voteAverage: json["vote_average"]?.toDouble(),
        overview: json["overview"],
      );

  TvDetail toEntity() {
    return TvDetail(
      posterPath: this.posterPath,
      id: this.id,
      originalName: this.originalName,
      voteAverage: this.voteAverage,
      overview: this.overview,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        posterPath,
        originalName,
        voteAverage,
        overview,
      ];
}

import 'package:equatable/equatable.dart';

class TV extends Equatable {
  TV({
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  TV.watchlist({
    required this.id,
    required this.posterPath,
    required this.originalName,
    required this.overview,
  });

  int id;
  String posterPath;
  String originalName;
  String? overview;
  String? backdropPath;
  List<int>? genreIds;
  String? name;
  List<String>? originCountry;
  String? originalLanguage;
  double? popularity;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        genreIds,
        id,
        name,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}

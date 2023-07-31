import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testTv = TV(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    name: "",
    originCountry: [],
    originalLanguage: "",
    originalName: "");

final testTvList = [testTv];

final testTvDetail = TvDetail(
  id: 1,
  originalName: "Tagesschau",
  overview:
      "German daily news program, the oldest still existing program on German television.",
  posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
  voteAverage: 48,
);

final testWatchlistTv = TV.watchlist(
  id: 1,
  originalName: "Tagesschau",
  overview:
      "German daily news program, the oldest still existing program on German television.",
  posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
);

final testTvTable = TvTable(
  id: 1,
  originalName: "Tagesschau",
  overview:
      "German daily news program, the oldest still existing program on German television.",
  posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'originalName': 'originalName',
};

final testTvTableNew = TvTable(
  id: 1,
  originalName: "originalName",
  overview: "overview",
  posterPath: "posterPath",
);

import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
    genreIds: [10763],
    id: 94722,
    overview:
        "German daily news program, the oldest still existing program on German television.",
    popularity: 4292.12,
    posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
    voteAverage: 7.6,
    voteCount: 48,
    name: "Tagesschau",
    originCountry: ["DE"],
    originalLanguage: "de",
    originalName: "Tagesschau",
  );
  final tTvResponseModel = TVResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air.json'));
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
            "genre_ids": [10763],
            "id": 94722,
            "overview":
                "German daily news program, the oldest still existing program on German television.",
            "popularity": 4292.12,
            "poster_path": "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
            "vote_average": 7.6,
            "vote_count": 48,
            "name": "Tagesschau",
            "origin_country": ["DE"],
            "original_language": "de",
            "original_name": "Tagesschau",
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}

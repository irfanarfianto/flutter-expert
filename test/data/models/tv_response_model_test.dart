import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/data/models/tv_model.dart';
import 'package:submission_flutter_expert/data/models/tv_response.dart';

import '../../json_reader.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Name",
    overview: "Overview",
    posterPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    name: "Name",
    voteAverage: 1.0,
    voteCount: 1,
    popularity: 1.0,
    video: false,
    originalLanguage: "en",
    releaseDate: "2020-05-05",
    revenue: 0,
    status: 'status',
    tagline: 'tagline',
    homepage: 'homepage',
    imdbId: 'imdbId',
  );

  const tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2020-05-05",
            "name": "Name",
            "vote_average": 1.0,
            "vote_count": 1,
            "video": false,
            "original_language": "en",
            "release_date": "2020-05-05",
            "revenue": 0,
            "status": 'status',
            "tagline": 'tagline',
            "adult": false,
            "homepage": 'homepage',
            "imdb_id": 'imdbId',
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}

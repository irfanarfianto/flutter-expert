import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/data/models/season_model.dart';
import 'package:submission_flutter_expert/domain/entities/episode.dart';
import 'package:submission_flutter_expert/domain/entities/season.dart';

void main() {
  const tEpisode = Episode(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview of episode 1',
    episodeNumber: 1,
    seasonNumber: 1,
    airDate: '2021-09-01',
  );

  const tSeasonModel = SeasonModel(
    seasonNumber: 1,
    episodes: [
      tEpisode,
    ],
    name: 'Season 1',
    posterPath: '/path/to/poster.jpg',
  );

  group('SeasonModel', () {
    test('should be a subclass of Season entity', () {
      final result = tSeasonModel.toEntity();
      expect(result, isA<Season>());
    });

    test('should return a valid model from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'seasonNumber': 1,
        'name': 'Season 1',
        'episodes': [
          {
            'id': 1,
            'name': 'Episode 1',
            'overview': 'Overview of episode 1',
            'episodeNumber': 1,
            'seasonNumber': 1,
            'airDate': '2021-09-01',
          }
        ],
        'posterPath': '/path/to/poster.jpg',
      };

      // Act
      final result = SeasonModel.fromJson(jsonMap);

      // Assert
      expect(result.seasonNumber, equals(tSeasonModel.seasonNumber));
      expect(result.name, equals(tSeasonModel.name));
      expect(result.posterPath, equals(tSeasonModel.posterPath));

      // Memeriksa setiap episode secara individual
      for (int i = 0; i < result.episodes.length; i++) {
        expect(result.episodes[i].id, equals(tSeasonModel.episodes[i].id));
        expect(result.episodes[i].name, equals(tSeasonModel.episodes[i].name));
        expect(result.episodes[i].overview,
            equals(tSeasonModel.episodes[i].overview));
        expect(result.episodes[i].episodeNumber,
            equals(tSeasonModel.episodes[i].episodeNumber));
        expect(result.episodes[i].seasonNumber,
            equals(tSeasonModel.episodes[i].seasonNumber));
        expect(result.episodes[i].airDate,
            equals(tSeasonModel.episodes[i].airDate));
      }
    });

    test('should return a JSON map containing proper data', () {
      // Arrange
      final expectedJsonMap = {
        'seasonNumber': 1,
        'name': 'Season 1',
        'episodes': [
          {
            'id': 1,
            'name': 'Episode 1',
            'overview': 'Overview of episode 1',
            'episodeNumber': 1,
            'seasonNumber': 1,
            'airDate': '2021-09-01',
          }
        ],
        'posterPath': '/path/to/poster.jpg',
      };

      // Act
      final result = tSeasonModel.toJson();

      // Assert
      expect(result, expectedJsonMap);
    });
  });
}

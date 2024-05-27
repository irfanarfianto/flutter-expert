import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/data/models/season_model.dart';
import 'package:submission_flutter_expert/domain/entities/season.dart';

void main() {
  // const tEpisode = Episode(
  //   id: 1,
  //   name: 'Episode 1',
  //   overview: 'Overview of episode 1',
  //   episodeNumber: 1,
  //   seasonNumber: 1,
  //   airDate: '2021-09-01',
  // );

  const tSeasonModel = SeasonModel(
    seasonNumber: 1,
    episodes: [],
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
          // {
          //   'id': 1,
          //   'name': 'Episode 1',
          //   'overview': 'Overview of episode 1',
          //   'episodeNumber': 1,
          //   'seasonNumber': 1,
          //   'airDate': '2021-09-01',
          // }
        ],
        'posterPath': '/path/to/poster.jpg',
      };

      // Act
      final result = SeasonModel.fromJson(jsonMap);

      // Assert
      expect(result, tSeasonModel);
    });

    test('should return a JSON map containing proper data', () {
      // Arrange
      final expectedJsonMap = {
        'seasonNumber': 1,
        'name': 'Season 1',
        'episodes': [
          // {
          //   'id': 1,
          //   'name': 'Episode 1',
          //   'overview': 'Overview of episode 1',
          //   'episodeNumber': 1,
          //   'seasonNumber': 1,
          //   'airDate': '2021-09-01',
          // }
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

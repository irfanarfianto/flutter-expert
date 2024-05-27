import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/domain/entities/episode.dart';

void main() {
  group('Episode', () {
    test('should create an Episode instance', () {
      // arrange
      const episode = Episode(
        episodeNumber: 1,
        name: 'Episode 1',
        id: 123,
        overview: 'Episode overview',
        seasonNumber: 1,
        airDate: '2024-05-30',
      );

      // assert
      expect(episode, isA<Episode>());
      expect(episode.episodeNumber, 1);
      expect(episode.name, 'Episode 1');
      expect(episode.id, 123);
      expect(episode.overview, 'Episode overview');
      expect(episode.seasonNumber, 1);
      expect(episode.airDate, '2024-05-30');
    });

    test('toJson should return a valid map', () {
      // arrange
      const episode = Episode(
        episodeNumber: 1,
        name: 'Episode 1',
        id: 123,
        overview: 'Episode overview',
        seasonNumber: 1,
        airDate: '2024-05-30',
      );

      // act
      final json = episode.toJson();

      // assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['episodeNumber'], 1);
      expect(json['name'], 'Episode 1');
      expect(json['id'], 123);
      expect(json['overview'], 'Episode overview');
      expect(json['seasonNumber'], 1);
      expect(json['airDate'], '2024-05-30');
    });

    test('fromJson should return a valid Episode instance', () {
      // arrange
      final json = {
        'episodeNumber': 1,
        'name': 'Episode 1',
        'id': 123,
        'overview': 'Episode overview',
        'seasonNumber': 1,
        'airDate': '2024-05-30',
      };

      // act
      final episode = Episode.fromJson(json);

      // assert
      expect(episode, isA<Episode>());
      expect(episode.episodeNumber, 1);
      expect(episode.name, 'Episode 1');
      expect(episode.id, 123);
      expect(episode.overview, 'Episode overview');
      expect(episode.seasonNumber, 1);
      expect(episode.airDate, '2024-05-30');
    });
  });
}

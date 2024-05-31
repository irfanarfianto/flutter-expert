import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/domain/entities/episode.dart';
import 'package:submission_flutter_expert/domain/entities/season.dart';

void main() {
  const tEpisode1 = Episode(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview of episode 1',
    episodeNumber: 1,
    seasonNumber: 1,
    airDate: '2021-09-01',
  );

  const tEpisode2 = Episode(
    id: 2,
    name: 'Episode 2',
    overview: 'Overview of episode 2',
    episodeNumber: 2,
    seasonNumber: 1,
    airDate: '2021-09-08',
  );

  const tSeason = Season(
    id: 1,
    seasonNumber: 1,
    episodes: [tEpisode1, tEpisode2],
    name: 'Season 1',
    posterPath: '/path/to/poster.jpg',
  );

  group('Season', () {
    test('should be a subclass of Equatable', () {
      expect(tSeason, isA<Season>());
    });

    test('should have correct properties', () {
      expect(tSeason.id, 1);
      expect(tSeason.seasonNumber, 1);
      expect(tSeason.episodes, [tEpisode1, tEpisode2]);
      expect(tSeason.name, 'Season 1');
      expect(tSeason.posterPath, '/path/to/poster.jpg');
    });

    test('should properly implement == and hashCode', () {
      const tSeasonCopy = Season(
        id: 1,
        seasonNumber: 1,
        episodes: [tEpisode1, tEpisode2],
        name: 'Season 1',
        posterPath: '/path/to/poster.jpg',
      );

      expect(tSeason, tSeasonCopy);
      expect(tSeason.hashCode, tSeasonCopy.hashCode);
    });
  });
}

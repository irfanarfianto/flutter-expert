import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:submission_flutter_expert/data/datasources/db/database_helper.dart';
import 'package:submission_flutter_expert/data/models/movie_table.dart';
import 'package:submission_flutter_expert/data/models/tv_table.dart';

void main() {
  sqfliteFfiInit();

  group('DatabaseHelper', () {
    late DatabaseHelper databaseHelper;

    setUp(() async {
      databaseHelper = DatabaseHelper();
      await databaseHelper.database;
    });

    test('Insert and Retrieve Movie from Watchlist', () async {
      // Arrange
      const movie = MovieTable(
        id: 1,
        title: 'Movie 1',
        overview: 'Overview of Movie 1',
        posterPath: '/path/to/poster1.jpg',
      );

      // Act
      await databaseHelper.insertMovieWatchlist(movie);
      final result = await databaseHelper.getMovieById(movie.id);

      // Assert
      expect(result, {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'type': 'movie',
      });
    });

    test('Insert and Retrieve TV Series from Watchlist', () async {
      // Arrange
      const tvSeries = TvTable(
        id: 1,
        name: 'TV Series 1',
        overview: 'Overview of TV Series 1',
        posterPath: '/path/to/poster1.jpg',
      );

      // Act
      await databaseHelper.insertTvSeriesWatchlist(tvSeries);
      final result = await databaseHelper.getTvSeriesById(tvSeries.id);

      // Assert
      expect(result, {
        'id': tvSeries.id,
        'title': tvSeries.name,
        'overview': tvSeries.overview,
        'posterPath': tvSeries.posterPath,
        'type': 'tvSeries',
      });
    });
  });
}

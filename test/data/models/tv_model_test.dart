import 'package:submission_flutter_expert/data/models/tv_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    adult: false,
    firstAirDate: 'firstAirDate',
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    popularity: 1,
    video: false,
    releaseDate: 'releaseDate',
    homepage: 'homepage',
    imdbId: 'imdbId',
    originalLanguage: 'originalLanguage',
    revenue: 1,
    status: 'status',
    tagline: 'tagline',
  );

  final tTvSeries = TvSeries(
    adult: false,
    firstAirDate: 'firstAirDate',
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}

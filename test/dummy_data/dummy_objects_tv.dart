import 'package:submission_flutter_expert/data/models/tv_table.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/domain/entities/tv_detail.dart';

final testTvSeries = TvSeries(
    adult: false,
    backdropPath: null,
    genreIds: const [1, 2, 3, 4],
    id: 5258378,
    name: "S.W.A.T.",
    originalName: "S.W.A.T.",
    overview:
        "SWAT faces their deadliest adversary yet when a violent cell of extremists looks to extract vengeance by blowing up half of Los Angeles, potentially killing thousands.",
    popularity: 1069.375,
    posterPath: "/49EdiYMjYg0FzTI10zPyubxIPk7.jpg",
    firstAirDate: "2020-05-05",
    originalLanguage: "id",
    releaseDate: "2020-05-05",
    revenue: 0,
    status: "",
    tagline: "",
    voteAverage: 8.107,
    voteCount: 1316,
    video: false);

final testTvList = [testTvSeries];

const testTvDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/uCY1j1YqfDWRbbS7hJwd9szX1sJ.jpg',
  genres: [],
  id: 1,
  name: 'name',
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  runtime: 120,
  voteAverage: 1,
  voteCount: 1,
  seasons: [],
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

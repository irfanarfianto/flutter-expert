import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TvSeries extends Equatable {
  TvSeries({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.homepage,
    this.imdbId,
    this.originalLanguage,
    this.releaseDate,
    this.revenue,
    this.status,
    this.tagline,
  });

  TvSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  String? firstAirDate;
  String? name;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? homepage;
  String? imdbId;
  String? originalLanguage;

  String? releaseDate;
  int? revenue;
  String? status;
  String? tagline;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        video,
        voteAverage,
        voteCount,
        homepage,
        imdbId,
        originalLanguage,
        popularity,
        releaseDate,
        revenue,
        status,
        tagline,
        video
      ];
}

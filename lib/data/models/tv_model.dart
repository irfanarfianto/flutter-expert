import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

class TvSeriesModel extends Equatable {
  const TvSeriesModel({
    required this.adult,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    this.homepage,
    this.imdbId,
    required this.originalLanguage,
    required this.releaseDate,
    required this.revenue,
    required this.status,
    required this.tagline,
    required this.video,
  });

  final int id;
  final bool adult;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String? homepage;
  final String? imdbId;
  final String originalLanguage;
  final String releaseDate;
  final int revenue;
  final String status;
  final String tagline;
  final bool video;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        id: json["id"],
        adult: json["adult"] ?? false,
        name: json["name"] ?? "",
        originalName: json["original_name"] ?? "",
        overview: json["overview"] ?? "",
        posterPath: json["poster_path"] ?? "",
        backdropPath: json["backdrop_path"] ?? "",
        firstAirDate: json["first_air_date"] ?? "",
        genreIds: (json["genre_ids"] != null)
            ? List<int>.from(json["genre_ids"].map((x) => x))
            : [],
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        popularity: json["popularity"] ?? 0,
        homepage: json["homepage"] ?? "",
        imdbId: json["imdb_id"] ?? "",
        originalLanguage: json["original_language"] ?? "",
        releaseDate: json["release_date"] ?? "",
        revenue: json["revenue"] ?? 0,
        status: json["status"] ?? "",
        tagline: json["tagline"] ?? "",
        video: json["video"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "adult": adult,
        "original_name": originalName,
        "overview": overview,
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "popularity": popularity,
        "homepage": homepage,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "release_date": releaseDate,
        "revenue": revenue,
        "status": status,
        "tagline": tagline,
        "video": video
      };

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      adult: adult,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      voteAverage: voteAverage,
      voteCount: voteCount,
      video: video,
      popularity: popularity,
      releaseDate: releaseDate,
      homepage: homepage,
      imdbId: imdbId,
      originalLanguage: originalLanguage,
      revenue: revenue,
      status: status,
      tagline: tagline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        adult,
        originalName,
        overview,
        posterPath,
        backdropPath,
        firstAirDate,
        genreIds,
        voteAverage,
        voteCount,
        popularity,
        homepage,
        imdbId,
        originalLanguage,
        releaseDate,
        revenue,
        status,
        tagline,
        video
      ];
}

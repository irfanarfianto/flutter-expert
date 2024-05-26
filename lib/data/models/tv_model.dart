import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';

class TvSeriesModel extends Equatable {
  const TvSeriesModel({
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
  });

  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        id: json["id"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "original_name": originalName,
        "overview": overview,
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      voteAverage: voteAverage,
      voteCount: voteCount,
      video: null,
      adult: null,
      popularity: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        originalName,
        overview,
        posterPath,
        backdropPath,
        firstAirDate,
        genreIds,
        voteAverage,
        voteCount,
      ];
}

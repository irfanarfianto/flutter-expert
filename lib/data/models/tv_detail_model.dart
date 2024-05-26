import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/data/models/genre_model.dart';
import 'package:submission_flutter_expert/data/models/season_model.dart';
import 'package:submission_flutter_expert/domain/entities/tv_detail.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.adult,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.runtime,
    required this.genres,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final int runtime;
  final List<GenreModel> genres;
  final double voteAverage;
  final int voteCount;
  final List<SeasonModel> seasons;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        adult: json["adult"],
        id: json["id"],
        name: json["name"] ?? "",
        originalName: json["original_name"] ?? "",
        overview: json["overview"],
        posterPath: json["poster_path"],
        backdropPath: json["backdrop_path"],
        runtime: json['episode_run_time'] != null &&
                json['episode_run_time'].isNotEmpty
            ? (json['episode_run_time'][0] as int)
            : 0,
        genres: (json["genres"] != null)
            ? List<GenreModel>.from(
                json["genres"].map((x) => GenreModel.fromJson(x)))
            : [],
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        seasons: (json['seasons'] as List<dynamic>)
            .map((seasonJson) => SeasonModel.fromJson(seasonJson))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "id": id,
        "name": name,
        "original_name": originalName,
        "overview": overview,
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
        "runtime": runtime,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
      };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      adult: adult,
      id: id,
      name: name,
      originalName: originalName,
      overview: overview,
      runtime: runtime,
      posterPath: posterPath,
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      voteAverage: voteAverage,
      voteCount: voteCount,
      seasons: seasons.map((seasons) => seasons.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        adult,
        id,
        name,
        originalName,
        overview,
        posterPath,
        backdropPath,
        runtime,
        genres,
        voteAverage,
        voteCount,
        seasons,
      ];
}

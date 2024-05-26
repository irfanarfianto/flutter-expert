import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/genre.dart';

class Episode {
  final int episodeNumber;
  final String title;

  const Episode({
    required this.episodeNumber,
    required this.title,
  });
}

class Season {
  final int seasonNumber;
  final List<Episode> episodes;

  const Season({
    required this.seasonNumber,
    required this.episodes,
  });
}

class MovieDetail extends Equatable {
  const MovieDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalTitle,
        overview,
        posterPath,
        releaseDate,
        runtime,
        title,
        voteAverage,
        voteCount,
        seasons,
      ];
}

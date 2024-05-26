import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/episode.dart';
import 'package:submission_flutter_expert/domain/entities/season.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.seasonNumber,
    required this.episodes,
    required this.name,
    required this.posterPath,
  });

  final int seasonNumber;
  final List<Episode> episodes;
  final String name;
  final String posterPath;

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'name': name,
      'episodes': episodes.map((episode) => episode.toJson()).toList(),
      'posterPath': posterPath,
    };
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      seasonNumber: json['seasonNumber'] ?? 0,
      name: json['name'] ?? '',
      posterPath: json['posterPath'] ?? '',
      episodes: (json['episodes'] != null)
          ? (json['episodes'] as List<dynamic>)
              .map((episodeJson) => Episode.fromJson(episodeJson))
              .toList()
          : [],
    );
  }

  Season toEntity() {
    return Season(
      id: seasonNumber,
      seasonNumber: seasonNumber,
      name: name,
      episodes: episodes,
      posterPath: posterPath,
    );
  }

  @override
  List<Object?> get props => [seasonNumber, name, episodes, posterPath];
}

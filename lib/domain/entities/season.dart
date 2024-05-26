import 'package:equatable/equatable.dart';
import 'package:submission_flutter_expert/domain/entities/episode.dart';

class Season extends Equatable {
  final int id;
  final int seasonNumber;
  final List<Episode> episodes;
  final String? name;
  final String? posterPath;

  const Season({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
    this.name,
    this.posterPath,
  });

  @override
  List<Object?> get props => [id, seasonNumber, posterPath, name, episodes];
}

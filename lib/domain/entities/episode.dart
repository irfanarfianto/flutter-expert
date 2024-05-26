class Episode {
  final int episodeNumber;
  final String name;

  final int id;
  final String overview;
  final int seasonNumber;
  final String airDate;

  const Episode({
    required this.episodeNumber,
    required this.name,
    required this.id,
    required this.overview,
    required this.seasonNumber,
    required this.airDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'overview': overview,
      'seasonNumber': seasonNumber,
      'airDate': airDate,
      'episodeNumber': episodeNumber,
      'name': name,
    };
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      overview: json['overview'],
      seasonNumber: json['seasonNumber'],
      airDate: json['airDate'],
      episodeNumber: json['episodeNumber'],
      name: json['name'],
    );
  }
}

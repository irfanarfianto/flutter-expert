class Episode {
  final int episodeNumber;
  final String name;

  const Episode({
    required this.episodeNumber,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'episodeNumber': episodeNumber,
      'name': name,
    };
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'],
      name: json['name'],
    );
  }
}

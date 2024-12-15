class MusicListModel {
  final String? id;
  final String title;
  final String artist;
  final String image;
  final String duration;
  final String track;

  const MusicListModel(
      {this.id,
      required this.title,
      required this.artist,
      required this.image,
      required this.duration,
      required this.track});

  factory MusicListModel.fromMap(Map<String, dynamic> json) {
    return MusicListModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        artist: json['artist']?['name'] ?? '',
        image: json['album']?['cover_medium'] ?? 'https://placeholder.com/placeholder.jpg',
        duration: (json['duration'] ?? 0).toString(),
        track: json['preview'] ?? '');
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': id,
        'img': image,
        'duration': duration,
        'track': track
      };
}

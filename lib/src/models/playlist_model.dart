class PlayListModel {
  final String? id;
  final String title;
  final String picture;
  final String nbTracks;
  final int isFevTracks;

  const PlayListModel(
      {this.id,
      required this.title,
      required this.picture,
      required this.nbTracks,
      required this.isFevTracks});

  factory PlayListModel.fromMap(Map<String, dynamic> json) {
    return PlayListModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        picture: json['picture'] ?? 'https://placeholder.com/placeholder.jpg',
        nbTracks: (json['nb_tracks'] ?? 0).toString(),
        isFevTracks: json['is_loved_track'] == true ? 1 : 0);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': id,
        'picture': picture,
        'nb_tracks': nbTracks,
        'isFexTracks': isFevTracks
      };
}

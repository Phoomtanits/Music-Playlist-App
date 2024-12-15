import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/playlist_model.dart';
import '../models/music_list_model.dart';
import '../services/api_url.dart';

class MusicService {
  static Future<List<MusicListModel>> getFavoriteSong() async {
    final response = await http.get(
      Uri.parse(favListURL),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRes = json.decode(response.body);
      List<dynamic> resTrack = jsonRes['tracks']['data'];

      List<MusicListModel> listFav = resTrack.map((result) {
        return MusicListModel.fromMap(result);
      }).toList();
      return listFav;
    } else {
      throw Exception('Failed to get Favorite Song');
    }
  }

  static Future<List<PlayListModel>> getPlayList() async {
    final response = await http.get(Uri.parse(playlistURL),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRes = json.decode(response.body);
      List<dynamic> resData = jsonRes['data'];
      List<PlayListModel> playList = resData.map((result) {
        return PlayListModel.fromMap(result);
      }).toList();
      playList.sort((a, b) {
        int isFev = b.isFevTracks.compareTo(a.isFevTracks);
        return isFev != 0 ? isFev : a.title.compareTo(b.title);
      });
      return playList;
    } else {
      throw Exception('Failed to get PlayList');
    }
  }

  static Future<List<MusicListModel>> getMusicInPlayList(id) async {
    final response = await http.get(Uri.parse('$musicListURL/$id'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRes = json.decode(response.body);
      List<dynamic> resTrack = jsonRes['tracks']['data'];
      List<MusicListModel> listFav = resTrack.map((result) {
        return MusicListModel.fromMap(result);
      }).toList();
      return listFav;
    } else {
      throw Exception('Failed to get Song');
    }
  }

}

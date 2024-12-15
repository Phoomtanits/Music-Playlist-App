import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:my_music_app/src/models/music_list_model.dart';
import 'package:my_music_app/src/models/playlist_model.dart';
import '../services/music_service.dart';

class MusicListController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  RxString titleList = ''.obs;
  RxList playList = <PlayListModel>[].obs;
  RxList fevSong = <MusicListModel>[].obs;
  RxList listSong = <MusicListModel>[].obs;
  RxInt indexSong = 0.obs;
  RxString imagePlaylist = ''.obs;
  RxString imageSong = ''.obs;
  RxString songName = ''.obs;
  RxString urlPlaying = ''.obs;
  Rx<Duration> durationAudio = Duration.zero.obs;
  Rx<Duration> progressAudio = Duration.zero.obs;
  Rx<double> positionBar = 0.0.obs;
  Rx<bool> isPlaying = false.obs;
  Rx<bool> isPaused = false.obs;
  Rx<bool> isRepeat = false.obs;
  RxString countDuration = ''.obs;
  RxString endDuration = ''.obs;
  Timer? timer;
  Random random = new Random();

  RxString page = 'homepage'.obs;
  var isLoading = true.obs;

  void setScreen(String screen) {
    page.value = screen;
  }

  String formatTime(Duration sec) {
    int minutes = sec.inMinutes;
    int seconds = sec.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectSong({
    required int index,
  }) async {
    clearAudio();
    indexSong.value = index;
    songName.value =
        page.value == 'homepage' ? fevSong[index].title : listSong[index].title;
    imageSong.value =
        page.value == 'homepage' ? fevSong[index].image : listSong[index].image;
    getTotalDuration();
    startTimer();
    playAudio(
        url: page.value == 'homepage'
            ? fevSong[index].track
            : listSong[index].track);
  }

  void clearAudio() {
    imageSong.value = '';
    songName.value = '';
    urlPlaying.value = '';
    durationAudio.value = Duration.zero;
    progressAudio.value = Duration.zero;
    positionBar.value = 0.0;
    isPaused.value = false;
    countDuration.value = '';
    endDuration.value = '';
    stopAudio();
    stopTimer();
  }

  void getFavMusicList() async {
    var fav = await MusicService.getFavoriteSong();
    titleList.value = 'Favourite tracks';
    fevSong.assignAll(fav);
  }

  void getPlayList() async {
    var playlist = await MusicService.getPlayList();
    playList.assignAll(playlist);
  }

  void getMusicInPlayList(id, title, img) async {
    imagePlaylist.value = img;
    titleList.value = title;
    isLoading(true);
    try {
      var musicList = await MusicService.getMusicInPlayList(id);
      listSong.assignAll(musicList);
    } finally {
      isLoading(false);
    }
  }

  void playAudio({required String url}) async {
    await audioPlayer.play(UrlSource(url));
    isPlaying.value = true;
    isPaused.value = false;
  }

  void pauseAudio() async {
    await audioPlayer.pause();
    isPaused.value = true;
    isPlaying.value = false;
    stopTimer();
  }

  void resumeAudio() async {
    startTimer();
    isPlaying.value = true;
    await audioPlayer.resume();
  }

  void stopAudio() async {
    isPlaying.value = false;
    await audioPlayer.stop();
  }

  void randomAudio() async {
    await audioPlayer.release();
    indexSong.value = random
        .nextInt(page.value == 'homepage' ? fevSong.length : listSong.length);
    selectSong(index: indexSong.value);
  }

  void prevAudio() async {
    stopAudio();
    if (isRepeat.value && indexSong.value == 0) {
      indexSong.value =
          page.value == 'homepage' ? fevSong.length - 1 : listSong.length - 1;
      selectSong(index: indexSong.value);
    } else if (indexSong.value == 0) {
      await audioPlayer.release();
      indexSong.value = 0;
      selectSong(index: indexSong.value);
    } else {
      indexSong.value -= 1;
      selectSong(index: indexSong.value);
    }
  }

  void nextAudio() async {
    stopAudio();
    final count = page.value == 'homepage' ? fevSong.length : listSong.length;
    if (isRepeat.value && indexSong.value + 1 == count) {
      indexSong.value = 0;
      selectSong(index: indexSong.value);
    } else if (indexSong.value + 1 < count) {
      indexSong.value += 1;
      selectSong(index: indexSong.value);
    } else {
      await audioPlayer.release();
      clearAudio();
    }
  }

  void updateSongProgress(Duration duration) {
    progressAudio.value = duration;
    audioPlayer.seek(progressAudio.value);
    audioPlayer.resume();
    update();
  }

  void getTotalDuration() async {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      durationAudio.value = duration;
      endDuration.value = formatTime(duration);
    });
  }

  void startTimer() {
    if (isPaused.value) {
      stopTimer();
    }
    isPaused.value = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (progressAudio.value < durationAudio.value) {
        countDuration.value = formatTime(progressAudio.value);
        progressAudio.value += const Duration(seconds: 1);
        endDuration.value =
            formatTime(durationAudio.value - progressAudio.value);
      } else {
        final count = page.value == 'homepage' ? fevSong.length : listSong.length;
        if (indexSong.value + 1 < count) {
          selectSong(index: indexSong.value + 1);
        } else {
          clearAudio();
          stopTimer();
        }
      }
    });
  }

  void stopTimer() {
    isPlaying.value = false;
    timer?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    getFavMusicList();
    getPlayList();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_app/src/assets/themes/color.dart';
import '../controllers/music_list_controller.dart';

class MusicMiniWidget extends StatelessWidget {
  MusicMiniWidget({
    super.key,
  });

  final MusicListController musicListController =
      Get.find<MusicListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(color: AppColor.darkbrownColor),
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        musicListController.imageSong.value != ''
                            ? Container(
                                width: 60,
                                height: 60,
                                margin:
                                    const EdgeInsets.only(left: 0, right: 0),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          musicListController.imageSong.value,
                                        ))),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                margin:
                                    const EdgeInsets.only(left: 0, right: 0),
                                decoration:
                                    BoxDecoration(color: AppColor.whiteColor)),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (musicListController.songName).toString(),
                                style: TextStyle(
                                    fontSize: 20, color: AppColor.whiteColor),
                              ),
                              Slider(
                                activeColor: AppColor.whiteColor,
                                min: 0,
                                max: musicListController
                                        .durationAudio.value.inSeconds
                                        .toDouble() +
                                    1,
                                value: musicListController
                                    .progressAudio.value.inSeconds
                                    .toDouble(),
                                onChanged: (value) async {
                                  musicListController.updateSongProgress(
                                      Duration(seconds: value.toInt()));
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (musicListController.countDuration.value),
                                      style:
                                          TextStyle(color: AppColor.whiteColor),
                                    ),
                                    Text(
                                      musicListController.endDuration.value,
                                      style:
                                          TextStyle(color: AppColor.whiteColor),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        musicListController.imageSong.value != ''
                            ? IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.cancel),
                                iconSize: 25,
                                onPressed: () async {
                                  musicListController.clearAudio();
                                },
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.only(left: 0, right: 0),
                              ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      color: AppColor.whiteColor,
                      icon: const Icon(Icons.shuffle),
                      iconSize: 30,
                      onPressed: () async {
                        musicListController.randomAudio();
                      },
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 35,
                      onPressed: () async {
                        musicListController.prevAudio();
                      },
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: IconButton(
                        color: Colors.black,
                        icon: musicListController.isPlaying.value
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        iconSize: 43,
                        onPressed: () async {
                          if (musicListController.isPlaying.value) {
                            musicListController.pauseAudio();
                          } else if (!musicListController.isPlaying.value &&
                              !musicListController.isPaused.value) {
                            musicListController.selectSong(
                                index: musicListController.indexSong.value);
                          } else {
                            musicListController.resumeAudio();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.skip_next),
                      iconSize: 35,
                      onPressed: () async {
                        musicListController.nextAudio();
                      },
                    ),
                    IconButton(
                      color: !musicListController.isRepeat.value
                          ? AppColor.whiteColor
                          : Colors.blue,
                      icon: const Icon(Icons.loop),
                      iconSize: 30,
                      onPressed: () async {
                        musicListController.isRepeat.value =
                            !musicListController.isRepeat.value;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

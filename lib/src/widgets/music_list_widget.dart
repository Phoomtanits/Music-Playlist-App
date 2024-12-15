import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_app/src/assets/themes/color.dart';
import 'package:my_music_app/src/controllers/music_list_controller.dart';

class MusicListWidget {
  final MusicListController musicListController =
      Get.find<MusicListController>();

  List<Widget> musicListWidget() {
    return musicListController.page.value == "homepage"
        ? musicListController.fevSong.asMap().entries.map((music) {
            return ListTile(
              leading: Image.network(
                music.value.image,
                height: 50,
              ),
              title: Text(music.value.title,
                  style: TextStyle(color: AppColor.whiteColor, fontSize: 18)),
              subtitle: Text(music.value.artist,
                  style: TextStyle(color: AppColor.whiteColor, fontSize: 16)),
              onTap: () async {
                musicListController.selectSong(
                  index: music.key,
                );
              },
            );
          }).toList()
        : musicListController.listSong.asMap().entries.map((music) {
            return ListTile(
              leading: Image.network(
                music.value.image,
                height: 50,
              ),
              title: Text(music.value.title,
                  style: TextStyle(color: AppColor.whiteColor, fontSize: 18)),
              subtitle: Text(music.value.artist,
                  style: TextStyle(color: AppColor.whiteColor, fontSize: 16)),
              onTap: () async {
                musicListController.selectSong(
                  index: music.key,
                );
              },
            );
          }).toList();
  }
}

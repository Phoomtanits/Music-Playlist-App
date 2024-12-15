import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music_app/src/widgets/music_list_widget.dart';
import '../controllers/music_list_controller.dart';
import '../widgets/music_mini_widget.dart';
import '../assets/themes/color.dart';

class MusicListScreen extends StatelessWidget {
  MusicListScreen({super.key});
  final navigatorKey = GlobalKey();
  final musicListWidget = MusicListWidget();

  final MusicListController musicListController =
      Get.find<MusicListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkbrownColor,
      body: Stack(
        children: [
          Obx(() {
            return musicListController.page.value == 'homepage'
                ? homepageScreen(context: context)
                : inPlaylistScreen(context: context);
          }),
          playerWidget(context),
        ],
      ),
    );
    // });
  }

  Widget homepageScreen({required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(bottom: 210),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          musicCardWidget(),
          ...musicListWidget.musicListWidget()
        ]),
      ),
    );
  }

  Widget inPlaylistScreen({required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(bottom: 210),
      child: SingleChildScrollView(
        child: Obx(() {
          return musicListController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  inPlayListCardWidget(),
                  ...musicListWidget.musicListWidget()
                ]);
        }),
      ),
    );
  }

  Widget playerWidget(BuildContext context) {
    return Positioned(
      child: Miniplayer(
        maxHeight: 200,
        minHeight: 200,
        builder: (height, percentage) {
          return MusicMiniWidget();
        },
      ),
    );
  }

  List<Widget> playListWidget() {
    return musicListController.playList.map((music) {
      return GestureDetector(
        onTap: () {
          musicListController.setScreen('playlist');
          musicListController.getMusicInPlayList(
              music.id, music.title, music.picture);
        },
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Image.network(
                  music.picture,
                  width: 200,
                  height: 160,
                )),
            Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(music.title,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 22,
                    )))
          ],
        ),
      );
    }).toList();
  }

  Widget musicCardWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Text(
            "My Playlist",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: AppColor.whiteColor),
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [...playListWidget()],
            )),
        Container(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Text(
              "My Favourite Song",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: AppColor.whiteColor),
            )),
      ],
    );
  }

  Widget inPlayListCardWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.network(
                    musicListController.imagePlaylist.value,
                    width: 200,
                    height: 160,
                  )),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "${musicListController.titleList.value} Playlist",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: AppColor.whiteColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

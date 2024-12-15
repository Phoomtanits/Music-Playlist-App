import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_app/src/assets/themes/color.dart';
import 'package:my_music_app/src/controllers/music_list_controller.dart';
import 'package:my_music_app/src/screens/music_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MusicListController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MusicListController musicListController =
      Get.find<MusicListController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Obx(() {
          return Scaffold(
            backgroundColor: Colors.grey.shade900,
            appBar: musicListController.page.value == 'homepage'
                ? AppBar(
                    centerTitle: true,
                    backgroundColor: AppColor.darkbrownColor,
                    title: const Text(
                      'Music Application',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : AppBar(
                    centerTitle: true,
                    backgroundColor: AppColor.darkbrownColor,
                    title: const Text(
                      "Music Application",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        musicListController.setScreen('homepage'); // กลับไปยังหน้าก่อนหน้า
                      },
                    ),
                  ),
            body: MusicListScreen(),
          );
        }));
  }
}

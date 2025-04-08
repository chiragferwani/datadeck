import 'package:datadeck/save.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:datadeck/home.dart';
import 'package:datadeck/movies.dart';
import 'package:datadeck/events.dart';
import 'package:datadeck/profile.dart';
import 'package:datadeck/infoscreen.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DataDesk",
          style: TextStyle(fontFamily: 'boldfont', color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12), // adjust padding as needed
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectInfoScreen()),
                );
              },
            ),
          ),
        ],
      ),

      extendBody: true, // Important for floating nav bar
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4, // Fixed number of navigation items
              (index) => GestureDetector(
                onTap: () => controller.selectedIndex.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        controller.selectedIndex.value == index
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(index),
                    color:
                        controller.selectedIndex.value == index
                            ? Colors.white
                            : Colors.white60,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Ionicons.home;
      case 1:
        return Ionicons.videocam;
      case 2:
        return Ionicons.bookmark;
      case 3:
        return Ionicons.person;
      default:
        return Ionicons.person;
    }
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    MoviesScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];
}

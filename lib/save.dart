import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datadeck/saved_controller.dart';

class SavedScreen extends StatelessWidget {
  final SavedController savedController = Get.put(SavedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final savedItems = savedController.savedItems;

          if (savedItems.isEmpty) {
            return Center(
              child: Text(
                "No saved items yet!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'boldfont',
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: savedItems.length,
            itemBuilder: (context, index) {
              final item = savedItems[index];
              final title = item['title'];
              final imageUrl = item['imageUrl'];
              final rating = item['rating'];
              final type = item['type'];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'boldfont',
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    type == 'movie' ? 'Rating: $rating/5' : 'Saved Event',
                    style: TextStyle(fontFamily: 'boldfont'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.bookmark, color: Colors.black),
                    onPressed: () => savedController.toggleSave(item),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

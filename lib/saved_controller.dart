// file: saved_controller.dart

import 'package:get/get.dart';

class SavedController extends GetxController {
  var savedItems = <Map<String, dynamic>>[].obs;

  void toggleSave(Map<String, dynamic> item) {
    if (isSaved(item)) {
      savedItems.removeWhere((element) => element['id'] == item['id']);
    } else {
      savedItems.add(item);
    }
  }

  bool isSaved(Map<String, dynamic> item) {
    return savedItems.any((element) => element['id'] == item['id']);
  }
}

import 'dart:io';

class ProfileData {
  static final ProfileData _instance = ProfileData._internal();

  factory ProfileData() => _instance;

  ProfileData._internal();

  File? profileImage;
  String name = '';
  String email = '';
  String phone = '';
}

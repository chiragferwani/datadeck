import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profile_data.dart'; // ⬅️ import the class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🧠 Load previously saved profile data
    final data = ProfileData();
    _profileImage = data.profileImage;
    _nameController.text = data.name;
    _emailController.text = data.email;
    _phoneController.text = data.phone;
  }

  Future<void> _pickImage() async {
    // 👮 Step 1: Request permission
    final permissionStatus = await Permission.camera.request();

    if (!permissionStatus.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📸 Camera permission chahiye bro")),
        );
      }
      return;
    }

    try {
      // 📷 Step 2: Pick image using camera
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      // 🛑 Step 3: Check if user cancelled image pick
      if (pickedFile == null || pickedFile.path.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Koi image nahi select hui bro")),
          );
        }
        return;
      }

      // 🧠 Step 4: Create File and update state
      final tempImage = File(pickedFile.path);

      if (mounted) {
        setState(() {
          _profileImage = tempImage;
        });
      }

      // 💾 Step 5: Save to memory (singleton)
      ProfileData().profileImage = tempImage;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
      }
      print("❌ Error while picking image: $e");
    }
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Fill All the fields",
            style: TextStyle(color: Colors.white, fontFamily: 'boldfont'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // optional: makes it float
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            seconds: 2,
          ), // optional: auto dismiss after 2 seconds
        ),
      );
    } else {
      // 💾 Save to memory
      final data = ProfileData();
      data.name = name;
      data.email = email;
      data.phone = phone;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Profle Updated!",
            style: TextStyle(color: Colors.white, fontFamily: 'boldfont'),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating, // optional: makes it float
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            seconds: 2,
          ), // optional: auto dismiss after 2 seconds
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child:
                    _profileImage == null
                        ? Icon(Ionicons.camera, size: 40, color: Colors.black)
                        : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'boldfont'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontFamily: 'boldfont'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(fontFamily: 'boldfont'),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: Icon(Icons.save, color: Colors.white), // white icon
              label: Text(
                "Update Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'boldfont',
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 🔥 black background
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // optional: rounded corners
                ),
                elevation: 4, // slight elevation
              ),
            ),
          ],
        ),
      ),
    );
  }
}

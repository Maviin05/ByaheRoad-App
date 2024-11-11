import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dashboard.dart';

class ProfileDriverScreen extends StatefulWidget {
  final String fullName;
  final String nickname;
  final String address;
  final String contactNumber;
  final String email;
  final double tips;
  final double rating;
  final double yearsOfExperience;
  final String bio;
  final Uint8List? profileImage;

  const ProfileDriverScreen({
    Key? key,
    required this.fullName,
    required this.nickname,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.tips,
    required this.rating,
    required this.yearsOfExperience,
    required this.bio,
    this.profileImage,
  }) : super(key: key);

  @override
  _ProfileDriverScreenState createState() => _ProfileDriverScreenState();
}

class _ProfileDriverScreenState extends State<ProfileDriverScreen> {
  late TextEditingController _bioController;
  Uint8List? _updatedProfileImage;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.bio);
    _updatedProfileImage = widget.profileImage;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _updatedProfileImage = await pickedFile.readAsBytes();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://via.placeholder.com/400x200'), // replace with a background image link
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture and Name
                  Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _updatedProfileImage != null
                            ? MemoryImage(
                                _updatedProfileImage!) // Use MemoryImage for web
                            : const NetworkImage(
                                'https://via.placeholder.com/150',
                              ),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Change Profile Picture'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 45, 45, 55),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        widget.fullName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.nickname,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ProfileInfoRow(
                        icon: Icons.location_on,
                        text: widget.address,
                      ),
                      ProfileInfoRow(
                        icon: Icons.phone,
                        text: widget.contactNumber,
                      ),
                      ProfileInfoRow(
                        icon: Icons.email,
                        text: widget.email,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileStat(
                          title: 'Tips',
                          value: '\$${widget.tips.toStringAsFixed(2)}'),
                      ProfileStat(
                          title: 'Rating',
                          value: widget.rating.toStringAsFixed(1)),
                      ProfileStat(
                          title: 'Years',
                          value: widget.yearsOfExperience.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bio
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _bioController,
                          maxLines: 3, // Allows for multi-line input
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your bio',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Confirm Profile Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(
                            driverName: widget.fullName,
                            profileImage: _updatedProfileImage,
                          ),
                        ),
                      );
                    },
                    child: const Text('Confirm Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoRow({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'profiledriver.dart';
import 'earnings.dart';
import 'dart:typed_data';

class MenuDriver extends StatelessWidget {
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

  MenuDriver({
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
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 190, 190),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: profileImage != null
                      ? MemoryImage(profileImage!)
                      : const NetworkImage(
                          'https://via.placeholder.com/150',
                        ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$rating / 10",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDriverScreen(
                    fullName: fullName,
                    nickname: nickname,
                    address: address,
                    contactNumber: contactNumber,
                    email: email,
                    tips: tips,
                    rating: rating,
                    yearsOfExperience: yearsOfExperience,
                    bio: bio,
                    profileImage: profileImage,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Earnings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EarningsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

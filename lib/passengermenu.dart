import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PassengerMenu extends StatelessWidget {
  final String passengerName;
  final String passengerAddress;
  final Uint8List? passengerPicture;

  const PassengerMenu({
    Key? key,
    required this.passengerName,
    required this.passengerAddress,
    this.passengerPicture,
  }) : super(key: key);

  Future<void> _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (passengerPicture != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(passengerPicture!),
            )
          else
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person),
            ),
          SizedBox(height: 20),
          Text(
            passengerName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            passengerAddress,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

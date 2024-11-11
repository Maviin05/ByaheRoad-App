import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login.dart';
import 'profiledriver.dart';
import 'dashboardpassenger.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedRole;
  bool _isDriver = false;
  String? _driverLicenseImageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _registerUser() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save user data to Database
        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'firstname': _fullNameController.text,
          'lastname': _nicknameController.text,
          'address': _addressController.text,
          'contactNumber': _contactNumberController.text,
          'email': _emailController.text,
          'role': _selectedRole ?? 'Passenger',
          'driverLicenseImage': _isDriver ? _driverLicenseImageUrl : null,
        });

        if (_selectedRole == 'Driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileDriverScreen(
                fullName: _fullNameController.text,
                nickname: _nicknameController.text,
                address: _addressController.text,
                contactNumber: _contactNumberController.text,
                email: _emailController.text,
                tips: 0.0,
                rating: 0.0,
                yearsOfExperience: 0.0,
                bio: '',
              ),
            ),
          );
        } else if (_selectedRole == 'Passenger') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPassenger(
                userName:
                    '${_fullNameController.text} ${_nicknameController.text}',
                userEmail: _emailController.text,
                userAddress: '',
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
        ),
      );
    }
  }

  Future<void> _pickDriverLicenseImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';

    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;

      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);

      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;

        final ref = _storage.ref('driver_licenses/${files[0].name}');
        await ref.putData(bytes);

        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          _driverLicenseImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver License Image Selected')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'CREATE NEW ACCOUNT',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Already registered? Log in here',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedRole = 'Driver';
                      _isDriver = true;
                    });
                  },
                  child: const Text('Driver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedRole == 'Driver' ? Colors.green : Colors.blue,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedRole = 'Passenger';
                      _isDriver = false;
                    });
                  },
                  child: const Text('Passenger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedRole == 'Passenger'
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isDriver) ...[
              ElevatedButton(
                onPressed: _pickDriverLicenseImage,
                child: const Text('Choose Driver License Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              if (_driverLicenseImageUrl != null)
                Text('Selected Image: $_driverLicenseImageUrl',
                    style: const TextStyle(fontSize: 16)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

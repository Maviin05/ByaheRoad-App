import 'package:flutter/material.dart';
import 'google_map.dart';
import 'menudriver.dart';
import 'newpassenger.dart';
import 'dart:typed_data';

class Dashboard extends StatefulWidget {
  final String driverName;
  final Uint8List? profileImage;

  const Dashboard({
    Key? key,
    required this.driverName,
    this.profileImage,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String pickupLocation = "My Current Location";
  String dropoffLocation = "Destination";
  double distanceInKm = 0.0;
  double fee = 0.0;
  bool showReceipt = false;

  void updateBookingInfo(
      String pickup, String dropoff, double distance, double fee) {
    setState(() {
      pickupLocation = pickup;
      dropoffLocation = dropoff;
      distanceInKm = distance;
      this.fee = fee;
    });
  }

  void showArrivedReceipt() {
    setState(() {
      showReceipt = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: MenuDriver(
        fullName: widget.driverName,
        nickname: 'Default Nickname',
        address: 'Default Address',
        contactNumber: '123-456-7890',
        email: 'example@example.com',
        tips: 0.0,
        rating: 0.0,
        yearsOfExperience: 0.0,
        profileImage: widget.profileImage,
        bio: 'Enter your bio here',
      ),
      body: Stack(
        children: [
          GoogleMapFlutter(
            onDestinationSelected: (pickup, destination, distance, fee) {
              updateBookingInfo(pickup, destination, distance, fee);
            },
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewPassengerScreen(
                          passengerName: 'Earon Aragon',
                          pickupLocation: 'Visayan Village',
                          destination: 'Magdum',
                          totalFee: 20.00,
                          onRideNow: showArrivedReceipt,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'New Passenger',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                if (showReceipt) // Show the receipt if showReceipt is true
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Arrived!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

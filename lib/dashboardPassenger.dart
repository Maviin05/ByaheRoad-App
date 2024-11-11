import 'package:flutter/material.dart';
import 'google_map.dart';
import 'booking_info.dart';
import 'passengermenu.dart';
import 'dart:typed_data';

class DashboardPassenger extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userAddress;
  final Uint8List? profileImage;
  final bool hasArrived;

  const DashboardPassenger({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userAddress,
    this.profileImage,
    this.hasArrived = false,
  }) : super(key: key);

  @override
  _DashboardPassengerState createState() => _DashboardPassengerState();
}

class _DashboardPassengerState extends State<DashboardPassenger> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String pickupLocation = "My Current Location";
  String dropoffLocation = "Destination";
  double distanceInKm = 0.0;
  double fee = 0.0;

  void updateBookingInfo(
      String pickup, String dropoff, double distance, double fee) {
    setState(() {
      pickupLocation = pickup;
      dropoffLocation = dropoff;
      distanceInKm = distance;
      this.fee = fee;
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
      body: Stack(
        children: [
          GoogleMapFlutter(
            onDestinationSelected: (pickup, destination, distance, fee) {
              updateBookingInfo(pickup, destination, distance, fee);
            },
          ),
          if (widget.hasArrived)
            Positioned(
                top: 20,
                left: 20,
                child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green.withOpacity(0.8),
                    child: Text(
                      "Arrived",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ))),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingInfo(
                      pickup: pickupLocation,
                      dropoff: dropoffLocation,
                      distance: distanceInKm,
                      fee: fee,
                    ),
                  ),
                );
              },
              backgroundColor: const Color.fromARGB(255, 101, 98, 95),
              child: Icon(Icons.book),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: PassengerMenu(
          passengerName: widget.userName,
          passengerAddress: widget.userAddress,
          passengerPicture: widget.profileImage,
        ),
      ),
    );
  }
}

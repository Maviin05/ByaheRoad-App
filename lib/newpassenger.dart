import 'package:flutter/material.dart';

class NewPassengerScreen extends StatelessWidget {
  final String passengerName;
  final String pickupLocation;
  final String destination;
  final double totalFee;
  final VoidCallback onRideNow; // Callback to notify when the ride is confirmed

  const NewPassengerScreen({
    Key? key,
    required this.passengerName,
    required this.pickupLocation,
    required this.destination,
    required this.totalFee,
    required this.onRideNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passenger Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Passenger Name: $passengerName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Pickup Location: $pickupLocation",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Destination: $destination",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Total Fee: \$${totalFee.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Call the callback function
                  onRideNow();
                  // Navigate back to the dashboard
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  child: Text(
                    "Ride Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

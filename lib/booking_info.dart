import 'package:flutter/material.dart';
import 'driverpass.dart';

class BookingInfo extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final double distance;
  final double fee;

  BookingInfo({
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Now"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Motorcycle",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("Pickup Location: $pickup"),
            SizedBox(height: 8),
            Text("Dropoff Location: $dropoff"),
            SizedBox(height: 8),
            Text("Distance: ${distance.toStringAsFixed(2)} km"),
            SizedBox(height: 8),
            Text("Estimated Fee: \$${fee.toStringAsFixed(2)}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverPassScreen(
                      passengerName: '',
                      passengerEmail: '',
                      passengerAddress: '',
                    ),
                  ),
                ).then((_) {
                  Navigator.pop(context);
                });
              },
              child: Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}

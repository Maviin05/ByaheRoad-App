import 'package:flutter/material.dart';
import 'dashboardpassenger.dart';

class DriverPassScreen extends StatelessWidget {
  final String driverName = "Lagang, Vince Neil John";
  final String driverRating = "8.7%";
  final String pickupLocation = "Sison, Tagum City";
  final double distance = 2.5; // in kilometers
  final int estimatedTime = 25; // in minutes
  final double fare = 105.0; // in Pesos

  final String passengerName;
  final String passengerEmail;
  final String passengerAddress;

  DriverPassScreen({
    required this.passengerName,
    required this.passengerEmail,
    required this.passengerAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "Driver Information",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your driver is coming in 3:35 mins",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/lagang.jpg'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Driver Name:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            driverName,
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text(
                                "Rate: ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.star, color: Colors.yellow, size: 16),
                              Text(
                                driverRating,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 20, thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        pickupLocation,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.directions_bike, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "$distance km",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        "$estimatedTime minutes",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange),
                      SizedBox(width: 10),
                      Text(
                        "$fare Pesos",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPassenger(
                            userName: passengerName,
                            userEmail: passengerEmail,
                            profileImage: null,
                            userAddress: passengerAddress,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: Text(
                        "Arrived",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  final List<RideHistory> rideHistory = [
    RideHistory(time: '6:40 am', location: 'Visayan Tagum City', amount: 49.00),
    RideHistory(
        time: '8:20 am', location: 'Meggere East Tagum City', amount: 25.00),
    RideHistory(time: '6:40 am', location: 'Tiniag Tagum City', amount: 74.00),
    RideHistory(time: '7:52 am', location: 'Visayan Tagum City', amount: 98.00),
    RideHistory(
        time: '10:10 am', location: 'Cancoctan Tagum City', amount: 78.00),
    RideHistory(time: '3:40 am', location: 'Visayan Tagum City', amount: 78.00),
  ];

  @override
  Widget build(BuildContext context) {
    double totalEarnings =
        rideHistory.fold(0, (sum, ride) => sum + ride.amount);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('My Earnings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    'EARNINGS',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₱$totalEarnings',
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ride History',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: rideHistory.length,
                itemBuilder: (context, index) {
                  final ride = rideHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      title: Text('${ride.time} - ${ride.location}'),
                      trailing: Text('₱${ride.amount}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RideHistory {
  final String time;
  final String location;
  final double amount;

  RideHistory({
    required this.time,
    required this.location,
    required this.amount,
  });
}

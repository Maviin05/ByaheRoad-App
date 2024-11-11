import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapFlutter extends StatefulWidget {
  final Function(String pickup, String dropoff, double distance, double fee)
      onDestinationSelected;

  const GoogleMapFlutter({Key? key, required this.onDestinationSelected})
      : super(key: key);

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation =
      const LatLng(7.424084254558798, 125.80534886840456);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Polyline? route;
  String get googleApiKey => 'AIzaSyDTZQ4n14RG4J-RlX5JCCqaWLB6KAS_AKM';
  LatLng? selectedDestination;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> placePredictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            markers: markers,
            polylines: route != null ? {route!} : {},
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
              zoom: 14,
            ),
            onTap: (LatLng destination) {
              setState(() {
                // Clear old marker if it exists
                if (selectedDestination != null) {
                  markers.removeWhere(
                      (marker) => marker.markerId.value == 'destination');
                }
                selectedDestination =
                    destination; // Update selected destination
                markers.add(Marker(
                  markerId: const MarkerId('destination'),
                  position: selectedDestination!,
                  infoWindow: InfoWindow(title: 'Selected Destination'),
                ));
              });
              getDirections(
                  destination); // Get directions when destination is tapped
            },
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Location',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          fetchPlacePredictions(_searchController.text);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      fetchPlacePredictions(value);
                    },
                  ),
                ),
                if (placePredictions.isNotEmpty)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
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
                    child: ListView.builder(
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(placePredictions[index]['description']),
                          onTap: () {
                            selectPlace(placePredictions[index]['place_id']);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await moveToCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> fetchPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        placePredictions.clear();
      });
      return;
    }

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&location=${myCurrentLocation.latitude},${myCurrentLocation.longitude}&radius=2000';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        placePredictions = data['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> selectPlace(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LatLng selectedPlace = LatLng(
        data['result']['geometry']['location']['lat'],
        data['result']['geometry']['location']['lng'],
      );

      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('searchedLocation'),
          position: selectedPlace,
          infoWindow: InfoWindow(title: data['result']['name']),
        ));
        placePredictions.clear();
      });

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedPlace,
            zoom: 14,
          ),
        ),
      );

      getDirections(selectedPlace);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<void> getDirections(LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${myCurrentLocation.latitude},${myCurrentLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        List points = data['routes'][0]['legs'][0]['steps'];
        List<LatLng> polylineCoordinates = [];

        // Calculate total distance
        double totalDistance = 0.0;
        for (var leg in data['routes'][0]['legs']) {
          totalDistance +=
              leg['distance']['value'] / 1000.0; // Convert meters to kilometers
        }

        for (var point in points) {
          polylineCoordinates.add(LatLng(
              point['end_location']['lat'], point['end_location']['lng']));
        }

        setState(() {
          route = Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 4,
          );
        });

        // Calculate the fee
        double fee = calculateFee(totalDistance);

        // Notify Dashboard with pickup and destination details and distance and fee
        widget.onDestinationSelected(
          "My Current Location", // Name of the pickup location
          data['routes'][0]['legs'][0]['end_address'], // Drop-off place name
          totalDistance,
          fee,
        );
      }
    }
  }

  double calculateFee(double distance) {
    // Calculate fee based on distance
    if (distance <= 3) {
      return 20.0;
    } else {
      return 20.0 + (5.0 * (distance - 3));
    }
  }

  Future<void> moveToCurrentLocation() async {
    Position position = await currentPosition();
    myCurrentLocation = LatLng(position.latitude, position.longitude);
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
      ),
    );

    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: myCurrentLocation,
    ));
    setState(() {});
  }

  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}

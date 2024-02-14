import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class MapsPage extends StatefulWidget {
  final bool loggedUser;

  MapsPage({@required this.loggedUser});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(1.3521, 103.8198);
  Set<Marker> _markers = {}; // A set of markers

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchLocationsAndCreateMarkers(); // Fetch locations when map is created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers, // Use the _markers set here
      ),
    );
  }

  void _fetchLocationsAndCreateMarkers() {
    try {
      log("Fetching locations");
      FirebaseFirestore.instance
          .collection('Location')
          .get()
          .then((querySnapshot) {
        Set<Marker> markers = {}; // Temporary set to hold new markers
        querySnapshot.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final LatLng position =
              LatLng(data['coords'].latitude, data['coords'].longitude);
          final String locationName = data['locationName'];
          final String locationAddress = data['locationAddress'];
          final String locationType = data['locationType'];

          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
                title: locationName + ' ($locationType)',
                snippet: locationAddress),
          );

          markers.add(marker);
        });

        setState(() {
          _markers = markers; // Update the state to refresh markers on the map
        });
      });
    } catch (e) {
      log("Error fetching locations: $e");
    }
  }
}

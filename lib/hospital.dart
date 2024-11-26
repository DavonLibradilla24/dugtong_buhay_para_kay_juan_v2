import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});
  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  String mapTheme = '';
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(0.0, 0.0);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _hospitalLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
    DefaultAssetBundle.of(context)
        .loadString('assets/styles/map_style.json')
        .then((value) {
      mapTheme = value;
    });
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation(); // Get the user's current location
    await _findNearestHospital(); // Always attempt to find the nearest hospital
    if (_hospitalLocation != null) {
      await _createRoute(_hospitalLocation!); // If a hospital is found, create the route
    }
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );

      _mapController.animateCamera(
        CameraUpdate.newLatLng(_initialPosition),
      );
    });
  }

  // Find the nearest hospital using the Google Places API
  Future<void> _findNearestHospital() async {
    const String apiKey = 'AIzaSyDak-C4yCq4C10hlQJS239WIbcQzEQK67w'; // Replace with your actual API key
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=5000&type=hospital&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        // Get the first hospital from the results
        final hospital = data['results'][0];
        _hospitalLocation = LatLng(
          hospital['geometry']['location']['lat'],
          hospital['geometry']['location']['lng'],
        );

        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('hospital'),
              position: _hospitalLocation!,
              infoWindow: const InfoWindow(title: 'Nearby Hospital'),
            ),
          );
        });
      } else {
        print('No hospitals found in the vicinity.');
      }
    } else {
      print('Error fetching nearby hospitals: ${response.body}');
    }
  }



  // Fetch route and draw polyline
  Future<void> _createRoute(LatLng hospitalLocation) async {
    const String apiKey = 'AIzaSyDak-C4yCq4C10hlQJS239WIbcQzEQK67w';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_initialPosition.latitude},${_initialPosition.longitude}&destination=${hospitalLocation.latitude},${hospitalLocation.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(points);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: decodedPoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        print('No route found.');
      }
    } else {
      print('Error fetching route: ${response.body}');
    }
  }

  // Decode the polyline string into a list of LatLng points
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(mapTheme);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
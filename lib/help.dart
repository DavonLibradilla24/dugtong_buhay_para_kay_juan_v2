import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';  // Import intl package for formatting the time
import 'home.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String? address;
  String? plusCode;
  double? latitude;
  double? longitude;
  String time = '';
  String date = ''; // New variable to store date
  double sliderValue = 0;  // Track the slider value

  final String apiKey = 'AIzaSyDak-C4yCq4C10hlQJS239WIbcQzEQK67w';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocationAndAddress();
    });
  }

  Future<void> _getLocationAndAddress() async {
    setState(() {
      time = DateFormat.Hm().format(DateTime.now()); // Format time to show only hours and minutes
      date = DateFormat.yMMMd().format(DateTime.now()); // Format date to show month, day, and year
    });

    var locationPermission = await Permission.location.request();
    if (!locationPermission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return;
    }

    try {
      // Set location settings for accuracy
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Adjust distance filter as needed
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // Use the new location settings
      );

      latitude = position.latitude;
      longitude = position.longitude;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'].isNotEmpty) {
          address = data['results'][0]['formatted_address'];
          plusCode = data['plus_code']?['global_code'];
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No address found for this location.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final Uri emergencyUrl = Uri(scheme: 'tel', path: '911');
    try {
      await launchUrl(emergencyUrl, mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening dialer to call 911...')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the dialer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Page'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Emergency Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (address != null && latitude != null && longitude != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: $date', // Display formatted date
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Time: $time', // Display formatted time
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Address: $address',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Latitude: $latitude',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                         'Longitude: $longitude',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Plus Code: ${plusCode ?? "Unavailable"}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Slide to Call 911',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
                ),
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;  // Update the slider value
                    });

                    if (value == 100) {
                      _makeEmergencyCall(context);
                    }
                  },
                  onChangeEnd: (value) {
                    setState(() {
                      sliderValue = 0;  // Reset the slider value to 0 when released
                    });
                  },
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey.shade300,
                  label: 'Slide to Call',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

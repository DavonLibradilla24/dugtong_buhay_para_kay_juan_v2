import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
      _navigateToHome();
    } else if (status.isDenied) {
      print('Location permission denied');
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
      openAppSettings();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('Location permission is required to proceed. Please allow it in the settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_splashscreen.gif',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}

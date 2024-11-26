import 'package:flutter/services.dart';

class EmergencyInfo {
  static const platform = MethodChannel('com.example.basic_life_support_and_first_aid_app/medicalInfo');

  static Future<Map<String, String>> getEmergencyInfo() async {
    try {
      // Using ?? to provide an empty map as the default if the result is null
      final Map<String, String> result = await platform.invokeMapMethod<String, String>('getEmergencyInfo') ?? {};
      return result;
    } on PlatformException catch (e) {
      print("Failed to get emergency info: '${e.message}'.");
      return {}; // Return an empty map in case of an error
    }
  }
}

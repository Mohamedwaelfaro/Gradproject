import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProfileService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) return null;

    final response = await _dio.post('farmer/profile', data: {'id': farmerId});
    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? location,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) return false;

    print("📤 Sending update to server:");
    print({
      'id': farmerId,
      'name': name,
      'email': email,
      'phoneNumber': phone,
      'location': location,
    });

    final response = await _dio.post(
      'farmer/update_profile',
      data: {
        'id': farmerId,
        'name': name,
        'email': email,
        'phoneNumber': phone,
        'location': location,
      },
    );

    print("✅ Response: ${response.statusCode} - ${response.data}");

    return response.statusCode == 200;
  }
}

import 'package:dio/dio.dart';

class AuthController {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // خريطة تسجيل الدخول حسب الدور
  final Map<String, String> loginEndpoints = {
    'مزارع': 'farmer/sign_in',
    'تاجر': 'merchant/sign_in',
    'مفتش جودة': 'quality/sign_in_in_quality',
    'شركة شحن': 'shipment/sign_in_in_shipment',
  };

  // خريطة تسجيل الحساب حسب الدور
  final Map<String, String> signUpEndpoints = {
    'مزارع': 'farmer/sign_up',
    'تاجر': 'merchant/sign_up',
    'مفتش جودة': 'quality/sign_up_in_quality',
    'شركة شحن': 'shipment/sign_up_in_shipment',
  };

  // تسجيل الدخول
  Future<Response?> signIn({
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      final endpoint = loginEndpoints[role];
      if (endpoint == null) throw Exception("Invalid role: $role");

      final response = await dio.post(
        endpoint,
        data: {'email': email, 'password': password},
      );

      return response;
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  // تسجيل الحساب
  Future<Response?> signUp({
    required String role,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final endpoint = signUpEndpoints[role];
      if (endpoint == null) throw Exception("Invalid role: $role");

      final response = await dio.post(
        endpoint,
        data: {
          'name': name,
          'email': email,
          'phoneNumber': int.tryParse(phoneNumber),
          'password': password,
        },
      );

      return response;
    } catch (e) {
      print('❌ Signup error: $e');
      return null;
    }
  }
}

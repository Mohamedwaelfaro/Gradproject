import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<Response?> addProduct({
    required String name,
    required String type,
    required int price,
    required String description,
    required File imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerId = prefs.getInt('farmer_id');

      if (farmerId == null) {
        throw Exception('لم يتم العثور على ID المزارع');
      }

      final formData = FormData.fromMap({
        'farmer': farmerId.toString(),
        'name': name,
        'typeofproduct': type,
        'price': price,
        'description': description,
        'product_image': await MultipartFile.fromFile(imageFile.path),
      });
      // ✅ اطبع البيانات قبل الإرسال
      print('📦 Sending Product Data:');
      for (var field in formData.fields) {
        print('${field.key}: ${field.value}');
      }

      final response = await _dio.post('farmer/add_product', data: formData);
      return response;
    } catch (e) {
      print('❌ Error while adding product: $e');
      return null;
    }
  }
}

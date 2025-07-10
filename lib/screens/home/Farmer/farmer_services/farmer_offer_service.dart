import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<dynamic>> fetchFarmerProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerId = prefs.getInt('farmer_id');
      if (farmerId == null) throw Exception('❌ Farmer ID غير موجود');

      final response = await _dio.post(
        'farmer/view_products',
        data: {"id": farmerId},
      );

      if (response.statusCode == 200 && response.data is List) {
        return response.data;
      } else {
        throw Exception('⚠️ فشل في تحميل المنتجات');
      }
    } catch (e) {
      print('❌ خطأ في تحميل المنتجات: $e');
      return [];
    }
  }

  Future<bool> removeProduct(int offerId) async {
    try {
      final response = await _dio.post(
        'farmer/removeProduct',
        data: {"id": offerId},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      print('📤 حذف المنتج - Status: ${response.statusCode}');
      print('🔁 Response Data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ خطأ أثناء حذف المنتج: $e');
      return false;
    }
  }
}

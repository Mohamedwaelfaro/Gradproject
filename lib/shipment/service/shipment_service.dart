import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShipmentOrderService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<dynamic>> fetchReceivedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final merchantId = prefs.getInt('merchant_id');

    if (merchantId == null) throw Exception('Merchant ID not found');

    final response = await _dio.post(
      'merchant/recived_orders_in_merchant',
      data: {'id': merchantId},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('فشل في تحميل الطلبات');
    }
  }
}

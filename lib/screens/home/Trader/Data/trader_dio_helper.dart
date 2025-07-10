import 'package:dio/dio.dart';

class TraderDioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/merchant/',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// ✅ جلب المنتجات المتاحة للتاجر
  static Future<List<Map<String, dynamic>>> getAllProducts({
    required int merchantId,
  }) async {
    try {
      final response = await _dio.post(
        'getAllProduct/5', // تأكد أن هذا الـ endpoint صحيح لـ merchantId
        data: {'id': merchantId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data;
        return rawData.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception("فشل في جلب المنتجات: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ خطأ في جلب المنتجات: $e");
    }
  }

  static Future<Response> addToFavorites({
    required int merchantId,
    required int productId,
  }) async {
    try {
      final response = await _dio.post(
        'addToFav',
        data: {"merchant": merchantId, "Product": productId},
      );
      return response;
    } catch (e) {
      throw Exception("❌ خطأ أثناء الإضافة إلى المفضلة: $e");
    }
  }

  static Future<List<dynamic>> viewFavorites({required int merchantId}) async {
    try {
      final response = await _dio.post(
        'viewFav',
        data: {'merchant': merchantId},
      );

      if (response.statusCode == 200 && response.data is List) {
        return response.data;
      } else {
        throw Exception(
          "❌ البيانات غير متوقعة أو خطأ في الاستجابة: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("❌ خطأ أثناء جلب المفضلة: $e");
    }
  }

  /// 🗑️ حذف منتج من المفضلة
  static Future<Map<String, dynamic>> removeFavorite({
    required int productId,
    required int merchantId,
  }) async {
    try {
      final response = await _dio.delete(
        'deletefromFav',
        data: {
          'Product': productId, // بحرف كبير زي الباك
          'merchant': merchantId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 204) {
        return {'success': true, 'message': 'تم الحذف بنجاح'};
      } else {
        print(
          "⚠️ فشل حذف المنتج من المفضلة. الكود: ${response.statusCode}, الرسالة: ${response.data}",
        );
        return {'success': false, 'message': 'فشل حذف المنتج من المفضلة'};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ خطأ Dio أثناء حذف المفضلة: ${e.response?.data}");
        return {
          'success': false,
          'message': 'خطأ في الخادم: ${e.response?.data}',
        };
      } else {
        print("❌ خطأ أثناء حذف المفضلة: $e");
        return {'success': false, 'message': 'حدث خطأ غير متوقع: $e'};
      }
    } catch (e) {
      print("❌ خطأ عام أثناء حذف المفضلة: $e");
      return {'success': false, 'message': 'حدث خطأ عام أثناء الحذف'};
    }
  }

  static Future<Response> cartMethod({
    required int merchantId,
    required int productId,
    int quantity = 1,
    required String method, // 'POST', 'PUT', 'DELETE'
  }) async {
    try {
      final data = {
        'merchant': merchantId,
        'Product': productId,
        'quantity': quantity,
      };

      late Response response;

      if (method == 'POST') {
        response = await _dio.post('CartMethods', data: data);
      } else if (method == 'PUT') {
        response = await _dio.put('CartMethods', data: data);
      } else if (method == 'DELETE') {
        response = await _dio.delete(
          'CartMethods',
          data: data,
          options: Options(contentType: Headers.jsonContentType),
        );
      } else {
        throw Exception("❌ طريقة غير مدعومة: $method");
      }

      return response;
    } catch (e) {
      throw Exception("❌ خطأ أثناء تنفيذ عملية السلة: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> viewCart({
    required int merchantId,
  }) async {
    try {
      final response = await _dio.post(
        'viewCart',
        data: {'merchant': merchantId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map &&
            response.data['message'] == 'Cart is empty') {
          return []; // سلة فاضية
        } else {
          throw Exception("بيانات غير متوقعة من السيرفر");
        }
      } else {
        throw Exception("فشل في جلب السلة: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ في جلب السلة: $e");
      throw Exception("حدث خطأ أثناء تحميل السلة");
    }
  }
}

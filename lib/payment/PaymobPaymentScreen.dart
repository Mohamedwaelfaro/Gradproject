import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class PaymobPaymentScreen extends StatelessWidget {
  final String paymentToken;

  const PaymobPaymentScreen({super.key, required this.paymentToken});

  Future<void> _handleSuccessfulPayment(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final merchantId = prefs.getInt('merchant_id');
    final cartItems =
        prefs.getStringList('cart_items') ?? []; // مفروض تكون محفوظه

    try {
      final response = await Dio().post(
        'http://192.168.1.3:8000/merchant/purchase',
        data: {'merchant_id': merchantId, 'products': cartItems},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم تسجيل الشراء بنجاح')),
        );
        Navigator.pop(context); // ارجع الشاشة السابقة
      } else {
        throw Exception("فشل تسجيل الشراء");
      }
    } catch (e) {
      debugPrint('❌ خطأ أثناء استدعاء API الشراء: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ فشل في تسجيل الطلب بعد الدفع')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String iframeUrl =
        'https://accept.paymob.com/api/acceptance/iframes/926704?payment_token=$paymentToken';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إتمام الدفع'),
          backgroundColor: Colors.green,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(iframeUrl)),
          onLoadStop: (controller, url) {
            debugPrint("✅ Finished loading: $url");

            // ✅ افحص هل الرابط فيه نجاح
            if (url != null && url.toString().contains("approved")) {
              _handleSuccessfulPayment(context);
            }
          },
          onLoadError: (controller, url, code, message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ أثناء تحميل صفحة الدفع')),
            );
          },
        ),
      ),
    );
  }
}

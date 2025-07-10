import 'package:mahsoly_app1/payment/paymob_constants.dart';

import 'dio_helper.dart';

class PaymobApiService {
  static Future<String> getAuthToken() async {
    final response = await DioHelper.postData(
      url: '/auth/tokens',
      data: {'api_key': PaymobConstants.apiKey},
    );

    return response.data['token'];
  }

  static Future<int> createOrder({
    required String token,
    required int amountCents,
  }) async {
    final response = await DioHelper.postData(
      url: '/ecommerce/orders',
      data: {
        'auth_token': token,
        'delivery_needed': false,
        'amount_cents': amountCents,
        'currency': 'EGP',
        'items': [],
      },
    );

    return response.data['id'];
  }

  static Future<String> getPaymentKey({
    required String token,
    required int amountCents,
    required int orderId,
    required int integrationId,
  }) async {
    final response = await DioHelper.postData(
      url: '/acceptance/payment_keys',
      data: {
        'auth_token': token,
        'amount_cents': amountCents,
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': {
          "apartment": "NA",
          "email": "test@example.com",
          "floor": "NA",
          "first_name": "test",
          "street": "NA",
          "building": "NA",
          "phone_number": "01111111111",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": "test",
          "state": "NA",
        },
        'currency': 'EGP',
        'integration_id': integrationId,
      },
    );

    return response.data['token'];
  }
}

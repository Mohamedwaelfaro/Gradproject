import 'package:flutter/material.dart';
import 'package:mahsoly_app1/payment/PaymobPaymentScreen.dart';
import '../payment/paymob_api_service.dart';
import '../payment/paymob_constants.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;

  const PaymentScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final ts = MediaQuery.of(context).textScaleFactor;

    int amountCents = (totalPrice * 100).round(); // ✅ تحويل للمليم

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // Header
            Container(
              height: sh * 0.28,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'imgs/istockphoto-1221724425-612x612 1.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green.withOpacity(0.7),
                      Colors.green.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // White Curve
            Positioned(
              top: sh * 0.18,
              left: 0,
              right: 0,
              child: Container(
                height: sh * 0.13,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
              ),
            ),

            // Title
            Positioned(
              top: sh * 0.11,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'الدفع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * ts,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Payment Methods
            Padding(
              padding: EdgeInsets.only(top: sh * 0.23),
              child: Column(
                children: [
                  Text(
                    'طرق الدفع',
                    style: TextStyle(
                      fontSize: 22 * ts,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: sh * 0.03),

                  // Vodafone Cash
                  GestureDetector(
                    onTap: () async {
                      final token = await PaymobApiService.getAuthToken();
                      final orderId = await PaymobApiService.createOrder(
                        token: token,
                        amountCents: amountCents,
                      );
                      final paymentToken = await PaymobApiService.getPaymentKey(
                        token: token,
                        amountCents: amountCents,
                        orderId: orderId,
                        integrationId: PaymobConstants.integrationWalletId,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymobPaymentScreen(
                                paymentToken: paymentToken,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: sw * 0.08),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'imgs/Coverage-Page-400x200-27 1.png',
                        height: sh * 0.08,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.03),

                  // Visa Card
                  GestureDetector(
                    onTap: () async {
                      final token = await PaymobApiService.getAuthToken();
                      final orderId = await PaymobApiService.createOrder(
                        token: token,
                        amountCents: amountCents,
                      );
                      final paymentToken = await PaymobApiService.getPaymentKey(
                        token: token,
                        amountCents: amountCents,
                        orderId: orderId,
                        integrationId: PaymobConstants.integrationCardId,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PaymobPaymentScreen(
                                paymentToken: paymentToken,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: sw * 0.08),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3949AB), Color(0xFF512DA8)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'imgs/fon-logo-logo-blue-visa-fon-viza 1.png',
                        height: sh * 0.06,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

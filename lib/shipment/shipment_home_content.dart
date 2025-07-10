import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mahsoly_app1/screens/home/Farmer/widgets/interactive_feature_card.dart';
import 'package:mahsoly_app1/shipment/ShipmentProductQualityScreen.dart';
import 'package:mahsoly_app1/shipment/shipment_appbar.dart';
import 'package:mahsoly_app1/shipment/shipment_received_orders_screen.dart';
import 'package:mahsoly_app1/shipment/shipment_stats_screen.dart';

class ShipmentHomeContent extends StatelessWidget {
  const ShipmentHomeContent({super.key});

  static final List<Map<String, dynamic>> _featureCardData = [
    {
      'title': 'الطلبات المستلمة',
      'icon': Icons.inventory_2_outlined,
      'color1': Color(0xFF2C3E50),
      'color2': Color(0xFF34495E),
      'screen': ShipmentReceivedOrdersScreen(),
    },
    {
      'title': 'جودة المنتجات',
      'icon': Icons.verified_user_outlined,
      'color1': Color(0xFF16A085),
      'color2': Color(0xFF1ABC9C),
      'screen': ShipmentProductQualityScreen(),
    },
    {
      'title': 'إحصائيات وتقارير',
      'icon': Icons.bar_chart,
      'color1': Color(0xFF8E44AD),
      'color2': Color(0xFF9B59B6),
      'screen': ShipmentStatsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ts = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const ShipmentAppBar(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '"إدارة الطلبات والجودة بسهولة من لوحة التاجر"',
                      style: TextStyle(
                        fontSize: 15 * ts,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimationLimiter(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _featureCardData.length,
                  itemBuilder: (context, index) {
                    final item = _featureCardData[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 475),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: InteractiveFeatureCard(
                            title: item['title'],
                            icon: item['icon'],
                            gradientColors: [item['color1'], item['color2']],
                            onTap:
                                item['screen'] != null
                                    ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => item['screen'],
                                        ),
                                      );
                                    }
                                    : () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'هذه الميزة ستكون متاحة قريباً!',
                                          ),
                                        ),
                                      );
                                    },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

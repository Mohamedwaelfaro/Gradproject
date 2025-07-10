import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_add_product_screen.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_offer_screen.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_stats_screen.dart';
import 'package:mahsoly_app1/screens/home/Farmer/widgets/farmer_app_bar.dart';
import 'package:mahsoly_app1/screens/home/Farmer/widgets/interactive_feature_card.dart'; // تأكد من أن هذا المسار صحيح

class FarmerHomeContent extends StatelessWidget {
  const FarmerHomeContent({super.key});

  // البيانات النهائية باستخدام الأيقونات
  static final List<Map<String, dynamic>> _featureCardData = [
    {
      'title': 'إضافة محصول جديد',
      'icon': Icons.add_circle_outline_rounded,
      'color1': const Color(0xFF1E824C),
      'color2': const Color(0xFF2ECC71),
      'screen': FarmerAddProductScreen(),
    },
    {
      'title': 'إدارة المحاصيل',
      'icon': Icons.article_outlined,
      'color1': const Color(0xFFD35400),
      'color2': const Color(0xFFE67E22),
      'screen': const FarmerOffer_screen(),
    },
    {
      'title': 'إحصائيات وتقارير',
      'icon': Icons.bar_chart_rounded,
      'color1': const Color(0xFF8E44AD),
      'color2': const Color(0xFF9B59B6),
      'screen': FarmerStatsScreen(),
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
            const FarmerAppBar(),
            const SizedBox(height: 24),
            // النص الترحيبي المُحسَّن
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.eco_rounded, color: Colors.green, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '"نحن هنا لمساعدتك في تسويق منتجاتك بأفضل طريقة"',
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
            // GridView مع الحركات التفاعلية
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

import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Driver/driver_details_screen.dart';

class DriverInfo {
  final String id;
  final String price;
  final String eta;
  final String location;
  final String truckImageUrl; // Placeholder for truck image

  DriverInfo({
    required this.id,
    required this.price,
    required this.eta,
    required this.location,
    required this.truckImageUrl,
  });
}

class AvailableVehiclesScreen extends StatelessWidget {
  AvailableVehiclesScreen({super.key});

  // بيانات مثال
  final List<DriverInfo> _drivers = [
    DriverInfo(
      id: '1',
      price: '3000 جنيه',
      eta: 'يصل خلال 3 ايام',
      location: 'اسيوط',
      truckImageUrl: 'imgs/truck_red.png',
    ), // استبدل بالمسارات الصحيحة
    DriverInfo(
      id: '2',
      price: '2500 جنيه',
      eta: 'يصل خلال 5 ايام',
      location: 'سوهاج',
      truckImageUrl: 'imgs/truck_white.png',
    ),
    DriverInfo(
      id: '3',
      price: '4000 جنيه',
      eta: 'يصل خلال يومان',
      location: 'المنيا',
      truckImageUrl: 'imgs/truck_blue.png',
    ),
    DriverInfo(
      id: '4',
      price: '3000 جنيه',
      eta: 'يصل خلال 3 ايام',
      location: 'اسيوط',
      truckImageUrl: 'imgs/truck_red.png',
    ),
    DriverInfo(
      id: '5',
      price: '2500 جنيه',
      eta: 'يصل خلال يومان',
      location: 'سوهاج',
      truckImageUrl: 'imgs/truck_white.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الخريطة مع المسار (Placeholder)
          Container(
            color: Colors.grey[800], // لون الخريطة الغامق
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.route_outlined,
                  size: screenWidth * 0.8,
                  color: Colors.grey[600],
                ),
              ), // أيقونة مسار مؤقتة
            ),
          ),
          // أيقونة سهم للخلف في الأعلى
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          // أيقونة سيارة صفراء على المسار (Placeholder)
          Positioned(
            top: screenWidth * 0.15,
            left: screenWidth * 0.3,
            child: Icon(
              Icons.local_shipping,
              color: Colors.yellow.shade600,
              size: 35,
            ),
          ),
          // أيقونة الدبوس في الأسفل (Placeholder)
          Positioned(
            bottom:
                MediaQuery.of(context).size.height *
                0.65, // تعديل الارتفاع ليكون فوق القائمة
            left: screenWidth * 0.5 - 15, // للتوسيط
            child: Icon(
              Icons.location_pin,
              color: Colors.yellow.shade600,
              size: 40,
            ),
          ),

          // قائمة السائقين
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.6, // ارتفاع القائمة
              decoration: BoxDecoration(
                color: Colors.green.shade700, // لون الخلفية الرئيسي للقائمة
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 10,
                  left: 10,
                  bottom: 10,
                ),
                itemCount: _drivers.length,
                itemBuilder: (context, index) {
                  final driver = _drivers[index];
                  // لتغيير لون الخلفية بشكل متبادل
                  final cardColor =
                      index % 2 == 0
                          ? Colors.green.shade600
                          : Colors.orange.shade600;

                  return InkWell(
                    onTap: () {
                      // TODO: Navigate to driver details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  DriverDetailsScreen(driverId: driver.id),
                        ), // افترض وجود شاشة تفاصيل السائق
                      );
                    },
                    child: Card(
                      color: cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.price,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    driver.eta,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Text(
                                driver.location,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              driver.truckImageUrl, // استخدم مسار صورة الشاحنة
                              width: screenWidth * 0.18, // عرض الشاحنة
                              height: screenWidth * 0.1,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (ctx, err, st) => Icon(
                                    Icons.local_shipping,
                                    color: Colors.white,
                                    size: screenWidth * 0.1,
                                  ),
                            ),
                          ],
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
    );
  }
}

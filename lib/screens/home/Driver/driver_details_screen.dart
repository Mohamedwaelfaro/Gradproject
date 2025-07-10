import 'package:flutter/material.dart';

class DriverDetailsScreen extends StatelessWidget {
  final String driverId; // لتحديد أي سائق سيتم عرضه (يمكن جلب بياناته لاحقًا)

  const DriverDetailsScreen({super.key, required this.driverId});

  void _showBookingSuccessDialog(BuildContext context) {
    // هذا هو الديالوج الذي يظهر في image_57f032.png
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاقه بالضغط خارج الديالوج
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green.shade700,
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "تم الحجز بنجاح",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "لقد تم تأكيد الحجز الخاص بك. سوف يأتي السائق لاستلام الشحنة خلال 4 ايام.",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); // أغلق الديالوج فقط
                      },
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); // أغلق الديالوج
                        // TODO: يمكنك هنا الانتقال إلى شاشة تتبع الطلب أو الشاشة الرئيسية
                        // Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "تم",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // بيانات مثال للسائق، يجب جلبها بناءً على driverId
    const driverName = "احمد علي";
    const driverLocation = "الأقصر";
    const driverPrice = "2500";
    const driverEta = "الوصول التقريبي:\nخلال 4 ايام";
    const driverImageUrl = 'imgs/driver_profile.png'; // استبدل بالمسار الصحيح
    const truckImageUrl = 'imgs/truck_red_large.png'; // استبدل بالمسار الصحيح

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الخريطة مع المسار (Placeholder)
          Container(
            color: Colors.grey[800],
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.route_outlined,
                  size: screenWidth * 0.8,
                  color: Colors.grey[600],
                ),
              ),
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
            bottom: MediaQuery.of(context).size.height * 0.65,
            left: screenWidth * 0.5 - 15,
            child: Icon(
              Icons.location_pin,
              color: Colors.yellow.shade600,
              size: 40,
            ),
          ),

          // كارت تفاصيل السائق في الأسفل
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6, // ارتفاع الكارت
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.green.shade700, // لون الخلفية
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // لمحاذاة المحتوى لليمين
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            driverName,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                driverLocation,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          driverImageUrl,
                        ), // صورة السائق
                        onBackgroundImageError:
                            (e, s) => Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Image.asset(
                        truckImageUrl, // صورة الشاحنة
                        width: screenWidth * 0.4,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (ctx, err, st) => Icon(
                              Icons.local_shipping,
                              color: Colors.white,
                              size: screenWidth * 0.2,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          driverPrice,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    driverEta,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement reject logic
                            Navigator.pop(
                              context,
                            ); // ارجع لقائمة السائقين مثلاً
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade600,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "رفض",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement accept logic
                            _showBookingSuccessDialog(
                              context,
                            ); // عرض ديالوج النجاح
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "قبول",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

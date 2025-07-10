import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_notification_screen.dart';

const kPrimaryGreen = Color(0xFF4CAF50);

class FarmerAppBar extends StatelessWidget {
  const FarmerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = MediaQuery.of(context).textScaleFactor;

    return Row(
      children: [
        // Notification Icon
        Container(
          padding: const EdgeInsets.all(10), // تعديل الحشو الداخلي قليلًا
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14), // زيادة استدارة الحواف
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // تعديل شفافية الظل
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerNotificationScreen(),
                ),
              );
            },
            child: Icon(
              Icons.notifications_none_outlined,
              color: Colors.grey.shade700,
              size: 26 * ts, // تعديل حجم الأيقونة
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Search Bar
        Expanded(
          child: SizedBox(
            // للتحكم في ارتفاع شريط البحث بشكل أفضل
            height: 48 * ts, // تحديد ارتفاع ثابت نسبيًا
            child: TextField(
              textAlign: TextAlign.right, // لجعل الكتابة تبدأ من اليمين
              textDirection: TextDirection.rtl, // لضمان محاذاة المحتوى لليمين
              style: TextStyle(fontSize: 14 * ts),
              decoration: InputDecoration(
                hintText: 'Hinted search text', // النص المؤقت من الصورة
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14 * ts,
                ),
                filled: true,
                fillColor: Colors.white,
                // تغيير ترتيب الأيقونة لتكون على اليسار والنص على اليمين (بسبب RTL)
                prefixIcon: Padding(
                  // استخدام prefix بسبب RTL
                  padding: const EdgeInsets.only(
                    left: 14.0,
                    right: 8.0,
                  ), // تعديل الحشو
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 22 * ts, // تعديل حجم أيقونة البحث
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  // ضبط الحشو الداخلي
                  vertical: 10.0 * ts, // تقليل الحشو العمودي قليلًا
                  horizontal: 0, // الحشو الأفقي يتم التحكم به عبر prefixIcon
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: kPrimaryGreen.withOpacity(0.7),
                    width: 1.5,
                  ), // تعديل لون الحدود عند التركيز
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Location/Filter
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10 * ts,
            vertical: 9 * ts,
          ), // تعديل الحشو
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25), // نفس استدارة شريط البحث
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                // أيقونة الفلتر/القائمة
                Icons.list_outlined, // أو Icons.filter_list_alt_outlined
                color: Colors.grey.shade700,
                size: 20 * ts, // تعديل حجم الأيقونة
              ),
              const SizedBox(width: 5),
              Text(
                "مصر",
                style: TextStyle(
                  fontSize: 13.5 * ts, // تعديل حجم الخط
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600, // زيادة سمك الخط قليلاً
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                // أيقونة الموقع (الدبوس)
                Icons.location_pin,
                color: kPrimaryGreen, // اللون الأخضر
                size: 18 * ts, // تعديل حجم الأيقونة
              ),
            ],
          ),
        ),
      ],
    );
  }
}

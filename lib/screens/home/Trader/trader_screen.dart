import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Trader/cart_screen.dart';
import 'package:mahsoly_app1/screens/home/Trader/favourite_screen.dart';
import 'package:mahsoly_app1/screens/home/Trader/trader_content.dart';
import 'package:mahsoly_app1/screens/profile/profile_screen.dart';

// تم إعادة تسميته ليعكس أنه شاشة التاجر الرئيسية مع شريط تنقل
class TraderHomeScreen extends StatefulWidget {
  const TraderHomeScreen({super.key});

  @override
  State<TraderHomeScreen> createState() => _TraderHomeScreenState();
}

class _TraderHomeScreenState extends State<TraderHomeScreen> {
  // يبدأ من الصفر لعرض الشاشة الرئيسية أولاً
  int _selectedIndex = 0;

  // قائمة الشاشات مرتبة بشكل منطقي
  // تأكد من أن FavouriteScreen موجودة ومستوردة بشكل صحيح
  final List<Widget> _screens = [
    HomeContent(), // 0: الرئيسية
    CartScreen(), // 1: السلة
    FavouriteScreen(), // 2: المفضلة
    ProfileScreen(), // 3: الحساب
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // عرض الشاشة التي تطابق الفهرس المحدد
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // --- تحسينات على التصميم ---
          type: BottomNavigationBarType.fixed, // يضمن ظهور كل الأيقونات والنصوص
          selectedItemColor: Colors.green, // لون الأيقونة النشطة
          unselectedItemColor: Colors.grey, // لون الأيقونات غير النشطة
          showSelectedLabels: true, // إظهار النص تحت الأيقونة النشطة
          showUnselectedLabels: true, // إظهار النص تحت الأيقونات غير النشطة
          // قائمة الأيقونات الآن مطابقة ومنظمة مع قائمة الشاشات
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(
                Icons.home,
              ), // أيقونة مختلفة عند التفعيل (اختياري)
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

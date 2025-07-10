import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahsoly_app1/screens/home/Driver/AvailableVehiclesScreen.dart';

class SearchingDriverScreen extends StatefulWidget {
  final String? pickupLocation;
  final String? destination;
  final String? productName;
  final double? price;

  const SearchingDriverScreen({
    super.key,
    this.pickupLocation,
    this.destination,
    this.productName,
    this.price,
  });

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with SingleTickerProviderStateMixin {
  String _loadingText = "البحث عن سائق";
  int _dotCount = 0;
  Timer? _timer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // تحديث النص المتحرك "..."
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
        _loadingText = "البحث عن سائق${'.' * _dotCount}";
      });
    });

    // الانتقال التلقائي بعد فترة زمنية (مثلاً 3-5 ثواني)
    _navigationTimer = Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AvailableVehiclesScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF4A4A4A), // لون خلفية الخريطة
      body: Stack(
        children: [
          // خلفية الخريطة (عنصر نائب)
          Container(
            color: const Color(0xFF4A4A4A),
            child: Center(
              child: Icon(
                Icons.location_pin,
                color: Colors.yellow[600],
                size: 50,
              ),
            ),
          ),

          // سهم الرجوع (إذا أردت إلغاء البحث)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context); // يرجع إلى SelectLocationScreen
                  }
                },
                tooltip: 'رجوع',
              ),
            ),
          ),

          // اللوحة السفلية
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.4, // يمكن تعديل الارتفاع
              width: screenWidth,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF5CB85C).withOpacity(0.95), // أخضر مشابه للصورة
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Center(
                child: Text(
                  _loadingText,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

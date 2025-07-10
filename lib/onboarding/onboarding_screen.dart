import 'package:flutter/material.dart';

import 'package:mahsoly_app1/onboarding/widgets.dart';
import 'package:mahsoly_app1/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnboardingPage(
                  title: 'مرحبا بك!',
                  description: '',
                  image: 'imgs/Group 1.png',
                ),
                OnboardingPage(
                  title: 'مميزات التطبيق',
                  description: 'هنا يمكنك استكشاف مزايا التطبيق.',
                  image: 'assets/images/second_screen.png',
                ),
                OnboardingPage(
                  title: 'ابدأ الآن!',
                  description: 'استمتع بتجربة التطبيق بعد التسجيل.',
                  image: 'assets/images/third_screen.png',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (_pageController.page == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ), // الانتقال إلى تسجيل الدخول
                  );
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E7B1D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'YourCustomFont',
                ),
                elevation: 10,
                shadowColor: Colors.greenAccent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white),
                  SizedBox(width: 10),
                  Text('التالي', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

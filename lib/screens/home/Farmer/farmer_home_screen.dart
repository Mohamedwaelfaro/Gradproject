import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_home_content.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_profile/profile_farmar_screen.dart';
import 'package:mahsoly_app1/screens/home/Farmer/widgets/farmer_bottom_nav_bar.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int currentIndex = 1; // 1 = Home

  final List<Widget> screens = const [
    ProfileFarmerScreen(),
    FarmerHomeContent(),
    // FarmerAddProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: FarmerBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

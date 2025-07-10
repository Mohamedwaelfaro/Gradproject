import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_profile/profile_farmar_screen.dart';
import 'package:mahsoly_app1/shipment/shipment_home_content.dart';
import 'package:mahsoly_app1/shipment/shipment_received_orders_screen.dart';
import 'package:mahsoly_app1/shipment/widgets%20copy/shipment_bottom_nav_bar.dart';

class ShipmentHomeScreen extends StatefulWidget {
  const ShipmentHomeScreen({super.key});

  @override
  State<ShipmentHomeScreen> createState() => _ShipmentHomeScreenState();
}

class _ShipmentHomeScreenState extends State<ShipmentHomeScreen> {
  int currentIndex = 1; // 1 = Home

  final List<Widget> screens = const [
    ProfileFarmerScreen(),
    ShipmentHomeContent(),
    ShipmentReceivedOrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: ShipmetBottomNavBar(
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

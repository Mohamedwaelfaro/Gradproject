import 'package:flutter/material.dart';

const kPrimaryGreen = Color(0xFF4CAF50);
const kLightGreenAccent = Color(0xFFE8F5E9);

class ShipmetBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ShipmetBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ts = MediaQuery.of(context).textScaleFactor;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: kPrimaryGreen,
      unselectedItemColor: Colors.grey.shade500,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8.0,
      iconSize: 24 * ts,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded, size: 26 * ts),
          activeIcon: Container(
            padding: EdgeInsets.all(6 * ts),
            decoration: const BoxDecoration(
              color: kLightGreenAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: kPrimaryGreen,
              size: 30 * ts,
            ),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_filled),
          label: '',
        ),
      ],
    );
  }
}

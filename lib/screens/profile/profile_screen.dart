import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/auth/login_screen.dart';
import 'package:mahsoly_app1/screens/profile/account_screen.dart'
    show AccountScreen;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final ts = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100, // Lighter background color
        body: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              height: sh * 0.3,
              padding: EdgeInsets.only(top: sh * 0.07),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50), // Green color from the design
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0), // No bottom border radius
                  bottomRight: Radius.circular(0), // No bottom border radius
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('imgs/User 07b.png'),
                  ),
                  SizedBox(height: sh * 0.015),
                  Text(
                    'احمد محمد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20 * ts,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '0116275257', // Updated phone number as per design
                    style: TextStyle(color: Colors.white70, fontSize: 14 * ts),
                  ),
                ],
              ),
            ),

            // MENU OPTIONS
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.04,
                  vertical: sh * 0.02,
                ),
                children: [
                  _buildOption(context, 'حسابي', Icons.person_outline, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ),
                    );
                  }),
                  _buildOption(
                    context,
                    'العروض التي قدمتها',
                    Icons.star_border, // Changed icon to match design
                    () {},
                  ),
                  _buildOption(
                    context,
                    'سياسة الخصوصية',
                    Icons.privacy_tip_outlined,
                    () {},
                  ),
                  _buildOption(
                    context,
                    'مركز المساعدة',
                    Icons.help_outline,
                    () {},
                  ),
                  _buildOption(context, 'قيمنا', Icons.star_border, () {}),
                ],
              ),
            ),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFE0E0E0,
                  ), // Light grey from design
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ), // Added padding for better alignment
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Distribute space
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ), // Logout icon
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.black, fontSize: 16 * ts),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ), // Arrow icon
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final ts = MediaQuery.of(context).textScaleFactor;
    return Card(
      elevation: 0, // No elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Rounded corners
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        // Use InkWell for tap effect
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.black54,
              ), // Icon on the left (trailing in RTL context)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right, // Text aligned to the right
                  style: TextStyle(
                    fontSize: 16 * ts,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
                size: 16,
              ), // Arrow on the right (leading in RTL context)
            ],
          ),
        ),
      ),
    );
  }
}

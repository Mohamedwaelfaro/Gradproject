import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:mahsoly_app1/screens/auth/login_screen.dart';
import 'package:mahsoly_app1/screens/profile/account_screen.dart'
    show AccountScreen;

class ProfileFarmerScreen extends StatefulWidget {
  const ProfileFarmerScreen({super.key});

  @override
  State<ProfileFarmerScreen> createState() => _ProfileFarmerScreenState();
}

class _ProfileFarmerScreenState extends State<ProfileFarmerScreen> {
  String name = '';
  String phone = '';
  bool isLoading = true;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) return;

    try {
      final response = await _dio.post(
        'farmer/profile',
        data: {"id": farmerId},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          name = data['name'] ?? '';
          phone = data['phoneNumber'].toString();
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ فشل في تحميل البيانات: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final ts = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // HEADER
                    Container(
                      width: double.infinity,
                      height: sh * 0.3,
                      padding: EdgeInsets.only(top: sh * 0.07),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
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
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * ts,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            phone,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14 * ts,
                            ),
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
                          _buildOption(
                            context,
                            'حسابي',
                            Icons.person_outline,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountScreen(),
                                ),
                              );
                            },
                          ),
                          _buildOption(
                            context,
                            'العروض التي قدمتها',
                            Icons.star_border,
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
                          _buildOption(
                            context,
                            'قيمنا',
                            Icons.star_border,
                            () {},
                          ),
                        ],
                      ),
                    ),

                    // LOGOUT BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0E0E0),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.logout, color: Colors.black),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16 * ts,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 16,
                            ),
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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.black54),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16 * ts,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

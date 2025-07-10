import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AccountFarmerScreen extends StatefulWidget {
  const AccountFarmerScreen({super.key});

  @override
  State<AccountFarmerScreen> createState() => _AccountFarmerScreenState();
}

class _AccountFarmerScreenState extends State<AccountFarmerScreen> {
  bool _isEditing = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = true;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await _dio.post(
        'farmer/profile',
        data: {"id": farmerId},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          usernameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phoneNumber'].toString();
          addressController.text = data['location'] ?? '';
          passwordController.text =
              '*********'; // Not fetched, placeholder only
          _isLoading = false;
        });
      }
    } catch (e) {
      print("❌ خطأ في جلب البيانات: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfileChanges(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) {
      print("❌ farmer_id مش موجود في SharedPreferences");
      return;
    }

    print("📤 جاري إرسال البيانات:");
    print("ID: $farmerId");
    print("Name: ${usernameController.text}");
    print("Email: ${emailController.text}");
    print("Phone: ${phoneController.text}");
    print("Location: ${addressController.text}");

    try {
      final response = await _dio.post(
        'farmer/update_profile',
        data: {
          "id": farmerId,
          "name": usernameController.text,
          "email": emailController.text,
          "phoneNumber": phoneController.text,
          "location": addressController.text,
        },
      );

      print("✅ Response status: ${response.statusCode}");
      print("✅ Response body: ${response.data}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم حفظ التغييرات بنجاح!')),
        );
      } else {
        throw Exception('فشل التحديث');
      }
    } catch (e) {
      print("❌ Exception أثناء الحفظ: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ خطأ أثناء الحفظ: $e')));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
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
        appBar: AppBar(
          backgroundColor: const Color(0xFF4CAF50),
          elevation: 0,
          title: Text(
            'الملف الشخصي',
            style: TextStyle(color: Colors.white, fontSize: 20 * ts),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (_isEditing) {
                  _saveProfileChanges(context);
                }
                setState(() => _isEditing = !_isEditing);
              },
            ),
          ],
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: sh * 0.25,
                        color: const Color(0xFF4CAF50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'imgs/User 07b.png',
                                  ),
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (_isEditing)
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'تغيير الصورة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16 * ts,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sw * 0.05,
                          vertical: sh * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputField(
                              'اسم المستخدم',
                              usernameController,
                              !_isEditing,
                            ),
                            _buildInputField(
                              'البريد الالكتروني',
                              emailController,
                              !_isEditing,
                            ),
                            _buildInputField(
                              'رقم الهاتف',
                              phoneController,
                              !_isEditing,
                            ),
                            _buildInputField(
                              'العنوان',
                              addressController,
                              !_isEditing,
                            ),
                            _buildInputField(
                              'كلمة السر',
                              passwordController,
                              true,
                              isPassword: true,
                            ),
                            if (_isEditing) SizedBox(height: 20),
                            if (_isEditing)
                              ElevatedButton(
                                onPressed: () {
                                  _saveProfileChanges(context);
                                  setState(() => _isEditing = false);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'حفظ التغييرات',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18 * ts,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool isReadOnly, {
    bool isPassword = false,
  }) {
    final ts = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon:
              isPassword && _isEditing
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() => _obscureText = !_obscureText),
                  )
                  : null,
        ),
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 16 * ts, color: Colors.black),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mahsoly_app1/shipment/shipment_hom_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mahsoly_app1/screens/auth/forget_password_screen.dart';
import 'package:mahsoly_app1/screens/auth/sign_up_screen.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_home_screen.dart';
import 'package:mahsoly_app1/screens/home/Trader/trader_screen.dart'; // ✅ تأكد من المسار الصحيح

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  final List<String> roles = ['مزارع', 'تاجر', 'شركة شحن', 'مفتش جودة'];

  final Map<String, String> roleApiMap = {
    'مزارع': 'farmer/sign_in',
    'تاجر': 'merchant/sign_in',
    'شركة شحن': 'shipment/sign_in_in_shipment',
    'مفتش جودة': 'quality/sign_in_in_quality',
  };

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار الدور')));
      return;
    }

    print('🚀 بدء تسجيل الدخول كـ $selectedRole');

    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.3:8000/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      final response = await dio.post(
        roleApiMap[selectedRole]!,
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      print("📥 Response Code: ${response.statusCode}");
      print("📦 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final prefs = await SharedPreferences.getInstance();

        int userId;

        if (data is Map && data.containsKey('id')) {
          userId = data['id'];
          await prefs.setString('user_data', jsonEncode(data));
        } else if (data is int) {
          userId = data;
          await prefs.setString('user_data', jsonEncode({'id': data}));
        } else {
          throw Exception("Unexpected response format: $data");
        }

        // حفظ الـ ID حسب الدور
        switch (selectedRole) {
          case 'مزارع':
            await prefs.setInt('farmer_id', userId);
            break;
          case 'تاجر':
            await prefs.setInt('merchant_id', userId);
            break;
          case 'شركة شحن':
            await prefs.setInt('shipment_id', userId);
            break;
          case 'مفتش جودة':
            await prefs.setInt('quality_id', userId);
            break;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول بنجاح')));

        // الانتقال حسب الدور
        switch (selectedRole) {
          case 'مزارع':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FarmerHomeScreen()),
            );
            break;
          case 'تاجر':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TraderHomeScreen()),
            );
            break;
          case 'شركة شحن':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ShipmentHomeScreen()),
            );
            break;
          case 'مفتش جودة':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TraderHomeScreen()),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('لم يتم تعريف الصفحة لهذا الدور بعد'),
              ),
            );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل تسجيل الدخول')));
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data ?? e.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('خطأ في الاتصال بالخادم')));
    } catch (e) {
      print('❌ General Exception: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ غير متوقع')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'imgs/Login Illustration.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'أهلاً بك في محصولي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          'البريد الإلكتروني أو رقم الهاتف',
                          Icons.email,
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'من فضلك أدخل البريد الإلكتروني أو رقم الهاتف'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: _inputDecoration('كلمة السر', Icons.lock),
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'كلمة السر يجب أن تكون 6 أحرف أو أكثر'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Text('اختر الدور'),
                        items:
                            roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => selectedRole = value),
                        validator:
                            (value) =>
                                value == null ? 'يرجى اختيار الدور' : null,
                        decoration: _inputDecoration('', null),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'نسيت كلمة السر؟',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: handleLogin,
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'ليس لديك حساب؟ إنشاء حساب جديد',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      filled: true,
      fillColor: Colors.green[50],
    );
  }
}

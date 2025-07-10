import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/auth/login_screen.dart';
import 'package:mahsoly_app1/screens/auth/services/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  final List<String> roles = ['مزارع', 'تاجر', 'شركة شحن', 'مفتش جودة'];

  Future<void> handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار الدور')));
      return;
    }

    final phone = phoneController.text.trim();
    if (int.tryParse(phone) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('رقم الهاتف غير صالح')));
      return;
    }

    print("🚀 بدء إنشاء الحساب لدور: $selectedRole");

    final response = await AuthController().signUp(
      role: selectedRole!,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phone,
      password: passwordController.text.trim(),
    );

    if (response != null && response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل في إنشاء الحساب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Image.asset('imgs/Login Illustration.png'),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'أهلاً بك في محصولي',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildField(
                    'الاسم كامل',
                    nameController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'من فضلك أدخل اسمك الكامل'
                                : null,
                  ),
                  buildField(
                    'البريد الإلكتروني',
                    emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك أدخل بريدك الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'بريد إلكتروني غير صالح';
                      }
                      return null;
                    },
                  ),
                  buildField(
                    'رقم الهاتف',
                    phoneController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'من فضلك أدخل رقم الهاتف'
                                : null,
                  ),
                  buildField(
                    'كلمة السر',
                    passwordController,
                    obscure: true,
                    validator:
                        (value) =>
                            value == null || value.length < 6
                                ? 'كلمة السر يجب أن تكون 6 أحرف أو أكثر'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('هل أنت؟', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        roles.map((role) {
                          return ChoiceChip(
                            label: Text(role),
                            selected: selectedRole == role,
                            selectedColor: Colors.green.shade700,
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: TextStyle(
                              color:
                                  selectedRole == role
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                            onSelected: (_) {
                              setState(() {
                                selectedRole = role;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: handleSignUp,
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'لديك حساب بالفعل؟ تسجيل الدخول',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

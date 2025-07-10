import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // متغير لتتبع حالة التعديل
  bool _isEditing = false;

  // Controllers for text fields
  final TextEditingController usernameController = TextEditingController(
    text: 'احمد محمد',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'ahmedmohamed@gmaill.com',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '0116275257',
  );
  final TextEditingController addressController = TextEditingController(
    text: 'القاهرة، مصر',
  ); // Added an initial address
  final TextEditingController passwordController = TextEditingController(
    text: '*********',
  ); // Masked password

  // لتغيير رؤية كلمة السر
  bool _obscureText = true;

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
        backgroundColor: Colors.grey.shade100, // Light background
        appBar: AppBar(
          backgroundColor: const Color(0xFF4CAF50), // Green AppBar
          elevation: 0,
          title: Text(
            'الملف الشخصي', // Changed title to 'الملف الشخصي'
            style: TextStyle(color: Colors.white, fontSize: 20 * ts),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ), // Back arrow (forward in RTL)
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isEditing
                    ? Icons.check
                    : Icons.edit, // تغيير الأيقونة بناءً على حالة التعديل
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    _saveProfileChanges(context);
                  }
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with profile picture
              Container(
                width: double.infinity,
                height: sh * 0.25, // Adjusted height
                color: const Color(0xFF4CAF50), // Green header
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          // Assuming 'imgs/User 07b.png' is the correct path for the user image
                          backgroundImage: AssetImage('imgs/User 07b.png'),
                        ),
                        // زر التعديل على الصورة يظهر فقط في وضع التعديل
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
                                onPressed: () {
                                  // Handle edit profile picture
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: sh * 0.01),
                    // زر تغيير الصورة يظهر فقط في وضع التعديل
                    if (_isEditing)
                      TextButton(
                        onPressed: () {
                          // Handle change photo
                        },
                        child: Text(
                          'تغيير الصورة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * ts,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Input Fields Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.05,
                  vertical: sh * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      context,
                      'اسم المستخدم',
                      usernameController,
                      hintText: 'احمد محمد',
                      keyboardType: TextInputType.name,
                      isReadOnly: !_isEditing, // تحديد حالة القراءة فقط
                    ),
                    _buildInputField(
                      context,
                      'البريد الالكتروني',
                      emailController,
                      hintText: 'ahmedmohamed@gmaill.com',
                      keyboardType: TextInputType.emailAddress,
                      isReadOnly: !_isEditing,
                    ),
                    _buildInputField(
                      context,
                      'رقم الهاتف',
                      phoneController,
                      hintText: '0116275257',
                      keyboardType: TextInputType.phone,
                      isReadOnly: !_isEditing,
                    ),
                    _buildInputField(
                      context,
                      'العنوان',
                      addressController,
                      hintText: 'القاهرة، مصر',
                      keyboardType: TextInputType.streetAddress,
                      isReadOnly: !_isEditing,
                    ),
                    _buildInputField(
                      context,
                      'كلمة السر',
                      passwordController,
                      hintText: '**********',
                      isPassword: true,
                      isReadOnly: !_isEditing,
                    ),

                    SizedBox(height: sh * 0.03),

                    // زر الحفظ يظهر فقط في وضع التعديل
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: () {
                          _saveProfileChanges(context);
                          setState(() {
                            _isEditing =
                                false; // العودة إلى وضع القراءة فقط بعد الحفظ
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF4CAF50,
                          ), // Green button
                          minimumSize: Size(double.infinity, 50),
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
    BuildContext context,
    String label,
    TextEditingController controller, {
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    required bool isReadOnly, // إضافة خاصية تحديد القراءة فقط
  }) {
    final ts = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16 * ts,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right, // Align label to the right
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText:
                isPassword
                    ? _obscureText
                    : false, // استخدم _obscureText للتحكم في الرؤية
            readOnly: isReadOnly, // هنا نستخدم الخاصية الجديدة
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14 * ts,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // No border for the input field
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      _isEditing
                          ? Colors.green
                          : Colors.transparent, // Border only when editing
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              // أيقونة العين تظهر فقط إذا كان الحقل كلمة سر وفي وضع التعديل
              suffixIcon:
                  isPassword && _isEditing
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // تبديل حالة رؤية كلمة السر
                          });
                        },
                      )
                      : null,
            ),
            style: TextStyle(fontSize: 16 * ts, color: Colors.black),
            textAlign: TextAlign.right, // Text input direction for RTL
          ),
        ],
      ),
    );
  }

  // دالة لحفظ التغييرات (يمكنك إضافة منطق حفظ حقيقي هنا)
  void _saveProfileChanges(BuildContext context) {
    print('Saving profile changes...');
    print('Username: ${usernameController.text}');
    print('Email: ${emailController.text}');
    print('Phone: ${phoneController.text}');
    print('Address: ${addressController.text}');
    // لا يجب طباعة كلمة السر مباشرة هنا لأسباب أمنية
    // يمكنك إرسال البيانات إلى API أو حفظها محليًا

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')));
  }
}

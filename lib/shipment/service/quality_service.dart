import 'dart:ui';

class ServiceProviderOption {
  final String id;
  final String companyName;
  final String serviceDescription;
  final String logoAssetPath;
  final String price;
  final String visitDate; // مثال: "14 فبراير" أو "الأربعاء 17 فبراير"
  final String duration;
  final Color backgroundColor; // يستخدم في القائمة السفلية

  ServiceProviderOption({
    required this.id,
    required this.companyName,
    required this.serviceDescription,
    required this.logoAssetPath,
    required this.price,
    required this.visitDate,
    required this.duration,
    required this.backgroundColor,
  });
}

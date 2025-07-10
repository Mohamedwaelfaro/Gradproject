import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Driver/select_location_screen.dart';
import 'package:mahsoly_app1/shipment/quality_check_screen.dart';
import 'package:mahsoly_app1/shipment/shipment_tracking_screen.dart';

class NotificationItem {
  final String id;
  final String title;
  final String statusIcon; // 'check', 'info', 'warning', etc.
  final String imageUrl;
  final String productName;
  final String quantity;
  final double price;
  final String dateCategory;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;

  NotificationItem({
    required this.id,
    required this.title,
    required this.statusIcon,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.dateCategory,
    this.actionButtonText,
    this.onActionPressed,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // قائمة الإشعارات تستخدم النموذج الموحد
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    // تهيئة بيانات الإشعارات عند بدء تشغيل الشاشة
    _initializeNotifications();
  }

  // دالة لتهيئة قائمة الإشعارات الأولية
  void _initializeNotifications() {
    // تم استخدام بيانات من الكود الثاني كمثال
    _notifications = [
      NotificationItem(
        id: 'n1',
        title: 'تم قبول عرضك',
        statusIcon: 'check',
        imageUrl:
            'imgs/tbl_articles_article_17762_957 1.png', // تأكد من أن مسار الصورة صحيح
        productName: 'عنب احمر',
        quantity: '1 طن',
        price: 10000.0,
        dateCategory: 'اليوم',
        actionButtonText: 'انشاء طلب توصيل',
        onActionPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectLocationScreen()),
          );
        },
      ),
      NotificationItem(
        id: 'n2',
        title: 'تم قبول عرضك',
        statusIcon: 'check',
        imageUrl: 'imgs/أفضل_أنواع_الأرز 1.png',
        productName: 'ارز مصري',
        quantity: '1 طن',
        price: 10000.0,
        dateCategory: 'اليوم',
        actionButtonText: '  تتبع الشحنة',
        onActionPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShipmentTrackingScreen()),
          );
        },
      ),
      NotificationItem(
        id: 'n3',
        title: 'نتيجة فحص الجودة',
        statusIcon: 'new_releases',
        imageUrl: 'imgs/القمح-1725709678-0.webp', // استخدم صورة مناسبة
        productName: 'قمح',
        quantity: '10 طن',
        price: 30000.0,
        dateCategory: 'الأمس',
        actionButtonText: 'بدء فحص الجودة',
        onActionPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QualityCheckScreen()),
          );
        },
      ),
    ];
  }

  // دالة لحذف إشعار معين
  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الإشعار بنجاح'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // دوال مساعدة للأيقونات والألوان (من الكود الثاني)
  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'check':
        return Icons.check_circle_outline_rounded;
      case 'info':
        return Icons.info_outline_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'new_releases':
        return Icons.new_releases_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'check':
        return Colors.green.shade600;
      case 'info':
        return Colors.blue.shade600;
      case 'warning':
        return Colors.orange.shade600;
      case 'new_releases':
        return Colors.purple.shade500;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // تجميع الإشعارات حسب التاريخ
    Map<String, List<NotificationItem>> groupedNotifications = {};
    for (var notification in _notifications) {
      if (!groupedNotifications.containsKey(notification.dateCategory)) {
        groupedNotifications[notification.dateCategory] = [];
      }
      groupedNotifications[notification.dateCategory]!.add(notification);
    }

    // فرز فئات التاريخ ("اليوم" أولاً ثم "الأمس" ...)
    List<String> sortedCategories = groupedNotifications.keys.toList();
    sortedCategories.sort((a, b) {
      if (a == 'اليوم') return -1;
      if (b == 'اليوم') return 1;
      if (a == 'الأمس') return -1;
      if (b == 'الأمس') return 1;
      return a.compareTo(b);
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'الاشعارات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Cairo', // تأكد من وجود هذا الخط في مشروعك
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          _notifications.isEmpty
              ? const Center(
                child: Text(
                  'لا توجد إشعارات حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children:
                      sortedCategories.map((category) {
                        List<NotificationItem> categoryNotifications =
                            groupedNotifications[category]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 8.0,
                                right: 8.0,
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            ...categoryNotifications.map(
                              (item) => _buildNotificationCard(
                                context,
                                item,
                                screenWidth,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }

  // بناء بطاقة الإشعار (من الكود الثاني مع إضافة زر الحذف)
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    double screenWidth,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Header with icon and title)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _getColorForStatus(item.statusIcon).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconForStatus(item.statusIcon),
                    color: _getColorForStatus(item.statusIcon),
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  // زر الحذف المضاف هنا
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                    ),
                    onPressed: () => _deleteNotification(item.id),
                    tooltip: 'حذف الإشعار',
                  ),
                ],
              ),
            ),
            // ... (Content with image and details)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      // استخدام Image.asset
                      item.imageUrl,
                      width: screenWidth * 0.22,
                      height: screenWidth * 0.22,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: screenWidth * 0.22,
                          height: screenWidth * 0.22,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: Text(
                                item.quantity,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${item.price.toStringAsFixed(0)} ج.م',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade600,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (item.actionButtonText != null &&
                item.onActionPressed != null) ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: item.onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(screenWidth * 0.85, 48),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    item.actionButtonText!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

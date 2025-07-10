import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

// ===================================
// شاشات وهمية (Placeholder Screens) لجعل الكود قابلاً للتشغيل
// ===================================
class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر موقع التوصيل')),
      body: const Center(child: Text('شاشة اختيار الموقع للمزارع')),
    );
  }
}

// ===================================
// 1. نموذج الإشعار (Notification Model)
// ===================================
class NotificationItem {
  final String id;
  final String title;
  final String statusIcon;
  final String imageUrl;
  final String productName;
  final String quantity;
  final double price;
  final DateTime timestamp; // تم التعديل إلى DateTime لفرز أكثر دقة
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
    required this.timestamp,
    this.actionButtonText,
    this.onActionPressed,
  });
}

// ===================================
// 2. خدمة محاكاة الـ API
// ===================================
class NotificationService {
  // قائمة بيانات أولية لمحاكاة قاعدة بيانات على الخادم
  List<NotificationItem> _mockNotifications = [];

  NotificationService() {
    _mockNotifications = [
      // NotificationItem(
      //   id: 'n1',
      //   title: 'تم قبول عرضك',
      //   statusIcon: 'check',
      //   imageUrl: 'assets/imgs/grapes.png', // استخدم مسار صورة حقيقي
      //   productName: 'عنب احمر',
      //   quantity: '1 طن',
      //   price: 10000.0,
      //   timestamp: DateTime.now(),
      //   actionButtonText: 'انشاء طلب توصيل',
      // ),
      NotificationItem(
        id: 'n2',
        title: 'تحديث حالة الطلب',
        statusIcon: 'info',
        imageUrl: 'imgs/2020_3_2_23_17_15_904 1.png', // استخدم مسار صورة حقيقي
        productName: 'برتقال ابو سرة',
        quantity: '500 كجم',
        price: 4500.0,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        actionButtonText: 'عرض التفاصيل',
      ),
      NotificationItem(
        id: 'n3',
        title: 'عرض جديد على محصولك',
        statusIcon: 'new_releases',
        imageUrl: 'imgs/القمح-1725709678-0.webp', // استخدم مسار صورة حقيقي
        productName: 'قمح مصري',
        quantity: '2 طن',
        price: 8000.0,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  Future<List<NotificationItem>> fetchFarmerNotifications() async {
    await Future.delayed(const Duration(seconds: 2)); // محاكاة تأخير الشبكة
    // إرجاع نسخة مرتبة من الأحدث إلى الأقدم
    _mockNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return List.from(_mockNotifications);
  }

  Future<void> deleteNotification(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // محاكاة تأخير الشبكة
    _mockNotifications.removeWhere((item) => item.id == id);
  }
}

// ===================================
// 3. شاشة إشعارات المزارع المحسّنة
// ===================================
class FarmerNotificationScreen extends StatefulWidget {
  const FarmerNotificationScreen({super.key});

  @override
  _FarmerNotificationScreenState createState() =>
      _FarmerNotificationScreenState();
}

class _FarmerNotificationScreenState extends State<FarmerNotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  late Future<List<NotificationItem>> _notificationsFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notificationsFuture = _notificationService.fetchFarmerNotifications();
    });
  }

  Future<void> _handleRefresh() async {
    // عند السحب للتحديث، نعيد تحميل البيانات مع إزالة القائمة القديمة
    final service =
        NotificationService(); // إعادة إنشاء الخدمة للحصول على البيانات الأصلية
    final freshNotifications = await service.fetchFarmerNotifications();

    // إزالة العناصر القديمة من AnimatedList
    for (int i = _notifications.length - 1; i >= 0; i--) {
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => const SizedBox.shrink(),
      );
    }

    setState(() {
      _notifications = freshNotifications;
    });

    // إضافة العناصر الجديدة
    for (int i = 0; i < _notifications.length; i++) {
      _listKey.currentState?.insertItem(i);
    }
  }

  void _deleteItem(int index) {
    final item = _notifications.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedItem(item, animation),
      duration: const Duration(milliseconds: 400),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف الإشعار'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            _notifications.insert(index, item);
            _listKey.currentState?.insertItem(index);
          },
        ),
      ),
    );

    // الحذف الفعلي من الـ "API"
    _notificationService.deleteNotification(item.id);
  }

  String _getDateCategory(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (itemDate == today) {
      return 'اليوم';
    } else if (itemDate == yesterday) {
      return 'الأمس';
    } else {
      // يمكنك إضافة تنسيق تاريخ مختلف هنا
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'إشعارات المزارع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed:
              () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<NotificationItem>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingShimmer();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'حدث خطأ في تحميل الإشعارات!',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد إشعارات حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            _notifications = snapshot.data!;
            return AnimatedList(
              key: _listKey,
              initialItemCount: _notifications.length,
              padding: const EdgeInsets.all(12.0),
              itemBuilder: (context, index, animation) {
                final item = _notifications[index];
                final dateCategory = _getDateCategory(item.timestamp);
                final showHeader =
                    index == 0 ||
                    dateCategory !=
                        _getDateCategory(_notifications[index - 1].timestamp);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) _buildDateHeader(dateCategory),
                    _buildAnimatedItem(item, animation, index),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateHeader(String category) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, right: 8.0),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(
    NotificationItem item,
    Animation<double> animation, [
    int? index,
  ]) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: _buildNotificationCard(
          context,
          item,
          MediaQuery.of(context).size.width,
          index,
        ),
      ),
    );
  }

  // دوال مساعدة للأيقونات والألوان
  IconData _getIconForStatus(String status) {
    // ... الكود كما هو
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
    // ... الكود كما هو
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

  // بناء بطاقة الإشعار
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    double screenWidth,
    int? index,
  ) {
    // ربط `onActionPressed` بالشاشات المناسبة
    VoidCallback? action = item.onActionPressed;
    if (item.id == 'n1' && action == null) {
      action =
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectLocationScreen(),
            ),
          );
    } else if (item.id == 'n2' && action == null) {
      action =
          () => showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text(
                    'تفاصيل طلب ${item.productName}',
                    textDirection: TextDirection.rtl,
                  ),
                  content: Text(
                    'هنا تظهر كل تفاصيل الطلب الخاص بـ ${item.productName}.',
                    textDirection: TextDirection.rtl,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("إغلاق"),
                    ),
                  ],
                ),
          );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  if (index != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () => _deleteItem(index),
                      tooltip: 'حذف الإشعار',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item.imageUrl,
                      width: screenWidth * 0.22,
                      height: screenWidth * 0.22,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey[600],
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
            if (item.actionButtonText != null && action != null) ...[
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: action,
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

  // ويدجت لعرض تأثير التحميل
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: 5,
        itemBuilder:
            (_, __) => Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(width: 26, height: 26, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(height: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            height: MediaQuery.of(context).size.width * 0.22,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 150,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

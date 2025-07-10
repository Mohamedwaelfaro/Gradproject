import 'package:flutter/material.dart';

import 'service/shipment_service.dart';

class ShipmentReceivedOrdersScreen extends StatefulWidget {
  const ShipmentReceivedOrdersScreen({super.key});

  @override
  State<ShipmentReceivedOrdersScreen> createState() =>
      _ShipmentReceivedOrdersScreenState();
}

class _ShipmentReceivedOrdersScreenState
    extends State<ShipmentReceivedOrdersScreen> {
  final ShipmentOrderService _orderService = ShipmentOrderService();
  List<dynamic> receivedOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReceivedOrders();
  }

  Future<void> fetchReceivedOrders() async {
    try {
      final data = await _orderService.fetchReceivedOrders();
      setState(() {
        receivedOrders = data;
        isLoading = false;
      });
    } catch (e) {
      print('❌ خطأ أثناء تحميل الطلبات: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    height: screenHeight * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'imgs/WhatsApp Image 2025-05-30 at 19.24.24_6286ca45.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'الطلبات المستلمة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child:
                        receivedOrders.isEmpty
                            ? const Center(child: Text('لا توجد طلبات حالياً'))
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: receivedOrders.length,
                              itemBuilder: (context, index) {
                                final order = receivedOrders[index];
                                return _buildOrderCard(order);
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              order['product_image'] != null
                  ? Image.network(
                    'http://192.168.1.5:8000${order['product_image']}',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                  : const Icon(Icons.image_not_supported, size: 48),
        ),
        title: Text(order['product_name'] ?? 'اسم غير متاح'),
        subtitle:
            order['farmer_name'] != null
                ? Text('من: ${order['farmer_name']}')
                : null,
      ),
    );
  }
}

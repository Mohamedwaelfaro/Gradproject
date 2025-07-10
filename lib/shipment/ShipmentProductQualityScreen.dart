import 'package:flutter/material.dart';

class ShipmentProductQualityScreen extends StatelessWidget {
  const ShipmentProductQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = MediaQuery.of(context).textScaleFactor;

    final List<Map<String, dynamic>> mockProducts = [
      {
        "name": "طماطم",
        "status": "تحتاج للفحص",
        "image": "https://cdn-icons-png.flaticon.com/512/415/415682.png",
      },
      {
        "name": "بطاطس",
        "status": "تم الفحص",
        "image": "https://cdn-icons-png.flaticon.com/512/135/135620.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('جودة المنتجات'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          final item = mockProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: ListTile(
              leading: Image.network(item['image'], width: 50),
              title: Text(
                item['name'],
                style: TextStyle(
                  fontSize: 16 * ts,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(item['status']),
              trailing:
                  item['status'] == "تحتاج للفحص"
                      ? ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("تم إرسال طلب الفحص")),
                          );
                        },
                        child: const Text("فحص"),
                      )
                      : const Icon(Icons.verified, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}

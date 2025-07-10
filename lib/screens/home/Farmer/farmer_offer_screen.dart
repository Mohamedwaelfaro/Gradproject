import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Offer {
  final int id;
  final String imageUrl;
  final String productName;
  final String type;
  final double price;
  final String description;

  Offer({
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.type,
    required this.price,
    required this.description,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      imageUrl:
          'http://192.168.1.3:8000${(json['product_image'] ?? '').toString().replaceFirst('//', '/')}',
      productName: json['name'] ?? '',
      type: json['typeofproduct'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}

class FarmerProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<dynamic>> fetchFarmerProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getInt('farmer_id');
    if (farmerId == null) throw Exception('Farmer ID غير موجود');

    final response = await _dio.post(
      'farmer/view_products',
      data: {"id": farmerId},
    );

    if (response.statusCode == 200 && response.data is List) {
      return response.data;
    } else {
      throw Exception('فشل في جلب البيانات');
    }
  }

  Future<bool> removeProduct(int id) async {
    try {
      final response = await _dio.post(
        'farmer/removeProduct',
        data: {"id": id},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ خطأ أثناء حذف المنتج: $e');
      return false;
    }
  }
}

class FarmerOffer_screen extends StatefulWidget {
  const FarmerOffer_screen({super.key});

  @override
  State<FarmerOffer_screen> createState() => _FarmerOffer_screenState();
}

class _FarmerOffer_screenState extends State<FarmerOffer_screen> {
  final FarmerProductService _service = FarmerProductService();
  List<Offer> farmerOffers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOffers();
  }

  Future<void> loadOffers() async {
    setState(() => isLoading = true);
    try {
      final data = await _service.fetchFarmerProducts();
      final offers = data.map<Offer>((item) => Offer.fromJson(item)).toList();
      setState(() {
        farmerOffers = offers;
        isLoading = false;
      });
    } catch (e) {
      print('❌ خطأ أثناء تحميل العروض: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteOffer(int offerId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل تريد حذف $name؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('حذف'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await _service.removeProduct(offerId);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ تم الحذف بنجاح')));
        await loadOffers();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ فشل في الحذف')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'imgs/WhatsApp Image 2025-05-30 at 19.24.24_6286ca45.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.30,
                          color: Colors.black.withOpacity(0.3),
                          alignment: Alignment.center,
                          child: const Text(
                            'العروض التي قدمتها',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children:
                            farmerOffers
                                .map(
                                  (offer) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15.0,
                                    ),
                                    child: _buildOfferCard(context, offer),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildOfferCard(BuildContext context, Offer offer) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(offer.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${offer.price.toStringAsFixed(0)} جنيه',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteOffer(offer.id, offer.productName),
            ),
            // Text('ID: ${offer.id}'),
          ],
        ),
      ),
    );
  }
}

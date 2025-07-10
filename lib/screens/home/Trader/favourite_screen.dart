import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_details.dart';
import 'package:mahsoly_app1/screens/home/Trader/Data/trader_dio_helper.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<dynamic> favourites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavourites();
  }

  Future<void> fetchFavourites() async {
    setState(() {
      isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final merchantId = prefs.getInt('merchant_id') ?? 0;

      final response = await TraderDioHelper.viewFavorites(
        merchantId: merchantId,
      );

      // ignore: unnecessary_type_check
      if (response is List) {
        setState(() {
          favourites = response;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ خطأ أثناء تحميل المفضلة: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _removeFromFavourites(int productId, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'تأكيد الحذف',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('هل تريد حذف هذا المنتج من المفضلة؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final merchantId = prefs.getInt('merchant_id') ?? 0;

      final result = await TraderDioHelper.removeFavorite(
        productId: productId,
        merchantId: merchantId,
      );

      if (result['success'] == true) {
        setState(() => favourites.removeAt(index));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم الحذف من المفضلة')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'فشل الحذف')),
        );
      }
    } catch (e) {
      print('❌ خطأ أثناء الحذف: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحذف')));
    }
  }

  void _navigateToDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductDetailsScreen(
              name: item['name'] ?? '',
              image: 'http://192.168.1.5:8000${item['product_image'] ?? ''}',
              description: item['description'] ?? '',
              price: item['price'].toString(),
              type: item['typeofproduct'] ?? '',
              seller: item['farmer'].toString(),
              date: item['date'] ?? '',
              productId: item['id'] ?? 0,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final ts = MediaQuery.of(context).textScaleFactor;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Background Image and Gradient
            Container(
              height: sh * 0.28,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'imgs/istockphoto-1221724425-612x612 1.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.7),
                      theme.primaryColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Rounded white background for content
            Positioned(
              top: sh * 0.18,
              left: 0,
              right: 0,
              child: Container(
                height: sh * 0.13, // This container sets the initial curve
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
              ),
            ),
            // Title "المفضلة"
            Positioned(
              top: sh * 0.11,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'المفضلة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30 * ts,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 4.0, // Increased blur for softer shadow
                        color: Colors.black54, // Slightly darker shadow
                        offset: Offset(2, 2), // Slightly larger offset
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Main content area
            Padding(
              padding: EdgeInsets.only(
                top: sh * 0.23,
              ), // Adjust top padding to align with the curve
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : favourites.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 80, // Larger icon
                              color: theme.primaryColor.withOpacity(
                                0.6,
                              ), // Slightly more opaque
                            ),
                            const SizedBox(height: 20), // Increased spacing
                            Text(
                              'لا توجد منتجات في المفضلة بعد',
                              style: TextStyle(
                                fontSize: 20 * ts, // Larger font size
                                color: theme.hintColor.withOpacity(
                                  0.8,
                                ), // Slightly darker hint color
                                fontWeight: FontWeight.w600, // Semi-bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement navigation to browse products screen
                                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsScreen()));
                              },
                              icon: const Icon(
                                Icons.storefront,
                                size: 24,
                              ), // Larger icon
                              label: const Text(
                                'تصفح المنتجات',
                                style: TextStyle(fontSize: 18),
                              ), // Larger text
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ), // Larger padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5, // Add a subtle elevation
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: favourites.length,
                        padding: const EdgeInsets.all(16), // Increased padding
                        itemBuilder: (context, index) {
                          final item = favourites[index];
                          return Dismissible(
                            key: Key(item['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24, // Increased padding
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.red.shade600, // Slightly darker red
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 35, // Larger icon
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              await _removeFromFavourites(item['id'], index);
                              return false; // We handle removal manually, so always return false here
                            },
                            child: Card(
                              elevation:
                                  5, // Increased elevation for a more prominent card
                              margin: const EdgeInsets.only(
                                bottom: 16,
                              ), // Increased bottom margin
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ), // More rounded corners
                              ),
                              child: InkWell(
                                onTap: () => _navigateToDetails(item),
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    16,
                                  ), // Increased padding inside card
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16,
                                        ), // More rounded image corners
                                        child: CachedNetworkImage(
                                          // Using CachedNetworkImage
                                          imageUrl:
                                              'http://192.168.1.3:8000${item['product_image']}',
                                          width: 100, // Larger image
                                          height: 100, // Larger image
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(
                                                    Icons.error_outline,
                                                    size: 40,
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ), // Increased spacing
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'] ?? 'اسم غير معروف',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    20 * ts, // Larger font size
                                                color:
                                                    theme
                                                        .textTheme
                                                        .titleLarge
                                                        ?.color, // Use theme's text color
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ), // Increased spacing
                                            Text(
                                              '${item['price'] ?? '0'} ج.م',
                                              style: TextStyle(
                                                fontSize:
                                                    18 * ts, // Larger font size
                                                color: theme.primaryColor
                                                    .withOpacity(
                                                      0.9,
                                                    ), // Highlight price
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item['description'] ??
                                                  'لا يوجد وصف',
                                              style: TextStyle(
                                                fontSize:
                                                    15 *
                                                    ts, // Slightly larger description font
                                                color: theme.hintColor
                                                    .withOpacity(0.8),
                                              ),
                                              maxLines:
                                                  2, // Limit description to 2 lines
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ), // Add some padding
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 20, // Slightly larger arrow
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

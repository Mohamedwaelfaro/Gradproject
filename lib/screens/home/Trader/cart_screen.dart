import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for haptic feedback
import 'package:mahsoly_app1/screens/home/Trader/Data/trader_dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../payment/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  int? merchantId;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    merchantId = prefs.getInt('merchant_id');

    if (merchantId == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final items = await TraderDioHelper.viewCart(merchantId: merchantId!);
      if (mounted) {
        setState(() {
          cartItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading cart: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _removeFromCart(int productId, int index) async {
    if (merchantId == null) return;

    // First, remove the item from the animated list
    final itemToRemove = cartItems[index];
    cartItems.removeAt(index);
    _animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCartItem(itemToRemove, animation, index),
      duration: const Duration(milliseconds: 400),
    );
    // Add haptic feedback for a better user experience
    HapticFeedback.mediumImpact();

    // Then, call the API to delete the item from the backend
    try {
      await TraderDioHelper.cartMethod(
        merchantId: merchantId!,
        productId: productId,
        method: 'DELETE',
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('The product has been removed from the cart'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (e) {
      print('❌ Error removing from cart: $e');
      // If the API call fails, add the item back to the list
      setState(() {
        cartItems.insert(index, itemToRemove);
      });
      _animatedListKey.currentState?.insertItem(index);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Failed to remove the product from the cart'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
    // Recalculate total after removing item
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double delivery = 2500;
    double total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['total_price'] ?? 0.0),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          _buildHeader(context),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
            ),
            child: Column(
              children: [
                Expanded(child: _buildBody()),
                _buildTotalSection(total, delivery),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return AnimatedList(
      key: _animatedListKey,
      initialItemCount: cartItems.length,
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      itemBuilder: (context, index, animation) {
        final item = cartItems[index];
        return _buildCartItem(item, animation, index);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    return Container(
      height: sh * 0.25,
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(45)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    Map<String, dynamic> item,
    Animation<double> animation,
    int index,
  ) {
    final imageUrl =
        item['image']?.toString().startsWith('http') == true
            ? item['image']
            : 'http://192.168.1.3:8000${item['image']}';
    final screenSize = MediaQuery.of(context).size;

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: screenSize.width * 0.2,
                  height: screenSize.width * 0.2,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.width * 0.2,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['price']} EGP per Kilo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantity: ${item['quantity']} Kg',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item['total_price']} EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.red.shade400,
                  size: 28,
                ),
                onPressed: () => _removeFromCart(item['product_id'], index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection(double total, double delivery) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTotalRow('Subtotal:', '$total EGP'),
          const SizedBox(height: 8),
          _buildTotalRow('Delivery:', '$delivery EGP'),
          const Divider(height: 24),
          _buildTotalRow(
            'Total Bill:',
            '${total + delivery} EGP',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                cartItems.isEmpty
                    ? null
                    : () {
                      double finalAmount = total + delivery;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PaymentScreen(totalPrice: finalAmount),
                        ),
                      );
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              disabledBackgroundColor: Colors.grey.shade400,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.black : Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}

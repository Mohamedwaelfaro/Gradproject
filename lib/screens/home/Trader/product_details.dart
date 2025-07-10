import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for haptic feedback
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Data/trader_dio_helper.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final String name;
  final String image;
  final String description;
  final String price;
  final String type;
  final String seller;
  final String date;

  const ProductDetailsScreen({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.type,
    required this.seller,
    required this.date,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;
  bool isFavoriteLoading = false;
  bool isCartLoading = false;
  int? merchantId;

  @override
  void initState() {
    super.initState();
    _loadMerchantId();
  }

  // --- All backend and data logic methods remain unchanged ---

  Future<void> _loadMerchantId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        merchantId = prefs.getInt('merchant_id');
      });
    }
  }

  void _incrementQuantity() {
    HapticFeedback.lightImpact();
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      HapticFeedback.lightImpact();
      setState(() => quantity--);
    }
  }

  Future<void> _toggleFavorite() async {
    if (merchantId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not find user ID')));
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => isFavoriteLoading = true);

    try {
      // Simulate API call for favoriting
      final response = await TraderDioHelper.addToFavorites(
        merchantId: merchantId!,
        productId: widget.productId,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) setState(() => isFavorite = !isFavorite);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
          ),
        );
      } else {
        throw Exception('Failed to update favorites');
      }
    } catch (e) {
      print("❌ Error updating favorites: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating favorites'),
        ),
      );
    } finally {
      if (mounted) setState(() => isFavoriteLoading = false);
    }
  }

  Future<void> _addToCart() async {
    if (merchantId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not find user ID')));
      return;
    }
    setState(() => isCartLoading = true);

    try {
      final response = await TraderDioHelper.cartMethod(
        merchantId: merchantId!,
        productId: widget.productId,
        quantity: quantity,
        method: 'POST',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart successfully!')),
        );
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      print("❌ Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while adding to cart')),
      );
    } finally {
      if (mounted) setState(() => isCartLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fixedImage = widget.image.replaceFirst('//', '/');
    final imageUrl =
        fixedImage.startsWith("http")
            ? fixedImage
            : 'http://192.168.1.3:8000$fixedImage';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(imageUrl),
            SliverToBoxAdapter(child: _buildBodyContent()),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(String imageUrl) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      elevation: 2,
      backgroundColor: Colors.green.shade600,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            Share.share(
              '${widget.name}\n${widget.description}\nPrice: ${widget.price} EGP',
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_image_${widget.productId}',
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
            errorBuilder:
                (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return Container(
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                '${widget.price} EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.type,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRowWithIcon(
            'Seller',
            widget.seller,
            Icons.person_outline,
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantityRow(),
          const SizedBox(width: 16),
          Expanded(child: _buildActionButtons()),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IconButton(
            onPressed: isFavoriteLoading ? null : _toggleFavorite,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  isFavoriteLoading
                      ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                      : Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isFavorite),
                        size: 28,
                        color: isFavorite ? Colors.red.shade400 : Colors.grey,
                      ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isCartLoading ? null : _addToCart,
            icon:
                isCartLoading
                    ? const SizedBox.shrink()
                    : const Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.white,
                    ),
            label:
                isCartLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: quantity > 1 ? _decrementQuantity : null,
            color: Colors.black54,
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _incrementQuantity,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade600, size: 20),
        const SizedBox(width: 12),
        Text(
          '$title:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

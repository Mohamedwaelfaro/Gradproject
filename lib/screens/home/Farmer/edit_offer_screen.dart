import 'package:flutter/material.dart';
import 'package:mahsoly_app1/screens/home/Farmer/farmer_offer_screen.dart';

class EditOfferScreen extends StatefulWidget {
  final Offer offer;

  const EditOfferScreen({super.key, required this.offer});

  @override
  State<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _typeController;
  late TextEditingController _priceController;
  late TextEditingController _deliveryController;
  late TextEditingController _storageController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(
      text: widget.offer.productName,
    );
    _typeController = TextEditingController(text: widget.offer.type);
    _priceController = TextEditingController(
      text: widget.offer.price.toStringAsFixed(0),
    );
    _descriptionController = TextEditingController(
      text: widget.offer.description,
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _deliveryController.dispose();
    _storageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'تعديل العرض',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: screenWidth * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(widget.offer.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _productNameController.text,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 25),
            _buildDetailField(
              context: context,
              label: 'النوع :',
              controller: _typeController,
            ),
            const SizedBox(height: 15),
            _buildDetailField(
              context: context,
              label: 'السعر :',
              controller: _priceController,
              isNumeric: true,
            ),
            const SizedBox(height: 15),
            _buildDetailField(
              context: context,
              label: 'التوصيل :',
              controller: _deliveryController,
            ),
            const SizedBox(height: 15),
            _buildDetailField(
              context: context,
              label: 'تخزين :',
              controller: _storageController,
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: const Text(
                'الوصف :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 10),
            _buildDescriptionField(
              context: context,
              controller: _descriptionController,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final updatedProductName = _productNameController.text;
                final updatedType = _typeController.text;
                final updatedPrice =
                    double.tryParse(_priceController.text) ?? 0.0;
                final updatedDelivery = _deliveryController.text;
                final updatedStorage = _storageController.text;
                final updatedDescription = _descriptionController.text;

                print('Updating offer:');
                print('Product Name: $updatedProductName');
                print('Type: $updatedType');
                print('Price: $updatedPrice');
                print('Delivery: $updatedDelivery');
                print('Storage: $updatedStorage');
                print('Description: $updatedDescription');

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث العرض بنجاح!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text(
                'تحديث',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    bool isNumeric = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.right,
                keyboardType:
                    isNumeric ? TextInputType.number : TextInputType.text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField({
    required BuildContext context,
    required TextEditingController controller,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          maxLines: 5,
          minLines: 3,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintTextDirection: TextDirection.rtl,
            contentPadding: EdgeInsets.zero,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

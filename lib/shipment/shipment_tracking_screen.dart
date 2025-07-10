import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mahsoly_app1/shipment/quality_check_screen.dart';

class TrackingStep {
  final String title;
  final String date;
  final IconData icon;

  TrackingStep({required this.title, required this.date, required this.icon});
}

class Shipment {
  final String productName;
  final String orderDate;
  final String shippingAddress;
  final String shippingCompany;
  final String imageAssetPath;
  final List<TrackingStep> steps;

  Shipment({
    required this.productName,
    required this.orderDate,
    required this.shippingAddress,
    required this.shippingCompany,
    required this.imageAssetPath,
    required this.steps,
  });
}

class ShipmentTrackingScreen extends StatefulWidget {
  const ShipmentTrackingScreen({super.key});

  @override
  State<ShipmentTrackingScreen> createState() => _ShipmentTrackingScreenState();
}

class _ShipmentTrackingScreenState extends State<ShipmentTrackingScreen> {
  bool _isLoading = true;
  int _currentStep = 0;
  Timer? _timer;

  final Shipment _shipment = Shipment(
    productName: 'أرز أبيض فاخر',
    orderDate: '15 نوفمبر',
    shippingAddress: 'أسوان',
    shippingCompany: 'شركة النيل للشحن السريع',
    imageAssetPath: 'imgs/أفضل_أنواع_الأرز 1.png',
    steps: [
      TrackingStep(
        title: 'جاري التجهيز للشحن',
        date: '16 نوفمبر',
        icon: Icons.inventory_2_outlined,
      ),
      TrackingStep(
        title: 'تم الشحن',
        date: '16 نوفمبر',
        icon: Icons.local_shipping_outlined,
      ),
      TrackingStep(
        title: 'في الطريق إلى التاجر',
        date: '17 نوفمبر',
        icon: Icons.route_outlined,
      ),
      TrackingStep(
        title: 'تم التوصيل بنجاح',
        date: '18 نوفمبر',
        icon: Icons.check_circle_outline,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _startTrackingSimulation();
      }
    });
  }

  void _startTrackingSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentStep < _shipment.steps.length - 1) {
        setState(() => _currentStep++);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                        children: [
                          _buildAppBar(context),
                          _buildProductCard(),
                          Expanded(child: _buildStepper()),
                          _buildActionButton(context),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'تتبع الشحنة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _shipment.imageAssetPath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _shipment.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تاريخ الطلب: ${_shipment.orderDate}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    'العنوان: ${_shipment.shippingAddress}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    'شركة الشحن: ${_shipment.shippingCompany}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Stepper(
      currentStep: _currentStep,
      physics: const BouncingScrollPhysics(),
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps:
          _shipment.steps.map((step) {
            int index = _shipment.steps.indexOf(step);
            return Step(
              title: Text(
                step.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                step.date,
                style: const TextStyle(color: Colors.white70),
              ),
              content: const SizedBox.shrink(),
              state:
                  index < _currentStep
                      ? StepState.complete
                      : index == _currentStep
                      ? StepState.editing
                      : StepState.indexed,
              isActive: index <= _currentStep,
            );
          }).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder:
          (child, animation) => ScaleTransition(scale: animation, child: child),
      child:
          _currentStep >= _shipment.steps.length - 1
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QualityCheckScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('إنشاء طلب فحص جودة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade600,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              : const SizedBox(height: 72),
    );
  }
}

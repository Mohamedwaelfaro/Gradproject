import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mahsoly_app1/screens/home/Driver/SearchingDriverScreen.dart';

class SelectLocationScreen extends StatefulWidget {
  final String? productName;
  final String? quantity;
  final double? price;

  const SelectLocationScreen({
    super.key,
    this.productName,
    this.quantity,
    this.price,
  });

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  String? _pickupText;
  String? _dropoffText;
  int selectedPrice = 2000;
  bool isSelectingPickup = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(24.0889, 32.8998),
              zoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  if (isSelectingPickup) {
                    _pickupLocation = point;
                    _pickupText =
                        'موقع الشحن: (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})';
                  } else {
                    _dropoffLocation = point;
                    _dropoffText =
                        'وجهة التوصيل: (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})';
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  if (_pickupLocation != null)
                    Marker(
                      point: _pickupLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  if (_dropoffLocation != null)
                    Marker(
                      point: _dropoffLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.48,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF5CB85C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "أين تريد توصيل شحنتك؟",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => isSelectingPickup = true),
                    child: Text(
                      _pickupText ?? "اضغط على الخريطة لتحديد موقع الشحن",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => isSelectingPickup = false),
                    child: Text(
                      _dropoffText ?? "اضغط على الخريطة لتحديد وجهة التوصيل",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          value: selectedPrice,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 2000,
                              child: Text("2000 جنيه"),
                            ),
                            DropdownMenuItem(
                              value: 3000,
                              child: Text("3000 جنيه"),
                            ),
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => selectedPrice = value ?? 2000),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            if (_pickupLocation == null ||
                                _dropoffLocation == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("يرجى تحديد الموقعين"),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => SearchingDriverScreen(
                                      pickupLocation: _pickupText ?? '',
                                      destination: _dropoffText ?? '',
                                      productName: widget.productName,
                                      price: widget.price,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "طلب",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

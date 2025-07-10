// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class MapPickerScreen extends StatefulWidget {
//   const MapPickerScreen({super.key});

//   @override
//   State<MapPickerScreen> createState() => _MapPickerScreenState();
// }

// class _MapPickerScreenState extends State<MapPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng _pickedLocation = const LatLng(30.033333, 31.233334); // Cairo
//   String _address = 'جارٍ تحديد العنوان...';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _address = 'يرجى تفعيل خدمة الموقع';
//         _isLoading = false;
//       });
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.always &&
//           permission != LocationPermission.whileInUse) {
//         setState(() {
//           _address = 'تم رفض صلاحية الوصول للموقع';
//           _isLoading = false;
//         });
//         return;
//       }
//     }

//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     final current = LatLng(position.latitude, position.longitude);

//     setState(() {
//       _pickedLocation = current;
//       _isLoading = false;
//     });

//     _mapController?.animateCamera(CameraUpdate.newLatLng(current));
//     _getAddressFromLatLng(current);
//   }

//   Future<void> _getAddressFromLatLng(LatLng location) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         location.latitude,
//         location.longitude,
//       );
//       final place = placemarks.first;
//       setState(() {
//         _address =
//             "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
//       });
//     } catch (e) {
//       setState(() => _address = "تعذر تحديد العنوان");
//     }
//   }

//   void _onMapTap(LatLng position) {
//     setState(() {
//       _pickedLocation = position;
//       _address = "جارٍ تحديد العنوان...";
//     });
//     _getAddressFromLatLng(position);
//   }

//   void _confirmLocation() {
//     Navigator.pop(context, {"location": _pickedLocation, "address": _address});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("اختيار الموقع"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: _confirmLocation,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: _pickedLocation,
//                   zoom: 14,
//                 ),
//                 onMapCreated: (controller) => _mapController = controller,
//                 onTap: _onMapTap,
//                 markers: {
//                   Marker(
//                     markerId: const MarkerId('picked'),
//                     position: _pickedLocation,
//                   ),
//                 },
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//               ),
//           Positioned(
//             bottom: 20,
//             left: 16,
//             right: 16,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 10,
//                     color: Colors.black26,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 _address,
//                 style: const TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

const kPrimaryGreen = Color(0xFF4CAF50);

class ShipmentAppBar extends StatefulWidget {
  final Function(String query)? onSearch;
  final Function()? onFilterPressed;
  final int newNotificationsCount;

  const ShipmentAppBar({
    super.key,
    this.onSearch,
    this.onFilterPressed,
    this.newNotificationsCount = 0,
  });

  @override
  State<ShipmentAppBar> createState() => _ShipmentAppBarState();
}

class _ShipmentAppBarState extends State<ShipmentAppBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = MediaQuery.of(context).textScaleFactor;

    return Row(
      children: [
        // Notification Icon with badge
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const NotificationScreen(),
                  //   ),
                  // );
                },
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.grey.shade700,
                  size: 26 * ts,
                ),
              ),
            ),
            if (widget.newNotificationsCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${widget.newNotificationsCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 10),

        // Search Bar
        Expanded(
          child: SizedBox(
            height: 48 * ts,
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearch,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 14 * ts),
              decoration: InputDecoration(
                hintText: 'ابحث عن الشحنة أو رقم التتبع...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14 * ts,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 22 * ts,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0 * ts,
                  horizontal: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: kPrimaryGreen.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Filter/Location Button
        GestureDetector(
          onTap: widget.onFilterPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10 * ts,
              vertical: 9 * ts,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  color: Colors.grey.shade700,
                  size: 20 * ts,
                ),
                const SizedBox(width: 5),
                Text(
                  "فلترة",
                  style: TextStyle(
                    fontSize: 13.5 * ts,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(Icons.tune, color: kPrimaryGreen, size: 18 * ts),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

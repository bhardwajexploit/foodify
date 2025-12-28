import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colours.dart';
import '../dashboard /dashboard_controller.dart';
import '../../../model/bookingModel.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
        title: const Text(
          "Bookings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),

      backgroundColor: Colors.white60,

      body: Obx(() {
        if (controller.isHistoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookingHistory.isEmpty) {
          return const Center(
            child: Text(
              "No bookings yet",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: controller.bookingHistory.length,
          itemBuilder: (_, i) {
            final b = controller.bookingHistory[i];

            return FutureBuilder(
              future: Future.wait([
                controller.getRestaurantNameCached(b.restaurantId),
                controller.getTableNumberCached(b.tableId),
              ]),
              builder: (_, snap) {
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: LinearProgressIndicator(),
                  );
                }

                final restaurantName = snap.data![0] ?? "Restaurant";
                final tableNum = snap.data![1] ?? "-";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        color: Colors.black.withValues(alpha: 0.08),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ---------- HEADER ----------
                        Row(
                          children: [
                            const Icon(Icons.restaurant, color: Colors.purple),
                            const SizedBox(width: 6),

                            Expanded(
                              child: Text(
                                restaurantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            _statusBadge(b.status),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ---------- TABLE & GUESTS ----------
                        Row(
                          children: [
                            const Icon(Icons.event_seat, size: 16),
                            const SizedBox(width: 6),
                            Text("Table $tableNum",
                                style: const TextStyle(fontSize: 12)),
                            const Spacer(),
                            Text("${b.guests} Guests",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // ---------- DATE & TIME ----------
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "${b.date}  |  ${b.timeStart} - ${b.timeEnd}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ---------- FOOD SECTION ----------
                        _foodSection(b),

                        const SizedBox(height: 8),

                        // ---------- CANCEL BUTTON ----------
                        if (b.status == "booked")
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton.icon(
                              onPressed: () async =>
                              await controller.cancelBooking(b.id!),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text("Cancel Booking"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  // ---------- FOOD SECTION ----------
  Widget _foodSection(BookingModel b) {
    if (b.items == null || b.items!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.fastfood, size: 16, color: Colors.orange),
            SizedBox(width: 6),
            Text(
              "Ordered Items",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ...b.items!.map((item) {
          final name = item["name"];
          final qty = item["qty"];
          final subtotal = item["subtotal"];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "$name  x$qty",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  "₹ $subtotal",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "Food Total: ",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "₹ ${b.totalAmount?.toStringAsFixed(2) ?? '0'}",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- STATUS BADGE ----------
  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "cancelled":
        color = Colors.red;
        break;
      case "completed":
        color = Colors.green;
        break;
      default:
        color = AppColours.kPrimaryPurple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
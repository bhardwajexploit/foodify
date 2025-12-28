import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colours.dart';
import '../../model/tableModel.dart';
import '../Booking/booking_controller.dart';

class TableSelectionScreen extends StatelessWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    controller.loadTables();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.kPrimaryPurple,
        title: const Text("Select a Table"),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoadingTables.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tables.isEmpty) {
          return const Center(child: Text("No tables available"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---- Selected Context Chips ----
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(.06),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip("Guests", "${controller.guests.value}"),
                    _infoChip("Date", controller.date.value),
                    _infoChip(
                      "Time",
                      "${controller.timeStart.value} - ${controller.timeEnd.value}",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Available Tables",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColours.kPrimaryPurple,
                ),
              ),

              const SizedBox(height: 6),
              const Text(
                "Tap a table to select it",
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),

              const SizedBox(height: 12),

              // ---- TABLE GRID ----
              Expanded(
                child: GridView.builder(
                  itemCount: controller.tables.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (_, i) {
                    final TableModel t = controller.tables[i];

                    return Obx(() {
                      final canSeat = controller.guests.value <= t.capacity;
                      final isSelected = controller.tableId.value == t.id;
                      final isDisabled = t.isBooked || !canSeat;

                      return GestureDetector(
                        onTap: () {
                          if (isDisabled) {
                            Get.snackbar(
                              "Unavailable",
                              t.isBooked
                                  ? "This table is already booked"
                                  : "Seats not enough for guests",
                            );
                            return;
                          }

                          controller.selectTable(t.id);
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isSelected
                                ? AppColours.kPrimaryPurple.withOpacity(.18)
                                : Colors.white,
                            border: Border.all(
                              width: 2,
                              color: isSelected
                                  ? AppColours.kPrimaryPurple
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.event_seat,
                                size: 28,
                                color: isDisabled
                                    ? Colors.grey
                                    : AppColours.kPrimaryPurple,
                              ),
                              Text(
                                "Table ${t.tableNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                "${t.capacity} seats",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                isSelected
                                    ? "Selected"
                                    : t.isBooked
                                    ? "Booked"
                                    : !canSeat
                                    ? "Too Small"
                                    : "Available",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColours.kPrimaryPurple
                                      : t.isBooked
                                      ? Colors.red
                                      : !canSeat
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),

      // ---- BOTTOM ACTIONS ----
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Obx(
                () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ---- FOOD PICKER ----
                TextButton.icon(
                  onPressed: controller.openFoodPicker,
                  icon: const Icon(Icons.fastfood),
                  label: const Text("Add Food (Optional)"),
                ),

                // ---- CART SUMMARY ----
                Obx(
                      () => controller.cart.isEmpty
                      ? const SizedBox()
                      : Text(
                    "${controller.cart.length} item(s) • ₹ ${controller.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ---- CONFIRM BOOKING ----
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.tableId.value.isEmpty
                          ? Colors.grey
                          : AppColours.kPrimaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: controller.tableId.value.isEmpty
                        ? null
                        : () async {
                      await controller.confirmBooking(
                        items: controller.cart.entries.map((e) {
                          final price = controller.menu
                              .firstWhere(
                                (m) => m["name"] == e.key,
                          )["price"];

                          return {
                            "name": e.key,
                            "qty": e.value,
                            "price": price,
                            "subtotal": price * e.value,
                          };
                        }).toList(),
                        totalAmount: controller.totalAmount,
                      );
                    },
                    child: Text(
                      controller.tableId.value.isEmpty
                          ? "Select a table"
                          : controller.cart.isEmpty
                          ? "Confirm Booking"
                          : "Confirm Booking + Food",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- CHIP UI ----
  Widget _infoChip(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

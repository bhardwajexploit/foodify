import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colours.dart';
import '../../model/resturantModel.dart';
import 'booking_controller.dart';

class BookingFormScreen extends StatelessWidget {
  const BookingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant = Get.arguments as Restaurant;

    final BookingController controller = Get.find<BookingController>();
    controller.setRestaurant(restaurant.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.kPrimaryPurple,
        title: const Text("Book a Table"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ==== HEADER CARD ====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                    color: Colors.black.withValues(alpha: 0.04),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: AppColours.kPrimaryPurple.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [

                      ]
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.purple,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        restaurant.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          "${restaurant.rating}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// SECTION TITLE
            Text(
              "Reserve Your Table",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColours.kPrimaryPurple,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Choose your preferred date, time and guests",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 12),

            /// ==== FORM CARD ====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                    color: Colors.black.withValues(alpha: 0.08),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// DATE
                  const Text("Select Date",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),

                  Obx(() => GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        controller.setDate(
                            "${picked.year}-${picked.month}-${picked.day}");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.date.value.isEmpty
                                ? "Tap to select date"
                                : controller.date.value,
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 18),

                  /// TIME SLOT
                  const Text("Select Time Slot",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 10,
                    children: [
                      timeChip("06:00 PM", "07:00 PM", controller),
                      timeChip("07:00 PM", "08:00 PM", controller),
                      timeChip("08:00 PM", "09:00 PM", controller),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// GUESTS
                  const Text("Guests",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),

                  Obx(() => Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// DECREMENT
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (controller.guests.value > 1) {
                              controller.setGuests(controller.guests.value - 1);
                            }
                          },
                          icon: const Icon(Icons.remove, size: 20),
                        ),

                        const SizedBox(width: 6),

                        /// VALUE
                        Text(
                          "${controller.guests.value}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 6),

                        /// INCREMENT (MAX 6)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (controller.guests.value < 6) {
                              controller.setGuests(controller.guests.value + 1);
                            } else {
                              Get.snackbar(
                                "Limit Reached",
                                "Maximum 6 guests allowed for a table",
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// NEXT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.kPrimaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                  onPressed: () {
                    if (controller.date.value.isEmpty ||
                        controller.timeStart.value.isEmpty) {
                      Get.snackbar(
                        "Missing Info",
                        "Please select date and time slot",
                      );
                      return;
                    }


                    Get.toNamed('/table-selection');
                  },
                child: const Text(
                  "Find Available Tables",
                  style:
                  TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeChip(
      String start, String end, BookingController controller) {
    return Obx(() {
      final isSelected = controller.timeStart.value == start;

      return ChoiceChip(
        label: Text("$start - $end"),
        selected: isSelected,
        selectedColor: AppColours.kPrimaryPurple,
        onSelected: (_) => controller.setTime(start, end),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      );
    });
  }
}

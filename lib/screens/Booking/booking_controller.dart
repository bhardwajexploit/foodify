import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodify/screens/dashboard%20/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/bookingModel.dart';
import '../../model/tableModel.dart';
import 'booking_repo.dart';

class BookingController extends GetxController {
  final DashboardController dashboard = Get.find<DashboardController>();
  final BookingRepository _repo = BookingRepository();
  final _db = FirebaseFirestore.instance;

  // Selected values from form
  RxString restaurantId = "".obs;
  RxString tableId = "".obs;
  RxInt guests = 1.obs;
  RxString date = "".obs;
  RxString timeStart = "".obs;
  RxString timeEnd = "".obs;

  RxBool isSubmitting = false.obs;

  RxList<TableModel> tables = <TableModel>[].obs;
  RxBool isLoadingTables = false.obs;

  // ================= SETTERS =================
  void setRestaurant(String id) => restaurantId.value = id;
  void setTable(String id) => tableId.value = id;
  void setGuests(int value) => guests.value = value;
  void setDate(String value) => date.value = value;

  void setTime(String start, String end) {
    timeStart.value = start;
    timeEnd.value = end;
  }

  //  ---------- FOOD ORDERING ----------
  RxList<Map<String, dynamic>> menu = <Map<String, dynamic>>[
    {"name": "Veg Burger", "price": 160.0},
    {"name": "Margherita Pizza", "price": 240.0},
    {"name": "Pasta Alfredo", "price": 220.0},
    {"name": "Cold Coffee", "price": 120.0},
    {"name": "Brownie", "price": 150.0},
  ].obs;

  RxMap<String, int> cart = <String, int>{}.obs;

  double get totalAmount {
    double total = 0;
    for (final e in cart.entries) {
      final item = menu.firstWhere((m) => m["name"] == e.key);
      total += (item["price"] * e.value);
    }
    return total;
  }


  List<Map<String, dynamic>> get selectedItems {
    return cart.entries.map((e) {
      final item = menu.firstWhere((m) => m["name"] == e.key);
      return {
        "name": e.key,
        "price": item["price"],
        "qty": e.value,
        "subtotal": item["price"] * e.value,
      };
    }).toList();
  }

  void openFoodPicker() {
    Get.bottomSheet(
      GetBuilder<BookingController>(
        init: this, // ← Ensures controller context
        builder: (controller) => Container(
          height: Get.height * 0.75,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Food to Booking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: menu.length,
                  itemBuilder: (_, i) {
                    final item = menu[i];
                    final name = item["name"];
                    final price = item["price"];
                    final qty = cart[name] ?? 0;

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text("₹ $price"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (qty > 0) {
                                  cart[name] = qty - 1;
                                  if (cart[name] == 0) cart.remove(name);
                                  update(); // ← Forces full rebuild
                                }
                              },
                            ),
                            Text("$qty"), // Will update on rebuild
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cart[name] = qty + 1;
                                update(); // ← Forces full rebuild
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹ ${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: Get.back,
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int recommendedCapacity() {
    final g = guests.value;
    if (g <= 2) return 2;
    if (g <= 4) return 4;
    return 6;
  }

  // ================= LOAD TABLES =================
  Future<void> loadTables() async {
    try {
      isLoadingTables.value = true;

      tables.value = await _repo.getTablesByRestaurant(restaurantId.value);

      await _checkAvailability();
    } catch (e) {
      debugPrint("Error Failed to load tables");
    } finally {
      isLoadingTables.value = false;
    }
  }

  // ================= TIME PARSING =================
  DateTime _parseTime(String date, String time) {
    return DateTime.parse("$date ${_to24Hour(time)}:00");
  }

  String _to24Hour(String t) {
    final parts = t.split(" ");
    final time = parts[0];
    final period = parts[1];

    final hhmm = time.split(":");
    int hour = int.parse(hhmm[0]);
    final minute = hhmm[1];

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    return "$hour:$minute";
  }

  // ================= AVAILABILITY CHECK =================
  Future<void> _checkAvailability() async {
    final rec = recommendedCapacity();

    // Check availability for ALL tables first
    for (var t in tables) {
      t.isBooked = await _hasConflict(t.id);
      t.isRecommended = (t.capacity == rec && !t.isBooked);
    }

    // ✅ FIXED: Auto-select ONLY on FIRST load (when no selection exists)
    // Users can now always manually override by tapping any valid table
    if (tableId.value.isEmpty) {
      final recommendedTable = tables.firstWhereOrNull((t) => t.isRecommended);
      if (recommendedTable != null) {
        tableId.value = recommendedTable.id;
      }
    }

    tables.refresh();
  }

  // ================= TIME SLOT CONFLICT =================
  Future<bool> _hasConflict(String tableId) async {
    final snap = await _db
        .collection("bookings")
        .where("restaurantId", isEqualTo: restaurantId.value)
        .where("tableId", isEqualTo: tableId)
        .where("date", isEqualTo: date.value)
        .where('status', isEqualTo: 'booked')
        .get();

    if (snap.docs.isEmpty) return false;

    final newStart = _parseTime(date.value, timeStart.value);
    final newEnd = _parseTime(date.value, timeEnd.value);

    for (var d in snap.docs) {
      final data = d.data();

      final existingStart = _parseTime(date.value, data["timeStart"]);
      final existingEnd = _parseTime(date.value, data["timeEnd"]);

      final overlaps =
          newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);

      if (overlaps) return true;
    }

    return false;
  }

  // ================= TABLE SELECTION =================
  void selectTable(String id) {
    final t = tables.firstWhere((e) => e.id == id);

    if (t.isBooked) {
      Get.snackbar("Unavailable", "This table is already booked");
      return;
    }

    if (guests.value > t.capacity) {
      Get.snackbar(
        "Table Too Small",
        "Please choose a table with higher capacity",
      );
      return;
    }

    tableId.value = id;
  }

  // ================= CONFIRM BOOKING =================

  Future<void> confirmBooking({
    List<Map<String, dynamic>>? items,
    double? totalAmount,
    String? notes,
  }) async {
    try {
      isSubmitting.value = true;

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar("Auth Error", "User not logged in");
        return;
      }

      final selected = tables.firstWhere((e) => e.id == tableId.value);

      // Final safety check
      if (guests.value > selected.capacity) {
        isSubmitting.value = false;
        Get.snackbar(
          "Table Too Small",
          "This table cannot accommodate ${guests.value} guests",
        );
        return;
      }

      // Re-check availability
      final conflict = await _hasConflict(selected.id);
      if (conflict) {
        isSubmitting.value = false;
        Get.snackbar("Unavailable", "Table has already been booked");
        await loadTables();
        return;
      }

      // ✅ ALWAYS FALLBACK TO CART (Important Fix)
      final orderItems = items ??
          cart.entries.map((e) {
            final price = menu.firstWhere((m) => m["name"] == e.key)["price"];
            return {
              "name": e.key,
              "qty": e.value,
              "price": price,
              "subtotal": price * e.value,
            };
          }).toList();

      final orderTotal = totalAmount ?? this.totalAmount;

      debugPrint("Saving order items: $orderItems");
      debugPrint("Order total: $orderTotal");

      final booking = BookingModel(
        userId: userId,
        restaurantId: restaurantId.value,
        tableId: tableId.value,
        guests: guests.value,
        date: date.value,
        timeStart: timeStart.value,
        timeEnd: timeEnd.value,
        items: orderItems.isEmpty ? null : orderItems,
        totalAmount: orderTotal == 0 ? null : orderTotal,
        notes: notes,
      );
      debugPrint("BOOKING ITEMS => ${booking.items}");
      await _repo.createBooking(booking);

      await _checkAvailability();
      await loadTables();

      dashboard.loadUserBookingHistory();
      dashboard.gotoBooks();

      Get.snackbar("Success", "Booking Confirmed");
    } catch (e) {
      Get.snackbar("Error", "Booking failed");
    } finally {
      isSubmitting.value = false;
    }
  }
}

extension ListTableModelExt on List<TableModel> {
  TableModel? firstWhereOrNull(bool Function(TableModel element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

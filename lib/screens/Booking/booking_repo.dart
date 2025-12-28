  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../../model/tableModel.dart';
  import '../../model/bookingModel.dart';

  class BookingRepository {
    final _db = FirebaseFirestore.instance;

    // ---------- Tables ----------
    Future<List<TableModel>> getTablesByRestaurant(String restaurantId) async {
      final snap = await _db
          .collection("tables")
          .where("restaurantId", isEqualTo: restaurantId)
          .get();

      return snap.docs
          .map((d) => TableModel.fromDoc(d.id, d.data()))
          .toList();
    }

    // ---------- Existing Booking Methods ----------
    Future<void> createBooking(BookingModel booking) async {
      await _db.collection("bookings").add(booking.toMap());
    }

    Future<List<BookingModel>> getTableBookings({
      required String restaurantId,
      required String tableId,
      required String date,
    }) async {
      final snap = await _db
          .collection("bookings")
          .where("restaurantId", isEqualTo: restaurantId)
          .where("tableId", isEqualTo: tableId)
          .where("date", isEqualTo: date)
          .get();

      return snap.docs
          .map((d) => BookingModel.fromMap(d.id, d.data()))
          .toList();
    }

  }

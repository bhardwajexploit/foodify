import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String userId;
  final String restaurantId;
  final String tableId;
  final int guests;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String status;

  // -------- New Fields --------
  final List<Map<String, dynamic>>? items;   // food list
  final double? totalAmount;
  final String? notes;

  String? restaurantName;
  String? tableNumber;

  BookingModel({
    this.id,
    required this.userId,
    required this.restaurantId,
    required this.tableId,
    required this.guests,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    this.status = "booked",

    this.items,
    this.totalAmount,
    this.notes,

    this.restaurantName,
    this.tableNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "restaurantId": restaurantId,
      "tableId": tableId,
      "guests": guests,
      "date": date,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "status": status,

      // 🔹 Serialize properly
      "items": items?.map((e) => {
        "name": e["name"],
        "qty": e["qty"],
        "price": e["price"],
        "subtotal": e["subtotal"],
      }).toList(),

      "totalAmount": totalAmount,
      "notes": notes,

      "createdAt": FieldValue.serverTimestamp(),
    };
  }


  factory BookingModel.fromMap(String id, Map<String, dynamic> map) {
    return BookingModel(
      id: id,
      userId: map["userId"],
      restaurantId: map["restaurantId"],
      tableId: map["tableId"],
      guests: (map["guests"] ?? 0) as int,
      date: map["date"] ?? "",
      timeStart: map["timeStart"] ?? "",
      timeEnd: map["timeEnd"] ?? "",
      status: map["status"] ?? "booked",

     items: (map["items"] as List?)
        ?.map((e) => Map<String, dynamic>.from(e))
        .toList(),
      totalAmount: (map["totalAmount"] ?? 0).toDouble(),
      notes: map["notes"],

      restaurantName: map["restaurantName"],
      tableNumber: map["tableNumber"],
    );
  }
}


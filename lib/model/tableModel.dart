class TableModel {
  final String id;
  final String restaurantId;
  final String tableNumber;
  final int capacity;
  final int layoutRow;
  final int layoutCol;

  /// Runtime flags (NOT stored in Firestore)
  bool isBooked;
  bool isRecommended;

  TableModel({
    required this.id,
    required this.restaurantId,
    required this.tableNumber,
    required this.capacity,
    required this.layoutRow,
    required this.layoutCol,
    this.isBooked = false,
    this.isRecommended = false,
  });

  factory TableModel.fromDoc(String id, Map<String, dynamic> json) {
    return TableModel(
      id: id,
      restaurantId: json["restaurantId"],
      tableNumber: json["tableNumber"].toString(),
      capacity: json["capacity"],
      layoutRow: json["layoutRow"],
      layoutCol: json["layoutCol"],
    );
  }
}

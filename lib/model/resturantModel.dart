import 'package:cloud_firestore/cloud_firestore.dart';
class Restaurant {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String imageUrl;

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
  });

  factory Restaurant.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: d['name'] ?? '',
      location: d['location'] ?? '',
      rating: (d['rating'] ?? 0).toDouble(),
      imageUrl: d['imageUrl'] ?? '',
    );
  }
}

import 'package:project_y3/model/cartItem.dart';

class Inventory {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Inventory({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
  });

  factory Inventory.fromFirestore(
      Map<String, dynamic> firestoreData, String docId) {
    return Inventory(
      id: docId,
      title: firestoreData['title'] ??
          '', // Providing default values is a good practice
      description: firestoreData['description'] ?? '',
      price: firestoreData['price'] is double
          ? firestoreData['price']
          : 0.0, // Ensure type safety
      imageUrl: firestoreData['imageUrl'] ?? '',
    );
  }
  
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String cartItemId;  // Added field for document ID
  final String userId;
  final String medicineUrl;
  final int quantity;
  final String unit;
  final String productName;
  final String imageUrl;
  final String genericName;
  final String manufacturer;
  final String strength;
  final String category;
  final String medicineId;
  final List<dynamic> medicinePrice;

  CartItem({
    required this.cartItemId,
    required this.userId,
    required this.medicineUrl,
    required this.quantity,
    required this.unit,
    required this.productName,
    required this.imageUrl,
    required this.genericName,
    required this.manufacturer,
    required this.strength,
    required this.category,
    required this.medicineId,
    required this.medicinePrice,
  });

  // Factory constructor to create a CartItem from Firestore DocumentSnapshot
  factory CartItem.fromDocument(DocumentSnapshot doc) {
    final cartItem = doc.data() as Map<String, dynamic>;

    return CartItem(
      cartItemId: doc.id,
      userId: cartItem['userId'],
      medicineUrl: cartItem['medicineUrl'],
      quantity: cartItem['quantity'],
      unit: cartItem['unit'],
      productName: cartItem['productName'],
      imageUrl: cartItem['imageUrl'],
      genericName: cartItem['genericName'],
      manufacturer: cartItem['manufacturer'],
      strength: cartItem['strength'],
      category: cartItem['category'],
      medicineId: cartItem['medicineId'],
      medicinePrice: cartItem['medicinePrice'] as List<dynamic>,
    );
  }


  factory CartItem.fromMap(Map<String, dynamic> cartItem) {

    return CartItem(
      cartItemId: cartItem['cartItemId'],
      userId: cartItem['userId'],
      medicineUrl: cartItem['medicineUrl'],
      quantity: cartItem['quantity'],
      unit: cartItem['unit'],
      productName: cartItem['productName'],
      imageUrl: cartItem['imageUrl'],
      genericName: cartItem['genericName'],
      manufacturer: cartItem['manufacturer'],
      strength: cartItem['strength'],
      category: cartItem['category'],
      medicineId: cartItem['medicineId'],
      medicinePrice: cartItem['medicinePrice'] as List<dynamic>,
    );
  }


  // Method to convert a CartItem to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'cartItemId': cartItemId,
      'userId': userId,
      'medicineUrl': medicineUrl,
      'quantity': quantity,
      'unit': unit,
      'productName': productName,
      'imageUrl': imageUrl,
      'genericName': genericName,
      'manufacturer': manufacturer,
      'strength': strength,
      'category': category,
      'medicineId': medicineId,
      'medicinePrice': medicinePrice,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.cartItemId == cartItemId &&
        other.userId == userId &&
        other.medicineUrl == medicineUrl &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.productName == productName &&
        other.imageUrl == imageUrl &&
        other.genericName == genericName &&
        other.manufacturer == manufacturer &&
        other.strength == strength &&
        other.category == category &&
        other.medicineId == medicineId &&
        other.medicinePrice == medicinePrice;
  }

  @override
  int get hashCode {
    return cartItemId.hashCode ^
    userId.hashCode ^
    medicineUrl.hashCode ^
    quantity.hashCode ^
    unit.hashCode ^
    productName.hashCode ^
    imageUrl.hashCode ^
    genericName.hashCode ^
    manufacturer.hashCode ^
    strength.hashCode ^
    category.hashCode ^
    medicineId.hashCode ^
    medicinePrice.hashCode;
  }
}
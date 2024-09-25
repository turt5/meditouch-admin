import 'package:cloud_firestore/cloud_firestore.dart';

import '_cartitemmodel.dart';

class OrderItem {
  final String orderId;
  final String paymentMethod;
  final String paymentStatus;
  final String userId;
  final String userAddress;
  final List<CartItem> orderedItems;
  final Timestamp timestamp;
  final String orderStatus;
  final String deliveryTime;

  OrderItem( {
    required this.orderId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.userId,
    required this.userAddress,
    required this.orderedItems,
    required this.timestamp,
    required this.orderStatus,
    required this.deliveryTime,
  });

  // Factory constructor to create an OrderItem from Firestore DocumentSnapshot
  factory OrderItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderItem(
      orderId: doc.id,
      paymentMethod: data['paymentMethod'] as String,
      paymentStatus: data['paymentStatus'] as String,
      userId: data['userId'] as String,
      userAddress: data['userAddress'] as String,
      timestamp: data['timestamp'] as Timestamp,
      orderedItems: (data['orderProducts'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      orderStatus: data['orderStatus'] as String,
      deliveryTime: data['deliveryTime'] as String,
    );
  }

  // Method to convert an OrderItem to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'userId': userId,
      'userAddress': userAddress,
      'orderedItems': orderedItems.map((item) => item.toMap()).toList(),
      'timestamp': timestamp,
      'orderStatus': orderStatus,
      'deliveryTime': deliveryTime,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.orderId == orderId &&
        other.paymentMethod == paymentMethod &&
        other.paymentStatus == paymentStatus &&
        other.userId == userId &&
        other.userAddress == userAddress &&
        other.timestamp == timestamp &&
        other.orderStatus == orderStatus &&
        other.deliveryTime == deliveryTime &&
        other.orderedItems == orderedItems;

  }

  @override
  int get hashCode {
    return orderId.hashCode ^
    paymentMethod.hashCode ^
    paymentStatus.hashCode ^
    userId.hashCode ^
    userAddress.hashCode ^
    timestamp.hashCode ^
    orderStatus.hashCode ^
    deliveryTime.hashCode ^
    orderedItems.hashCode;
  }
}
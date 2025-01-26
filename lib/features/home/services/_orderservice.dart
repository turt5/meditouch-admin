import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/ordermodel.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<OrderItem>> getAllOrders() {
    return _firestore.collection('orders').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => OrderItem.fromDocument(doc)).toList());
  }

  Stream<int> getOrderCountStream() {
    return _firestore
        .collection('db_client_user_orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.size;
    });
  }

  Stream<int> getTotalAgents() {
    return _firestore
        .collection('db_client_agent_userinfo')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<double> getTotalRevenue() {
    try {
      return _firestore
          .collection('db_client_user_orders')
          .where('payment_method', isEqualTo: 'bKash')
          .snapshots()
          .map((snapshot) {
        double totalRevenue = 0;

        for (var doc in snapshot.docs) {
          final double totalPrice = doc['total_price'];
          print(totalPrice);
          totalRevenue += totalPrice;
        }

        return totalRevenue;
      });
    } on Exception catch (e) {
      throw e;
    }
  }

  Stream<Map<String, double>> getDailyRevenueForCurrentMonth() {
  DateTime now = DateTime.now();
  DateTime startOfMonth = DateTime(now.year, now.month, 1); // First day of the month
  DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
      .subtract(Duration(days: 1)); // Last day of the month

  return _firestore
      .collection('db_client_user_orders')
      .where('payment_method', isEqualTo: 'bKash')
      .snapshots()
      .map((snapshot) {
    Map<String, double> dailyRevenue = {};

    for (var doc in snapshot.docs) {
      String orderDateString = doc['order_date'];
      DateTime orderDate = DateTime.parse(orderDateString); // Parse ISO 8601 date string
      if (orderDate.isBefore(startOfMonth) || orderDate.isAfter(endOfMonth)) {
        continue; // Skip dates outside the current month
      }

      String dayKey = DateFormat('yyyy-MM-dd').format(orderDate);

      if (!dailyRevenue.containsKey(dayKey)) {
        dailyRevenue[dayKey] = 0;
      }

      // List<dynamic> orderProducts = doc['orderProducts'];

      // for (var product in orderProducts) {
      //   String unit = product['unit'];
      //   List<dynamic> priceUnits = product['medicinePrice'];
      //   int quantity = product['quantity'];

      //   for (var priceData in priceUnits) {
      //     if (unit == priceData['unit']) {
      //       double price = double.parse(priceData['price'].toString());
      //       dailyRevenue[dayKey] = dailyRevenue[dayKey]! + (price * quantity);
      //       break; // Exit the loop after matching the correct unit
      //     }
      //   }
      // }
      dailyRevenue[dayKey] = dailyRevenue[dayKey]! + doc['total_price'];
    }

    return dailyRevenue;
  });
}


  Future<bool> markAsDelivered(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'orderStatus': 'Delivered',
        'deliveryTime': DateTime.now().toString(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}

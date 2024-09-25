import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/ordermodel.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<OrderItem>> getAllOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => OrderItem.fromDocument(doc)).toList());
  }

  Stream<int> getOrderCountStream() {
    return _firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.size;
    });
  }

  Stream<double> getTotalRevenue() {
    return _firestore
        .collection('orders')
        .where('paymentStatus', isEqualTo: 'Paid')
        .snapshots()
        .map((snapshot) {
      double totalRevenue = 0;

      for (var doc in snapshot.docs) {
        List<dynamic> orderProducts = doc['orderProducts'];

        for (var product in orderProducts) {
          String unit = product['unit'];
          List<dynamic> priceUnits = product['medicinePrice'];
          int quantity = product['quantity'];

          for (var priceData in priceUnits) {
            if (unit == priceData['unit']) {
              double price = double.parse(priceData['price'].toString());
              totalRevenue += price * quantity;
              break; // Exit the loop after matching the correct unit
            }
          }
        }
      }

      return totalRevenue;
    });
  }

  Stream<Map<String, double>> getDailyRevenueForCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime startOfMonth =
        DateTime(now.year, now.month, 1); // First day of the month
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
        .subtract(Duration(days: 1)); // Last day of the month

    return _firestore
        .collection('orders')
        .where('paymentStatus', isEqualTo: 'Paid') // Only paid orders
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .map((snapshot) {
      Map<String, double> dailyRevenue = {};

      for (var doc in snapshot.docs) {
        Timestamp timestamp = doc['timestamp'];
        DateTime orderDate = timestamp.toDate();
        String dayKey = DateFormat('yyyy-MM-dd').format(orderDate);

        if (!dailyRevenue.containsKey(dayKey)) {
          dailyRevenue[dayKey] = 0;
        }

        List<dynamic> orderProducts = doc['orderProducts'];

        for (var product in orderProducts) {
          String unit = product['unit'];
          List<dynamic> priceUnits = product['medicinePrice'];
          int quantity = product['quantity'];

          for (var priceData in priceUnits) {
            if (unit == priceData['unit']) {
              double price = double.parse(priceData['price'].toString());
              dailyRevenue[dayKey] = dailyRevenue[dayKey]! + (price * quantity);
              break; // Exit the loop after matching the correct unit
            }
          }
        }
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


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/_datetimeformat.dart';
import '../../home/models/_cartitemmodel.dart';
import '../../home/models/_usermodel.dart';
import '../../home/services/_orderservice.dart';
import '../../home/services/_userservice.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme),
        const SizedBox(height: 20,),
        Expanded(
          child: _buildOrdersList(theme),
        ),
      ],
    );
  }

  Widget _buildTopBar(ColorScheme theme){
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Order History',
            style: TextStyle(
              fontSize: 20,
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),

          StreamBuilder(stream: OrderService().getAllOrders(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator(
                radius: 12,
                color: theme.primary,
              );
            }
            if (snapshot.hasError) {
              return const Text('An error occurred while fetching orders');
            }

            final orders = snapshot.data;

            if (orders == null || orders.isEmpty) {
              return const Text('No orders found.');
            }

            // Filter pending orders
            final deliveredOrders =
            orders.where((order) => order.orderStatus == 'Delivered').toList();

            if (deliveredOrders.isEmpty) {
              return const Text('No pending orders found.');
            }

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
              ),
              child: Text('${deliveredOrders.length}',
                  style: TextStyle(color: theme.onPrimary,fontSize: 15)),
            );
          }),
        ],
      ),
    );
  }


  Widget _buildOrdersList(ColorScheme theme) {
    return StreamBuilder(
      stream: OrderService().getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CupertinoActivityIndicator(
            radius: 12,
            color: theme.primary,
          ));
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text('An error occurred while fetching orders'));
        }

        final orders = snapshot.data;

        if (orders == null || orders.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        // Filter pending orders
        final deliveredOrders =
        orders.where((order) => order.orderStatus == 'Delivered').toList();

        if (deliveredOrders.isEmpty) {
          return const Center(child: Text('No pending orders found.'));
        }

        // Sort orders by timestamp
        // deliveredOrders.sort((a, b) => b.timestamp.compareTo(a.deliveryTime));
        deliveredOrders.sort((a, b){
          DateTime aTime = DateTime.parse(a.deliveryTime);
          DateTime bTime = DateTime.parse(b.deliveryTime);
          return bTime.compareTo(aTime);
        });

        // Fetch all users once
        return FutureBuilder<List<UserModel>>(
          future: UserService().getAllUsers().first, // Fetch users once
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError) {
              return const Center(child: Text('Failed to load users.'));
            }

            final users = userSnapshot.data ?? [];
            final userMap = {for (var user in users) user.userId: user};

            return ListView.builder(
              itemCount: deliveredOrders.length,
              itemBuilder: (context, index) {
                final order = deliveredOrders[index];
                final user = userMap[order.userId] ??
                    UserModel(
                      userId: 'unknown',
                      userName: 'Unknown',
                      userEmail: '',
                      userPhone: '',
                      userImage: '',
                      userDob: '',
                      userGender: '',
                    );

                return _buildOrderCard(order, user, theme, context);
              },
            );
          },
        );
      },
    );
  }



  Widget _buildOrderCard(
      order, UserModel user, ColorScheme theme, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(.2),
            blurRadius: 100,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Order ID: ${order.orderId}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: theme.onPrimary)),
            subtitle: Text('User: ${user.userName}',
                style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
          ),
          Divider(color: theme.onSurface.withOpacity(.2)),
          _buildOrderDetails(order, theme),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(order, ColorScheme theme) {

    DateTime deliveryTime = DateTime.parse(order.deliveryTime);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Date: ${AppDateTimeFormat().formatTimestamp(order.timestamp)}',
            style: TextStyle(color: theme.onPrimary.withOpacity(.6)),
          ),
          Text('Payment Method: ${order.paymentMethod}',
              style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
          Text('Payment Status: ${order.paymentStatus}',
              style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
          Text('User Address: ${order.userAddress}',
              style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
          Text('Ordered Items:',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: theme.onPrimary)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderedItems.length,
            itemBuilder: (context, index) {
              final orderProduct = order.orderedItems[index];
              final individualPrice = calculateIndividualPrice(orderProduct);

              return ListTile(
                title: Text("${orderProduct.productName} ${orderProduct.strength}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.onPrimary)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${orderProduct.manufacturer}',
                        style: TextStyle(
                            color: theme.onPrimary.withOpacity(.6))),
                    Text(
                      '${orderProduct.quantity} x ${orderProduct.unit}',
                      style: TextStyle(color: theme.onPrimary.withOpacity(.6)),
                    ),
                  ],
                ),
                trailing: Text('৳ $individualPrice',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.onPrimary)),
              );
            },
          ),
          Divider(color: theme.onSurface.withOpacity(.2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(color: theme.onPrimary.withOpacity(.6)),
                ),
                Text(
                  '৳ ${getTotalAmount(order.orderedItems)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: theme.onPrimary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Order Status: ',
                  style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
              const SizedBox(width: 5),
              Text(order.orderStatus,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: theme.onPrimary)),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Delivery Time: ',
                  style: TextStyle(color: theme.onPrimary.withOpacity(.6))),
              const SizedBox(width: 5),
              Text(AppDateTimeFormat().formatTime(deliveryTime.toString()),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: theme.onPrimary)),
            ],
          ),
        ],
      ),
    );
  }


  String calculateIndividualPrice(CartItem orderProduct) {
    final medicinePrice = orderProduct.medicinePrice.firstWhere(
          (price) => price['unit'] == orderProduct.unit,
      orElse: () => {'price': 0},
    );
    final totalPrice = (medicinePrice['price'] as num) * orderProduct.quantity;
    return totalPrice.toStringAsFixed(2);
  }

  String getTotalAmount(List<CartItem> orderProducts) {
    double total = 0;

    for (var orderProduct in orderProducts) {
      final medicinePrice = orderProduct.medicinePrice.firstWhere(
            (price) => price['unit'] == orderProduct.unit,
        orElse: () => {'price': 0},
      );

      total += (medicinePrice['price'] as num) * orderProduct.quantity;
    }

    return total.toStringAsFixed(2);
  }
}

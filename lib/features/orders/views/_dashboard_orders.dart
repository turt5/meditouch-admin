import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/home/services/_orderservice.dart';
import 'package:meditouch_admin/shared/widgets/_custom_alert.dart';
import '../../../core/utils/_datetimeformat.dart';
import '../../home/models/_cartitemmodel.dart';
import '../../home/models/_usermodel.dart';
import '../../home/services/_userservice.dart';

class DashboardOrders extends StatelessWidget {
  const DashboardOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 20),
        Expanded(child: _buildOrdersList(theme)),
      ],
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
        final pendingOrders =
        orders.where((order) => order.orderStatus == 'Pending').toList();

        if (pendingOrders.isEmpty) {
          return const Center(child: Text('No pending orders found.'));
        }

        // Sort orders by timestamp
        pendingOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));

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
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Order Status:',
                    style: TextStyle(color: theme.onPrimary.withOpacity(.6)),
                  ),
                  const SizedBox(width: 10),
                  Text(order.orderStatus,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: theme.onPrimary)),
                ],
              ),
              ElevatedButton(
                onPressed: () async {

                  bool response =
                  await OrderService().markAsDelivered(order.orderId);


                  if (response) {

                    showCustomAlert(context, 'Marked as delivered!',
                        CupertinoColors.activeGreen, Colors.white);
                  } else {

                    showCustomAlert(context,
                        'Action failed, Something went wrong!', Colors.red, Colors.white);
                  }
                },
                child: Row(
                  children: const [
                    Icon(Icons.done),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Mark as Delivered'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderDetails(order, ColorScheme theme) {
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
                title: Text(orderProduct.productName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.onPrimary)),
                subtitle: Text(
                  '${orderProduct.quantity} x ${orderProduct.unit}',
                  style: TextStyle(color: theme.onPrimary.withOpacity(.6)),
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
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme theme) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(.1),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Pending Orders',
              style: TextStyle(fontSize: 20, color: theme.primary,fontWeight: FontWeight.bold)),
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
            final pendingOrders =
            orders.where((order) => order.orderStatus == 'Pending').toList();

            if (pendingOrders.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.error,
                  shape: BoxShape.circle,
                ),
                child: Text('0',
                    style: TextStyle(color: theme.onError,fontSize: 15)),
              );
            }

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.error,
                shape: BoxShape.circle,
              ),
              child: Text('${pendingOrders.length}',
                  style: TextStyle(color: theme.onError,fontSize: 15)),
            );
          }),
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

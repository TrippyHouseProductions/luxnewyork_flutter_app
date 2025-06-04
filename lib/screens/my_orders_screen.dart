import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product_data.dart';

class Order {
  final Product product;
  final String orderDate;
  final String status;

  Order({required this.product, required this.orderDate, required this.status});
}

final List<Order> orders = [
  Order(product: products[0], orderDate: '2025-05-20', status: 'Delivered'),
  Order(product: products[3], orderDate: '2025-05-25', status: 'Processing'),
  Order(product: products[6], orderDate: '2025-06-01', status: 'Shipped'),
];

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Orders', style: textTheme.titleLarge),
            const SizedBox(height: 20),
            Expanded(
              child: orders.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Image.asset(
                              order.product.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(order.product.name,
                                style: textTheme.bodyLarge),
                            subtitle: Text(
                              'Date: ${order.orderDate}\nStatus: ${order.status}',
                              style: textTheme.bodyMedium,
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No orders yet', style: textTheme.bodyMedium),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

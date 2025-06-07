import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/list_tile_skeleton.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  Future<void> _refresh() async {
    await context.read<OrderProvider>().fetchOrders();
  }

  Future<void> _showOrderDetails(int id) async {
    final order = await context.read<OrderProvider>().fetchOrderDetail(id);
    if (order == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Order #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (order.status.isNotEmpty) Text('Status: ${order.status}'),
              if (order.total.isNotEmpty) Text('Total: ${order.total}'),
              const SizedBox(height: 12),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Text('${item.quantity} x ${item.name}'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: colorScheme.surface,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, __) => const ListTileSkeleton(),
            );
          }

          if (provider.orders.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 300,
                  child: Center(child: Text('No orders found')),
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.orders.length,
              itemBuilder: (_, index) {
                final order = provider.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text('Order #${order.id}'),
                    subtitle: order.total.isNotEmpty
                        ? Text('Total: ${order.total}')
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showOrderDetails(order.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

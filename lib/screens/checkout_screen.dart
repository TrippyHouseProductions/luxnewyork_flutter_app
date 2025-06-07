import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final fakeInfo =
        '${_cardNumberController.text}|${_expiryController.text}|${_cvvController.text}';
    setState(() => _isLoading = true);
    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();
    final order = await orderProvider.placeOrder(fakeInfo);
    setState(() => _isLoading = false);

    if (order != null) {
      await cartProvider.loadCart();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order')),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter card number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(labelText: 'Expiry Date'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter expiry date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter CVV' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

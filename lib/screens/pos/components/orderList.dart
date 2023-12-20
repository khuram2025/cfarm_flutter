import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Total Products (3)'),
                ),
                ProductOrderItem(
                  productName: 'RedBull',
                  productPrice: '30 EGP',
                  productImage: 'assets/images/6.jpg',
                  quantity: 1,
                ),
                ProductOrderItem(
                  productName: 'Water',
                  productPrice: '50 EGP',
                  productImage: 'assets/images/4.jpeg',
                  quantity: 1,
                ),
                ProductOrderItem(
                  productName: 'Oil',
                  productPrice: '150 EGP',
                  productImage: 'assets/images/5.jpeg',
                  quantity: 1,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Select Customer (optional)'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Select Payment Method'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('215 EGP'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax (14%)'),
                    Text('30 EGP'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Text('245 EGP', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, // make button full width
                  child: ElevatedButton(
                    child: Text('Checkout'),
                    onPressed: () {
                      // TODO: Implement checkout logic
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductOrderItem extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final int quantity;

  const ProductOrderItem({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(productImage, width: 50, height: 50),
      title: Text(productName),
      subtitle: Text(productPrice),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              // TODO: Decrease quantity
            },
          ),
          Text(quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Increase quantity
            },
          ),
        ],
      ),
    );
  }
}

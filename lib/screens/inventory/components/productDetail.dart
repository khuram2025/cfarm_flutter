import 'package:cstore_flutter/screens/inventory/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you have added flutter_svg in your pubspec.yaml

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String smsIcon = 'assets/icons/sms.svg';
    final String callIcon = 'assets/icons/call.svg';
    final String houseImagePath =
        product.imageUrl; // Use your Product's image path

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Property Information'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [
            Image.network(
              houseImagePath,
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              product.description,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(icon: emailIcon, label: 'EMAIL', onTap: () {}),
                ActionButton(icon: smsIcon, label: 'SMS', onTap: () {}),
                ActionButton(icon: callIcon, label: 'CALL', onTap: () {}),
              ],
            ),
            Divider(),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align TabBar to the left
                child: TabBar(
                  isScrollable: true,
                  // Enable horizontal scrolling
                  indicatorColor: Colors.green,
                  // Color for the indicator
                  indicatorSize: TabBarIndicatorSize.tab,
                  // Indicator size as per tab
                  labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  // Reduce left and right padding of each tab
                  tabs: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      child: Tab(
                        icon: Icon(Icons.visibility, size: 16),
                        // Example icon, replace with your own icon
                        text: 'Overview',
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.storage, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Stock Status',
                    ),
                    Tab(
                      icon: Icon(Icons.attach_money, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Sale',
                    ),
                    Tab(
                      icon: Icon(Icons.shopping_cart, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Purchase',
                    ),
                    Tab(
                      icon: Icon(Icons.analytics, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Analytics',
                    ),
                    Tab(
                      icon: Icon(Icons.report, size: 16),
                      // Example icon, replace with your own icon
                      text: 'Reports',
                    ),
                    // ... add more tabs as needed ...
                  ],
                ),
              ),
            ),

            // Expanded widget to take the remaining space for TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Overview Content')),
                  Center(child: Text('Stock Status Content')),
                  Center(child: Text('Sale Content')),
                  Center(child: Text('Purchase Content')),
                  Center(child: Text('Analytics Content')),
                  Center(child: Text('Reports Content')),
                  // ... add more tab views as needed ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
      ),
    );
  }
}

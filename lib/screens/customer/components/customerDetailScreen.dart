import 'package:cstore_flutter/screens/customer/components/customerOrdersDetailList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you have added flutter_svg in your pubspec.yaml

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String smsIcon = 'assets/icons/sms.svg';
    final String callIcon = 'assets/icons/call.svg';
    final String customerLevelIcon = 'assets/icons/star.svg'; // Example icon for customer level

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Customer Information'),
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
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(customer.imagePath), // Replace with your customer image path
                  radius: 50,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(customerLevelIcon, width: 20, height: 20),
                        Text(' Level 1'),
                      ],
                    ),
                  ],
                ),
              ],
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
                alignment: Alignment.centerLeft,
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
                      text: 'Orders',
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
            Expanded(
              child: TabBarView(
                children: [
                  // Customer Details Tab
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: SvgPicture.asset(emailIcon),
                          title: Text(customer.email),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(callIcon),
                          title: Text(customer.phone),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(customer.address),
                        ),
                      ],
                    ),
                  ),
                  // Customer Orders Tab
          CustomerOrdersDetailList(
            orders: [
              Order(
                imageUrl: 'https://example.com/image1.jpg', // Replace with actual image URL
                customerName: 'John Doe',
                mobileNumber: '123-456-7890',
                date: '2023-03-15',
                transactionType: 'Full',
                totalAmount: 100.00,
              ),
// Add more Order objects with different details
            ],
          ),

          // Customer Activity Tab
                  Center(child: Text('Customer Activity Content')),
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

class Customer {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String imagePath; // Add imagePath to Customer class

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.imagePath, // Initialize imagePath in constructor
  });
}

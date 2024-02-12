import 'package:cstore_flutter/screens/inventory/animal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../api/models.dart';
import 'milkingTab.dart'; // Ensure you have added flutter_svg in your pubspec.yaml

class AnimalDetailScreen extends StatelessWidget {

  final Animal animal;
  final List<MilkingData> milkingDataList;

  AnimalDetailScreen({Key? key, required this.animal, required this.milkingDataList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Dummy data for icons, replace with your actual assets
    final String emailIcon = 'assets/icons/email.svg';
    final String smsIcon = 'assets/icons/sms.svg';
    final String callIcon = 'assets/icons/call.svg';
    String imageUrl = animal.imagePath ?? 'default_image_url'; // Use your Product's image path


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
              imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              animal.tag,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
              padding: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.centerLeft, // Align TabBar to the left
                child: TabBar(
                  isScrollable: true,
                  // Enable horizontal scrolling
                  indicatorColor: Colors.green,
                  // Color for the indicator
                  indicatorSize: TabBarIndicatorSize.tab,
                  // Indicator size as per tab
                  labelPadding: EdgeInsets.only(left: 0, right: 12.0),
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
                      text: 'Milking Tab',
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
                  _buildSpecificationSection(context, animal),
                MilkingTable(animalId: animal.id),
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



  Widget _buildSpecificationSection(BuildContext context, Animal animal) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    Widget _buildSpecificationItem(String title, String data) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontSize: isLargeScreen ? 16 : 14,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                data,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: isLargeScreen ? 16 : 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpecificationItem("Age", _calculateAge(animal.dob)),
        _buildSpecificationItem("Weight", '${animal.latestWeight ?? 'N/A'} kg'),
        _buildSpecificationItem("Type", animal.animalType),
        _buildSpecificationItem("Price", '\$${animal.purchaseCost ?? 'N/A'}'),
        _buildSpecificationItem("Sex", animal.sex),
        _buildSpecificationItem("Status", animal.status),
        // Add more specifications as needed
      ],
    );
  }
  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }

    if (days < 0) {
      final lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
      months--;
    }

    String age = '';
    if (years > 0) age += '$years Year${years > 1 ? 's' : ''} ';
    if (months > 0) age += '$months Month${months > 1 ? 's' : ''} ';
    if (days > 0) age += '$days Day${days > 1 ? 's' : ''}';

    return age.trim();
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

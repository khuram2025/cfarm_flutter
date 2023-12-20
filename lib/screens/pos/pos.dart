import 'package:cstore_flutter/constants.dart';
import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';
import 'package:cstore_flutter/screens/pos/components/orderList.dart';
import 'package:cstore_flutter/screens/pos/components/searchBar.dart';
import 'package:flutter/material.dart';

import 'components/models.dart';
// Assume 'Responsive', 'Header', 'SideMenu', and 'constants.dart' are defined as in your previous code.

class POSScreen extends StatefulWidget {
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOrderScreenVisible = false;

  void toggleOrderScreen() {
    setState(() {
      isOrderScreenVisible = !isOrderScreenVisible;
    });
  }






  bool isActiveCategory(Category category) {
    // Implement your logic to determine if a category is active
    return category.name == 'Beverages';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isOrderScreenVisible
          ? null // Hide the floating action button when OrderScreen is visible
          : FloatingActionButton.extended(
        onPressed: toggleOrderScreen,
        label: Text('Proceed with order 3 Items \$5000'),
        icon: Icon(Icons.shopping_cart),
      ),
      bottomNavigationBar: isOrderScreenVisible
          ? null // Hide the bottom bar when OrderScreen is visible
          : BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 48), // Balance the space on the right side
              Text('Total: \$5000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(width: 48), // Placeholder for symmetry
            ],
          ),
        ),
      ),
      body: isOrderScreenVisible
          ? OrderScreen() // Show OrderScreen when isOrderScreenVisible is true
          : SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(child: SideMenu()),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),
                    CustomSearchBar(),
                    SizedBox(height: defaultPadding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: ChoiceChip(
                              label: Text(category.name),
                              selected: isActiveCategory(category),
                              onSelected: (selected) {
                                // TODO: Handle category selection
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    ProductListView(products: products), // Product list
                    // You can add more widgets here as per your POS screen requirement
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(width: defaultPadding),
            // On Mobile means if the screen is less than 850 we don't want to show it
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: OrderScreen(),
              ),
          ],
        ),
      ),
    );
  }
}


class ProductListView extends StatelessWidget {
  final List<Product> products;

  ProductListView({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the cross-axis count and aspect ratio based on the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200 ? 4 : screenWidth > 600 ? 3 : 2; // For desktop, tablet, mobile
    double cardWidth = screenWidth > 600 ? 250 : 200;
    double cardHeight = screenWidth > 600 ? 200 : 150;
    double childAspectRatio = cardWidth / cardHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(), // Allows the GridView to be scrollable
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0), // Add padding around the image
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.error)); // Fallback icon in case of an error
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${product.salePrice} EGP', style: TextStyle(color: Colors.grey)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            // TODO: Implement increase quantity
                          },
                        ),
                        Text('1', style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            // TODO: Implement decrease quantity
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}









class Product {
  final String name;
  final String barcode;
  final String quantity;
  final String category;
  final String salePrice;
  final String purchasePrice;
  final String description;
  final String expirationDate;
  final String imagePath;

  Product({
    required this.name,
    required this.barcode,
    required this.quantity,
    required this.category,
    required this.salePrice,
    required this.purchasePrice,
    required this.description,
    required this.expirationDate,
    required this.imagePath,
  });
}

class Category {
  final String name;

  Category(this.name);
}

import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/dashboard/components/storage_details.dart';
import 'package:cstore_flutter/screens/inventory/components/AddNewProduct.dart';
import 'package:cstore_flutter/screens/inventory/components/productDetail.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';

import 'package:flutter/material.dart';
import '../../../constants.dart';


class ProductListScreen extends StatefulWidget {
  final String companyName;

  ProductListScreen({Key? key, required this.companyName}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Product? selectedProduct; // The selected product for detail view
  bool isAddingNewProduct = false; // To determine if we are adding a new product




  List<Product> products = [];

  final List<Category> categories = [
    Category('Beverages'),
    Category('Candy'),
    Category('Packaged Food'),
    Category('Home'),
  ];
  void onProductSelected(Product product) {
    setState(() {
      selectedProduct = product;
      isAddingNewProduct = false;
    });
  }

  void onAddProduct() {
    setState(() {
      selectedProduct = null;
      isAddingNewProduct = true;
    });
  }


  bool isActiveCategory(Category category) {
  // Implement your logic to determine if a category is active
  // This is just an example, you can replace it with your actual logic
  return category.name == 'Beverages';
  }
  bool _isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      var companyId = 11; // Replace with actual company ID
      var fetchedProducts = await ApiService().fetchProducts(companyId);
      setState(() {
        products = fetchedProducts.map<Product>((json) => Product.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    Widget detailScreen = selectedProduct != null
        ? ProductDetailScreen(product: selectedProduct!) // selectedProduct must be the correct Product type
        : AddNewProductScreen();

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),

                    Row(
                      children: [
                        SizedBox(width: defaultPadding),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Product',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                      ],
                    ),

                    SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        ElevatedButton(
                          onPressed: () {
// TODO: Add your 'Add Category' logic here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text('Add Category'),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),

                    Row(
                      children: [



                        // Add Horizontal Scroll View
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                            child: Wrap(
                              spacing: 5.0, // Space between categories
                              children: [
                                // Loop through categories and create buttons
                                for (final category in categories)
                                  ElevatedButton(
                                    onPressed: () {}, // Add your category selection logic here
                                    style: ElevatedButton.styleFrom(

                                      onPrimary: isActiveCategory(category) ? Colors.blue : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.grey[300]!),
                                      ),
                                    ),
                                    child: Text(category.name),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                      ],
                    ),


                    SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product List",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(width: defaultPadding),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the AddNewProductScreen when the button is pressed
                            if (Responsive.isMobile(context)) {
                              // If it's a mobile layout, push a new screen on the navigation stack
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddNewProductScreen()),
                              );
                            } else {
                              // For desktop layout, update the state to show the AddNewProductScreen
                              onAddProduct(); // This will call your existing function to change the state
                            }
                          },
                          child: Text("Add Product"),
                        ),



                      ],
                    ),
                    SizedBox(height: defaultPadding),

                    ProductListView(products: products, onProductSelected: onProductSelected,), // Correctly placed within a Column
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

              child: isAddingNewProduct ? AddNewProductScreen() : (selectedProduct != null ? ProductDetailScreen(product: selectedProduct!) : Container()),
            )
          ],
        ),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;

  ProductListView({Key? key, required this.products, required this.onProductSelected,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: Image.network(
              product.imageUrl, // Use the actual image URL here
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Fallback icon in case of an error
              },
            ),
            title: Text(product.name),
            subtitle: Row(
              children: [
                Text('Purchase: ${product.purchasePrice ?? "N/A"}'),
                SizedBox(width: 8), // Small gap
                Text('Sale: ${product.salePrice ?? "N/A"}'),
                SizedBox(width: 8), // Small gap
                Text('Stock: ${product.quantity ?? "N/A"}'),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              if (Responsive.isMobile(context)) {
                // If in mobile view, push the ProductDetailScreen onto the navigation stack
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                );
              } else {
                // For larger screens, use onProductSelected to update the state
                onProductSelected(product);
              }
            },
          ),
        );
      },
    );
  }
}

class Product {
  final int id;
  final String name;
  final String barcode;
  final String quantity;
  final String category;
  final String salePrice;
  final String purchasePrice;
  final String current_stock;
  final String description;
  final String expirationDate;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    this.barcode = '0000000000',
    this.quantity = '10',
    this.category = 'Dummy Category',
    this.salePrice = '100.00',
    this.purchasePrice = '80.00',
    this.description = 'This is a dummy product description.',
    this.expirationDate = '2024-01-01',
    this.current_stock = '10',
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Define the base URL
    const String baseUrl = 'http://app.channab.com';

    // Check if image_url is not null and concatenate with base URL, otherwise use a default image
    String imageUrl = json['image_url'] != null
        ? baseUrl + json['image_url']
        : 'assets/images/default_image.png';

    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'] ?? '0000000000',
      quantity: json['current_stock']?.toString() ?? '0.0',
      category: json['category'] ?? 'Dummy Category',
      salePrice: json['sale_price']?.toString() ?? '000.00',
      purchasePrice: json['purchase_price']?.toString() ?? '00.00',
      description: json['description'] ?? 'This is a dummy product description.',
      expirationDate: json['expiration_date'] ?? '2024-01-01',
      imageUrl: imageUrl,
      // Other fields remain as dummy data
    );
  }
}






class Category {
  final String name;

  Category(this.name);
}
import 'package:flutter/material.dart';

class AddNewProductScreen extends StatefulWidget {
  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // You can create TextEditingControllers if needed to manage form input
  // TextEditingController barcodeController = TextEditingController();
  // ... other controllers for each field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Product Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Barcode',
                  suffixIcon: Icon(Icons.qr_code_scanner),
                  // Add other decoration properties as needed
                ),
                // controller: barcodeController,
                // Add validator if needed
              ),
              // Repeat TextFormField for each field...
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                // controller: firstNameController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                // controller: quantityController,
              ),
              // Add more TextFormFields for Category, Expiration Date, Sale Price, etc.
              // ...

              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Product'),
                onPressed: () {
                  // Perform action to add the product
                  if (_formKey.currentState!.validate()) {
                    // If all data are correct then save data to out variables
                    _formKey.currentState!.save();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background (button) color
                  onPrimary: Colors.white, // foreground (text) color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

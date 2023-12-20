import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/screens/inventory/product_list.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone, // Use phone keyboard type
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  try {
                    var response = await apiService.login(
                      mobileController.text,
                      passwordController.text,
                    );
                    if (response['status'] == 'success') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductListScreen(companyName: "Your Company Name")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Don\'t have an account? Sign up'),
                onPressed: () {
                  // TODO: Navigate to Signup Screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

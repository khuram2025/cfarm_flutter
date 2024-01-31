import 'package:flutter/material.dart';

import '../../api/apiService.dart';
import '../inventory/animal_list.dart';
// import '../inventory/animal_list.dart'; // Uncomment this when you have the AnimalListScreen in your project
// import 'package:cstore_flutter/api/apiService.dart'; // Uncomment this when you have the ApiService in your project

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channab Dairy APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Uncomment this when you have the ApiService in your project

  void _login() async {
    try {
      print("Attempting to login...");
      final response = await _apiService.loginUser(_mobileController.text, _passwordController.text);
      print('API Response: $response');

      if (response != null) {
        if (response.containsKey("token")) {
          print("Login successful! Navigating to HomePage...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AnimalListScreen()), // Pass the token if needed
          );
        } else {
          print("Login failed. Check your credentials.");
          if (response.containsKey('error')) {
            print('API Error: ${response['error']}'); // Handle error response
          }
        }
      } else {
        print("Login failed. Response was null.");
      }
    } catch (e, stacktrace) {
      print('Exception occurred: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the width is more than 600 which can be considered as a breakpoint for desktop
          if (constraints.maxWidth > 600) {
            // Desktop layout
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue.shade100,
                    child: Center(
                      child: Text(
                        "Welcome To Channab Dairy APP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildLoginForm(),
                ),
              ],
            );
          } else {
            // Mobile layout
            return Center(
              child: _buildLoginForm(),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    // Use MediaQuery to make padding responsive
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    double verticalPadding = MediaQuery.of(context).size.height * 0.1;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome To Channab",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 40),
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Mobile Number",
              hintText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity, // Make the button stretch to the width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _login,
              child: Text("Login"),
            ),
          ),
          SizedBox(height: 20),
          _buildBottomTextButtons(),
        ],
      ),
    );
  }

  Widget _buildBottomTextButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // Handle reset password
          },
          child: Text(
            "Reset Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle signup
          },
          child: Text(
            "Signup",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

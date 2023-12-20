import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://app.channab.com/';

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    print('Sending to API: Mobile: $mobile, Password: $password'); // Add this line

    final response = await http.post(
      Uri.parse(baseUrl + 'account/api/mobile-login/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
        'password': password,
      }),
    );

    print('Response Status Code: ${response.statusCode}'); // Add this line
    print('Response Body: ${response.body}'); // Add this line

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchProducts(int companyId) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'companies/api/inventory/11/'), // Adjust the URL as needed
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['store_products']; // Assuming 'store_products' is the key
    } else {
      throw Exception('Failed to fetch products. Status code: ${response.statusCode}');
    }
  }
}

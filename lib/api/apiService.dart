import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class ApiService {
  final String baseUrl = "http://farmapp.channab.com/";

  Future<Map<String, dynamic>?> loginUser(String mobileNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/api/login/'),
      body: {
        'username': mobileNumber,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String? token = data['token'];  // Assuming the token is returned with the key 'token'
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
      return data;
    }
  }


  Future<AnimalResponse> fetchAnimals(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/dairy/api/animals/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> animalsJson = data['animals'];
      List<Animal> animals = animalsJson.map((json) => Animal.fromJson(json)).toList();
      Map<String, String> animalTypes = Map<String, String>.from(data['animal_types']);

      return AnimalResponse(animals: animals, animalTypes: animalTypes);
    } else {
      print('Failed to load animals with status code: ${response.statusCode}');
      throw Exception('Failed to load animals with status code: ${response.statusCode}');
    }
  }

  Future<AnimalResponse> fetchAnimalsByType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/dairy/api/animals/?type=$type'), // Adjust API endpoint as needed
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> animalsJson = data['animals'];
      List<Animal> animals = animalsJson.map((json) => Animal.fromJson(json)).toList();
      Map<String, String> animalTypes = Map<String, String>.from(data['animal_types']);

      return AnimalResponse(animals: animals, animalTypes: animalTypes);
    } else {
      print('Failed to load animals with status code: ${response.statusCode}');
      throw Exception('Failed to load animals with status code: ${response.statusCode}');
    }
  }


}

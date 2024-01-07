import 'package:cstore_flutter/screens/inventory/components/animalDetail.dart';
import 'package:flutter/material.dart';

import '../../../api/apiService.dart';
import '../../../api/models.dart';
import '../../../responsive.dart';

class AnimalListView extends StatefulWidget {
  final List<Animal> animals;
  final Key key;
  final Function(Animal) onAnimalTap;


  AnimalListView({required this.key, required this.animals, required this.onAnimalTap}) : super(key: key);

  @override
  _AnimalListViewState createState() => _AnimalListViewState();
}
class _AnimalListViewState extends State<AnimalListView> {

  late ApiService apiService;
  List<Animal> animals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadAnimals();
  }

  void _loadAnimals() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Animal> fetchedAnimals = await apiService.fetchAnimals(1);
      setState(() {
        animals = fetchedAnimals;
      });
    } catch (e) {
      print("Error fetching animals: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return animals.isEmpty
        ? Text("No animals available")
        : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.animals.length,
      itemBuilder: (context, index) {
        final animal = widget.animals[index];
        return InkWell(
          onTap: () {
            if (Responsive.isMobile(context)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimalDetailScreen(animal: animal,milkingDataList: [
                  // Populate this list with your milking data
                  MilkingData(DateTime.now(), 5.0, 4.5, 6.0),
                  // ... more data ...
                ],)),
              );
            } else {
              widget.onAnimalTap(animal); // Call the callback function
            }
          },
          child: Card(
            child: Container(
              height: 140,
              child: Row(
                children: [
                  // First Column: Animal Image
                  Container(
                    width: 120,
                    height: 140,
                    child: Image.network(
                      animal.imagePath ?? 'default_image_url_here',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  ),
                  // Second Column: Animal Details
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row: Tag, Edit, Delete Icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                animal.tag,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.green),
                                  SizedBox(width: 8),
                                  Icon(Icons.delete, color: Colors.red),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8), // Add vertical gap
                          // Second Row: Weight
                          Text('Weight: ${animal.latestWeight ?? 'N/A'} kg'),
                          SizedBox(height: 8), // Add vertical gap
                          // Third Row: Age
                          Text('Age: ${calculateAge(animal.dob)}'),
                          SizedBox(height: 8), // Add vertical gap
                          // Fourth Row: Type, Sex, Category
                          Row(
                            children: [
                              _buildDetailBox(capitalizeFirstLetter(animal.animalType)),
                              _buildDetailBox(capitalizeFirstLetter(animal.sex)),
                              _buildDetailBox(capitalizeFirstLetter(animal.categoryTitle)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return '$age years';
  }

  Widget _buildDetailBox(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.green),
      ),
    );
  }

}


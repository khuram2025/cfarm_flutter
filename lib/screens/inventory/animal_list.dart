import 'package:cstore_flutter/responsive.dart';
import 'package:cstore_flutter/screens/dashboard/components/header.dart';
import 'package:cstore_flutter/screens/dashboard/components/storage_details.dart';
import 'package:cstore_flutter/screens/inventory/components/AddNewProduct.dart';
import 'package:cstore_flutter/screens/inventory/components/animalDetail.dart';
import 'package:cstore_flutter/screens/main/components/side_menu.dart';

import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../api/apiService.dart';
import '../../api/models.dart';
import 'components/animal_listScreen.dart';


class AnimalListScreen extends StatefulWidget {
  AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}
class _AnimalListScreenState extends State<AnimalListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> animalTypes = [];
  String selectedType = 'All';
  Map<String, int> animalTypeCounts = {};
  Animal? selectedAnimal;



  late ApiService apiService;
  List<Animal> animals = [];


  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadAnimalTypes();
    _loadAnimals();
  }
  void _loadAnimalTypes() async {
    try {
      List<Map<String, dynamic>> fetchedTypesWithCounts = await apiService.fetchAnimalTypes();

      // Clear previous data
      animalTypeCounts.clear();

      int totalCount = 0;

      // Populate the animalTypeCounts map and calculate the total count
      for (var typeInfo in fetchedTypesWithCounts) {
        String type = typeInfo['animal_type'] ?? 'Unknown';
        int count = typeInfo['count'] ?? 0;
        animalTypeCounts[type] = count;
        totalCount += count;
      }

      // Add the total count for 'All'
      animalTypeCounts['All'] = totalCount;

      // Update the animalTypes list
      setState(() {
        animalTypes = ['All', ...animalTypeCounts.keys.where((type) => type != 'All')];
      });
    } catch (e) {
      print("Error fetching animal types: $e");
    }
  }



  void _loadAnimals() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Animal> fetchedAnimals = await apiService.fetchAnimals(1);
      setState(() {
        animals = fetchedAnimals;
        selectedAnimal = animals.isNotEmpty ? animals.first : null;
      });
    } catch (e) {
      print("Error fetching animals: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadAnimalsByType(String type) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Animal> fetchedAnimals;
      if (type == 'All') {
        fetchedAnimals = await apiService.fetchAnimals(1);
      } else {
        fetchedAnimals = await apiService.fetchAnimalsByType(type);
      }
      setState(() {
        animals = fetchedAnimals;
        selectedAnimal = animals.isNotEmpty ? animals.first : null;
      });
    } catch (e) {
      print("Error fetching animals by type: $e");
      // Consider showing an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }




  Widget _buildAnimalTypeBox(String type, int count) {
    String displayText = '${capitalizeFirstLetter(type)} ($count)';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
          if (type == 'All') {
            _loadAnimals();
          } else {
            _loadAnimalsByType(type);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
          color: selectedType == type ? Colors.green : Colors.transparent,
        ),
        child: Text(
          displayText,
          style: TextStyle(color: selectedType == type ? Colors.white : Colors.green),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }




  @override
  Widget build(BuildContext context) {
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
                            child: Row(
                              children: animalTypes.map((type) => _buildAnimalTypeBox(
                                  type,
                                  animalTypeCounts[type] ?? 0 // Provide the count, default to 0 if not found
                              )).toList(),
                            )


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

                            }
                          },
                          child: Text("Add Product"),
                        ),

                      ],
                    ),
                    SizedBox(height: defaultPadding),

                    SizedBox(height: defaultPadding),
                    AnimalListView(
                      key: ValueKey(selectedType),
                      animals: animals,
                      onAnimalTap: (Animal animal) {
                        setState(() {
                          selectedAnimal = animal;
                        });
                      },
                    )
// Correctly placed within a Column
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(width: defaultPadding),
            // On Mobile means if the screen is less than 850 we don't want to show it
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 3,

                child: selectedAnimal != null
                    ? AnimalDetailScreen(animal: selectedAnimal!, milkingDataList: [
                  // Populate this list with your milking data
                  MilkingData(DateTime.now(), 5.0, 4.5, 6.0),
                  // ... more data ...
                ],)
                    : Center(child: Text("No animal selected")),
              )
          ],
        ),
      ),
    );
  }
}


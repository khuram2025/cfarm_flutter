import 'package:flutter/material.dart';
import 'package:cstore_flutter/screens/milkRecord/milkTable.dart';
import 'package:intl/intl.dart';
import '../../api/apiService.dart';
import '../../api/models.dart';
import '../main/components/side_menu.dart';
import '../dashboard/components/header.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class MilkingRecordScreen extends StatefulWidget {
  @override
  _MilkingRecordScreenState createState() => _MilkingRecordScreenState();
}

class _MilkingRecordScreenState extends State<MilkingRecordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedFilter = 'this_year'; // Default filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(
              flex: 5,

              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(scaffoldKey: _scaffoldKey),
                    SizedBox(height: defaultPadding),
                    Center(
                      child: Text(
                        "Milking Records",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showAddMilkForm(context),
                          icon: Icon(Icons.add),
                          label: Text('Add Milk'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFilter = newValue!;
                            });
                          },
                          items: <String>['last_7_days', 'this_month', 'this_year']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.replaceAll('_', ' ').toUpperCase()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    MilkingTable(animalId: 1, filter: selectedFilter), // Pass the selected filter to MilkingTable
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: Text("Milk Record Detail"),
              ),
          ],
        ),
      ),
    );
  }



  void _showAddMilkForm(BuildContext context) async  {
    final _formKey = GlobalKey<FormState>();
    DateTime selectedDate = DateTime.now();
    List<Animal> animals = await ApiService().fetchMilkAnimals(); // Fetch animals
    Animal? selectedAnimal;
    TextEditingController _firstTimeController = TextEditingController();
    TextEditingController _secondTimeController = TextEditingController();
    TextEditingController _thirdTimeController = TextEditingController();

    // Function to display date picker
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer to the initial date
        firstDate: DateTime(2000), // Lower bound for the date picker
        lastDate: DateTime.now(), // Upper bound is today
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Milk Record'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Date picker field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Choose Date'),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _firstTimeController,
                    decoration: InputDecoration(labelText: '1st Time Milk (L)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _secondTimeController,
                    decoration: InputDecoration(labelText: '2nd Time Milk (L)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _thirdTimeController,
                    decoration: InputDecoration(labelText: '3rd Time Milk (L)'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<Animal>(
                    value: selectedAnimal,
                    onChanged: (Animal? newValue) {
                      selectedAnimal = newValue;
                    },
                    items: animals.map<DropdownMenuItem<Animal>>((Animal animal) {
                      return DropdownMenuItem<Animal>(
                        value: animal,
                        child: Text(animal.tag), // Updated to use tag instead of id
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Animal'),
                  ),
                  // Add more fields if necessary
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // Inside _showAddMilkForm, for the 'Save' button onPressed callback
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (selectedAnimal != null) { // Ensure selectedAnimal is not null
                    try {
                      // Make the API call and wait for the result
                      bool success = await ApiService().createOrUpdateMilkRecord(
                        date: selectedDate,
                        animalId: selectedAnimal!.id, // Use the selectedAnimal's ID safely
                        firstTime: double.tryParse(_firstTimeController.text),
                        secondTime: double.tryParse(_secondTimeController.text),
                        thirdTime: double.tryParse(_thirdTimeController.text),
                      );

                      if (success) {
                        // Handle success, e.g., show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Milk record created/updated successfully")),
                        );
                        Navigator.of(context).pop(); // Close the dialog
                        // Optionally, refresh the list or perform other actions upon success
                      } else {
                        // Handle failure, e.g., show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to create/update milk record")),
                        );
                      }
                    } catch (e) {
                      // Handle any errors that occur during the API call
                      print(e); // For debugging
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("An error occurred while saving the milk record")),
                      );
                    }
                  } else {
                    // Handle case where no animal is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select an animal")),
                    );
                  }
                }
              },
            ),


          ],
        );
      },
    );
  }


}

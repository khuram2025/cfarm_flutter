import 'package:flutter/material.dart';
import 'package:cstore_flutter/screens/milkRecord/milkTable.dart';
import 'package:intl/intl.dart';
import '../../api/apiService.dart';
import '../../api/models.dart';
import '../main/components/side_menu.dart';
import '../dashboard/components/header.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'package:flutter/scheduler.dart';

class MilkingRecordScreen extends StatefulWidget {
  @override
  _MilkingRecordScreenState createState() => _MilkingRecordScreenState();
}

class _MilkingRecordScreenState extends State<MilkingRecordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedFilter = 'this_year'; // Default filter
  Widget? sidePanelContent;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  List<Animal> animals = [];
  Animal? selectedAnimal;
  TextEditingController _firstTimeController = TextEditingController();
  TextEditingController _secondTimeController = TextEditingController();
  TextEditingController _thirdTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        sidePanelContent = _buildAddMilkForm(context);
      });
    });
  }

  Future<void> _fetchAnimals() async {
    animals = await ApiService().fetchMilkAnimals();
    setState(() {}); // Update state after fetching animals
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
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(
              flex: 4,
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
                    MilkingTable(animalId: 1, filter: selectedFilter),
                  ],
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: sidePanelContent!,
              ),
          ],
        ),
      ),
    );
  }

  void _showAddMilkForm(BuildContext context) async {
    if (Responsive.isDesktop(context)) {
      setState(() {
        sidePanelContent = _buildAddMilkForm(context);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: _buildAddMilkForm(context),

        ),
      );
    }
  }



  Widget _buildAddMilkForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding( // Add padding for better visual spacing
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align labels to the start
            children: <Widget>[
              Text(
                "Add Milk Record",
                style: Theme.of(context).textTheme.subtitle1, // Style the label
              ),
              SizedBox(height: defaultPadding / 2), // Add spacing between label and picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Choose Date'),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding), // Add spacing between sections

              // Milk time TextFields

              SizedBox(height: defaultPadding / 2),
              TextFormField(
                controller: _firstTimeController,
                decoration: InputDecoration(labelText: '1st Time'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: defaultPadding / 2),
              TextFormField(
                controller: _secondTimeController,
                decoration: InputDecoration(labelText: '2nd Time'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: defaultPadding / 2),
              TextFormField(
                controller: _thirdTimeController,
                decoration: InputDecoration(labelText: '3rd Time'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: defaultPadding),

              // Animal Dropdown
              Text(
                "Animal",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: defaultPadding / 2),
              DropdownButtonFormField<Animal>(
                value: selectedAnimal,
                onChanged: (Animal? newValue) {
                  setState(() {
                    selectedAnimal = newValue;
                  });
                },
                items: animals.map<DropdownMenuItem<Animal>>((Animal animal) {
                  return DropdownMenuItem<Animal>(
                    value: animal,
                    child: Text(animal.tag),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Animal'),
              ),
              SizedBox(height: defaultPadding),

              // Save and Cancel buttons
              Padding(
                padding: const EdgeInsets.only(top: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Clear/reset the form and update the state
                        _formKey.currentState?.reset(); // Reset the form
                        _firstTimeController.clear();
                        _secondTimeController.clear();
                        _thirdTimeController.clear();
                        selectedAnimal = null; // Clear selected animal
                        selectedDate = DateTime.now(); // Reset date
                        setState(() {}); // Update the UI

                        if (Responsive.isMobile(context)) {
                          Navigator.of(context).pop(); // Close dialog on mobile
                        }
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, // Use a different color for Cancel
                      ),
                    ),
                    SizedBox(width: defaultPadding / 2),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (selectedAnimal != null) {
                            try {
                              bool success = await ApiService().createOrUpdateMilkRecord(
                                date: selectedDate,
                                animalId: selectedAnimal!.id,
                                firstTime: double.tryParse(_firstTimeController.text),
                                secondTime: double.tryParse(_secondTimeController.text),
                                thirdTime: double.tryParse(_thirdTimeController.text),
                              );

                              if (success) {
                                // Show success message or navigate back
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Milk record saved successfully")),
                                );
                                Navigator.of(context).pop(); // Close dialog if in mobile mode
                                // You might also want to refresh the milk record list here
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to save milk record")),
                                );
                              }
                            } catch (e) {
                              // Handle errors
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("An error occurred while saving")),
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
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white, // Style matching "Add Milk" button
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
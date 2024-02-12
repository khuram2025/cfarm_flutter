import 'package:flutter/material.dart';
import 'package:cstore_flutter/screens/milkRecord/milkTable.dart';
import '../main/components/side_menu.dart';
import '../dashboard/components/header.dart';
import '../../constants.dart';
import '../../responsive.dart';

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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
}

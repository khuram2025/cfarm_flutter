import 'package:cstore_flutter/screens/milkRecord/milkTable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../main/components/side_menu.dart';
import '../dashboard/components/header.dart';


class MilkingRecordScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                    SizedBox(height: defaultPadding),
                    // Add your MilkingTable widget here
                    MilkingTable(animalId: 1), // Pass the appropriate animal ID
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

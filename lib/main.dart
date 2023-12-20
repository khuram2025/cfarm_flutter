import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cstore_flutter/constants.dart';
import 'package:cstore_flutter/controllers/MenuAppController.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    // Initialize the controller
    Get.put(MenuAppController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: secondaryColor,
      ),
      home: MainScreen(),
    );
  }
}

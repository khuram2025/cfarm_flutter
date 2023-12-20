import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // If you are using SVG icons

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust the color to match your design
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Product Here',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
        // Plus icon button
        IconButton(
          icon: Icon(Icons.add, color: Colors.grey),
          onPressed: () {
            // TODO: Implement add product logic
          },
        ),
        // Barcode scan icon button
        IconButton(
          icon: SvgPicture.asset('assets/icons/barcode_scan.svg'), // Example of using an SVG icon
          onPressed: () {
            // TODO: Implement barcode scan logic
          },
        ),
      ],
    );
  }
}

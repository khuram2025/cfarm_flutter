import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/apiService.dart';
import '../../../api/models.dart';

class MilkingTable extends StatefulWidget {
  final int animalId;

  const MilkingTable({Key? key, required this.animalId}) : super(key: key);

  @override
  _MilkingTableState createState() => _MilkingTableState();
}

class _MilkingTableState extends State<MilkingTable> {
  late Future<List<MilkingData>> milkingDataFuture;
  String selectedFilter = 'This Month'; // New state for tracking selected filter

  void initState() {
    super.initState();
    milkingDataFuture = ApiService().fetchMilkingData(
        widget.animalId,
        selectedFilter, // Pass the filter as a named parameter
        from: customFromDate,
        to: customToDate
    );
  }


  void updateFilter(String newFilter) async {
    if (newFilter == 'Custom Range') {
      await selectCustomDateRange(context);
    }
    setState(() {
      selectedFilter = newFilter;
      milkingDataFuture = ApiService().fetchMilkingData(
          widget.animalId,
          selectedFilter,
          from: customFromDate,
          to: customToDate
      );
    });
  }


  DateTime? customFromDate;
  DateTime? customToDate;

  Future<void> selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialDateRange: customFromDate != null && customToDate != null
          ? DateTimeRange(start: customFromDate!, end: customToDate!)
          : null,
    );

    if (pickedDateRange != null) {
      setState(() {
        customFromDate = pickedDateRange.start;
        customToDate = pickedDateRange.end;
        // Update the filter with a new value that represents the range
        selectedFilter = "${DateFormat('yyyy-MM-dd').format(customFromDate!)} to ${DateFormat('yyyy-MM-dd').format(customToDate!)}";
      });
      updateFilter(selectedFilter); // Now this will pass the new date range to your API
    }
  }




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddMilkAndFilterRow(context),
        _buildTableHeader(),
        Expanded(
          child: FutureBuilder<List<MilkingData>>(
            future: milkingDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("FutureBuilder error: ${snapshot.error}");
                return Center(child: Text("Error occurred. Check console for details."));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No milking data available"));
              } else {
                List<MilkingData> sortedData = List.from(snapshot.data!);
                sortedData.sort((a, b) => b.date.compareTo(a.date));
                return _buildMilkingTable(context, sortedData);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddMilkAndFilterRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () {
              // TODO: Implement Add Milk functionality
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.green,
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add Milk', style: TextStyle(color: Colors.green)),
          ),
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    List<String> filterOptions = ['Last 7 Days', 'This Month', 'This Year', 'Custom Range'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter, // Default to the first item
          icon: Icon(Icons.arrow_drop_down, color: Colors.green),
          items: filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.green, fontSize: 14)), // Reduced font size
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              if (newValue == 'Custom Range') {
                selectCustomDateRange(context);
              } else {
                updateFilter(newValue);
              }
            }
          },

        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          _buildHeaderItem("Date", flex: 2),
          _buildHeaderItem("1st", flex: 1),
          _buildHeaderItem("2nd", flex: 1),
          _buildHeaderItem("3rd", flex: 1),
          _buildHeaderItem("Total", flex: 1),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMilkingTable(BuildContext context, List<MilkingData> data) {
    // Calculate the totals
    double totalFirstMilking = 0;
    double totalSecondMilking = 0;
    double totalThirdMilking = 0;
    double grandTotal = 0;

    for (var milkingData in data) {
      totalFirstMilking += milkingData.firstMilking ?? 0;
      totalSecondMilking += milkingData.secondMilking ?? 0;
      totalThirdMilking += milkingData.thirdMilking ?? 0;
      grandTotal += milkingData.total;
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => _buildTableRow(data[index]),
              ),
            ),
            SizedBox(height: 48), // Space for the total row
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildTotalRow(totalFirstMilking, totalSecondMilking, totalThirdMilking, grandTotal),
        ),
      ],
    );
  }

  Widget _buildTotalRow(double totalFirst, double totalSecond, double totalThird, double grandTotal) {
    // You can customize the style as needed
    return Container(
      color: Colors.grey[200], // Gives a distinct background color for the total row
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('${totalFirst.toStringAsFixed(2)} L', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('${totalSecond.toStringAsFixed(2)} L', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('${totalThird.toStringAsFixed(2)} L', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('${grandTotal.toStringAsFixed(2)} L', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }



  Widget _buildTableRow(MilkingData data) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(DateFormat('yyyy-MM-dd').format(data.date))),
          Expanded(child: Text('${data.firstMilking ?? 0} L')),
          Expanded(child: Text('${data.secondMilking ?? 0} L')),
          Expanded(child: Text('${data.thirdMilking ?? 0} L')),
          Expanded(child: Text('${data.total} L')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/apiService.dart';
import '../../api/models.dart';

class MilkingTable extends StatefulWidget {
  final int animalId;
  final String filter;

  const MilkingTable({Key? key, required this.animalId, required this.filter}) : super(key: key); // Modify this line

  @override
  _MilkingTableState createState() => _MilkingTableState();
}

class _MilkingTableState extends State<MilkingTable> {
  late Future<List<MilkingRecord>> milkingDataFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    milkingDataFuture = ApiService().fetchTotalMilkingData(widget.filter); // Use the filter
  }

  @override
  void didUpdateWidget(MilkingTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      fetchData(); // Fetch data again if the filter changes
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MilkingRecord>>(
      future: milkingDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error occurred: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No milking data available."));
        }

        List<MilkingRecord> milkingRecords = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('1st Milking (L)')),
              DataColumn(label: Text('2nd Milking (L)')),
              DataColumn(label: Text('3rd Milking (L)')),
              DataColumn(label: Text('Total Milk (L)')),
            ],
            rows: milkingRecords.map<DataRow>((record) {
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(record.date))),
                  DataCell(Text(record.firstTime?.toString() ?? 'N/A')),
                  DataCell(Text(record.secondTime?.toString() ?? 'N/A')),
                  DataCell(Text(record.thirdTime?.toString() ?? 'N/A')),
                  DataCell(Text(record.totalMilk.toString())),

                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

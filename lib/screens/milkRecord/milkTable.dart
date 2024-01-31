import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/apiService.dart';
import '../../api/models.dart';

class MilkingTable extends StatefulWidget {
  final int animalId;

  const MilkingTable({Key? key, required this.animalId}) : super(key: key);

  @override
  _MilkingTableState createState() => _MilkingTableState();
}

class _MilkingTableState extends State<MilkingTable> {
  late Future<List<MilkingRecord>> milkingDataFuture;

  @override
  void initState() {
    super.initState();
    milkingDataFuture = ApiService().fetchTotalMilkingData('this_month');
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

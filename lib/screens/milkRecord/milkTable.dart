import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/apiService.dart';
import '../../api/models.dart';

class MilkingTable extends StatefulWidget {
  final int animalId;
  final String filter;

  const MilkingTable({Key? key, required this.animalId, required this.filter})
      : super(key: key);

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
    milkingDataFuture = ApiService().fetchTotalMilkingData(widget.filter);
  }

  @override
  void didUpdateWidget(MilkingTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the scale factor for text and spacing based on screen width
        final scale = constraints.maxWidth < 600 ? 0.8 : 1.0;

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
            var totalDays = snapshot.data!.length;


            double totalFirstTime = milkingRecords.fold(0, (previousValue, record) => previousValue + (record.firstTime ?? 0));
            double totalSecondTime = milkingRecords.fold(0, (previousValue, record) => previousValue + (record.secondTime ?? 0));
            double totalThirdTime = milkingRecords.fold(0, (previousValue, record) => previousValue + (record.thirdTime ?? 0));
            double totalMilk = milkingRecords.fold(0, (previousValue, record) => previousValue + (record.totalMilk ?? 0));
            var averageMilkPerDay = totalDays > 0 ? totalMilk / totalDays : 0;
            return Expanded(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25 * scale, // Adjust column spacing
                      dataRowHeight: 48 * scale, // Adjust row height
                      headingRowHeight: 56 * scale, // Adjust heading row height
                      dataTextStyle: TextStyle(fontSize: 14 * scale), // Adjust data text size
                      headingTextStyle: TextStyle(fontSize: 16 * scale), // Adjust heading text size
                      columns: [
                        DataColumn(
                          label: Flexible( // Use Flexible to allow the column to expand
                            fit: FlexFit.tight, // Ensure the label takes up all available space
                            child: Text('Date'),
                          ),
                        ),
                        DataColumn(label: Text('1st(Lit)')),
                        DataColumn(label: Text('2nd(Lit)')),
                        DataColumn(label: Text('3rd(Lit)')),
                        DataColumn(label: Text('Total(Lit)')),
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
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Expanded(child: Center(child: Text('Avg. ${averageMilkPerDay.toStringAsFixed(2)} L'))),
                        Expanded(child: Center(child: Text('${totalFirstTime.toStringAsFixed(2)} L'))),
                        Expanded(child: Center(child: Text('${totalSecondTime.toStringAsFixed(2)} L'))),
                        Expanded(child: Center(child: Text('${totalThirdTime.toStringAsFixed(2)} L'))),
                        Expanded(child: Center(child: Text('${totalMilk.toStringAsFixed(2)} L'))),
                      ],
                    ),
                  ),
                ],
              ),
            );

          },
        );
      },
    );
  }
}

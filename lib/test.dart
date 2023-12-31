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

  @override
  void initState() {
    super.initState();
    milkingDataFuture = ApiService().fetchMilkingData(widget.animalId);
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
    //... [Existing code]
  }

  Widget _buildFilterDropdown() {
    //... [Existing code]
  }

  Widget _buildTableHeader() {
    //... [Existing code]
  }

  Widget _buildHeaderItem(String title, {int flex = 1}) {
    //... [Existing code]
  }

  Widget _buildMilkingTable(BuildContext context, List<MilkingData> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => _buildTableRow(data[index]),
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

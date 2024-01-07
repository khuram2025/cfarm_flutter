
Widget _buildMilkingTable(BuildContext context) {
  bool isLargeScreen = MediaQuery.of(context).size.width > 600;

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

  Widget _buildTableRow(MilkingData data) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(DateFormat('yyyy-MM-dd').format(data.date))),
          Expanded(child: Text('${data.firstMilking} L')),
          Expanded(child: Text('${data.secondMilking} L')),
          Expanded(child: Text('${data.thirdMilking} L')),
          Expanded(child: Text('${data.total} L')),
        ],
      ),
    );
  }

  return Column(
    children: [
      _buildTableHeader(),
      Expanded(
        child: ListView.builder(
          itemCount: milkingDataList.length,
          itemBuilder: (context, index) => _buildTableRow(milkingDataList[index]),
        ),
      ),
    ],
  );
}
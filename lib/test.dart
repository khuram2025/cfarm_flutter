Widget _buildMilkingTable(BuildContext context, List<MilkingData> data) {
  final totalMilk = data.fold<Map<String, double>>(
    {},
        (previousValue, element) => {
      ...previousValue,
      'firstMilking': (previousValue['firstMilking'] ?? 0) + element.firstMilking!,
      'secondMilking': (previousValue['secondMilking'] ?? 0) + element.secondMilking!,
      'thirdMilking': (previousValue['thirdMilking'] ?? 0) + element.thirdMilking!,
      'total': (previousValue['total'] ?? 0) + element.total,
    },
  );

  return ListView.builder(
    itemCount: data.length + 1,
    itemBuilder: (context, index) {
      if (index == data.length) {
        return _buildTotalRow(totalMilk, isScrolling: true); // Pass flag to differentiate
      } else {
        return _buildTableRow(data[index]);
      }
    },
  );
}

Widget _buildTotalRow(Map<String, double> totalMilk, {bool isScrolling = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('${totalMilk['firstMilking']!.toStringAsFixed(1)} L', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('${totalMilk['secondMilking']!.toStringAsFixed(1)} L', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('${totalMilk['thirdMilking']!.toStringAsFixed(1)} L', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('${totalMilk['total']!.toStringAsFixed(1)} L', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    ),
    color: isScrolling ? null : Colors.grey[200], // Set background color only for fixed row
  );
}

import 'package:flutter/material.dart';

class CustomerOrdersDetailList extends StatefulWidget {
  final List<Order> orders;

  const CustomerOrdersDetailList({Key? key, required this.orders}) : super(key: key);

  @override
  _CustomerOrdersDetailListState createState() => _CustomerOrdersDetailListState();
}

class _CustomerOrdersDetailListState extends State<CustomerOrdersDetailList> {
  int _sortColumnIndex = 0;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          columnSpacing: 10.0,
          sortAscending: _isAscending,
          columns: [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Name')),
            DataColumn(
              label: Text('Date'),
              onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.date),
            ),
            DataColumn(
              label: Text('Transaction'),
              onSort: (columnIndex, ascending) => _sortByString(columnIndex, ascending, (o) => o.transactionType),
            ),
            DataColumn(
              label: Text('Total Amount'),
              onSort: (columnIndex, ascending) => _sortByDouble(columnIndex, ascending, (o) => o.totalAmount),
            ),
          ],
          rows: widget.orders.map<DataRow>((order) {
            return DataRow(
              cells: [
                DataCell(CircleAvatar(
                  backgroundImage: NetworkImage(order.imageUrl),
                  radius: 25,
                )),
                DataCell(Text(order.customerName)),
                DataCell(Text(order.date)),
                DataCell(Text(order.transactionType)),
                DataCell(Text('\$${order.totalAmount.toString()}')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _sortByString(int columnIndex, bool ascending, String Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      if (ascending) {
        widget.orders.sort((a, b) => getField(a).compareTo(getField(b)));
      } else {
        widget.orders.sort((a, b) => getField(b).compareTo(getField(a)));
      }
    });
  }

  void _sortByDouble(int columnIndex, bool ascending, double Function(Order) getField) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      if (ascending) {
        widget.orders.sort((a, b) => getField(a).compareTo(getField(b)));
      } else {
        widget.orders.sort((a, b) => getField(b).compareTo(getField(a)));
      }
    });
  }
}

class Order {
  final String imageUrl;
  final String customerName;
  final String mobileNumber;
  final String date;
  final String transactionType;
  final double totalAmount;

  Order({
    required this.imageUrl,
    required this.customerName,
    required this.mobileNumber,
    required this.date,
    required this.transactionType,
    required this.totalAmount,
  });
}

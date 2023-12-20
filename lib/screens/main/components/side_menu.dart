import 'package:cstore_flutter/screens/accounts/login.dart';
import 'package:cstore_flutter/screens/customer/customers_list.dart';
import 'package:cstore_flutter/screens/inventory/product_list.dart';

import 'package:cstore_flutter/screens/main/main_screen.dart';
import 'package:cstore_flutter/screens/pos/pos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../dashboard/dashboard_screen.dart';
import '../../transactions/transaction_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => TransactionScreen()),
              );

            },
          ),
          DrawerListTile(
            title: "Products",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => ProductListScreen(companyName: "Your Company Name")),
              );

            },

          ),
          DrawerListTile(
            title: "Customers",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => CustomerListScreen()),
              );

            },
          ),

          DrawerListTile(
            title: "Login",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );

            },
          ),
          DrawerListTile(
            title: "POS",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => POSScreen()),
              );

            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.lightBlue),
      ),
    );
  }
}

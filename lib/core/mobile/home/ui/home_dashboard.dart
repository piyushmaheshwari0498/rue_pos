import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/asset_paths.dart';
import '../../../tablet/aniket/menus/all_orders/all_orders_landscape.dart';
import '../../../tablet/aniket/menus/all_orders/all_orders_landscape_new.dart';
import '../../../tablet/aniket/menus/closeDay.dart';
import '../../../tablet/aniket/menus/sales_landscape.dart';
import '../../../tablet/aniket/menus/sales_landscape_new.dart';
import '../../../tablet/aniket/menus/settings/settings.dart';
import '../../../tablet/create_order/create_order_landscape2.dart';
import '../../../tablet/tables/tableDine_landscape.dart';
import '../../../tablet/tables/tableDine_landscape_new.dart';
import '../../create_order_new/ui/new_create_order.dart';
import '../../customers/ui/customers.dart';
import '../../finance/ui/finance.dart';
import '../../my_account/ui/my_account.dart';
import '../../products/ui/products.dart';
import '../../transaction_history/view/transaction_screen.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CreateOrderLandscape(selectedView: "New Order".obs), // New Order
    TableDineLandscapeNew(),
    CurrentOrdersLandscapeNew(),
    CloseDayMobileScreen(),
    SalesMenuLandscapeNew(type: 0),
    SettingsLandscape(), // My Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Highlighted color
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_ORDERS_ICON, height: 25, width: 25),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_HISTORY_ICON, height: 25, width: 25),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_CUSTOMERS_ICON, height: 25, width: 25),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_CUSTOMERS_ICON, height: 25, width: 25),
            label: 'Cashier',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_FINANCE_ICON, height: 25, width: 25),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(FAB_ACCOUNT_ICON, height: 25, width: 25),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
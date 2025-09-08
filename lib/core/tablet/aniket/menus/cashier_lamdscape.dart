import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/core/service/api_cashier/api/api_cashier_common.dart';
import 'package:nb_posx/core/tablet/aniket/menus/reprint_landscape.dart';
import 'package:nb_posx/core/tablet/aniket/menus/sales_landscape.dart';
import 'package:nb_posx/core/tablet/aniket/menus/sales_landscape_new.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../utils copy/helpers/sync_helper.dart';
import '../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../utils/helper.dart';
import '../../../service/api_cashier/model/addAndWithdrawCash.dart';
import '../../../service/api_cashier/model/closeDay.dart';
import '../../login/login_landscape2.dart';

class CashierLandscape extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CashierState();
}

class CashierState extends State<CashierLandscape> {
  AddWithdrawCash _addWithdrawCash = AddWithdrawCash();
  Closeday _closeday = Closeday();

  String _selectedBranchId = '';
  String _selectedCounterId = '';
  String _addedCash = '';
  String _withdrawCash = '';
  String _addedCashRemarks = '';
  String _withdrawCashRemarks = '';

  var amount20 = 0;
  var amount10 = 0;
  var amount05 = 0;
  var amount01 = 0;

  var amount500 = 0.00;
  var amount100 = 0.00;
  var amount50 = 0.00;
  var amount25 = 0.00;
  var amount010 = 0.00;
  var amount005 = 0.00;

  String _selectedEmployeeId = "";

  var totalAmount = 0.00;

  TextEditingController addCashAmount = TextEditingController();
  TextEditingController addCashRemarks = TextEditingController();
  TextEditingController withdrawCashAmount = TextEditingController();
  TextEditingController withdrawCashRemarks = TextEditingController();

  TextEditingController myController20 = TextEditingController();
  TextEditingController myController10 = TextEditingController();
  TextEditingController myController5 = TextEditingController();
  TextEditingController myController1 = TextEditingController();

  TextEditingController myController500 = TextEditingController();
  TextEditingController myController100 = TextEditingController();
  TextEditingController myController50 = TextEditingController();
  TextEditingController myController25 = TextEditingController();
  TextEditingController myController010 = TextEditingController();
  TextEditingController myController005 = TextEditingController();

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String _selectedCounter = "";
  String _selectedEmployeeName = "";

  void _incrementCounter(int value) {
    setState(() {
      switch (value) {
        case 20:
          amount20 = amount20 + 1;
          myController20.text = amount20.toString();
          break;
        case 10:
          amount10 = amount10 + 1;
          myController10.text = amount10.toString();
          break;
        case 5:
          amount05 = amount05 + 1;
          myController5.text = amount05.toString();
          break;
        case 1:
          amount01 = amount01 + 1;
          myController1.text = amount01.toString();
          break;
        case 500:
          amount500 = amount500 + 1;
          myController500.text = amount500.toString();
          break;
        case 100:
          amount100 = amount100 + 1;
          myController100.text = amount100.toString();
          break;
        case 50:
          amount50 = amount50 + 1;
          myController50.text = amount50.toString();
          break;
        case 25:
          amount25 = amount25 + 1;
          myController25.text = amount25.toString();
          break;
        case 1000:
          amount010 = amount010 + 1;
          myController010.text = amount010.toString();
          break;
        case 5000:
          amount005 = amount005 + 1;
          myController005.text = amount005.toString();
          break;
        default:
      }
      totalAmount = (amount20 * 20 +
          amount10 * 10 +
          amount05 * 5 +
          amount01 * 1 +
          amount500 * .500 +
          amount100 * .100 +
          amount50 * .050 +
          amount25 * .025 +
          amount010 * .010 +
          amount005 * .005);
      log("Total: ${totalAmount}");
    });
  }

  void _decrementCounter(int value) {
    setState(() {
      print(value);
      switch (value) {
        case 20:
          if (amount20 != 0) amount20 = amount20 - 1;
          myController20.text = amount20.toString();
          break;
        case 10:
          if (amount10 != 0) amount10 = amount10 - 1;
          myController10.text = amount10.toString();
          break;
        case 5:
          if (amount05 != 0) amount05 = amount05 - 1;
          myController5.text = amount05.toString();
          break;
        case 1:
          if (amount01 != 0) amount01 = amount01 - 1;
          myController1.text = amount01.toString();
          break;
        case 500:
          if (amount500 != 0) amount500 = amount500 - 1;
          myController500.text = amount500.toString();
          break;
        case 100:
          if (amount100 != 0) amount100 = amount100 - 1;
          myController100.text = amount100.toString();
          break;
        case 50:
          if (amount50 != 0) amount50 = amount50 - 1;
          myController50.text = amount50.toString();
          break;
        case 25:
          if (amount25 != 0) amount25 = amount25 - 1;
          myController25.text = amount25.toString();
          break;
        case 1000:
          if (amount010 != 0) amount010 = amount010 - 1;
          myController010.text = amount010.toString();
          break;
        case 5000:
          if (amount005 != 0) amount005 = amount005 - 1;
          myController005.text = amount005.toString();
          break;
        default:
      }
      totalAmount = (amount20 * 20 +
          amount10 * 10 +
          amount05 * 5 +
          amount01 * 1 +
          amount500 * .500 +
          amount100 * .100 +
          amount50 * .050 +
          amount25 * .025 +
          amount010 * .010 +
          amount005 * .005);
      log("Total: ${totalAmount}");
    });
  }

  Future<void> _getIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
      // print('inside getIdss $_selectedBranchId, $_selectedCounterId');
      printerIP = prefs.getString('printer_ip') ?? "";
      selectedPrinter = prefs.getString('printer_type') ?? "No Printer";
      branch_name = prefs.getString(BranchName) ?? "";
      branch_add1 = prefs.getString(BranchAdd1) ?? "";
      branch_add2 = prefs.getString(BranchAdd2) ?? "";
      branch_add3 = prefs.getString(BranchAdd3) ?? "";
      branch_phone = prefs.getString(BranchPhone) ?? "";
      branch_vat = prefs.getString(BranchVAT) ?? "";

      _selectedEmployeeName = manager.name;
      _selectedCounter = prefs.getString(CounterName) ?? '';
    });
  }

  Future<AddWithdrawCash> getResult(
      String url, String cashAmount, String remarksss) async {
    return CashierApiService().insCash(
      apiString: url,
      amount: cashAmount,
      branchId: _selectedBranchId,
      userId: _selectedEmployeeId,
      remarks: remarksss,
      counterId: _selectedCounterId,
    );
  }

  Future<Closeday> closeDayMethod() async {
    return CashierApiService().closeDay(
      amount: '$totalAmount',
      branchId: _selectedBranchId,
      userId: _selectedEmployeeId,
      counterId: _selectedCounterId,
      bD20: '$amount20',
      bD10: '$amount10',
      bD5: '$amount05',
      bD1: '$amount01',
      fils500: '$amount500',
      fils100: '$amount100',
      fils50: '$amount50',
      fils25: '$amount25',
      fils10: '$amount010',
      fils5: '$amount005',
    );
  }

  @override
  void initState() {
    _getIds();
    setState(() {
      addCashAmount.text = _addedCash.toString();
      addCashRemarks.text = _addedCashRemarks.toString();
      withdrawCashAmount.text = _withdrawCash.toString();
      withdrawCashRemarks.text = _withdrawCashRemarks.toString();
    });

    myController20.text = amount20.toString();
    myController10.text = amount10.toString();
    myController5.text = amount05.toString();
    myController1.text = amount01.toString();

    myController500.text = amount500.toString();
    myController100.text = amount100.toString();
    myController50.text = amount50.toString();
    myController25.text = amount25.toString();
    myController010.text = amount010.toString();
    myController005.text = amount005.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 80,
        elevation: 0,
        color: Colors.transparent,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.center,
              margin: defaultTargetPlatform == TargetPlatform.iOS
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(0),
              height: 50,
              width: defaultTargetPlatform == TargetPlatform.iOS ? 200 : 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: MAIN_COLOR,
              ),
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesMenuLandscapeNew(
                                  type: 1,
                                )));
                  },
                  icon: const Icon(
                    Icons.list_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                  label: Text(
                    'Sales',
                    style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              width: defaultTargetPlatform == TargetPlatform.iOS ? 200 : 250,
              height: 50,
              margin: defaultTargetPlatform == TargetPlatform.iOS
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: MAIN_COLOR,
              ),
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReprintLandscape()));
                  },
                  icon: const Icon(
                    Icons.print_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  label: Text(
                    'Reprint',
                    style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              width: defaultTargetPlatform == TargetPlatform.iOS ? 250 : 250,
              height: 50,
              margin: defaultTargetPlatform == TargetPlatform.iOS
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: MAIN_COLOR,
              ),
              child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.open_in_browser_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  label: Text(
                    'Open Drawer',
                    style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              width: defaultTargetPlatform == TargetPlatform.iOS ? 200 : 250,
              height: 50,
              margin: defaultTargetPlatform == TargetPlatform.iOS
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: MAIN_COLOR,
              ),
              child: TextButton.icon(
                  onPressed: () async {
                    _closeday = await closeDayMethod();
                    if (_closeday.status == 1 &&
                        _closeday.result == "Success") {
                      _printReceipt(_closeday.message!,_closeday);

                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            content: Text(_closeday.message!),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await SyncHelper().logoutFlow();
                                    Get.offAll(() => const LoginLandscape2());
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 35,
                  ),
                  label: Text(
                    'Close Day',
                    style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
                  )),
            ),
          ],
        ),
      ),
      appBar: AppBar(
          toolbarHeight: 70,
          // backgroundColor: const Color.fromRGBO(139, 143, 124, 40.0),
          title: ListTile(
            leading: null,
            title: Center(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Close Day',
                  style: getTextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR),
                ),
              ),
            ),
            // trailing: const Text(
            //   'Check in 2.34 PM',
            //   style: TextStyle(fontSize: 20, color: Colors.white),
            // )
          )),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(245, 248, 247, 1),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 35),
                child: Container(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.money_rounded,
                        size: 30,
                      ),
                      Text(
                        'DRAWER DENOMINATIONS (BHD)',
                        style: getTextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                  child: cashierViewForCurrency()),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                  child: cashierViewForCurrency2()),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount : ${totalAmount.toStringAsFixed(3)}',
                      style: getTextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Add Cash',
                              style: getTextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              // height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: getTextStyle(fontSize: 20.0),
                                    ),
                                    TextField(
                                      controller: addCashAmount,
                                      textAlign: TextAlign.center,
                                      style: getTextStyle(
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Remarks',
                                      style: getTextStyle(fontSize: 20.0),
                                    ),
                                    TextField(
                                      controller: addCashRemarks,
                                      maxLines: null,
                                      textAlign: TextAlign.center,
                                      style: getTextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: CupertinoButton(
                                          color: MAIN_COLOR,
                                          onPressed: () async {
                                            // print(' ${getResult().toString()}');
                                            _addWithdrawCash = await getResult(
                                                '/api/Mobile/insAddCash',
                                                addCashAmount.text,
                                                addCashRemarks.text);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  content: Text(_addWithdrawCash
                                                      .message!),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Add Cash',
                                            style: getTextStyle(
                                                fontSize: 25.0,
                                                color: Colors.white),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Withdraw Cash',
                              style: getTextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              // height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: getTextStyle(fontSize: 20.0),
                                    ),
                                    TextField(
                                      controller: withdrawCashAmount,
                                      textAlign: TextAlign.center,
                                      style: getTextStyle(
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Remarks',
                                      style: getTextStyle(fontSize: 20.0),
                                    ),
                                    TextField(
                                      textAlign: TextAlign.center,
                                      controller: withdrawCashRemarks,
                                      style: getTextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: CupertinoButton(
                                          color: MAIN_COLOR,
                                          onPressed: () async {
                                            // print(' ${getResult().toString()}');
                                            _addWithdrawCash = await getResult(
                                                '/api/Mobile/insWithdrawCash',
                                                withdrawCashAmount.text,
                                                withdrawCashRemarks.text);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  content: Text(_addWithdrawCash
                                                      .message!),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Withdraw Cash',
                                            style: getTextStyle(
                                                fontSize: 25.0,
                                                color: Colors.white),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cashierViewForCurrency() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(155, 155, 155, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 140,
      child: Row(
        children: [
          buildCurrencyUnit(value: 20, controller: myController20),
          buildCurrencyUnit(value: 10, controller: myController10),
          buildCurrencyUnit(value: 5, controller: myController5),
          buildCurrencyUnit(value: 1, controller: myController1),
          buildCurrencyUnit(value: 500, controller: myController500, isPrefixDot: true),
        ],
      ),
    );
  }

  Widget cashierViewForCurrency2() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(155, 155, 155, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 140,
      child: Row(
        children: [
          buildCurrencyUnit(value: 100, controller: myController100, isPrefixDot: true),
          buildCurrencyUnit(value: 50, controller: myController50, isPrefixDot: true),
          buildCurrencyUnit(value: 25, controller: myController25, isPrefixDot: true),
          buildCurrencyUnit(value: 1000, controller: myController010, isPrefixDot: true), // 0.10 = 1000 in your logic
          buildCurrencyUnit(value: 5000, controller: myController005, isPrefixDot: true), // 0.5 = 5000 in your logic
        ],
      ),
    );
  }


  Widget buildCurrencyUnit({
    required int value,
    required TextEditingController controller,
    bool isPrefixDot = false,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Color.fromRGBO(155, 155, 155, 1)),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isPrefixDot ? '.${value ~/ 10}' : '$value',
                  style: getTextStyle(
                    fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 20.0 : 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, size: 40),
                  onPressed: () => _decrementCounter(value),
                ),
                Container(
                  color: Colors.white,
                  width: 100,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.0, fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  onPressed: () => _incrementCounter(value),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _printReceipt(String msg, Closeday closeday) async {
    print("_printReceipt");
    /*if (selectedPrinter == "IP Printer") {
      bool printStatus = await Helper().printIPSaleReport(
          context,
          printerIP!,
          closeday,
          _selectedEmployeeName,
          _selectedCounter,
          branch_name,
          branch_add1,
          branch_add2,
          branch_add3,
          branch_phone,
          branch_vat,
          "");
      if (printStatus) {
        Helper.showToastSuccess(
            "IP ${printerIP!} Printing successful", context);
      } else {
        Helper.showToastFail("IP ${printerIP!} Printing Failed", context);
      }
    }
    else {*/

      await SunmiPrinter.bindingPrinter();

      bool printStatus = await Helper().printInternalSaleReport(
          context,
          closeday,
          _selectedEmployeeName,
          _selectedCounter,
          branch_name,
          branch_add1,
          branch_add2,
          branch_add3,
          branch_phone,
          branch_vat,
          "");
      if (printStatus) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              content: Text(closeday.message!),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await SyncHelper().logoutFlow();
                      Get.offAll(() => const LoginLandscape2());
                    },
                    child: const Text('OK'))
              ],
            );

          },
        );
      } else {
        Helper.showToastFail("Internal Printing Failed", context);
      }
    // }
  }


}

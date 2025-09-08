import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart'; // If you're using GetX for navigation

class CloseDayMobileScreen extends StatefulWidget {
  const CloseDayMobileScreen({super.key});

  @override
  State<StatefulWidget> createState() => CloseDayScreen();
}

class CloseDayScreen extends State<CloseDayMobileScreen> {
  final bool isTablet = Device.get().isTablet;

  double totalAmount = 0.0; // Update this with your logic
  dynamic _addWithdrawCash;

  // AddWithdrawCash _addWithdrawCash = AddWithdrawCash();

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

  // var totalAmount = 0.00;

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
      // log("Total: ${totalAmount}");
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
      // log("Total: ${totalAmount}");
    });
  }

  // CloseDayScreen({super.key});

  // Example function for demonstration
  Future<dynamic> getResult(String url, String amount, String remarks) async {
    return {'message': 'Transaction completed'}; // Replace with API logic
  }

  Future<dynamic> closeDayMethod() async {
    return {'message': 'Day Closed'}; // Replace with actual method
  }

  Widget _buildAddWithdrawSection(BuildContext context) {
    final children = [
      _buildCashSection(
        title: 'Add Cash',
        controllerAmount: addCashAmount,
        controllerRemarks: addCashRemarks,
        buttonText: 'Add Cash',
        onPressed: () async {
          _addWithdrawCash = await getResult('/api/Mobile/insAddCash',
              addCashAmount.text, addCashRemarks.text);
          _showDialog(context, _addWithdrawCash['message']);
        },
      ),
      _buildCashSection(
        title: 'Withdraw Cash',
        controllerAmount: withdrawCashAmount,
        controllerRemarks: withdrawCashRemarks,
        buttonText: 'Withdraw Cash',
        onPressed: () async {
          _addWithdrawCash = await getResult('/api/Mobile/insWithdrawCash',
              withdrawCashAmount.text, withdrawCashRemarks.text);
          _showDialog(context, _addWithdrawCash['message']);
        },
      ),
    ];

    return isTablet
        ? Row(children: children.map((e) => Expanded(child: e)).toList())
        : Column(children: children);
  }

  Widget _buildCashSection({
    required String title,
    required TextEditingController controllerAmount,
    required TextEditingController controllerRemarks,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Amount', style: TextStyle(fontSize: 20)),
              TextField(
                controller: controllerAmount,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text('Remarks', style: TextStyle(fontSize: 20)),
              TextField(
                controller: controllerRemarks,
                maxLines: null,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Center(
                child: CupertinoButton(
                  color: Colors.brown,
                  onPressed: onPressed,
                  child: Text(buttonText,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Close Day",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: Colors.brown[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(context, Icons.list_alt, '', () {}),
            Spacer(),
            _navButton(context, Icons.print_rounded, '', () {}),
            Spacer(),
            _navButton(context, Icons.open_in_browser_rounded, '', () {}),
            Spacer(),
            _navButton(context, Icons.done, '', () async {
              _addWithdrawCash = await closeDayMethod();

              if (_addWithdrawCash.status == 1 &&
                  _addWithdrawCash.result == "Success") {
                _showDialog(context, _addWithdrawCash['message']);
              }else{
                _showDialog(context, _addWithdrawCash['message']);
              }

            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: const Color.fromRGBO(245, 248, 247, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.money_rounded, size: 30),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'DRAWER DENOMINATIONS(BHD)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Your cashierViewForCurrency() and cashierViewForCurrency2()
              // First row (e.g. 20, 10, 5, 1)
              cashierCurrencyViewCombined(),
              const SizedBox(height: 10),
              // Second row (e.g. .500, .100, .50, etc.)
              cashierCurrencyViewCombined(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Text('Total Amount : ${totalAmount.toStringAsFixed(3)}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right),
              const SizedBox(height: 30),
              _buildAddWithdrawSection(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      flex: 5,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.brown,
        ),
        child: TextButton.icon(
          onPressed: onTap,
          icon: Center(child: Icon(icon, color: Colors.white, size: 28)),
          label: Text(label,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  Widget currencyUnit({
    required String label,
    required int amount,
    required TextEditingController controller,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(155, 155, 155, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      width: Device.get().isTablet ? 150 : double.infinity,
      child: Row(
        children: [
          Expanded(
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      label,
                      style: getTextStyle(
                        fontSize: Device.get().isTablet ? 30.0 : 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: 35),
                onPressed: onRemove,
              ),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  color: Colors.white,
                  width: 100,
                  height: 40,
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
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 35),
                onPressed: onAdd,
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget cashierCurrencyViewCombined() {
    final isTablet = Device.get().isTablet;

    final currencyWidgets = [
      currencyUnit(
        label: '20',
        amount: 20,
        controller: myController20,
        onAdd: () => _incrementCounter(20),
        onRemove: () => _decrementCounter(20),
      ),
      currencyUnit(
        label: '10',
        amount: 10,
        controller: myController10,
        onAdd: () => _incrementCounter(10),
        onRemove: () => _decrementCounter(10),
      ),
      currencyUnit(
        label: '5',
        amount: 5,
        controller: myController5,
        onAdd: () => _incrementCounter(5),
        onRemove: () => _decrementCounter(5),
      ),
      currencyUnit(
        label: '1',
        amount: 1,
        controller: myController1,
        onAdd: () => _incrementCounter(1),
        onRemove: () => _decrementCounter(1),
      ),
      currencyUnit(
        label: '.500',
        amount: 500,
        controller: myController500,
        onAdd: () => _incrementCounter(500),
        onRemove: () => _decrementCounter(500),
      ),
      currencyUnit(
        label: '.100',
        amount: 100,
        controller: myController100,
        onAdd: () => _incrementCounter(100),
        onRemove: () => _decrementCounter(100),
      ),
      currencyUnit(
        label: '.50',
        amount: 50,
        controller: myController50,
        onAdd: () => _incrementCounter(50),
        onRemove: () => _decrementCounter(50),
      ),
      currencyUnit(
        label: '.25',
        amount: 25,
        controller: myController25,
        onAdd: () => _incrementCounter(25),
        onRemove: () => _decrementCounter(25),
      ),
      currencyUnit(
        label: '.10',
        amount: 1000,
        controller: myController010,
        onAdd: () => _incrementCounter(1000),
        onRemove: () => _decrementCounter(1000),
      ),
      currencyUnit(
        label: '.5',
        amount: 5000,
        controller: myController005,
        onAdd: () => _incrementCounter(5000),
        onRemove: () => _decrementCounter(5000),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(155, 155, 155, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: isTablet
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: currencyWidgets,
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currencyWidgets,
            ),
    );
  }
}

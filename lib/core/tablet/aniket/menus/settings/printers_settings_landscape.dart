import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as blue;
// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart' as esc_print;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_star_prnt/flutter_star_prnt.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_star_prnt/flutter_star_prnt.dart';
// import 'package:flutter_star_prnt/flutter_star_prnt.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starxpand/models/starxpand_printer.dart';
import 'package:starxpand/starxpand.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../utils copy/helper.dart';
import '../../../../../utils copy/helper.dart';
import '../../../../../utils/helper.dart' as help;
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../service/api_printer_setting/model/printerList.dart';
// import 'package:flutter_star_prnt/flutter_star_prnt.dart';

// import 'package:starxpand/models/starxpand_printer.dart';
// import 'package:starxpand/starxpand.dart';

class PrinterSettingsLandscape extends StatefulWidget {
  PrinterSettingsLandscape({super.key});

  // PrinterBluetoothManager printerManager = blue.PrinterBluetoothManager();
  // List<blue.PrinterBluetooth> _devices = [];

  @override
  State<PrinterSettingsLandscape> createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettingsLandscape> {
  String? selectedPrinter; // Stores the selected printer option
  String? printerIP; // Stores the IP address if IP Printer is selected
  String? branch_name; // Stores the IP address if IP Printer is selected
  String? branch_add1; // Stores the IP address if IP Printer is selected
  String? branch_add2; // Stores the IP address if IP Printer is selected
  String? branch_add3; // Stores the IP address if IP Printer is selected
  String? branch_phone; // Stores the IP address if IP Printer is selected
  String? branch_vat; // Stores the IP address if IP Printer is selected

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load stored printer selection and IP
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPrinter = prefs.getString('printer_type') ?? "No Printer";
      branch_name = prefs.getString(BranchName) ?? "";
      branch_add1 = prefs.getString(BranchAdd1) ?? "";
      branch_add2 = prefs.getString(BranchAdd2) ?? "";
      branch_add3 = prefs.getString(BranchAdd3) ?? "";
      branch_phone = prefs.getString(BranchPhone) ?? "";
      branch_vat = prefs.getString(BranchVAT) ?? "";
      printerIP = prefs.getString('printer_ip') ?? "";
    });
  }

  // Save printer selection in SharedPreferences
  Future<void> _savePrinterSelection(String printerType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_type', printerType);
    setState(() {
      selectedPrinter = printerType;
    });
    if (printerType == "IP Printer") {
      _showIPInputDialog(); // Show IP input dialog if IP Printer is selected
    }
  }

  // Save the entered IP address
  Future<void> _savePrinterIP(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_ip', ip);
    setState(() {
      printerIP = ip;
    });
  }

  // Show dialog to select printer type
  void _showPrinterSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Printer Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Internal Printer"),
                onTap: () {
                  _savePrinterSelection("Internal Printer");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("IP Printer"),
                onTap: () {
                  _savePrinterSelection("IP Printer");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show dialog to enter IP address
  void _showIPInputDialog() {
    TextEditingController ipController = TextEditingController(text: printerIP);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Printer IP Address"),
          content: TextField(
            controller: ipController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "192.168.x.x"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _savePrinterIP(ipController.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String printer_details = "";

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
            ),
            child: IntrinsicHeight(
              // Automatically adjusts height based on children
              child: Column(
                children: [
                  ListTile(
                    visualDensity: const VisualDensity(vertical: 4),
                    leading: const Icon(Icons.print_rounded, size: 30),
                    title: Text(
                      'SUNMI Printer',
                      style:
                          TextStyle(fontSize: Device.get().isTablet
                              ? 18 : 14, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text(selectedPrinter ?? "No Printer",
                    //     style: const TextStyle(fontSize: 17, color: Colors.black)),
                    trailing: ElevatedButton(
                      onPressed: _showPrinterSelectionDialog,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(selectedPrinter ?? "No Printer",
                          style: TextStyle(fontSize: Device.get().isTablet
                              ? 17 : 14, color: Colors.white)),
                    ),
                  ),
                  if (selectedPrinter == "IP Printer") ...[
                    ListTile(
                      visualDensity: const VisualDensity(vertical: 4),
                      title: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: Text(printerIP?.isNotEmpty == true
                            ? "Update IP ($printerIP)"
                            : "Set Printer IP"),
                        onPressed: _showIPInputDialog,
                      ),
                    ),
                  ],
                  ListTile(
                    visualDensity: const VisualDensity(vertical: 4),
                    title: ElevatedButton.icon(
                      icon: const Icon(Icons.print, size: 30),
                      label: const Text("Print Test Receipt", maxLines: 1),
                      onPressed: () async {
                        // Your test print logic
                        if (selectedPrinter == "IP Printer") {
                          bool printStatus = await help.Helper()
                              .printTestIPInvoice(
                                  context,
                                  printerIP!,
                                  branch_name,
                                  branch_add1,
                                  branch_add2,
                                  branch_add3,
                                  branch_phone,
                                  branch_vat,
                                  "",
                                  "Table 1",
                                  "Server Name");
                          if (printStatus) {
                            help.Helper.showToastSuccess(
                                "IP ${printerIP!} Printing successful",
                                context);
                          } else {
                            help.Helper.showToastFail(
                                "IP ${printerIP!} Printing Failed", context);
                          }
                        }
                        else {
                          await SunmiPrinter.bindingPrinter();

                          bool printStatus = await help.Helper()
                              .printTestInternalSunmiInvoice(
                                  context,
                                  branch_name,
                                  branch_add1,
                                  branch_add2,
                                  branch_add3,
                                  branch_phone,
                                  branch_vat,
                                  "",
                                  "Table 1",
                                  "Server Name");
                          if (printStatus) {
                            help.Helper.showToastSuccess(
                                "Internal Printing successful", context);
                          } else {
                            help.Helper.showToastFail(
                                "Internal Printing Failed", context);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: false,
              child: Column(children: [
                Container(
                    height: 180,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 1.0))),
                    child: Column(
                      children: [
                        ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          leading: const Icon(
                            Icons.print_rounded,
                            size: 30,
                          ),
                          title: Text(
                            'Receipt Print',
                            style: getTextStyle(
                                fontSize: LARGE_MINUS20_FONT_SIZE,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(printer_details,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              )),
                          trailing: ElevatedButton.icon(
                            label: const Text('Star Printer',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                )),
                            icon: const Icon(null),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 255, 17, 0))),
                            onPressed: () async {
                              PrintCommands commands = PrintCommands();
                              String raster = "        Star Clothing Boutique\n" +
                                  "             123 Star Road\n" +
                                  "           City, State 12345\n" +
                                  "\n" +
                                  "Date:MM/DD/YYYY          Time:HH:MM PM\n" +
                                  "--------------------------------------\n" +
                                  "SALE\n" +
                                  "SKU            Description       Total\n" +
                                  "300678566      PLAIN T-SHIRT     10.99\n" +
                                  "300692003      BLACK DENIM       29.99\n" +
                                  "300651148      BLUE DENIM        29.99\n" +
                                  "300642980      STRIPED DRESS     49.99\n" +
                                  "30063847       BLACK BOOTS       35.99\n" +
                                  "\n" +
                                  "Subtotal                        156.95\n" +
                                  "Tax                               0.00\n" +
                                  "--------------------------------------\n" +
                                  "Total                           156.95\n" +
                                  "--------------------------------------\n" +
                                  "\n" +
                                  "Charge\n" +
                                  "156.95\n" +
                                  "Visa XXXX-XXXX-XXXX-0123\n" +
                                  "Refunds and Exchanges\n" +
                                  "Within 30 days with receipt\n" +
                                  "And tags attached\n";
                              // commands.appendBitmapText(text: raster);
                              commands.push({
                                'appendBitmapText':
                                    "Android Hello World to Star Printer"
                              });
                              commands
                                  .push({'appendCutPaper': "FullCutWithFeed"});
                              await StarPrnt.print(
                                  portName: printerIP!,
                                  emulation: 'StarGraphic',
                                  printCommands: commands);

                              print(await StarPrnt.print(
                                  portName: printerIP!,
                                  emulation: 'StarGraphic',
                                  printCommands: commands));

                              Helper.showPopup(context,
                                  " $printerIP \n ${await StarPrnt.print(
                                      portName: printerIP!,
                                      emulation: 'StarGraphic',
                                      printCommands: commands)}");

                              // const PaperSize paper = PaperSize.mm80;
                              /*final profile = await CapabilityProfile.load();
                              final generator = Generator(PaperSize.mm80, profile);

                              List<int> bytes = [];

                              bytes += generator.text('Hello, World!', styles: const PosStyles(align: PosAlign.center));
                              bytes += generator.feed(2);
                              bytes += generator.cut();

                              try {
                                // await printer.print(bytes);
                                final printer = PrinterNetworkManager(printerIP!);
                                PosPrintResult connect = await printer.connect();
                                await help.Helper().printBytesAsAscii(bytes);
                                if (connect == PosPrintResult.success) {
                                  PosPrintResult printing = await printer.printTicket(bytes);

                                  print(printing.msg);
                                  printer.disconnect();
                                }
                                Helper.showPopup(context,
                                    " Print Star Successful \nIP: ${printerIP}");
                                print('Print successful!');
                              } catch (e) {
                                Helper.showPopup(context,
                                    " Print Star Failed \nIP: ${printerIP}");
                                print('Error printing: $e');
                              }*/

                              /*final printer =
                                  esc_print.NetworkPrinter(paper, profile);

                              final esc_print.PosPrintResult res = await printer
                                  .connect(Helper.ip_adrress!, port: 9100);

                              if (res == esc_print.PosPrintResult.success) {
                                // testReceipt(printer);
                                // printer.disconnect();

                                help.Helper.showToastSuccess(
                                    "Connection successful", context);
                                // Set print styles (optional: you can modify the style to suit your needs)
                                printer.connect(Helper.ip_adrress!, port: 9100);
                                printer.rawBytes(
                                    Uint8List.fromList([0x1B, 0x40])); // Reset
                                printer.text('Hello World!');
                                printer
                                    .setStyles(PosStyles(align: PosAlign.left));

                                // Print receipt content
                                printer.text('Receipt Example');
                                // printer.text('Item 1 - \$10.00');
                                // printer.text('Item 2 - \$20.00');
                                printer.text('Total - \$30.00');
                                help.Helper.showToastInfo(
                                    "Print successful", context);
                                // Optionally, cut the paper after printing
                                printer.feed(2);
                                printer.cut();

                                printer.beep();
                                await Future.delayed(Duration(seconds: 2));
                                // Disconnect from the printer after printing
                                printer.disconnect();
                              }

                              setState(() {
                                printer_details =
                                    'Print result: ${res.msg} - IP: ${Helper.ip_adrress}';
                              });*/
                              // print(
                              //     'Print result: ${res.msg} - IP: ${Helper.ip_adrress}');
                            },
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              visualDensity: const VisualDensity(vertical: 4),
                              leading: ElevatedButton.icon(
                                label: Text(
                                  'Select Printer',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? 18
                                          : 20),
                                ),
                                icon: Icon(
                                  Icons.compare_arrows_sharp,
                                  size: defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 25
                                      : 30,
                                ),
                                onPressed: () async {
                                  CircularProgressIndicator;

                                  // _find();
                                  // Find printers
                                  // List<PortInfo> list =
                                  //     await StarPrnt.portDiscovery(StarPortType.LAN);
                                  // // print(list);
                                  // list.forEach((port) async {
                                  //   selectPrinter(list);
                                  //   print(port.portName);
                                  //   if (port.portName?.isNotEmpty != null) {
                                  //     print(await StarPrnt.getStatus(
                                  //       portName: port.portName!,
                                  //       emulation: emulationFor(port.modelName!),
                                  //     ));
                                  //     showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return AlertDialog(
                                  //             content: Text('${port.modelName}'),
                                  //             title: const Center(
                                  //                 child: Text(
                                  //               'Select Printer',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                   fontSize: 20),
                                  //             )),
                                  //           );
                                  //         });
                                  //   }
                                  // });

                                  showOpeningBalanceDialog(context);
                                },
                              ),
                              title: ElevatedButton.icon(
                                label: Text('Print Test Receipt',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: defaultTargetPlatform ==
                                                TargetPlatform.iOS
                                            ? 18
                                            : 20)),
                                icon: Icon(
                                  Icons.print,
                                  size: defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 25
                                      : 30,
                                ),
                                onPressed: () async {
                                  // const PaperSize paper = PaperSize.mm80;
                                  // final profile = await CapabilityProfile.load();
                                  // final printer = NetworkPrinter(paper, profile);
                                  //
                                  // final PosPrintResult res = await printer
                                  //     .connect(Helper.ip_adrress!, port: 9100);
                                  //
                                  // if (res == PosPrintResult.success) {
                                  //   // testReceipt(printer);
                                  //   // printer.disconnect();
                                  //
                                  //   help.Helper.showToastSuccess(
                                  //       "Connection successful", context);
                                  //   // Set print styles (optional: you can modify the style to suit your needs)
                                  //   printer.connect(Helper.ip_adrress!, port: 9100);
                                  //   printer.rawBytes(
                                  //       Uint8List.fromList([0x1B, 0x40])); // Reset
                                  //   printer.text('Hello World!');
                                  //   // printer
                                  //       // .setStyles(PosStyles(align: PosAlign.left));
                                  //
                                  //   // Print receipt content
                                  //   printer.text('Receipt Example');
                                  //   printer.text('Item 1 - \$10.00');
                                  //   printer.text('Item 2 - \$20.00');
                                  //   printer.text('Total - \$30.00');
                                  //
                                  //   // Optionally, cut the paper after printing
                                  //   printer.cut();
                                  //
                                  //   await Future.delayed(Duration(seconds: 2));
                                  //   // Disconnect from the printer after printing
                                  //   printer.disconnect();
                                  // }

                                  // setState(() {
                                  //   printer_details =
                                  //       'Print result: ${res.msg} - IP: ${Helper.ip_adrress}';
                                  // });

                                  PrintCommands commands = PrintCommands();
                                  String raster = "        Star Clothing Boutique\n" +
                                      "             123 Star Road\n" +
                                      "           City, State 12345\n" +
                                      "\n" +
                                      "Date:MM/DD/YYYY          Time:HH:MM PM\n" +
                                      "--------------------------------------\n" +
                                      "SALE\n" +
                                      "SKU            Description       Total\n" +
                                      "300678566      PLAIN T-SHIRT     10.99\n" +
                                      "300692003      BLACK DENIM       29.99\n" +
                                      "300651148      BLUE DENIM        29.99\n" +
                                      "300642980      STRIPED DRESS     49.99\n" +
                                      "30063847       BLACK BOOTS       35.99\n" +
                                      "\n" +
                                      "Subtotal                        156.95\n" +
                                      "Tax                               0.00\n" +
                                      "--------------------------------------\n" +
                                      "Total                           156.95\n" +
                                      "--------------------------------------\n" +
                                      "\n" +
                                      "Charge\n" +
                                      "156.95\n" +
                                      "Visa XXXX-XXXX-XXXX-0123\n" +
                                      "Refunds and Exchanges\n" +
                                      "Within 30 days with receipt\n" +
                                      "And tags attached\n";
                                  commands.appendBitmapText(text: raster);
                                  // commands.push({'appendBitmapText': "Android Hello World to Star Printer"});
                                  commands.push(
                                      {'appendCutPaper': "FullCutWithFeed"});
                                  await StarPrnt.print(
                                      portName: printerIP!,
                                      emulation: 'StarGraphic',
                                      printCommands: commands);

                                  Helper.showPopup(context,
                                      " $printerIP \n ${await StarPrnt.print(
                                          portName: printerIP!,
                                          emulation: 'StarGraphic',
                                          printCommands: commands)}");

                                  },
                              ),
                              trailing: ElevatedButton.icon(
                                label: Text('Open Cash Drawer',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: defaultTargetPlatform ==
                                                TargetPlatform.iOS
                                            ? 18
                                            : 20)),
                                icon: Icon(
                                  Icons.drafts,
                                  size: defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 25
                                      : 30,
                                ),
                                onPressed: () {
                                  // printTicket(testTicket as List<int>);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  )),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: const VisualDensity(vertical: 4),
                        leading: const Icon(
                          Icons.print_rounded,
                          size: 30,
                        ),
                        title: Text(
                          'KOT Print',
                          style: getTextStyle(
                              fontSize: LARGE_MINUS20_FONT_SIZE,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(error),
                        trailing: ElevatedButton.icon(
                          label: const Text('No Printer',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              )),
                          icon: const Icon(null),
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 255, 17, 0))),
                          onPressed: () async {
                            // printReceipt_raw(Helper.ip_adrress!, 9100);
                          },
                        ),
                      ),
                      Container(
                        // alignment: Alignment.topLeft,
                        // width: 800,
                        child: ListTile(
                            visualDensity: const VisualDensity(vertical: 4),
                            leading: ElevatedButton.icon(
                              label: Text('Change Printer',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? 18
                                          : 20)),
                              icon: Icon(
                                Icons.compare_arrows_sharp,
                                size:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 25
                                        : 30,
                              ),
                              onPressed: () {
                                // scanForPrinters();
                              },
                            ),
                            title: ElevatedButton.icon(
                              label: Text('Print Test Receipt',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? 18
                                          : 20)),
                              icon: Icon(
                                Icons.print,
                                size:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 25
                                        : 30,
                              ),
                              onPressed: () async {
                                // widget.printerManager.scanResults.listen((devices) async {
                                //   // print('UI: Devices found ${devices.length}');
                                //   setState(() {
                                //     widget._devices = devices;
                                //   });
                                // });
                                //
                                //
                                // setState(() {
                                //   widget._devices = [];
                                // });
                                // widget.printerManager.startScan(Duration(seconds: 4));
                                //
                                // _testPrint(widget._devices[0]);
                                // showPrinterSelectionDialog;
                              },
                            ),
                            trailing: null),
                      ),
                    ],
                  ),
                ),
              ])),
        ],
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     List<PortInfo> list =
  //     await StarPrnt.portDiscovery(StarPortType.LAN);
  //     print(list);
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     // _platformVersion = platformVersion;
  //   });
  // }

  _print(StarXpandPrinter printer) async {
    var doc = StarXpandDocument();
    var printDoc = StarXpandDocumentPrint();

    // http.Response response = await http.get(
    //   Uri.parse(
    //       'https://ovatu.com/marketing/images/ovatu/logo-large-navy.png'),
    // );

    // printDoc.actionPrintImage(response.bodyBytes, 350);

    printDoc.style(
        internationalCharacter: StarXpandStyleInternationalCharacter.usa,
        characterSpace: 0.0,
        alignment: StarXpandStyleAlignment.center);
    printDoc.actionPrintText("Star Clothing Boutique\n"
        "123 Star Road\n"
        "City, State 12345\n");

    printDoc.style(alignment: StarXpandStyleAlignment.left);
    printDoc.actionPrintText("Date:MM/DD/YYYY    Time:HH:MM PM\n"
        "--------------------------------\n");

    printDoc.add(StarXpandDocumentPrint()
      ..style(bold: true)
      ..actionPrintText("SALE\n"));

    printDoc.actionPrintText("SKU         Description    Total\n"
        "--------------------------------\n"
        "300678566   PLAIN T-SHIRT  10.99\n"
        "300692003   BLACK DENIM    29.99\n"
        "300651148   BLUE DENIM     29.99\n"
        "300642980   STRIPED DRESS  49.99\n"
        "300638471   BLACK BOOTS    35.99\n"
        "Subtotal                  156.95\n"
        "Tax                         0.00\n"
        "--------------------------------\n");

    printDoc.actionPrintText("Total     ");

    printDoc.add(StarXpandDocumentPrint()
      ..style(magnification: StarXpandStyleMagnification(2, 2))
      ..actionPrintText("   \$156.95\n"));

    printDoc.actionPrintText("--------------------------------\n"
        "Charge\n"
        "156.95\n"
        "Visa XXXX-XXXX-XXXX-0123\n");

    printDoc.add(StarXpandDocumentPrint()
      ..style(invert: true)
      ..actionPrintText("Refunds and Exchanges\n"));

    printDoc.actionPrintText("Within ");

    printDoc.add(StarXpandDocumentPrint()
      ..style(underLine: true)
      ..actionPrintText("30 days"));

    printDoc.actionPrintText(" with receipt\n");
    printDoc.actionPrintText("And tags attached\n\n");

    printDoc.style(alignment: StarXpandStyleAlignment.center);

    printDoc.actionPrintBarcode("0123456",
        symbology: StarXpandBarcodeSymbology.jan8,
        barDots: 3,
        height: 5,
        printHri: true);

    printDoc.actionFeedLine(1);

    printDoc.actionPrintQRCode("Hello, World\n",
        level: StarXpandQRCodeLevel.l, cellSize: 8);

    printDoc.actionCut(StarXpandCutType.partial);

    doc.addPrint(printDoc);
    doc.addDrawer(StarXpandDocumentDrawer());

    StarXpand.printDocument(printer, doc);
  }

  List<String> availablePrinters = [];
  String error = "No printer found";

  Future<void> scanForPrinters() async {
    // Function to scan for available printers on the network

    List<String> foundPrinters = [];
    String subnet = "192.168.0."; // Modify to your local network subnet
    int startRange = 1;
    int endRange = 254;

    // Try connecting to each IP in the subnet
    for (int i = startRange; i <= endRange; i++) {
      String ip = "$subnet$i";
      Socket? socket;
      try {
        socket = await Socket.connect(ip, 9100, timeout: Duration(seconds: 1));
        socket.destroy();
        // socket?.close();
        setState(() {
          error = "try:Printer found";
        });
        foundPrinters
            .add(ip); // If we successfully connect, this is a valid printer
      } catch (e) {
        socket?.destroy();
        // Navigator.pop(context);
        print("scan Print ${e.toString()}");

        setState(() {
          error = "Catch:" + e.toString();
        });
        // Helper.showPopup(context, e.toString());
        // If connection fails, this IP doesn't have a printer or is unreachable
      } finally {
        socket
            ?.destroy(); // Ensure socket is closed in both success and failure cases
      }
    }
    setState(() {
      availablePrinters = foundPrinters;
    });
  }

  // Function to show a dialog for selecting a printer

  // Function to print receipt after selecting a printer
  void printReceipt(String ipAddress) async {
    final profile = await CapabilityProfile.load();
    // final printer = NetworkPrinter(PaperSize.mm80, profile);

    // final connectResult = await printer.connect(ipAddress, port: 9100);
    // if (connectResult == PosPrintResult.success) {
    //   printer.setStyles(PosStyles(align: PosAlign.left));
    //   printer.text('Receipt Example');
    //   printer.text('Item 1 - \$10.00');
    //   printer.text('Item 2 - \$20.00');
    //   printer.text('Total - \$30.00');
    //   printer.cut();
    //   printer.disconnect();
    // } else {
    //   Helper.showPopup(context, 'Failed to connect to the printer');
    // }
  }

  // Function to show a dialog for selecting a printer
  void showPrinterListSelectionDialog(List<StarXpandPrinter> printerList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Printer"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            for (var p in printerList!)
              ListTile(
                  onTap: () => _print(p),
                  title: Text(p.model.label),
                  subtitle: Text(p.identifier),
                  trailing: Text(p.interface.name))
          ]),
        );
      },
    );
  }

  void showPrinterSelectionDialog() {
    if (availablePrinters.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Printer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availablePrinters.map((printerIp) {
              return ListTile(
                title: Text(printerIp),
                onTap: () {
                  Navigator.pop(context);
                  // Handle printer selection (connect and print)
                  printReceipt(printerIp);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void showOpeningBalanceDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    amountController.text = Helper.ip_adrress!;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.3, // 30% of screen width
            // height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change IP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "Please Enter ip",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "IP",
                  ),
                ),
                SizedBox(height: 10),

                // Spacer(), // Pushes buttons to the bottom
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Handle "Start Sales" action

                      setState(() {
                        Helper.ip_adrress = amountController.text;
                      });
                      Navigator.pop(context);
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
                    // ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

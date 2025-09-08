import 'dart:io';
import 'dart:math';
import 'dart:ui';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as blue;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';
// import 'package:flutter_star_prnt/flutter_star_prnt.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../utils copy/helper.dart';
import '../../../../../utils copy/helper.dart';
import '../../../../../utils/helper.dart' as help;
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';

import 'package:flutter/material.dart';
import 'package:starxpand/models/starxpand_printer.dart';
import 'package:starxpand/starxpand.dart';

import '../../../../service/api_printer_setting/model/printerList.dart';

class PrinterSettingsLandscapeCopy extends StatefulWidget {
  PrinterSettingsLandscapeCopy({super.key});

  // PrinterBluetoothManager printerManager = blue.PrinterBluetoothManager();
  // List<blue.PrinterBluetooth> _devices = [];
  // final printer = Printer();
  @override
  State<PrinterSettingsLandscapeCopy> createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettingsLandscapeCopy> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool isOn = false;
    String printer_details = "";
    List<StarXpandPrinter>? printers;

    String emulationFor(String modelName) {
      String emulation = 'StarLine';
      // if (modelName != '') {
      //   final em = StarMicronicsUtilities.detectEmulation(modelName: modelName);
      //   emulation = em!.emulation!;
      // }
      return emulation;
    }

    // _openDrawer(StarXpandPrinter printer) {
    //   StarXpand.openDrawer(printer);
    // }
    //
    // _startInputListener(StarXpandPrinter printer) {
    //   StarXpand.startInputListener(
    //       printer, (p) => print('_startInputListener: ${p.inputString}'));
    // }
    //
    // _print(StarXpandPrinter printer) async {
    //   var doc = StarXpandDocument();
    //   var printDoc = StarXpandDocumentPrint();
    //
    //   // http.Response response = await http.get(
    //   //   Uri.parse(
    //   //       'https://ovatu.com/marketing/images/ovatu/logo-large-navy.png'),
    //   // );
    //
    //   // printDoc.actionPrintImage(response.bodyBytes, 350);
    //
    //   printDoc.style(
    //       internationalCharacter: StarXpandStyleInternationalCharacter.usa,
    //       characterSpace: 0.0,
    //       alignment: StarXpandStyleAlignment.center);
    //   printDoc.actionPrintText("Star Clothing Boutique\n"
    //       "123 Star Road\n"
    //       "City, State 12345\n");
    //
    //   printDoc.style(alignment: StarXpandStyleAlignment.left);
    //   printDoc.actionPrintText("Date:MM/DD/YYYY    Time:HH:MM PM\n"
    //       "--------------------------------\n");
    //
    //   printDoc.add(StarXpandDocumentPrint()
    //     ..style(bold: true)
    //     ..actionPrintText("SALE\n"));
    //
    //   printDoc.actionPrintText("SKU         Description    Total\n"
    //       "--------------------------------\n"
    //       "300678566   PLAIN T-SHIRT  10.99\n"
    //       "300692003   BLACK DENIM    29.99\n"
    //       "300651148   BLUE DENIM     29.99\n"
    //       "300642980   STRIPED DRESS  49.99\n"
    //       "300638471   BLACK BOOTS    35.99\n"
    //       "Subtotal                  156.95\n"
    //       "Tax                         0.00\n"
    //       "--------------------------------\n");
    //
    //   printDoc.actionPrintText("Total     ");
    //
    //   printDoc.add(StarXpandDocumentPrint()
    //     ..style(magnification: StarXpandStyleMagnification(2, 2))
    //     ..actionPrintText("   \$156.95\n"));
    //
    //   printDoc.actionPrintText("--------------------------------\n"
    //       "Charge\n"
    //       "156.95\n"
    //       "Visa XXXX-XXXX-XXXX-0123\n");
    //
    //   printDoc.add(StarXpandDocumentPrint()
    //     ..style(invert: true)
    //     ..actionPrintText("Refunds and Exchanges\n"));
    //
    //   printDoc.actionPrintText("Within ");
    //
    //   printDoc.add(StarXpandDocumentPrint()
    //     ..style(underLine: true)
    //     ..actionPrintText("30 days"));
    //
    //   printDoc.actionPrintText(" with receipt\n");
    //   printDoc.actionPrintText("And tags attached\n\n");
    //
    //   printDoc.style(alignment: StarXpandStyleAlignment.center);
    //
    //   printDoc.actionPrintBarcode("0123456",
    //       symbology: StarXpandBarcodeSymbology.jan8,
    //       barDots: 3,
    //       height: 5,
    //       printHri: true);
    //
    //   printDoc.actionFeedLine(1);
    //
    //   printDoc.actionPrintQRCode("Hello, World\n",
    //       level: StarXpandQRCodeLevel.l, cellSize: 8);
    //
    //   printDoc.actionCut(StarXpandCutType.partial);
    //
    //   doc.addPrint(printDoc);
    //   doc.addDrawer(StarXpandDocumentDrawer());
    //
    //   StarXpand.printDocument(printer, doc);
    // }
    //
    // // set up the buttons
    // Widget cancelButton = TextButton(
    //   child: const Text("Cancel"),
    //   onPressed: () {
    //     // Navigator.of(context).pop();
    //   },
    // );
    // Widget continueButton = TextButton(
    //   child: const Text("Continue"),
    //   onPressed: () {
    //     // Navigator.of(context).pop();
    //   },
    // );

    // set up the AlertDialog
    // AlertDialog alert = AlertDialog(
    //   title: Text("printer $printers"),
    //   content: const Text(
    //       "Would you like to continue learning how to use Flutter alerts?"),
    //   actions: [
    //     cancelButton,
    //     continueButton,
    //   ],
    // );

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              height: 180,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0))),
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
                      label: const Text('No Printer',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          )),
                      icon: const Icon(null),
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 255, 17, 0))),
                      onPressed: () {},
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
                                fontSize:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 18
                                        : 20),
                          ),
                          icon: Icon(
                            Icons.compare_arrows_sharp,
                            size: defaultTargetPlatform == TargetPlatform.iOS
                                ? 25
                                : 30,
                          ),
                          onPressed: () async {
                            CircularProgressIndicator;
                            // _find();
                            // Find printers
                            /* List<PortInfo> list =
                                await StarPrnt.portDiscovery(StarPortType.All);
                            // print(list);
                            list.forEach((port) async {
                              selectPrinter(list);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('${port.portName}'),
                                      title: const Center(
                                          child: Text(
                                        'Select Printer',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )),
                                    );
                                  });*/
                            // print(port.portName);
                            // if (port.portName?.isNotEmpty != null) {
                            //   print(await StarPrnt.getStatus(
                            //     portName: "TCP:192.168.5.166",
                            //     emulation: emulationFor(port.modelName!),
                            //   ));

                           /* PrintCommands commands = PrintCommands();
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
                            commands.push({'appendBitmapText': "Hello World"});
                            commands
                                .push({'appendCutPaper': "FullCutWithFeed"});
                            await StarPrnt.sendCommands(
                                portName: "TCP:192.168.6.55",
                                emulation: 'StarGraphic',
                                printCommands: commands);

                            print(await StarPrnt.sendCommands(
                                portName: "TCP:192.168.6.55",
                                emulation: 'StarGraphic',
                                printCommands: commands));

                            //   showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           content: Text('${port.modelName}'),
                            //           title: const Center(
                            //               child: Text(
                            //             'Select Printer',
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 20),
                            //           )),
                            //         );
                            //       });
                            // // } else {
                            //   debugPrint('else part');
                            // }
                            // });
                            debugPrint('else part after for loop');
                            showOpeningBalanceDialog(context);*/
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
                            size: defaultTargetPlatform == TargetPlatform.iOS
                                ? 25
                                : 30,
                          ),
                          onPressed: () async {
                            const PaperSize paper = PaperSize.mm80;
                            final profile = await CapabilityProfile.load();
                            final printer = NetworkPrinter(paper, profile);

                            final PosPrintResult res = await printer
                                .connect(Helper.ip_adrress!, port: 9100);

                            if (res == PosPrintResult.success) {
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
                              printer.text('Item 1 - \$10.00');
                              printer.text('Item 2 - \$20.00');
                              printer.text('Total - \$30.00');

                              // Optionally, cut the paper after printing
                              printer.cut();

                              await Future.delayed(Duration(seconds: 2));
                              // Disconnect from the printer after printing
                              printer.disconnect();
                            }

                            setState(() {
                              printer_details =
                                  'Print result: ${res.msg} - IP: ${Helper.ip_adrress}';
                            });
                            print(
                                'Print result: ${res.msg} - IP: ${Helper.ip_adrress}');
                            Helper.showPopup(context,
                                " ${res.msg} \nIP: ${Helper.ip_adrress}");
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
                            size: defaultTargetPlatform == TargetPlatform.iOS
                                ? 25
                                : 30,
                          ),
                          onPressed: () {},
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
                    onPressed: () async {},
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
                                fontSize:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 18
                                        : 20)),
                        icon: Icon(
                          Icons.compare_arrows_sharp,
                          size: defaultTargetPlatform == TargetPlatform.iOS
                              ? 25
                              : 30,
                        ),
                        onPressed: () {
                          scanForPrinters();
                        },
                      ),
                      title: ElevatedButton.icon(
                        label: Text('Print Test Receipt',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 18
                                        : 20)),
                        icon: Icon(
                          Icons.print,
                          size: defaultTargetPlatform == TargetPlatform.iOS
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
                          showPrinterSelectionDialog;
                        },
                      ),
                      trailing: null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _testPrint(blue.PrinterBluetooth printer) async {
  //   widget.printerManager.selectPrinter(printer);
  //
  //   // TODO Don't forget to choose printer's paper
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //
  //   // TEST PRINT
  //   // final PosPrintResult res =
  //   // await printerManager.printTicket(await testTicket(paper));
  //
  //   // DEMO RECEIPT
  //   final PosPrintResult res =
  //   (await widget.printerManager.printTicket((await demoReceipt(paper, profile)))) as PosPrintResult;
  //
  //   // showToast(res.msg);
  // }

  // Future<List<int>> demoReceipt(
  //     PaperSize paper, CapabilityProfile profile) async {
  //   final Generator ticket = Generator(paper, profile);
  //   List<int> bytes = [];
  //
  //   // Print image
  //   // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
  //   // final Uint8List imageBytes = data.buffer.asUint8List();
  //   // final Image? image = decodeImage(imageBytes);
  //   // bytes += ticket.image(image);
  //
  //   bytes += ticket.text('GROCERYLY',
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);
  //
  //   bytes += ticket.text('889  Watson Lane',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += ticket.text('New Braunfels, TX',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += ticket.text('Tel: 830-221-1234',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += ticket.text('Web: www.example.com',
  //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);
  //
  //   bytes += ticket.hr();
  //   bytes += ticket.row([
  //     PosColumn(text: 'Qty', width: 1),
  //     PosColumn(text: 'Item', width: 7),
  //     PosColumn(
  //         text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(
  //         text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   bytes += ticket.row([
  //     PosColumn(text: '2', width: 1),
  //     PosColumn(text: 'ONION RINGS', width: 7),
  //     PosColumn(
  //         text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(
  //         text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   bytes += ticket.row([
  //     PosColumn(text: '1', width: 1),
  //     PosColumn(text: 'PIZZA', width: 7),
  //     PosColumn(
  //         text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(
  //         text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   bytes += ticket.row([
  //     PosColumn(text: '1', width: 1),
  //     PosColumn(text: 'SPRING ROLLS', width: 7),
  //     PosColumn(
  //         text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(
  //         text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   bytes += ticket.row([
  //     PosColumn(text: '3', width: 1),
  //     PosColumn(text: 'CRUNCHY STICKS', width: 7),
  //     PosColumn(
  //         text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
  //     PosColumn(
  //         text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   bytes += ticket.hr();
  //
  //   bytes += ticket.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //     PosColumn(
  //         text: '\$10.97',
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //   ]);
  //
  //   bytes += ticket.hr(ch: '=', linesAfter: 1);
  //
  //   bytes += ticket.row([
  //     PosColumn(
  //         text: 'Cash',
  //         width: 7,
  //         styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //     PosColumn(
  //         text: '\$15.00',
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   ]);
  //   bytes += ticket.row([
  //     PosColumn(
  //         text: 'Change',
  //         width: 7,
  //         styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //     PosColumn(
  //         text: '\$4.03',
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  //   ]);
  //
  //   bytes += ticket.feed(2);
  //   bytes += ticket.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   final now = DateTime.now();
  //   final formatter = DateFormat('MM/dd/yyyy H:m');
  //   final String timestamp = formatter.format(now);
  //   bytes += ticket.text(timestamp,
  //       styles: PosStyles(align: PosAlign.center), linesAfter: 2);
  //
  //   // Print QR Code from image
  //   // try {
  //   //   const String qrData = 'example.com';
  //   //   const double qrSize = 200;
  //   //   final uiImg = await QrPainter(
  //   //     data: qrData,
  //   //     version: QrVersions.auto,
  //   //     gapless: false,
  //   //   ).toImageData(qrSize);
  //   //   final dir = await getTemporaryDirectory();
  //   //   final pathName = '${dir.path}/qr_tmp.png';
  //   //   final qrFile = File(pathName);
  //   //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  //   //   final img = decodeImage(imgFile.readAsBytesSync());
  //
  //   //   bytes += ticket.image(img);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //
  //   // Print QR Code using native function
  //   // bytes += ticket.qrcode('example.com');
  //
  //   ticket.feed(2);
  //   ticket.cut();
  //   return bytes;
  // }
  //
  // Future<List<int>> testTicket(
  //     PaperSize paper, CapabilityProfile profile) async {
  //   final Generator generator = Generator(paper, profile);
  //   List<int> bytes = [];
  //
  //   bytes += generator.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   // bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
  //   //     styles: PosStyles(codeTable: PosCodeTable.westEur));
  //   // bytes += generator.text('Special 2: blåbærgrød',
  //   //     styles: PosStyles(codeTable: PosCodeTable.westEur));
  //
  //   bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  //   bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  //   bytes += generator.text('Underlined text',
  //       styles: PosStyles(underline: true), linesAfter: 1);
  //   bytes +=
  //       generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   bytes += generator.text('Align center',
  //       styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Align right',
  //       styles: PosStyles(align: PosAlign.right), linesAfter: 1);
  //
  //   bytes += generator.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);
  //
  //   bytes += generator.text('Text size 200%',
  //       styles: PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));
  //
  //   // Print image
  //   // final ByteData data = await rootBundle.load('assets/logo.png');
  //   // final Uint8List buf = data.buffer.asUint8List();
  //   // final Image image = decodeImage(buf)!;
  //   // bytes += generator.image(image);
  //   // Print image using alternative commands
  //   // bytes += generator.imageRaster(image);
  //   // bytes += generator.imageRaster(image, imageFn: PosImageFn.graphics);
  //
  //   // Print barcode
  //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  //   bytes += generator.barcode(Barcode.upcA(barData));
  //
  //   // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
  //   // bytes += generator.text(
  //   //   'hello ! 中文字 # world @ éphémère &',
  //   //   styles: PosStyles(codeTable: PosCodeTable.westEur),
  //   //   containsChinese: true,
  //   // );
  //
  //   bytes += generator.feed(2);
  //
  //   bytes += generator.cut();
  //   return bytes;
  // }


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
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final connectResult = await printer.connect(ipAddress, port: 9100);
    if (connectResult == PosPrintResult.success) {
      printer.setStyles(PosStyles(align: PosAlign.left));
      printer.text('Receipt Example');
      printer.text('Item 1 - \$10.00');
      printer.text('Item 2 - \$20.00');
      printer.text('Total - \$30.00');
      printer.cut();
      printer.disconnect();
    } else {
      Helper.showPopup(context, 'Failed to connect to the printer');
    }
  }

  // Function to show a dialog for selecting a printer
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

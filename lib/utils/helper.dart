import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/new_create_order.dart';
import 'package:nb_posx/core/mobile/home/ui/home_dashboard.dart';
import 'package:nb_posx/database/models/api_order_item.dart';
import 'package:nb_posx/database/models/api_park_order.dart';
import 'package:nb_posx/database/models/park_order.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
import 'package:sunmi_printer_plus/core/types/sunmi_column.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:toastification/toastification.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../core/mobile/home/ui/home.dart';
import '../core/service/api_cart/model/cart_data.dart';
import '../core/service/api_cart/model/cart_response.dart';
import '../core/service/api_cashier/model/closeDay.dart';
import '../core/service/api_sales/model/orderDetailsModel.dart';
import '../database/db_utils/db_constants.dart';
import '../database/db_utils/db_preferences.dart';
import '../database/models/hub_manager.dart';
import '../database/models/order_item.dart';
import '../database/models/sale_order.dart';
import '../widgets/popup_widget.dart';
import 'ReceiptLogger.dart';
import 'ui_utils/padding_margin.dart';
import 'ui_utils/text_styles/custom_text_style.dart';
import 'package:image/image.dart' as img;

class Helper {
  static HubManager? hubManager;
  static ParkOrder? activeParkedOrder;
  static APIParkOrder? activeAPIParkedOrder;
  static String? ip_adrress = 'TCP:192.168.6.55';

  ///
  /// convert double amount value into currency type with 2 decimal places
  /// returns a string value to be used in UI
  ///
  String formatCurrency(double amount) {
    var currencyFormatter = NumberFormat("###0.00", "en_US");
    return currencyFormatter.format(amount);
  }

  double getTotal(List<OrderItem> orderedProducts) {
    double totalAmount = 0.0;
    for (var product in orderedProducts) {
      totalAmount =
          totalAmount + (product.orderedPrice * product.orderedQuantity);
    }
    return totalAmount;
  }

  double getAPIORDERTotal(List<APIOrderItem> orderedProducts) {
    double totalAmount = 0.0;
    for (var product in orderedProducts) {
      totalAmount =
          totalAmount + (product.orderedPrice * product.orderedQuantity);
    }
    return totalAmount;
  }

  ///Function to check internet connectivity in app.
  static Future<bool> isNetworkAvailable() async {
    //Checking for the connectivity
    // var connection = await Connectivity().checkConnectivity();

    bool hasInternet = await InternetConnectionChecker().hasConnection;

    //If connected to mobile data or wifi
    if (hasInternet) {
      //Returning result as true
      return true;
    } else {
      //Returning result as false
      return false;
    }
  }

  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: leftSpace(x: 15),
              child: Text(PLEASE_WAIT_TXT,
                  style: getTextStyle(
                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                      fontWeight: FontWeight.normal))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showToastSuccess(String text, BuildContext context) {
    toastification.show(
      context: context,
      // optional if you use ToastificationWrapper
      title: text,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static void showToastFail(String text, BuildContext context) {
    toastification.show(
      context: context,
      // optional if you use ToastificationWrapper
      title: text,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static void showToastInfo(String text, BuildContext context) {
    toastification.show(
      context: context,
      // optional if you use ToastificationWrapper
      title: text,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static bool checkOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static void showCustomLoaderDialog(BuildContext context, String text) {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        width: Device.get().isTablet
            ? MediaQuery.of(context).size.width * 0.3
            : MediaQuery.of(context).size.width * 0.1, // 30% of screen width
        height: Device.get().isTablet
            ? MediaQuery.of(context).size.height * 0.1
            : 50, // 15% of screen height
        child: Row(
          children: [
            Device.get().isTablet
                ? const SizedBox(width: 20)
                : const SizedBox(width: 0), // Space between spinner and text
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: Device.get().isTablet ? 4 : 2,
                valueColor: AlwaysStoppedAnimation<Color>(MAIN_COLOR),
              ),
            ),
            const SizedBox(width: 50), // Space between spinner and text
            Expanded(
              child: Text(
                text,
                style: getTextStyle(
                  fontSize: Device.get().isTablet
                      ? MediaQuery.of(context).size.width * 0.01
                      : MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  //Function to show the snackbar messages on UI.
  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: getTextStyle(
          fontSize: MEDIUM_MINUS_FONT_SIZE,
          fontWeight: FontWeight.normal,
          color: WHITE_COLOR),
    ));
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  //Function to show the popup with one button with on pressed functionality to close popup.
  static showPopup(BuildContext context, String message,
      {bool? barrierDismissible = false}) async {
    await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SizedBox(
            height: 100,
            child: SimplePopup(
              barrier: barrierDismissible,
              message: message,
              buttonText: OPTION_OK.toUpperCase(),
              onOkPressed: () {
                barrierDismissible == true
                    ? SystemNavigator.pop()
                    : Navigator.pop(context);
              },
            ),
          );
        });
  }

  //FIXME:: Fix the width of the popup for tablet here
  //Function to show the popup with one button with on pressed functionality to close popup.
  static showPopupForTablet(BuildContext context, String message) async {
    await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(left: 400, right: 400),
              child: SimplePopup(
                message: message,
                buttonText: OPTION_OK.toUpperCase(),
                onOkPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }

  //Function to show the popup with one button with on pressed functionality to close popup.
  static Future showConfirmationPopup(
      BuildContext context, String message, String btnTxt,
      {bool hasCancelAction = false}) async {
    var popup = await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SizedBox(
            height: 100,
            child: SimplePopup(
              message: message,
              buttonText: btnTxt,
              hasCancelAction: hasCancelAction,
              onOkPressed: () {
                SystemNavigator.pop();
              },
            ),
          );
        });
    return popup;
  }

  ///Function to fetch the image bytes from image url.
  static Future<Uint8List> getImageBytesFromUrl(String imageUrl) async {
    /* try {
      http.Response imageResponse = await http.get(
        Uri.parse(imageUrl),
      );
      log('Image data Response :: $imageResponse');
      return imageResponse.bodyBytes;
    } catch (e) {
      log('Exception occurred during image bytes fetching :: $e');
      return Uint8List.fromList([]);
    } */
    try {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load('');

      // log('Image : $imageData');

      final Uint8List bytes = imageData.buffer.asUint8List();

      return bytes;
    } catch (e) {
      log('Exception occurred during image bytes fetching :: $e');
      return Uint8List.fromList([]);
    }
  }

  ///ONLY FOR LOGGING PURPOSE - Function to print the JSON object in logs in proper format.
  ///[data] -> Decoded JSON body
  static printJSONData(var data) {
    final prettyString = const JsonEncoder.withIndent(' ').convert(data);
    log(prettyString);
  }

  static String getCurrentDateTime() {
    return DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  }

  static String getCurrentDate() {
    return DateFormat("yyyy-MM-dd").format(DateTime.now());
  }

  static String getCurrentTime() {
    return DateFormat("HH:mm").format(DateTime.now());
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return DateFormat('EEEE, d MMM yyyy, h:mm a').format(dateTime);
  }

  static Future<String> getOrderId() async {
    NumberFormat numberFormat = NumberFormat("0000");
    DateTime currentDateTime = DateTime.now();
    String orderNo = await DBPreferences().getPreference(CURRENT_ORDER_NUMBER);
    if (orderNo.isEmpty) orderNo = "1";
    String orderSeries = await DBPreferences().getPreference(SalesSeries);
    String orderId = orderSeries
        .replaceAll(".YYYY.", "${currentDateTime.year}")
        .replaceAll(".MM.", "${currentDateTime.month}")
        .replaceAll(".####", numberFormat.format(int.parse(orderNo)));

    return orderId;
  }

  static String getTime(String time) {
    List<String> splittedString = time.split(':');

    String temp = splittedString[0];

    if (temp.length == 1) {
      temp = "0$temp";

      splittedString.removeAt(0);
      splittedString.insert(0, temp);

      String finalTime = splittedString.join(':');

      return finalTime;
    } else {
      return time;
    }
  }

  static Color getPaymentStatusColor(String paymentStatus) {
    if (paymentStatus == "Unpaid") {
      return Colors.red;
    } else if (paymentStatus == "Paid") {
      return GREEN_COLOR;
    } else {
      return MAIN_COLOR;
    }
  }

  ///Siddhant : Commented code, as GetMaterialApp from GetX state management is not the root.
  ///
  // static List<Map> getMenuItemList() {
  //   List<Map> menuItems = [];
  //   Map<String, dynamic> homeMenu = {
  //     "title": "Home",
  //     "action": () {
  //       Get.offAll(() => const Home());
  //     }
  //   };
  //   Map<String, dynamic> createOrderMenu = {
  //     "title": "Create new sale",
  //     "action": () {
  //       Get.offAll(NewCreateOrder(), arguments: "create_new_order");
  //     }
  //   };
  //   Map<String, dynamic> parkOrderMenu = {
  //     "title": "Parked orders",
  //     "action": () {
  //       Get.offAll(const OrderListScreen(), arguments: "parked_order");
  //     }
  //   };
  //   menuItems.add(createOrderMenu);
  //   menuItems.add(parkOrderMenu);
  //   menuItems.add(homeMenu);
  //   return menuItems;
  // }

  static List<Map> getMenuItemList(BuildContext context) {
    List<Map> menuItems = [];
    Map<String, dynamic> homeMenu = {
      "title": "Home",
      "action": () {
        //Get.offAll(() => const Home());
        // Navigator.push(
        //     // ignore: prefer_const_constructors
        //     context,
        //     MaterialPageRoute(builder: (context) => HomeDashboard()));
      }
    };
    Map<String, dynamic> createOrderMenu = {
      "title": "Create new sale",
      "action": () {
        //Get.offAll(NewCreateOrder(), arguments: "create_new_order");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewCreateOrder()));
      }
    };
    Map<String, dynamic> parkOrderMenu = {
      "title": "Parked orders",
      "action": () {
        //Get.offAll(const OrderListScreen(), arguments: "parked_order");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewCreateOrder()));
      }
    };
    menuItems.add(createOrderMenu);
    menuItems.add(parkOrderMenu);
    menuItems.add(homeMenu);
    return menuItems;
  }

  static void activateParkedOrder(ParkOrder parkedOrder) {
    activeParkedOrder = parkedOrder;
  }

  static void activateAPIParkedOrder(APIParkOrder parkedOrder) {
    activeAPIParkedOrder = parkedOrder;
  }

  ///Function to check whether the input URL is valid or not
  /* static bool isValidUrl(String url) {
    // Regex to check valid URL
    String regex =
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";

    return RegExp(regex).hasMatch(url);
  }*/

  //TODO:: Need to handle the print receipt here
  ///Helper method to print the invoice in PDF format and through printer device.
  Future<bool> printInvoice(BuildContext context, SaleOrder placedOrder) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Create receipt data
    final List<int> bytes = [];

    bytes.addAll(generator.text('Receipt Example',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text('Item 1 - \$10.00'));
    bytes.addAll(generator.text('Item 2 - \$20.00'));
    bytes.addAll(
        generator.text('Total - \$30.00', styles: PosStyles(bold: true)));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    // Send to printer using RawSocket
    try {
      final socket = await Socket.connect(Helper.ip_adrress!, 9100);
      socket.add(bytes);
      await socket.flush();
      socket.destroy();
      print("Print success!");
      Helper.showToastSuccess("Print successful", context);

      return true;
    } catch (e) {
      print("Print failed: $e");
      Helper.showToastFail("Printing failure", context);

      return false;
    }
  }

  ///Production Sunmi Receipt
/*  Future<bool> printProductionInternalSunmiInvoice(
      BuildContext context,
      List<OrderItem> placedOrder,
      order_amount,
      vat,
      discount,
      delivery,
      ord_no,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server) async {
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('$address3 $phoneNo CR No: $crno',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('VAT: $vatNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('Date:$transactionDate  Time:$transactionTime',
    //     style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
        text: 'Date:$transactionDate',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT),
      ),
      SunmiColumn(
        text: 'Time:$transactionTime',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.RIGHT),
      ),
    ]);
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('TAX INVOICE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Order No: ${ord_no}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Table No: ${tableNo}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Server: ${server}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Qty',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Price',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Amount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.line();

    for (int i = 0; i < placedOrder.length; i++) {
      double rate = placedOrder[i].price as double;
      double qty = placedOrder[i].orderedQuantity as double;
      double amt = rate * qty;
      await SunmiPrinter.printRow(cols: [
        SunmiColumn(
            text: '${placedOrder[i].orderedQuantity}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${placedOrder[i].price}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '$amt',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);

      await SunmiPrinter.printText(
          '${placedOrder[i].name} (TAX${placedOrder[i].taxCode}%)',
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
      for (int j = 0; j < placedOrder[i].attributes!.length; j++) {
        for (int k = 0; k < placedOrder[i].attributes![j].options.length; j++) {
          if (placedOrder[i].attributes![j].options![k].selected) {
            await SunmiPrinter.printText(
                '    ${placedOrder[i].attributes![j].options![k].name} (${placedOrder[i].attributes![j].options![k].price})',
                style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
          }
        }
      }
    }

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Subtotal',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${order_amount.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'VAT',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${vat.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Discount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${discount.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Delivery Charges',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${discount.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.line();
    await SunmiPrinter.printText(
        'BHD ${order_amount.toStringAsFixed(3).toString()}',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.RIGHT));
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Thank you',
          width: 3,
          style: SunmiTextStyle(
            align: SunmiPrintAlign.CENTER,
            bold: true,
            reverse: true,
          )),
      SunmiColumn(
          text: 'Visit Again',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
    ]);

    // if (kDebugMode) {
    print(SunmiPrinter);
    // }

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.cutPaper();
    await SunmiPrinter.exitTransactionPrint(true);

    return true;
  }*/
  Future<bool> printProductionInternalSunmiInvoice(
    BuildContext context,
    List<OrderItem> placedOrder,
    order_amount,
    vat,
    discount,
    delivery,
    ord_no,
    branch_name,
    address1,
    address2,
    address3,
    phoneNo,
    vatNo,
    crno,
    tableNo,
    server,
  )
  async {
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);

    // ---------- Logging Helpers ----------
    StringBuffer logBuffer = StringBuffer();

    void logLine(String line) {
      logBuffer.writeln(line);
      debugPrint("[RECEIPT] $line");
    }

    Future<void> safePrintText(String text, {SunmiTextStyle? style}) async {
      try {
        await SunmiPrinter.printText(text, style: style);
        logLine(text);
      } catch (e) {
        // logLine("PRINT FAILED: $text (Error: $e)");
        logLine("PRINT FAILED: $text");
      }
    }

    Future<void> safePrintRow(List<SunmiColumn> cols) async {
      try {
        await SunmiPrinter.printRow(cols: cols);
        logLine(cols.map((c) => c.text).join(" | "));
      } catch (e) {
        // logLine("PRINT ROW FAILED: ${cols.map((c) => c.text).join(" | ")} (Error: $e)");
        logLine("PRINT ROW FAILED: ${cols.map((c) => c.text).join(" | ")}");
      }
    }

    // ---------- Init Printer ----------
    bool printerOk = true;
    try {
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);
    } catch (e) {
      printerOk = false;
      logLine("⚠️ Printer init failed: $e");
    }

    // ---------- HEADER ----------
    await safePrintText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await safePrintText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText('$address3 $phoneNo CR No: $crno',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await safePrintText('VAT: $vatNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await safePrintRow([
      SunmiColumn(
        text: 'Date:$transactionDate',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT),
      ),
      SunmiColumn(
        text: 'Time:$transactionTime',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.RIGHT),
      ),
    ]);

    await safePrintText('--------------------------------------------');
    await safePrintText('TAX INVOICE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await safePrintText('Order No: ${ord_no}');
    await safePrintText('Table No: ${tableNo}');
    await safePrintText('Server: ${server}');
    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Qty',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Price',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Amount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintText('--------------------------------------------');

    // ---------- ITEMS ----------
    for (int i = 0; i < placedOrder.length; i++) {
      double rate = placedOrder[i].price as double;
      double qty = placedOrder[i].orderedQuantity as double;
      double amt = rate * qty;

      await safePrintRow([
        SunmiColumn(
            text: '$qty',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '$rate',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '$amt',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);

      await safePrintText(
          '${placedOrder[i].name} (TAX${placedOrder[i].taxCode}%)',
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));

      if (placedOrder[i].attributes != null) {
        for (var attr in placedOrder[i].attributes!) {
          for (var opt in attr.options) {
            if (opt.selected) {
              await safePrintText("    ${opt.name} (${opt.price})",
                  style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
            }
          }
        }
      }
    }

    await safePrintText('--------------------------------------------');

    // ---------- TOTALS ----------
    await safePrintRow([
      SunmiColumn(
          text: 'Subtotal',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${order_amount.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'VAT',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${vat.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Discount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${discount.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Delivery Charges',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${delivery.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');
    await safePrintText("BHD ${order_amount.toStringAsFixed(3)}",
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.RIGHT));

    await safePrintRow([
      SunmiColumn(
          text: 'Thank you',
          width: 3,
          style: SunmiTextStyle(
              align: SunmiPrintAlign.CENTER, bold: true, reverse: true)),
      SunmiColumn(
          text: 'Visit Again',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
    ]);

    // ---------- Finalize ----------
    if (printerOk) {
      try {
        await SunmiPrinter.cutPaper();
        await SunmiPrinter.exitTransactionPrint(true);
      } catch (e) {
        logLine("⚠️ Cut/Exit failed: $e");
      }
    }

    // dump full receipt in logs
    // debugPrint("===== RECEIPT START =====\n${logBuffer.toString()}===== RECEIPT END =====");

    // dump full receipt in logs + save for UI
    ReceiptLogger.lastReceiptLog = logBuffer.toString();
    debugPrint(
        "===== RECEIPT START =====\n${logBuffer.toString()}===== RECEIPT END =====");

    return true;
  }

  Future<bool> printProductionIPInvoice(
      BuildContext context,
      String printerIp,
      List<TbDirectOrderDet> placedOrder,
      order_amount,
      vat,
      discount,
      ord_no,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);
    // Title
    bytes.addAll(generator.text(
        "RUE", //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size3, bold: true)));
    bytes.addAll(generator.text('RUE CATERING BOUTIQUE W.L.L',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(branch_name, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address1, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address2, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text(address3 + " " + phoneNo + " " + "CR No: $crno",
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text('VAT: $vatNo',
        styles: PosStyles(align: PosAlign.center)));
    // Date and Time
    bytes.addAll(
        generator.text('Date:$transactionDate   Time: $transactionTime'));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text("TAX INVOICE",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size1, bold: true)));
    // Order Type
    bytes.addAll(generator.feed(2));
    // bytes.addAll(generator.text(placedOrder.orderType == 1 ? "Dine In" : "Parcel",
    //     styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2)));
    // bytes.addAll(generator.feed(1));

    // Order Info
    bytes.addAll(generator.text('Order No : $ord_no'));
    // bytes.addAll(generator.text('Table  : Table 1'));
    bytes.addAll(generator.text('Table : $tableNo'));
    bytes.addAll(generator.text('Server : $server'));
    bytes.addAll(generator.feed(2));

    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    // Table Headers
    bytes.addAll(generator.row([
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Price', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'Amount', width: 4, styles: PosStyles(bold: true)),
    ]));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    // Items
    for (int i = 0; i < placedOrder.length; i++) {
      double rate = placedOrder[i].rate as double;
      double qty = placedOrder[i].qty as double;
      double amt = rate * qty;
      bytes.addAll(generator.row([
        PosColumn(text: '${placedOrder[i].qty}', width: 2),
        PosColumn(text: '${placedOrder[i].rate}', width: 6),
        PosColumn(text: '${amt}', width: 4),
      ]));
      bytes.addAll(generator
          .text('${placedOrder[i].name}(TAX${placedOrder[i].taxPercentage}%'));
      for (int a = 0; a < placedOrder[i].tbDirectOrderTopping!.length; a++) {
        // for (int o = 0; o < placedOrder[i].tbDirectOrderTopping[a].options.length; o++) {
        if (placedOrder[i].tbDirectOrderTopping![a].checked!) {
          bytes.addAll(generator.text(
              '   ${placedOrder[i].tbDirectOrderTopping![a].name} x${placedOrder[i].tbDirectOrderTopping![a].qty} (${placedOrder[i].tbDirectOrderTopping![a].rate})'));
        }
      }
    }

    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Subtotal', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${order_amount.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'VAT', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${vat.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Discount', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${discount.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text(
        "BHD ${order_amount.toStringAsFixed(3).toString()}",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.right, height: PosTextSize.size1, bold: true)));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    // bytes.addAll(generator.row([
    //   PosColumn(
    //       text: 'Card', width: 6, styles: PosStyles(align: PosAlign.left)),
    //   PosColumn(
    //       text: '8.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    // ]));
    // Ticket Number
    bytes.addAll(generator.text('Thank you Visit again',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            bold: true,
            reverse: true)));
    // )));

    // bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    // Call this function
    printBytesAsAscii(bytes);

    // Send data to printer
    try {
      final socket = await Socket.connect(printerIp, 9100);
      socket.add(bytes);
      bytes.clear();
      await socket.flush();
      socket.destroy();
      print("✅ Print success!");
      return true;
    } catch (e) {
      print("❌ Print failed: $e");
      return false;
    }
  }

  Future<bool> printProductionDuplicateInternalSunmiInvoice(
      BuildContext context,
      List<OrderDtl>? placedOrder,
      order_amount,
      vat,
      discount,
      delivery,
      ord_no,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server)
  /*async {
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);
    log('Formatted Transaction Date :: $transactionDate');
    log('Formatted Transaction Time :: $transactionTime');
    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('$address3 $phoneNo CR No: $crno',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('VAT: $vatNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printText('',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Date:$transactionDate  Time:$transactionTime',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('TAX INVOICE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('Order No: ${ord_no}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Table No: ${tableNo}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Server: ${server}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printText('',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Qty',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Price',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Amount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    for (int i = 0; i < placedOrder!.length; i++) {
      await SunmiPrinter.printRow(cols: [
        SunmiColumn(
            text: '${placedOrder[i].qty}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${placedOrder[i].rate}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '${placedOrder[i].total}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);

      await SunmiPrinter.printText(
          '${placedOrder[i].description} (TAX${placedOrder[i].taxPer}%)',
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
      for (int j = 0; j < placedOrder[i]!.tbDirectOrderTopping!.length; j++) {
        if (placedOrder[i]!.tbDirectOrderTopping![j].status!) {
          await SunmiPrinter.printText(
              '    ${placedOrder[i].tbDirectOrderTopping![j].name}(${placedOrder[i].tbDirectOrderTopping![j].rate})',
              style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
        }
      }
    }

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Subtotal',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${order_amount.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'VAT',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${vat.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Discount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${discount.toStringAsFixed(3).toString()}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(
        'BHD ${order_amount.toStringAsFixed(3).toString()}',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.RIGHT));

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Thank you',
          width: 3,
          style: SunmiTextStyle(
            align: SunmiPrintAlign.CENTER,
            bold: true,
            reverse: true,
          )),
      SunmiColumn(
          text: 'Visit Again',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
    ]);
    await SunmiPrinter.printText('Duplicate Bill',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.cutPaper();
    await SunmiPrinter.exitTransactionPrint(true);
    print(await SunmiPrinter);

    return true;
  }*/
  async {
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);

    // ---------- Logging Helpers ----------
    StringBuffer logBuffer = StringBuffer();

    void logLine(String line) {
      logBuffer.writeln(line);
      debugPrint("[RECEIPT] $line");
    }

    Future<void> safePrintText(String text, {SunmiTextStyle? style}) async {
      try {
        await SunmiPrinter.printText(text, style: style);
        logLine(text);
      } catch (e) {
        // logLine("PRINT FAILED: $text (Error: $e)");
        logLine("PRINT FAILED: $text");
      }
    }

    Future<void> safePrintRow(List<SunmiColumn> cols) async {
      try {
        await SunmiPrinter.printRow(cols: cols);
        logLine(cols.map((c) => c.text).join(" | "));
      } catch (e) {
        // logLine("PRINT ROW FAILED: ${cols.map((c) => c.text).join(" | ")} (Error: $e)");
        logLine("PRINT ROW FAILED: ${cols.map((c) => c.text).join(" | ")}");
      }
    }

    // ---------- Init Printer ----------
    bool printerOk = true;
    try {
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);
    } catch (e) {
      printerOk = false;
      logLine("⚠️ Printer init failed: $e");
    }

    // ---------- HEADER ----------
    await safePrintText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await safePrintText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText('$address3 $phoneNo CR No: $crno',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await safePrintText('VAT: $vatNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await safePrintRow([
      SunmiColumn(
        text: 'Date:$transactionDate',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT),
      ),
      SunmiColumn(
        text: 'Time:$transactionTime',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.RIGHT),
      ),
    ]);

    await safePrintText('--------------------------------------------');
    await safePrintText('TAX INVOICE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await safePrintText('Order No: ${ord_no}');
    await safePrintText('Table No: ${tableNo}');
    await safePrintText('Server: ${server}');
    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Qty',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Price',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Amount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintText('--------------------------------------------');

    // ---------- ITEMS ----------
    for (int i = 0; i < placedOrder!.length; i++) {
      double rate = placedOrder![i].rate as double;
      double qty = placedOrder![i].qty as double;
      double amt = rate * qty;

      await safePrintRow([
        SunmiColumn(
            text: '$qty',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '$rate',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '$amt',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);

      await safePrintText(
          '${placedOrder[i].description} (TAX${placedOrder![i].taxPer}%)',
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));

      if (placedOrder[i].tbDirectOrderTopping != null) {
        for (var attr in placedOrder[i].tbDirectOrderTopping!) {
          // for (var opt in attr.) {
            if (attr.status!) {
              await safePrintText("    ${attr.name} (${attr.rate})",
                  style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
            }
          // }
        }
      }
    }

    await safePrintText('--------------------------------------------');

    // ---------- TOTALS ----------
    await safePrintRow([
      SunmiColumn(
          text: 'Subtotal',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${order_amount.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'VAT',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${vat.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Discount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${discount.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Delivery Charges',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'BHD ${delivery.toStringAsFixed(3)}',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');
    await safePrintText("BHD ${order_amount.toStringAsFixed(3)}",
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.RIGHT));

    await safePrintRow([
      SunmiColumn(
          text: 'Thank you',
          width: 3,
          style: SunmiTextStyle(
              align: SunmiPrintAlign.CENTER, bold: true, reverse: true)),
      SunmiColumn(
          text: 'Visit Again',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
    ]);

    await safePrintRow([
      SunmiColumn(
          text: 'Duplicate Bill',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
    ]);

    // ---------- Finalize ----------
    if (printerOk) {
      try {
        await SunmiPrinter.cutPaper();
        await SunmiPrinter.exitTransactionPrint(true);
      } catch (e) {
        // logLine("⚠️ Cut/Exit failed: $e");
      }
    }

    // dump full receipt in logs
    // debugPrint("===== RECEIPT START =====\n${logBuffer.toString()}===== RECEIPT END =====");

    // dump full receipt in logs + save for UI
    ReceiptLogger.lastReceiptLog = logBuffer.toString();
    debugPrint(
        "===== RECEIPT START =====\n${logBuffer.toString()}===== RECEIPT END =====");

    return true;
  }

  Future<bool> printProductionIPDuplicateInvoice(
      BuildContext context,
      String printerIp,
      List<OrderDtl>? placedOrder,
      order_amount,
      vat,
      discount,
      ord_no,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);
    // Title
    bytes.addAll(generator.text(
        "RUE", //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size3, bold: true)));
    bytes.addAll(generator.text('RUE CATERING BOUTIQUE W.L.L',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(branch_name, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address1, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address2, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text(address3 + " " + phoneNo,
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text('CR No: $crno',
        styles: PosStyles(align: PosAlign.center)));
    // Date and Time
    bytes.addAll(
        generator.text('Date:$transactionDate   Time: $transactionTime'));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text("TAX INVOICE",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size1, bold: true)));
    // Order Type
    bytes.addAll(generator.feed(1));
    // bytes.addAll(generator.text(placedOrder.orderType == 1 ? "Dine In" : "Parcel",
    //     styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2)));
    // bytes.addAll(generator.feed(1));

    // Order Info
    bytes.addAll(generator.text('Order No : $ord_no'));
    // bytes.addAll(generator.text('Table  : Table 1'));
    bytes.addAll(generator.text('Table : $tableNo'));
    bytes.addAll(generator.text('Server : $server'));
    bytes.addAll(generator.feed(1));

    // Table Headers
    bytes.addAll(generator.row([
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Price', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'Amount', width: 4, styles: PosStyles(bold: true)),
    ]));
    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    // Items
    for (int i = 0; i < placedOrder!.length; i++) {
      bytes.addAll(generator.row([
        PosColumn(text: '${placedOrder[i].qty}', width: 2),
        PosColumn(text: '${placedOrder[i].rate}', width: 6),
        PosColumn(text: '${placedOrder[i].total}', width: 4),
      ]));
      bytes.addAll(generator
          .text('${placedOrder[i].description}(TAX${placedOrder[i].taxPer}%'));
      for (int a = 0; a < placedOrder[i].tbDirectOrderTopping!.length; a++) {
        // for (int o = 0; o < placedOrder[i].tbDirectOrderTopping![a].length; o++) {
        if (placedOrder[i].tbDirectOrderTopping![a].status!) {
          bytes.addAll(generator.text(
              '   ${placedOrder[i].tbDirectOrderTopping![a].name}(${placedOrder[i].tbDirectOrderTopping![a].rate})'));
        }
        // }
      }
    }

    bytes.addAll(generator.text(
        '-----------------------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Subtotal', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${order_amount.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'VAT', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${vat.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Discount', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${discount.toStringAsFixed(3).toString()}',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(
        generator.text('-----------------------------------------------'));
    bytes.addAll(generator.text("BHD $order_amount",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.right, height: PosTextSize.size1, bold: true)));
    bytes.addAll(
        generator.text('-----------------------------------------------'));
    // bytes.addAll(generator.row([
    //   PosColumn(
    //       text: 'Card', width: 6, styles: PosStyles(align: PosAlign.left)),
    //   PosColumn(
    //       text: '8.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    // ]));
    // Ticket Number
    bytes.addAll(generator.text('Thank you Visit again',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            bold: true,
            reverse: true)));

    bytes.addAll(generator.text('Duplicate Bill',
        styles: PosStyles(align: PosAlign.center)));

    // bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    // Call this function
    printBytesAsAscii(bytes);
    // Send data to printer
    try {
      final socket = await Socket.connect(printerIp, 9100);
      socket.add(bytes);
      bytes.clear();
      await socket.flush();
      socket.destroy();
      print("✅ Print success!");
      return true;
    } catch (e) {
      print("❌ Print failed: $e");
      return false;
    }
  }

/*  Future<bool> printInternalSaleReport(
      BuildContext context,
      Closeday closeday,
      user_name,
      counter_name,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno) async {
    var now = DateTime.now();
    var transactionDate = DateFormat('dd-MM-yyyy').format(now);
    var transactionTime = DateFormat('HH:mm a').format(now);
    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('$address3 $phoneNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('Date:$transactionDate  Time:$transactionTime',
    //     style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
        text: 'Date:$transactionDate',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT),
      ),
      SunmiColumn(
        text: 'Time:$transactionTime',
        width: 6,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.RIGHT),
      ),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('User: $user_name',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Branch: $branch_name',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Counter: $counter_name',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('Cash Breakdown',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    // for (int i = 0; i < closeday.cashFlowSummary!.length; i++) {
    final denominations = [
      "20",
      "10",
      "5",
      "1",
      "0.500",
      "0.100",
      "0.50",
      "0.25",
      "0.10",
      "0.5"
    ];

    // your API values (make sure they match the order of denominations)
    final apiValues = [
      closeday.cashFlowSummary![1].bd20 ?? 0.0,
      closeday.cashFlowSummary![1].bd10 ?? 0.0,
      closeday.cashFlowSummary![1].bd5 ?? 0.0,
      closeday.cashFlowSummary![1].bd1 ?? 0.0,
      closeday.cashFlowSummary![1].fils500 ?? 0.0,
      closeday.cashFlowSummary![1].fils100 ?? 0.0,
      closeday.cashFlowSummary![1].fils50 ?? 0.0,
      closeday.cashFlowSummary![1].fils25 ?? 0.0,
      closeday.cashFlowSummary![1].fils10 ?? 0.0,
      closeday.cashFlowSummary![1].fils5 ?? 0.0,
    ];

    for (int i = 0; i < denominations.length; i++) {
      await SunmiPrinter.printRow(cols: [
        SunmiColumn(
          text: denominations[i],
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT),
        ),
        SunmiColumn(
          text: 'X',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER),
        ),
        SunmiColumn(
          text: apiValues[i].toString(),
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT),
        ),
      ]);
    }

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Total Amount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '0.000',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Opening Balance',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.opBal}',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Added Cash',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.addCash}',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Cash Sales',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cashSales}',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Shortage Amount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.excessShortage}',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('  ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('Sales Report',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Description',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Cash Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cashSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.cashSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Card Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cardSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.cardSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Benefit Pay',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.benifitPaySalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.benifitPaySales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Delivery Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliveryServiceCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliveryServiceSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Discount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.discountAmount}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'NET SALES',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.posSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Description',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Pickup Orders',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.pickupSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.pickupSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Delivery Orders',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliverySalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliverySales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Dine-in Orders',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.dineinSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.dineinSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: '',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.posSalesCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.posSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.printText('',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('Delivery Sales',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Description',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    for (int i = 0; i < closeday.deliveryService!.length; i++) {
      await SunmiPrinter.printRow(cols: [
        SunmiColumn(
            text: closeday.deliveryService![i].name,
            width: 10,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${closeday.deliveryService![i].cnt}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '${closeday.deliveryService![i].amount}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);
    }
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: '',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliveryServiceCnt}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliveryServiceSales}',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('Itemized Sales',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'DESCRIPTION',
          width: 10,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'QTY',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'VALUE',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    for (int i = 0; i < closeday.itemWiseSales!.length; i++) {
      await SunmiPrinter.printRow(cols: [
        SunmiColumn(
            text: closeday.itemWiseSales![i].product,
            width: 10,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${closeday.itemWiseSales![i].qty}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '${closeday.itemWiseSales![i].amount}',
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);
    }
    await SunmiPrinter.printText('--------------------------------------------',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    SunmiColumn(
        text: 'GRAND TOTAL',
        width: 6,
        style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
    SunmiColumn(
        text: '',
        width: 6,
        style: SunmiTextStyle(align: SunmiPrintAlign.CENTER));
    SunmiColumn(
        text: '${closeday.posSales}',
        width: 6,
        style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT));

    await SunmiPrinter.printText(' ',
        style: SunmiTextStyle(fontSize: 40, align: SunmiPrintAlign.CENTER));

    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.cutPaper();
    await SunmiPrinter.exitTransactionPrint(true);
    print(await SunmiPrinter);

    return true;
  }*/

  Future<bool> printInternalSaleReport(
    BuildContext context,
    Closeday closeday,
    user_name,
    counter_name,
    branch_name,
    address1,
    address2,
    address3,
    phoneNo,
    vatNo,
    crno,
  ) async {
    final logBuffer = StringBuffer();

    void logLine(String line) {
      logBuffer.writeln(line);
      // debugPrint("[REPORT] $line");
    }

    Future<void> safePrintText(String text, {SunmiTextStyle? style}) async {
      try {
        await SunmiPrinter.printText(text, style: style);
      } catch (e) {
        // debugPrint("PrintText failed: $e (text: $text)");
      }
      logLine(text);
    }

    Future<void> safePrintRow(List<SunmiColumn> cols) async {
      try {
        await SunmiPrinter.printRow(cols: cols);
      } catch (e) {
        // debugPrint(
        //     "PrintRow failed: $e (cols: ${cols.map((c) => c.text).join(" | ")})");
      }
      logLine(cols.map((c) => c.text).join(" | "));
    }

    // try {
    // final bound = await SunmiPrinter.bindingPrinter();
    // if (!bound!) {
    //   debugPrint('Sunmi printer not bound.');
    //   return false;
    // }

    bool printerOk = true;
    try {
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);
    } catch (e) {
      printerOk = false;
      // logLine("⚠️ Printer init failed: $e");
    }

    final now = DateTime.now();
    final transactionDate = DateFormat('dd-MM-yyyy').format(now);
    final transactionTime = DateFormat('hh:mm a').format(now);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await safePrintText('RUE',
        style: SunmiTextStyle(
            fontSize: 55, bold: true, align: SunmiPrintAlign.CENTER));
    await safePrintText('RUE CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await safePrintText('$address3 $phoneNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));

    await safePrintText(' ');

    await safePrintRow([
      SunmiColumn(
          text: 'Date:$transactionDate',
          width: 6,
          style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Time:$transactionTime',
          width: 6,
          style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintText('User: $user_name');
    await safePrintText('Branch: $branch_name');
    await safePrintText('Counter: $counter_name');

    await safePrintText('--------------------------------------------');
    await safePrintText('Cash Breakdown',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    final denominations = [
      "20",
      "10",
      "5",
      "1",
      "0.500",
      "0.100",
      "0.50",
      "0.25",
      "0.10",
      "0.5"
    ];
    final apiValues = [
      closeday.cashFlowSummary![1].bd20 ?? 0.0,
      closeday.cashFlowSummary![1].bd10 ?? 0.0,
      closeday.cashFlowSummary![1].bd5 ?? 0.0,
      closeday.cashFlowSummary![1].bd1 ?? 0.0,
      closeday.cashFlowSummary![1].fils500 ?? 0.0,
      closeday.cashFlowSummary![1].fils100 ?? 0.0,
      closeday.cashFlowSummary![1].fils50 ?? 0.0,
      closeday.cashFlowSummary![1].fils25 ?? 0.0,
      closeday.cashFlowSummary![1].fils10 ?? 0.0,
      closeday.cashFlowSummary![1].fils5 ?? 0.0,
    ];

    for (int i = 0; i < denominations.length; i++) {
      await safePrintRow([
        SunmiColumn(
            text: denominations[i],
            width: 4,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: 'X',
            width: 2,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: apiValues[i].toString(),
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);
    }

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Total Amount',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cashFlowSummary![1].transAmount!}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Opening Balance',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.opBal}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Added Cash',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.addCash}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Cash Sales',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cashSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Shortage Amount',
          width: 8,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.excessShortage}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText(' ');

    await safePrintText('Sales Report',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Description',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Cash Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cashSalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.cashSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Card Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.cardSalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.cardSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Benefit Pay',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.benifitPaySalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.benifitPaySales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Delivery Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliveryServiceCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliveryServiceSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Discount',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.discountAmount}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'NET SALES',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.posSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintText(' ');

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Description',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Pickup Orders',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.pickupSalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.pickupSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Delivery Orders',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliverySalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliverySales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await safePrintRow([
      SunmiColumn(
          text: 'Dine-in Orders',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.dineinSalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.dineinSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: '',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.posSalesCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.posSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText(' ');

    await safePrintText('Delivery Sales',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'Description',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Bills',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Sales',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    for (int i = 0; i < closeday.deliveryService!.length; i++) {
      await safePrintRow([
        SunmiColumn(
            text: closeday.deliveryService![i].name,
            width: 4,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${closeday.deliveryService![i].cnt}',
            width: 4,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '${closeday.deliveryService![i].amount}',
            width: 4,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);
    }

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: '',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '${closeday.deliveryServiceCnt}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.deliveryServiceSales}',
          width: 4,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText(' ');
    await safePrintText('Itemized Sales',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'DESCRIPTION',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'QTY',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'VALUE',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await safePrintText('--------------------------------------------');

    for (int i = 0; i < closeday.itemWiseSales!.length; i++) {
      await safePrintRow([
        SunmiColumn(
            text: closeday.itemWiseSales![i].product,
            width: 6,
            style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
        SunmiColumn(
            text: '${closeday.itemWiseSales![i].qty}',
            width: 3,
            style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
        SunmiColumn(
            text: '${closeday.itemWiseSales![i].amount}',
            width: 3,
            style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
      ]);
    }

    await safePrintText('--------------------------------------------');

    await safePrintRow([
      SunmiColumn(
          text: 'GRAND TOTAL',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT, bold: true)),
      SunmiColumn(
          text: '',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '${closeday.posSales}',
          width: 3,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT, bold: true)),
    ]);

    await safePrintText(' ');
    // await SunmiPrinter.lineWrap(2);
    // await SunmiPrinter.cutPaper();
    // await SunmiPrinter.exitTransactionPrint(true);

    // ---------- Finalize ----------
    if (printerOk) {
      try {
        await SunmiPrinter.lineWrap(2);
        await SunmiPrinter.cutPaper();
        await SunmiPrinter.exitTransactionPrint(true);
      } catch (e) {
        logLine("⚠️ Cut/Exit failed: $e");
      }
    }

    ReceiptLogger.lastReceiptLog = logBuffer.toString();
    debugPrint(
        "===== REPORT START =====\n${logBuffer.toString()}===== REPORT END =====");
    // } catch (e, st) {
    //   // debugPrint('printInternalSaleReport error: $e');
    // }
    return true;
  }

  /// must binding ur printer at first init in app
  Future<bool?> bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  ///Test Sunmi Receipt
  Future<bool> printTestInternalSunmiInvoice(
      BuildContext context,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server) async {
    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText('RUE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('CATERING BOUTIQUE W.L.L',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(branch_name,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address1,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(address2,
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('$address3 $phoneNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('TRN $vatNo',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Date:24-03-2025  Time:09:35 AM',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.line();
    await SunmiPrinter.printText('TAX INVOICE',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Order No: ORD-R2-244234423',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Table No: ${tableNo}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('Server: ${server}',
        style: SunmiTextStyle(fontSize: 25, align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.lineWrap(2);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Qty',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'Price',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: 'Amount',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);

    await SunmiPrinter.line();

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: '1',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '1.7',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER)),
      SunmiColumn(
          text: '3.8',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printText('Americano (TAX10%)',
        style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('    Cold(0.2)',
        style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));
    await SunmiPrinter.printText('    Decat(0.2)',
        style: SunmiTextStyle(align: SunmiPrintAlign.LEFT));

    await SunmiPrinter.line();
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Subtotal',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '9.000',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'VAT',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '9.000',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Discount',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '0',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.printText('BHD 9.000',
        style: SunmiTextStyle(
            fontSize: 35, bold: true, align: SunmiPrintAlign.RIGHT));
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Card',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: '8.3',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Card Number',
          width: 25,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
      SunmiColumn(
          text: 'xar',
          width: 5,
          style: SunmiTextStyle(align: SunmiPrintAlign.RIGHT)),
    ]);
    await SunmiPrinter.lineWrap(2);

    await SunmiPrinter.printRow(cols: [
      SunmiColumn(
          text: 'Thank you',
          width: 5,
          style: SunmiTextStyle(
            align: SunmiPrintAlign.LEFT,
            bold: true,
            reverse: true,
          )),
      SunmiColumn(
          text: 'Visit Again',
          width: 6,
          style: SunmiTextStyle(align: SunmiPrintAlign.LEFT)),
    ]);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.line();
    await SunmiPrinter.lineWrap(1);

    // await SunmiPrinter.cutPaper();
    await SunmiPrinter.cutPaper(); // SUBMIT and cut paper
    await SunmiPrinter.exitTransactionPrint(true);
    print(await SunmiPrinter);

    return true;
  }

  ///Helper method to print the invoice in PDF format and through printer device.
  Future<bool> printTestIPInvoice(
      BuildContext context,
      String printerIp,
      branch_name,
      address1,
      address2,
      address3,
      phoneNo,
      vatNo,
      crno,
      tableNo,
      server) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];

    // String dateTimeString = placedOrder.ordDate;
    //
    // DateTime dateTime = DateTime.parse(dateTimeString);
    //
    // // Format date as YYYY-MM-DD
    // String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    //
    // // Format time in 12-hour format with AM/PM
    // String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Title
    bytes.addAll(generator.text(
        "RUE", //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size1, bold: true)));
    bytes.addAll(generator.text('CATERING BOUTIQUE W.L.L',
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(branch_name, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address1, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(
        generator.text(address2, styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.text(address3 + " " + phoneNo,
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text('TRN $vatNo',
        styles: PosStyles(align: PosAlign.center)));
    // Date and Time
    bytes.addAll(generator.text('Date:24-03-2025   Time: 09:35 AM'));
    bytes.addAll(
        generator.text('-----------------------------------------------'));
    bytes.addAll(generator.text("TAX INVOICE",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.center, height: PosTextSize.size1, bold: true)));
    // Order Type
    bytes.addAll(generator.feed(1));
    // bytes.addAll(generator.text(placedOrder.orderType == 1 ? "Dine In" : "Parcel",
    //     styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2)));
    // bytes.addAll(generator.feed(1));

    // Order Info
    bytes.addAll(generator.text('Order No : ORD-R2-45345345'));
    // bytes.addAll(generator.text('Table  : Table 1'));
    bytes.addAll(generator.text('Table : $tableNo'));
    bytes.addAll(generator.text('Server : $server'));
    bytes.addAll(generator.feed(1));

    // Table Headers
    bytes.addAll(generator.row([
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Price', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'Amount', width: 4, styles: PosStyles(bold: true)),
    ]));
    bytes.addAll(
        generator.text('-----------------------------------------------'));

    // Items
    // for (int i = 0; i < placedOrder.tbOrdertoKitchenItem.length; i++) {
    bytes.addAll(generator.row([
      PosColumn(text: '1', width: 2),
      PosColumn(text: '1.7', width: 6),
      PosColumn(text: '1.7', width: 4),
    ]));
    bytes.addAll(generator.text('Americano(TAX10%'));
    bytes.addAll(generator.text('   Cold(0.2'));
    bytes.addAll(generator.text('   Decat(0.2'));
    // }

    bytes.addAll(
        generator.text('-----------------------------------------------'));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Subtotal', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '7.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'VAT', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '0.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Discount', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '0.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(
        generator.text('-----------------------------------------------'));
    bytes.addAll(generator.text("BHD 9.0",
        //Kitchen = KOT // Dispatch = Delivery Receipt // MainChef = KOT
        styles: PosStyles(
            align: PosAlign.right, height: PosTextSize.size1, bold: true)));
    bytes.addAll(
        generator.text('-----------------------------------------------'));
    bytes.addAll(generator.row([
      PosColumn(
          text: 'Card', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '8.000', width: 6, styles: PosStyles(align: PosAlign.right)),
    ]));
    // Ticket Number
    bytes.addAll(generator.text('Thank you Visit again',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            bold: true,
            reverse: true)));

    // bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    // Call this function
    printBytesAsAscii(bytes);
    // Send data to printer
    try {
      final socket = await Socket.connect(printerIp, 9100);
      socket.add(bytes);
      await socket.flush();
      socket.destroy();
      print("✅ Print success!");
      return true;
    } catch (e) {
      print("❌ Print failed: $e");
      return false;
    }
  }

  printBytesAsAscii(List<int> bytes) {
    String asciiString = bytes
        .map((b) => b >= 32 && b <= 126 ? String.fromCharCode(b) : '.\n')
        .join();
    print("ASCII Representation of Bytes:");
    print(asciiString);
  }
}

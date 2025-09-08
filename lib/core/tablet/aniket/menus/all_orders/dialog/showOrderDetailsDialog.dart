import 'package:flutter/material.dart';

import 'detail_current_orders_dialog.dart';

Future<dynamic> showOrderDetailsDialog(BuildContext context,
    {required String orderNo,
    required int orderId,
    required int status,
    required String customerName,
    required String orderType,
    required double subTotal,
    required double discount,
    required double tax,
    required double total,
    required double cash,
    required double due,
    required VoidCallback? onOrderCancelled}) {
  return showDialog(
    // <- yaha return add kar
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.50,
          child: DetailCurrentOrdersDialogContent(
            orderNo: orderNo,
            orderId: orderId,
            status: status,
            customerName: customerName,
            orderType: orderType,
            sub_total: subTotal,
            discount: discount,
            tax: tax,
            total: total,
            cash: cash,
            due: due,
            onOrderCancelled: onOrderCancelled,
          ),
        ),
      );
    },
  );
}

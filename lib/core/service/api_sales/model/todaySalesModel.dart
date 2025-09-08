class TodaySalesModel {
  final int? status;
  final String? result;
  final List<Sales>? sales;
  final double? cashSales;
  final double? ahlanCashSales;
  final double? ahlanCredit;
  final double? ahlanCardSales;
  final double? ahlanBenifitPaySales;
  final double? cashDeliverySales;
  final double? cardSales;
  final double? creditCardSales;
  final double? debitCardSales;
  final int? creditCardCnt;
  final int? debitCardCnt;
  final double? benifitSales;
  final double? deliveryBenifitSales;
  final int? cashCnt;
  final int? ahlanCashSalesCnt;
  final int? ahlanCreditSalesCnt;
  final int? ahlanCardSalesCnt;
  final int? ahlanBenifitPaySalesCnt;
  final int? cashDeliveryCnt;
  final int? cardCnt;
  final int? benifitCnt;
  final int? deliveryBenifitCnt;
  final double? totalSales;
  final double? cancelledSales;
  final int? cancelledCnt;
  final double? discountAmount;
  final int? discountCnt;
  final double? deliveryServiceSales;
  final int? deliveryServiceCnt;
  final List<DeliveryService>? deliveryService; // ✅ added

  TodaySalesModel({
    this.status,
    this.result,
    this.sales,
    this.cashSales,
    this.ahlanCashSales,
    this.ahlanCredit,
    this.ahlanCardSales,
    this.ahlanBenifitPaySales,
    this.cashDeliverySales,
    this.cardSales,
    this.creditCardSales,
    this.debitCardSales,
    this.creditCardCnt,
    this.debitCardCnt,
    this.benifitSales,
    this.deliveryBenifitSales,
    this.cashCnt,
    this.ahlanCashSalesCnt,
    this.ahlanCreditSalesCnt,
    this.ahlanCardSalesCnt,
    this.ahlanBenifitPaySalesCnt,
    this.cashDeliveryCnt,
    this.cardCnt,
    this.benifitCnt,
    this.deliveryBenifitCnt,
    this.totalSales,
    this.cancelledSales,
    this.cancelledCnt,
    this.discountAmount,
    this.discountCnt,
    this.deliveryServiceSales,
    this.deliveryServiceCnt,
    this.deliveryService,
  });

  factory TodaySalesModel.fromJson(Map<String, dynamic> json) {
    return TodaySalesModel(
      status: json['Status'],
      result: json['Result'],
      sales: (json['Sales'] as List<dynamic>?)
          ?.map((v) => Sales.fromJson(v))
          .toList(),
      cashSales: (json['CashSales'] ?? 0).toDouble(),
      ahlanCashSales: (json['AhlanCashSales'] ?? 0).toDouble(),
      ahlanCredit: (json['AhlanCredit'] ?? 0).toDouble(),
      ahlanCardSales: (json['AhlanCardSales'] ?? 0).toDouble(),
      ahlanBenifitPaySales: (json['AhlanBenifitPaySales'] ?? 0).toDouble(),
      cashDeliverySales: (json['CashDeliverySales'] ?? 0).toDouble(),
      cardSales: (json['CardSales'] ?? 0).toDouble(),
      creditCardSales: (json['CreditCardSales'] ?? 0).toDouble(),
      debitCardSales: (json['DebitCardSales'] ?? 0).toDouble(),
      creditCardCnt: json['CreditCardCnt'],
      debitCardCnt: json['DebitCardCnt'],
      benifitSales: (json['BenifitSales'] ?? 0).toDouble(),
      deliveryBenifitSales: (json['DeliveryBenifitSales'] ?? 0).toDouble(),
      cashCnt: json['CashCnt'],
      ahlanCashSalesCnt: json['AhlanCashSalesCnt'],
      ahlanCreditSalesCnt: json['AhlanCreditSalesCnt'],
      ahlanCardSalesCnt: json['AhlanCardSalesCnt'],
      ahlanBenifitPaySalesCnt: json['AhlanBenifitPaySalesCnt'],
      cashDeliveryCnt: json['CashDeliveryCnt'],
      cardCnt: json['CardCnt'],
      benifitCnt: json['BenifitCnt'],
      deliveryBenifitCnt: json['DeliveryBenifitCnt'],
      totalSales: (json['TotalSales'] ?? 0).toDouble(),
      cancelledSales: (json['CancelledSales'] ?? 0).toDouble(),
      cancelledCnt: json['CancelledCnt'],
      discountAmount: (json['DiscountAmount'] ?? 0).toDouble(),
      discountCnt: json['DiscountCnt'],
      deliveryServiceSales: (json['DeliveryServiceSales'] ?? 0).toDouble(),
      deliveryServiceCnt: json['DeliveryServiceCnt'],
      deliveryService: (json['DeliverySevice'] as List<dynamic>?) // ✅ fixed
          ?.map((e) => DeliveryService.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Result': result,
      'Sales': sales?.map((v) => v.toJson()).toList(),
      'CashSales': cashSales,
      'AhlanCashSales': ahlanCashSales,
      'AhlanCredit': ahlanCredit,
      'AhlanCardSales': ahlanCardSales,
      'AhlanBenifitPaySales': ahlanBenifitPaySales,
      'CashDeliverySales': cashDeliverySales,
      'CardSales': cardSales,
      'CreditCardSales': creditCardSales,
      'DebitCardSales': debitCardSales,
      'CreditCardCnt': creditCardCnt,
      'DebitCardCnt': debitCardCnt,
      'BenifitSales': benifitSales,
      'DeliveryBenifitSales': deliveryBenifitSales,
      'CashCnt': cashCnt,
      'AhlanCashSalesCnt': ahlanCashSalesCnt,
      'AhlanCreditSalesCnt': ahlanCreditSalesCnt,
      'AhlanCardSalesCnt': ahlanCardSalesCnt,
      'AhlanBenifitPaySalesCnt': ahlanBenifitPaySalesCnt,
      'CashDeliveryCnt': cashDeliveryCnt,
      'CardCnt': cardCnt,
      'BenifitCnt': benifitCnt,
      'DeliveryBenifitCnt': deliveryBenifitCnt,
      'TotalSales': totalSales,
      'CancelledSales': cancelledSales,
      'CancelledCnt': cancelledCnt,
      'DiscountAmount': discountAmount,
      'DiscountCnt': discountCnt,
      'DeliveryServiceSales': deliveryServiceSales,
      'DeliveryServiceCnt': deliveryServiceCnt,
      'DeliverySevice': deliveryService?.map((e) => e.toJson()).toList(),
    };
  }
}

class Sales {
  final int? salId;
  final String? salNo;
  final String? salDate;
  final String? salTime;
  final String? client;
  final int? deliveryType;
  final String? orderTypeText;
  final String? deliveryService;
  final double? qty;
  final double? subTotal;
  final double? cancelledAmt;
  final double? discAmount;
  final double? taxAmount;
  final double? netAmount;
  final String? modeOfPay;
  final String? modeOfPay1;
  final String? modeOfPay2;
  final double? payAmount;
  final double? payAmount1;
  final double? payAmount2;
  final double? payAmount3;
  final String? payStatus;
  final int? status;
  final String? statusText;
  final String? remarks;
  final String? ahlanOrder;

  Sales({
    this.salId,
    this.salNo,
    this.salDate,
    this.salTime,
    this.client,
    this.deliveryType,
    this.orderTypeText,
    this.deliveryService,
    this.qty,
    this.subTotal,
    this.cancelledAmt,
    this.discAmount,
    this.taxAmount,
    this.netAmount,
    this.modeOfPay,
    this.modeOfPay1,
    this.modeOfPay2,
    this.payAmount,
    this.payAmount1,
    this.payAmount2,
    this.payAmount3,
    this.payStatus,
    this.status,
    this.statusText,
    this.remarks,
    this.ahlanOrder,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      salId: json['SalId'],
      salNo: json['SalNo'],
      salDate: json['SalDate'],
      salTime: json['SalTime'],
      client: json['Client'],
      deliveryType: json['DeliveryType'],
      orderTypeText: json['OrderTypeText'],
      deliveryService: json['DeliveryService'],
      qty: (json['Qty'] ?? 0).toDouble(),
      subTotal: (json['SubTotal'] ?? 0).toDouble(),
      cancelledAmt: (json['CancelledAmt'] ?? 0).toDouble(),
      discAmount: (json['DiscAmount'] ?? 0).toDouble(),
      taxAmount: (json['TaxAmount'] ?? 0).toDouble(),
      netAmount: (json['NetAmount'] ?? 0).toDouble(),
      modeOfPay: json['ModeOfPay'],
      modeOfPay1: json['ModeOfPay1'],
      modeOfPay2: json['ModeOfPay2'],
      payAmount: (json['PayAmount'] ?? 0).toDouble(),
      payAmount1: (json['PayAmount1'] ?? 0).toDouble(),
      payAmount2: (json['PayAmount2'] ?? 0).toDouble(),
      payAmount3: (json['PayAmount3'] ?? 0).toDouble(),
      payStatus: json['PayStatus'],
      status: json['Status'],
      statusText: json['StatusText'],
      remarks: json['Remarks'],
      ahlanOrder: json['AhlanOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SalId': salId,
      'SalNo': salNo,
      'SalDate': salDate,
      'SalTime': salTime,
      'Client': client,
      'DeliveryType': deliveryType,
      'OrderTypeText': orderTypeText,
      'DeliveryService': deliveryService,
      'Qty': qty,
      'SubTotal': subTotal,
      'CancelledAmt': cancelledAmt,
      'DiscAmount': discAmount,
      'TaxAmount': taxAmount,
      'NetAmount': netAmount,
      'ModeOfPay': modeOfPay,
      'ModeOfPay1': modeOfPay1,
      'ModeOfPay2': modeOfPay2,
      'PayAmount': payAmount,
      'PayAmount1': payAmount1,
      'PayAmount2': payAmount2,
      'PayAmount3': payAmount3,
      'PayStatus': payStatus,
      'Status': status,
      'StatusText': statusText,
      'Remarks': remarks,
      'AhlanOrder': ahlanOrder,
    };
  }
}

class DeliveryService {
  final int? id;
  final String? name;
  final String? image;
  final int? cnt;
  final double? amount;

  DeliveryService({
    this.id,
    this.name,
    this.image,
    this.cnt,
    this.amount,
  });

  factory DeliveryService.fromJson(Map<String, dynamic> json) {
    return DeliveryService(
      id: json['id'],
      name: json['Name'],
      image: json['Image'],
      cnt: json['Cnt'],
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Image': image,
      'Cnt': cnt,
      'Amount': amount,
    };
  }
}

class Closeday {
  int? status;
  String? result;
  String? message;
  List<CashFlowSummary>? cashFlowSummary;
  List<ItemWiseSales>? itemWiseSales;
  List<ToppingWiseSales>? toppingWiseSales;
  double? cashSales;
  double? ahlanCashSales;
  double? ahlanCredit;
  double? ahlanCardSales;
  double? ahlanBenifitPaySales;
  double? cashDeliverySales;
  int? cashDeliverySalesCnt;
  double? cardSales;
  double? creditCardSales;
  double? debitCardSales;
  double? benifitPaySales;
  double? discountAmount;
  double? cancelledSales;
  int? cashSalesCnt;
  int? cardSalesCnt;
  int? creditCardSalesCnt;
  int? debitCardSalesCnt;
  int? benifitPaySalesCnt;
  int? ahlanCashSalesCnt;
  int? ahlanCreditSalesCnt;
  int? ahlanCardSalesCnt;
  int? ahlanBenifitPaySalesCnt;
  double? deliveryBenifitPaySales;
  int? deliveryBenifitPaySalesCnt;
  int? cancelledSalesCnt;
  double? opBal;
  double? addCash;
  double? withdraw;
  double? cancelledCashSales;
  double? excessShortage;
  double? dineinSales;
  int? dineinSalesCnt;
  double? pickupSales;
  int? pickupSalesCnt;
  double? deliverySales;
  int? deliverySalesCnt;
  List<DeliveryService>? deliveryService;
  double? deliveryServiceSales;
  int? deliveryServiceCnt;
  double? posSales;
  double? onlineSales;
  double? preOrderSales;
  int? posSalesCnt;
  int? onlineSalesCnt;
  int? preOrderSalesCnt;

  /// ✅ Empty constructor
  Closeday();

  /// ✅ From JSON
  factory Closeday.fromJson(Map<String, dynamic> json) {
    return Closeday()
      ..status = json['Status']
      ..result = json['Result']
      ..message = json['Message']
      ..cashFlowSummary = (json['CashFlowSummary'] as List?)
          ?.map((e) => CashFlowSummary.fromJson(e))
          .toList()
      ..itemWiseSales = (json['ItemWiseSales'] as List?)
          ?.map((e) => ItemWiseSales.fromJson(e))
          .toList()
      ..toppingWiseSales = (json['ToppingWiseSales'] as List?)
          ?.map((e) => ToppingWiseSales.fromJson(e))
          .toList()
      ..cashSales = (json['CashSales'] ?? 0).toDouble()
      ..ahlanCashSales = (json['AhlanCashSales'] ?? 0).toDouble()
      ..ahlanCredit = (json['AhlanCredit'] ?? 0).toDouble()
      ..ahlanCardSales = (json['AhlanCardSales'] ?? 0).toDouble()
      ..ahlanBenifitPaySales = (json['AhlanBenifitPaySales'] ?? 0).toDouble()
      ..cashDeliverySales = (json['CashDeliverySales'] ?? 0).toDouble()
      ..cashDeliverySalesCnt = json['CashDeliverySalesCnt'] ?? 0
      ..cardSales = (json['CardSales'] ?? 0).toDouble()
      ..creditCardSales = (json['CreditCardSales'] ?? 0).toDouble()
      ..debitCardSales = (json['DebitCardSales'] ?? 0).toDouble()
      ..benifitPaySales = (json['BenifitPaySales'] ?? 0).toDouble()
      ..discountAmount = (json['DiscountAmount'] ?? 0).toDouble()
      ..cancelledSales = (json['CancelledSales'] ?? 0).toDouble()
      ..cashSalesCnt = json['CashSalesCnt'] ?? 0
      ..cardSalesCnt = json['CardSalesCnt'] ?? 0
      ..creditCardSalesCnt = json['CreditCardSalesCnt'] ?? 0
      ..debitCardSalesCnt = json['DebitCardSalesCnt'] ?? 0
      ..benifitPaySalesCnt = json['BenifitPaySalesCnt'] ?? 0
      ..ahlanCashSalesCnt = json['AhlanCashSalesCnt'] ?? 0
      ..ahlanCreditSalesCnt = json['AhlanCreditSalesCnt'] ?? 0
      ..ahlanCardSalesCnt = json['AhlanCardSalesCnt'] ?? 0
      ..ahlanBenifitPaySalesCnt = json['AhlanBenifitPaySalesCnt'] ?? 0
      ..deliveryBenifitPaySales =
      (json['DeliveryBenifitPaySales'] ?? 0).toDouble()
      ..deliveryBenifitPaySalesCnt = json['DeliveryBenifitPaySalesCnt'] ?? 0
      ..cancelledSalesCnt = json['CancelledSalesCnt'] ?? 0
      ..opBal = (json['OpBal'] ?? 0).toDouble()
      ..addCash = (json['AddCash'] ?? 0).toDouble()
      ..withdraw = (json['Withdraw'] ?? 0).toDouble()
      ..cancelledCashSales = (json['CancelledCashSales'] ?? 0).toDouble()
      ..excessShortage = (json['ExcessShortage'] ?? 0).toDouble()
      ..dineinSales = (json['DineinSales'] ?? 0).toDouble()
      ..dineinSalesCnt = json['DineinSalesCnt'] ?? 0
      ..pickupSales = (json['PickupSales'] ?? 0).toDouble()
      ..pickupSalesCnt = json['PickupSalesCnt'] ?? 0
      ..deliverySales = (json['DeliverySales'] ?? 0).toDouble()
      ..deliverySalesCnt = json['DeliverySalesCnt'] ?? 0
      ..deliveryService = (json['DeliverySevice'] as List?)  // 👈 note typo
          ?.map((e) => DeliveryService.fromJson(e))
          .toList()
      ..deliveryServiceSales = (json['DeliveryServiceSales'] ?? 0).toDouble()
      ..deliveryServiceCnt = json['DeliveryServiceCnt'] ?? 0
      ..posSales = (json['POSSales'] ?? 0).toDouble()
      ..onlineSales = (json['OnlineSales'] ?? 0).toDouble()
      ..preOrderSales = (json['PreOrderSales'] ?? 0).toDouble()
      ..posSalesCnt = json['POSSalesCnt'] ?? 0
      ..onlineSalesCnt = json['OnlineSalesCnt'] ?? 0
      ..preOrderSalesCnt = json['PreOrderSalesCnt'] ?? 0;
  }
}

class CashFlowSummary {
  final int id;
  final int dailyTransId;
  final double transAmount;
  final int transType;
  final String? remarks;
  final int? bd20, bd10, bd5, bd1, fils500, fils100, fils50, fils25, fils10, fils5;

  CashFlowSummary({
    required this.id,
    required this.dailyTransId,
    required this.transAmount,
    required this.transType,
    this.remarks,
    this.bd20,
    this.bd10,
    this.bd5,
    this.bd1,
    this.fils500,
    this.fils100,
    this.fils50,
    this.fils25,
    this.fils10,
    this.fils5,
  });

  factory CashFlowSummary.fromJson(Map<String, dynamic> json) {
    return CashFlowSummary(
      id: json['id'],
      dailyTransId: json['DailyTransId'],
      transAmount: (json['TransAmount'] ?? 0).toDouble(),
      transType: json['TransType'],
      remarks: json['Remarks'],
      bd20: json['BD20'],
      bd10: json['BD10'],
      bd5: json['BD5'],
      bd1: json['BD1'],
      fils500: json['Fils500'],
      fils100: json['Fils100'],
      fils50: json['Fils50'],
      fils25: json['Fils25'],
      fils10: json['Fils10'],
      fils5: json['Fils5'],
    );
  }
}

class ItemWiseSales {
  final int itemId;
  final int categoryId;
  final String product;
  final double qty;
  final double amount;

  ItemWiseSales({
    required this.itemId,
    required this.categoryId,
    required this.product,
    required this.qty,
    required this.amount,
  });

  factory ItemWiseSales.fromJson(Map<String, dynamic> json) {
    return ItemWiseSales(
      itemId: json['ItemId'],
      categoryId: json['CategoryId'],
      product: json['Product'],
      qty: (json['Qty'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}

class ToppingWiseSales {
  final int itemId;
  final String name;
  final double qty;
  final double amount;

  ToppingWiseSales({
    required this.itemId,
    required this.name,
    required this.qty,
    required this.amount,
  });

  factory ToppingWiseSales.fromJson(Map<String, dynamic> json) {
    return ToppingWiseSales(
      itemId: json['ItemId'],
      name: json['Name'],
      qty: (json['Qty'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}

class DeliveryService {
  final int id;
  final String name;
  final int cnt;
  final double amount;

  DeliveryService({
    required this.id,
    required this.name,
    required this.cnt,
    required this.amount,
  });

  factory DeliveryService.fromJson(Map<String, dynamic> json) {
    return DeliveryService(
      id: json['id'],
      name: json['Name'],
      cnt: json['Cnt'] ?? 0,
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}

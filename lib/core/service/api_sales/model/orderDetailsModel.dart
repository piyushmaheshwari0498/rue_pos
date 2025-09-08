// Updated Dart model based on new JSON structure with toString
import 'dart:convert';

import '../../api_cart/model/cart_data.dart';

class OrderDetailsModel {
  int? status;
  String? result;
  String? message;
  List<OrderDetailList>? orderList;
  List<TaxBreakDown>? taxBreakDown;
  List<KOTPrint>? kOTPrint;

  OrderDetailsModel({
    this.status,
    this.result,
    this.message,
    this.orderList,
    this.taxBreakDown,
    this.kOTPrint,
  });

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    message = json['Message'];
    if (json['orderList'] != null) {
      orderList = <OrderDetailList>[];
      json['orderList'].forEach((v) {
        orderList!.add(OrderDetailList.fromJson(v));
      });
    }
    if (json['TaxBreakDown'] != null) {
      taxBreakDown = <TaxBreakDown>[];
      json['TaxBreakDown'].forEach((v) {
        taxBreakDown!.add(TaxBreakDown.fromJson(v));
      });
    }
    if (json['KOTPrint'] != null) {
      kOTPrint = <KOTPrint>[];
      json['KOTPrint'].forEach((v) {
        kOTPrint!.add(KOTPrint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'Result': result,
    'Message': message,
    'orderList': orderList?.map((v) => v.toJson()).toList(),
    'TaxBreakDown': taxBreakDown?.map((v) => v.toJson()).toList(),
    'KOTPrint': kOTPrint?.map((v) => v.toJson()).toList(),
  };

  @override
  String toString() {
    return 'OrderDetailsModel(status: $status, result: $result, message: $message, orderList: $orderList, taxBreakDown: $taxBreakDown, kOTPrint: $kOTPrint)';
  }
}

class OrderDetailList {
  int? ordId;
  String? ordNo;
  String? ordDate;
  int? kitchenTicketNo;
  int? clientId;
  String? clientName;
  String? address;
  String? flatNo;
  String? buildingNo;
  String? roadNo;
  String? blockNo;
  String? area;
  String? notes;
  String? mobileNo;
  int? deliveryType;
  String? email;
  double? subTotal;
  double? cancelledAmt;
  String? cancelRemarks;
  double? varianceAmt;
  double? balanceAmt;
  double? discount;
  double? taxAmount;
  double? netAmount;
  double? tenderAmount;
  double? refundAmount;
  double? deliveryFees;
  int? tableLocationId;
  String? tableLocation;
  String? tableNo;
  int? driverId;
  String? driverName;
  bool? deliveryService;
  String? modeOfPay;
  String? payStatus;
  String? orderType;
  int? status;
  String? orderNotes;
  bool? isModified;
  String? statusText;
  List<OrderDtl>? orderDtl;
  List<TbDirectOrderPayment>? tbDirectOrderPayment;
  UserData? userData;

  OrderDetailList.fromJson(Map<String, dynamic> json) {
    ordId = json['OrdId'];
    ordNo = json['OrdNo'];
    ordDate = json['OrdDate'];
    kitchenTicketNo = json['KitchenTicketNo'];
    clientId = json['ClientId'];
    clientName = json['ClientName'];
    address = json['Address'];
    flatNo = json['FlatNo'];
    buildingNo = json['BuildingNo'];
    roadNo = json['RoadNo'];
    blockNo = json['BlockNo'];
    area = json['Area'];
    notes = json['Notes'];
    mobileNo = json['MobileNo'];
    deliveryType = json['DeliveryType'];
    email = json['Email'];
    subTotal = json['SubTotal'];
    cancelledAmt = json['CancelledAmt'];
    cancelRemarks = json['CancelRemarks'];
    varianceAmt = json['VarianceAmt'];
    balanceAmt = json['BalanceAmt'];
    discount = json['Discount'];
    taxAmount = json['TaxAmount'];
    netAmount = json['NetAmount'];
    tenderAmount = json['TenderAmount'];
    refundAmount = json['RefundAmount'];
    deliveryFees = json['DeliveryFees'];
    tableLocationId = json['TableLocationId'];
    tableLocation = json['TableLocation'];
    tableNo = json['TableNo'];
    driverId = json['DriverId'];
    driverName = json['DriverName'];
    deliveryService = json['DeliveryService'];
    modeOfPay = json['ModeOfPay'];
    payStatus = json['PayStatus'];
    orderType = json['OrderType'];
    status = json['Status'];
    orderNotes = json['OrderNotes'];
    isModified = json['isModified'];
    statusText = json['StatusText'];
    if (json['OrderDtl'] != null) {
      orderDtl = <OrderDtl>[];
      json['OrderDtl'].forEach((v) {
        orderDtl!.add(OrderDtl.fromJson(v));
      });
    }
    if (json['tb_DirectOrderPayment'] != null) {
      tbDirectOrderPayment = <TbDirectOrderPayment>[];
      json['tb_DirectOrderPayment'].forEach((v) {
        tbDirectOrderPayment!.add(TbDirectOrderPayment.fromJson(v));
      });
    }
    if (json['userData'] != null) {
      userData = UserData.fromJson(json['userData']);
    }
  }

  Map<String, dynamic> toJson() => {
    'OrdId': ordId,
    'OrdNo': ordNo,
    'OrdDate': ordDate,
    'KitchenTicketNo': kitchenTicketNo,
    'ClientId': clientId,
    'ClientName': clientName,
    'Address': address,
    'FlatNo': flatNo,
    'BuildingNo': buildingNo,
    'RoadNo': roadNo,
    'BlockNo': blockNo,
    'Area': area,
    'Notes': notes,
    'MobileNo': mobileNo,
    'DeliveryType': deliveryType,
    'Email': email,
    'SubTotal': subTotal,
    'CancelledAmt': cancelledAmt,
    'CancelRemarks': cancelRemarks,
    'VarianceAmt': varianceAmt,
    'BalanceAmt': balanceAmt,
    'Discount': discount,
    'TaxAmount': taxAmount,
    'NetAmount': netAmount,
    'TenderAmount': tenderAmount,
    'RefundAmount': refundAmount,
    'DeliveryFees': deliveryFees,
    'TableLocationId': tableLocationId,
    'TableLocation': tableLocation,
    'TableNo': tableNo,
    'DriverId': driverId,
    'DriverName': driverName,
    'DeliveryService': deliveryService,
    'ModeOfPay': modeOfPay,
    'PayStatus': payStatus,
    'OrderType': orderType,
    'Status': status,
    'OrderNotes': orderNotes,
    'isModified': isModified,
    'StatusText': statusText,
    'OrderDtl': orderDtl?.map((v) => v.toJson()).toList(),
    'tb_DirectOrderPayment': tbDirectOrderPayment?.map((v) => v.toJson()).toList(),
    'userData': userData?.toJson(),
  };

  @override
  String toString() {
    return 'OrderDetailList(ordId: $ordId, ordNo: $ordNo, tableNo: $tableNo, clientName: $clientName, statusText: $statusText, items: $orderDtl)';
  }
}

class UserData {
  int? userId;
  String? userName;
  String? userImage;

  UserData({this.userId, this.userName, this.userImage});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    userName = json['UserName'];
    userImage = json['UserImage'];
  }

  Map<String, dynamic> toJson() => {
    'UserId': userId,
    'UserName': userName,
    'UserImage': userImage,
  };

  @override
  String toString() => 'UserData(userId: $userId, userName: $userName, userImage: $userImage)';
}

class ToppingModel {
  int? id;
  int? directOrdId;
  int? directOrdItemId;
  int? productId;
  int? toppingId;
  String? name;
  double? rate;
  double? qty;
  double? amount;
  bool? status;
  int? toppingStatus;

  ToppingModel({
    this.id,
    this.directOrdId,
    this.directOrdItemId,
    this.productId,
    this.toppingId,
    this.name,
    this.rate,
    this.qty,
    this.amount,
    this.status,
    this.toppingStatus,
  });

  factory ToppingModel.fromJson(Map<String, dynamic> json) => ToppingModel(
    id: json['id'],
    directOrdId: json['DirectOrdId'],
    directOrdItemId: json['DirectOrdItemId'],
    productId: json['ProductId'],
    toppingId: json['ToppingId'],
    name: json['Name'],
    rate: (json['Rate'] as num?)?.toDouble(),
    qty: (json['Qty'] as num?)?.toDouble(),
    amount: (json['Amount'] as num?)?.toDouble(),
    status: json['Status'],
    toppingStatus: json['ToppingStatus'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'DirectOrdId': directOrdId,
    'DirectOrdItemId': directOrdItemId,
    'ProductId': productId,
    'ToppingId': toppingId,
    'Name': name,
    'Rate': rate,
    'Qty': qty,
    'Amount': amount,
    'Status': status,
    'ToppingStatus': toppingStatus,
  };

  @override
  String toString() => 'ToppingModel(name: $name, rate: $rate, qty: $qty, status: $status)';
}

class OrderDtl {
  int? directOrdItemId;
  int? directOrdId;
  int? itemId;
  int? categoryId;
  String? description;
  String? image;
  String? skuId;
  String? variation;
  String? extraDesc;
  String? nameOnBox;
  String? variationRemarks;
  double? qty;
  int? uomId;
  double? rate;
  double? toppingAmount;
  double? subTotal;
  double? discPer;
  double? discAmount;
  int? taxId;
  double? taxPer;
  double? taxAmount;
  double? total;
  String? remarks;
  int? status;
  int? kotStatus;
  List<ToppingModel>? tbDirectOrderTopping;
  List<ToppingModel>? tbDirectOrderDtlAssorted;

  OrderDtl.fromJson(Map<String, dynamic> json) {
    directOrdItemId = json['DirectOrdItemId'];
    directOrdId = json['DirectOrdId'];
    itemId = json['ItemId'];
    categoryId = json['CategoryId'];
    description = json['Description'];
    image = json['Image'];
    skuId = json['SKUId'];
    variation = json['Variation'];
    extraDesc = json['ExtraDesc'];
    nameOnBox = json['NameonBox'];
    variationRemarks = json['VariationRemarks'];
    qty = (json['Qty'] as num?)?.toDouble();
    uomId = json['UomId'];
    rate = (json['Rate'] as num?)?.toDouble();
    toppingAmount = (json['ToppingAmount'] as num?)?.toDouble();
    subTotal = (json['SubTotal'] as num?)?.toDouble();
    discPer = (json['DiscPer'] as num?)?.toDouble();
    discAmount = (json['DiscAmount'] as num?)?.toDouble();
    taxId = json['TaxId'];
    taxPer = (json['TaxPer'] as num?)?.toDouble();
    taxAmount = (json['TaxAmount'] as num?)?.toDouble();
    total = (json['Total'] as num?)?.toDouble();
    remarks = json['Remarks'];
    status = json['Status'];
    kotStatus = json['KOTStatus'];
    if (json['tb_DirectOrderTopping'] != null) {
      tbDirectOrderTopping = <ToppingModel>[];
      json['tb_DirectOrderTopping'].forEach((v) {
        tbDirectOrderTopping!.add(ToppingModel.fromJson(v));
      });
    }
    if (json['tb_DirectOrderDtl_Assorted'] != null) {
      tbDirectOrderDtlAssorted = <ToppingModel>[];
      json['tb_DirectOrderDtl_Assorted'].forEach((v) {
        tbDirectOrderDtlAssorted!.add(ToppingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'DirectOrdItemId': directOrdItemId,
    'DirectOrdId': directOrdId,
    'ItemId': itemId,
    'CategoryId': categoryId,
    'Description': description,
    'Image': image,
    'SKUId': skuId,
    'Variation': variation,
    'ExtraDesc': extraDesc,
    'NameonBox': nameOnBox,
    'VariationRemarks': variationRemarks,
    'Qty': qty,
    'UomId': uomId,
    'Rate': rate,
    'ToppingAmount': toppingAmount,
    'SubTotal': subTotal,
    'DiscPer': discPer,
    'DiscAmount': discAmount,
    'TaxId': taxId,
    'TaxPer': taxPer,
    'TaxAmount': taxAmount,
    'Total': total,
    'Remarks': remarks,
    'Status': status,
    'KOTStatus': kotStatus,
    'tb_DirectOrderTopping': tbDirectOrderTopping?.map((v) => v.toJson()).toList(),
    'tb_DirectOrderDtl_Assorted': tbDirectOrderDtlAssorted?.map((v) => v.toJson()).toList(),
  };

  @override
  String toString() => 'OrderDtl(description: $description, qty: $qty, rate: $rate, total: $total)';
}

class TaxBreakDown {
  String? taxCode;
  double? taxPercentage;
  double? taxableAmt;
  double? taxAmt;

  TaxBreakDown({this.taxCode, this.taxPercentage, this.taxableAmt, this.taxAmt});

  TaxBreakDown.fromJson(Map<String, dynamic> json) {
    taxCode = json['TaxCode'];
    taxPercentage = (json['TaxPercentage'] as num?)?.toDouble();
    taxableAmt = (json['TaxableAmt'] as num?)?.toDouble();
    taxAmt = (json['TaxAmt'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'TaxCode': taxCode,
    'TaxPercentage': taxPercentage,
    'TaxableAmt': taxableAmt,
    'TaxAmt': taxAmt,
  };

  @override
  String toString() => 'TaxBreakDown(code: $taxCode, percent: $taxPercentage, amt: $taxAmt)';
}

class KOTPrint {
  int? printerId;
  String? printerName;
  String? modelName;
  String? typeName;
  String? portName;
  String? emulation;
  String? printerIP;
  int? fontSize;
  List<ItemList>? itemList;

  KOTPrint.fromJson(Map<String, dynamic> json) {
    printerId = json['PrinterId'];
    printerName = json['PrinterName'];
    modelName = json['ModelName'];
    typeName = json['TypeName'];
    portName = json['PortName'];
    emulation = json['Emulation'];
    printerIP = json['PrinterIP'];
    fontSize = json['FontSize'];
    if (json['ItemList'] != null) {
      itemList = <ItemList>[];
      json['ItemList'].forEach((v) {
        itemList!.add(ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'PrinterId': printerId,
    'PrinterName': printerName,
    'ModelName': modelName,
    'TypeName': typeName,
    'PortName': portName,
    'Emulation': emulation,
    'PrinterIP': printerIP,
    'FontSize': fontSize,
    'ItemList': itemList?.map((v) => v.toJson()).toList(),
  };

  @override
  String toString() => 'KOTPrint(printer: $printerName, items: $itemList)';
}

class ItemList {
  int? itemId;
  String? category;
  int? categoryId;
  String? product;
  String? description;
  String? extraDesc;
  String? variationRemarks;
  double? qty;
  double? rate;
  String? amount;
  int? categorySeqNo;
  int? productSeqNo;
  List<ToppingModel>? tbDirectOrderTopping;

  ItemList.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    category = json['Category'];
    categoryId = json['CategoryId'];
    product = json['product'];
    description = json['Description'];
    extraDesc = json['ExtraDesc'];
    variationRemarks = json['VariationRemarks'];
    qty = (json['Qty'] as num?)?.toDouble();
    rate = (json['Rate'] as num?)?.toDouble();
    // amount = (json['Amount'] as num?)?.toDouble();
    amount = json['Amount']?.toString();
    categorySeqNo = json['CategorySeqNo'];
    productSeqNo = json['ProductSeqNo'];
    if (json['tb_DirectOrderTopping'] != null) {
      tbDirectOrderTopping = <ToppingModel>[];
      json['tb_DirectOrderTopping'].forEach((v) {
        tbDirectOrderTopping!.add(ToppingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'ItemId': itemId,
    'Category': category,
    'CategoryId': categoryId,
    'product': product,
    'Description': description,
    'ExtraDesc': extraDesc,
    'VariationRemarks': variationRemarks,
    'Qty': qty,
    'Rate': rate,
    'Amount': amount,
    'CategorySeqNo': categorySeqNo,
    'ProductSeqNo': productSeqNo,
    'tb_DirectOrderTopping': tbDirectOrderTopping?.map((v) => v.toJson()).toList(),
  };

  @override
  String toString() => 'ItemList(product: $product, qty: $qty, rate: $rate, amount: $amount)';
}

import 'dart:ffi';

class CurrentOrdersModel {
  int? status;
  String? result;
  String? message;
  List<OrderList>? orderList;

  CurrentOrdersModel({this.status, this.result, this.message, this.orderList});

  CurrentOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    message = json['Message'];
    if (json['orderList'] != null) {
      orderList = <OrderList>[];
      json['orderList'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['Message'] = this.message;
    if (this.orderList != null) {
      data['orderList'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderList {
  int? id;
  String? orderNo;
  String? orderDate;
  String? orderTime;
  String? customer;
  String? mobileNo;
  int? deliveryType;
  String? delivery;
  String? tableNo;
  String? email;
  String? address;
  double? subTotal;
  double? cancelledAmt;
  double? taxAmount;
  double? discount;
  double? deliveryFees;
  int? driverId;
  String? driverName;
  String? userName;
  double? netAmount;
  String? modeOfPay;
  String? payStatus;
  double? payAmount;
  double? payAmount1;
  double? payAmount2;
  String? area;
  String? lat;
  String? lang;
  String? orderType;
  int? status;
  String? orderNotes;
  int? pizzaCount;
  int? desertCount;
  int? drinkCount;
  String? statusText;
  String? image;
  String? ahlanOrder;

  OrderList(
      {this.id,
      this.orderNo,
      this.orderDate,
      this.orderTime,
      this.customer,
      this.mobileNo,
      this.deliveryType,
      this.delivery,
      this.tableNo,
      this.email,
      this.address,
      this.subTotal,
      this.cancelledAmt,
      this.taxAmount,
      this.discount,
      this.deliveryFees,
      this.driverId,
      this.driverName,
      this.userName,
      this.netAmount,
      this.modeOfPay,
      this.payStatus,
      this.payAmount,
      this.payAmount1,
      this.payAmount2,
      this.area,
      this.lat,
      this.lang,
      this.orderType,
      this.status,
      this.orderNotes,
      this.pizzaCount,
      this.desertCount,
      this.drinkCount,
      this.statusText,
      this.image,
      this.ahlanOrder});

  OrderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    orderTime = json['OrderTime'];
    customer = json['Customer'];
    mobileNo = json['MobileNo'] ?? "";
    deliveryType = json['DeliveryType'] ?? 0;
    delivery = json['Delivery'];
    tableNo = json['TableNo'];
    email = json['Email'] ?? "";
    address = json['Address'];
    subTotal = json['SubTotal'];
    cancelledAmt = json['CancelledAmt'] ?? 0.0;
    taxAmount = json['TaxAmount'];
    discount = json['Discount'];
    deliveryFees = json['DeliveryFees'] ?? 0.0;
    driverId = json['DriverId'] ?? 0;
    driverName = json['DriverName'] ?? "";
    userName = json['UserName'];
    netAmount = json['NetAmount'];
    modeOfPay = json['ModeOfPay'];
    payStatus = json['PayStatus'];
    payAmount = json['PayAmount'];
    payAmount1 = json['PayAmount1'];
    payAmount2 = json['PayAmount2'];
    area = json['Area'] ?? "";
    lat = json['Lat'] ?? "";
    lang = json['Lang'] ?? "";
    orderType = json['OrderType'];
    status = json['Status'];
    orderNotes = json['OrderNotes'] ?? "";
    pizzaCount = json['PizzaCount'];
    desertCount = json['DesertCount'];
    drinkCount = json['DrinkCount'];
    statusText = json['StatusText'];
    image = json['Image'];
    ahlanOrder = json['AhlanOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['OrderTime'] = this.orderTime;
    data['Customer'] = this.customer;
    data['MobileNo'] = this.mobileNo;
    data['DeliveryType'] = this.deliveryType;
    data['Delivery'] = this.delivery;
    data['TableNo'] = this.tableNo;
    data['Email'] = this.email;
    data['Address'] = this.address;
    data['SubTotal'] = this.subTotal;
    data['CancelledAmt'] = this.cancelledAmt;
    data['TaxAmount'] = this.taxAmount;
    data['Discount'] = this.discount;
    data['DeliveryFees'] = this.deliveryFees;
    data['DriverId'] = this.driverId;
    data['DriverName'] = this.driverName;
    data['UserName'] = this.userName;
    data['NetAmount'] = this.netAmount;
    data['ModeOfPay'] = this.modeOfPay;
    data['PayStatus'] = this.payStatus;
    data['PayAmount'] = this.payAmount;
    data['PayAmount1'] = this.payAmount1;
    data['PayAmount2'] = this.payAmount2;
    data['Area'] = this.area;
    data['Lat'] = this.lat;
    data['Lang'] = this.lang;
    data['OrderType'] = this.orderType;
    data['Status'] = this.status;
    data['OrderNotes'] = this.orderNotes;
    data['PizzaCount'] = this.pizzaCount;
    data['DesertCount'] = this.desertCount;
    data['DrinkCount'] = this.drinkCount;
    data['StatusText'] = this.statusText;
    data['Image'] = this.image;
    data['AhlanOrder'] = this.ahlanOrder;
    return data;
  }
}

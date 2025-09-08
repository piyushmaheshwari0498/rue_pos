class CartData {
  int? ahlanFlag;
  String? authToken;
  int? clientId;
  String? subTotal;
  String? taxAmount;
  String? discount;
  String? netAmount;
  int? balanceAmount;
  int? payStatus;
  int? createrId;
  int? modifiedBy;
  String? branchId;
  int? counterId;
  List<TbDirectOrderDet>? tbDirectOrderDet;
  int? modeOfPay;
  int? status;
  String? modeofPay1;
  String? modeofPay2;
  String? deliveryType;
  String? shippingCharge;
  int? tenderAmount;
  List<TbDirectOrderPayment>? tbDirectOrderPayment;
  int? orderStatus;

  CartData(
      {this.ahlanFlag,
        this.authToken,
        this.clientId,
        this.subTotal,
        this.taxAmount,
        this.discount,
        this.netAmount,
        this.balanceAmount,
        this.payStatus,
        this.createrId,
        this.modifiedBy,
        this.branchId,
        this.counterId,
        this.tbDirectOrderDet,
        this.modeOfPay,
        this.status,
        this.modeofPay1,
        this.modeofPay2,
        this.deliveryType,
        this.shippingCharge,
        this.tenderAmount,
        this.tbDirectOrderPayment,
        this.orderStatus});

  CartData.fromJson(Map<String, dynamic> json) {
    ahlanFlag = json['AhlanFlag'];
    authToken = json['AuthToken'];
    clientId = json['ClientId'];
    subTotal = json['SubTotal'];
    taxAmount = json['TaxAmount'];
    discount = json['Discount'];
    netAmount = json['NetAmount'];
    balanceAmount = json['BalanceAmount'];
    payStatus = json['PayStatus'];
    createrId = json['CreaterId'];
    modifiedBy = json['ModifiedBy'];
    branchId = json['BranchId'];
    counterId = json['CounterId'];
    if (json['tb_DirectOrderDet'] != null) {
      tbDirectOrderDet = <TbDirectOrderDet>[];
      json['tb_DirectOrderDet'].forEach((v) {
        tbDirectOrderDet!.add(new TbDirectOrderDet.fromJson(v));
      });
    }
    modeOfPay = json['ModeOfPay'];
    status = json['Status'];
    modeofPay1 = json['ModeofPay1'];
    modeofPay2 = json['ModeofPay2'];
    deliveryType = json['DeliveryType'];
    shippingCharge = json['ShippingCharge'];
    tenderAmount = json['TenderAmount'];
    if (json['tb_DirectOrderPayment'] != null) {
      tbDirectOrderPayment = <TbDirectOrderPayment>[];
      json['tb_DirectOrderPayment'].forEach((v) {
        tbDirectOrderPayment!.add(new TbDirectOrderPayment.fromJson(v));
      });
    }
    orderStatus = json['OrderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AhlanFlag'] = this.ahlanFlag;
    data['AuthToken'] = this.authToken;
    data['ClientId'] = this.clientId;
    data['SubTotal'] = this.subTotal;
    data['TaxAmount'] = this.taxAmount;
    data['Discount'] = this.discount;
    data['NetAmount'] = this.netAmount;
    data['BalanceAmount'] = this.balanceAmount;
    data['PayStatus'] = this.payStatus;
    data['CreaterId'] = this.createrId;
    data['ModifiedBy'] = this.modifiedBy;
    data['BranchId'] = this.branchId;
    data['CounterId'] = this.counterId;
    if (this.tbDirectOrderDet != null) {
      data['tb_DirectOrderDet'] =
          this.tbDirectOrderDet!.map((v) => v.toJson()).toList();
    }
    data['ModeOfPay'] = this.modeOfPay;
    data['Status'] = this.status;
    data['ModeofPay1'] = this.modeofPay1;
    data['ModeofPay2'] = this.modeofPay2;
    data['DeliveryType'] = this.deliveryType;
    data['ShippingCharge'] = this.shippingCharge;
    data['TenderAmount'] = this.tenderAmount;
    if (this.tbDirectOrderPayment != null) {
      data['tb_DirectOrderPayment'] =
          this.tbDirectOrderPayment!.map((v) => v.toJson()).toList();
    }
    data['OrderStatus'] = this.orderStatus;
    return data;
  }
}

class TbDirectOrderDet {
  int? itemId;
  String? product;
  String? description;
  Null? selprodimg;
  String? selprodprice;
  String? rate;
  Null? selcode;
  int? qty;
  int? taxPercentage;
  String? taxCode;
  List<Null>? tbDirectOrderDtlAssorted;
  bool? remarks;
  String? extraDesc;
  String? nameonBox;
  String? variationRemarks;
  String? toppingAmount;
  String? name;
  List<TbDirectOrderTopping>? tbDirectOrderTopping;
  int? itemStatus;

  TbDirectOrderDet(
      {this.itemId,
        this.product,
        this.description,
        this.selprodimg,
        this.selprodprice,
        this.rate,
        this.selcode,
        this.qty,
        this.taxPercentage,
        this.taxCode,
        this.tbDirectOrderDtlAssorted,
        this.remarks,
        this.extraDesc,
        this.nameonBox,
        this.variationRemarks,
        this.toppingAmount,
        this.name,
        this.tbDirectOrderTopping,
        this.itemStatus});

  TbDirectOrderDet.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    product = json['product'];
    description = json['Description'];
    selprodimg = json['selprodimg'];
    selprodprice = json['selprodprice'];
    rate = json['Rate'];
    selcode = json['selcode'];
    qty = json['Qty'];
    taxPercentage = json['TaxPercentage'];
    taxCode = json['TaxCode'];
    if (json['tb_DirectOrderDtl_Assorted'] != null) {
      tbDirectOrderDtlAssorted = <Null>[];
      json['tb_DirectOrderDtl_Assorted'].forEach((v) {
        // tbDirectOrderDtlAssorted!.add(new Null.fromJson(v));
      });
    }
    remarks = json['Remarks'];
    extraDesc = json['ExtraDesc'];
    nameonBox = json['NameonBox'];
    variationRemarks = json['VariationRemarks'];
    toppingAmount = json['ToppingAmount'];
    name = json['name'];
    if (json['tb_DirectOrderTopping'] != null) {
      tbDirectOrderTopping = <TbDirectOrderTopping>[];
      json['tb_DirectOrderTopping'].forEach((v) {
        tbDirectOrderTopping!.add(new TbDirectOrderTopping.fromJson(v));
      });
    }
    itemStatus = json['ItemStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemId'] = this.itemId;
    data['product'] = this.product;
    data['Description'] = this.description;
    data['selprodimg'] = this.selprodimg;
    data['selprodprice'] = this.selprodprice;
    data['Rate'] = this.rate;
    data['selcode'] = this.selcode;
    data['Qty'] = this.qty;
    data['TaxPercentage'] = this.taxPercentage;
    data['TaxCode'] = this.taxCode;
    if (this.tbDirectOrderDtlAssorted != null) {
      // data['tb_DirectOrderDtl_Assorted'] =
      //     this.tbDirectOrderDtlAssorted!.map((v) => v.toJson()).toList();
    }
    data['Remarks'] = this.remarks;
    data['ExtraDesc'] = this.extraDesc;
    data['NameonBox'] = this.nameonBox;
    data['VariationRemarks'] = this.variationRemarks;
    data['ToppingAmount'] = this.toppingAmount;
    data['name'] = this.name;
    if (this.tbDirectOrderTopping != null) {
      data['tb_DirectOrderTopping'] =
          this.tbDirectOrderTopping!.map((v) => v.toJson()).toList();
    }
    data['ItemStatus'] = this.itemStatus;
    return data;
  }
}

class TbDirectOrderTopping {
  int? id;
  int? toppingId;
  String? name;
  double? rate;
  bool? checked;
  int? qty;

  TbDirectOrderTopping(
      {this.id, this.toppingId, this.name, this.rate, this.checked, this.qty});

  TbDirectOrderTopping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingId = json['ToppingId'];
    name = json['Name'];
    rate = json['Rate'];
    checked = json['checked'];
    qty = json['Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ToppingId'] = this.toppingId;
    data['Name'] = this.name;
    data['Rate'] = this.rate;
    data['checked'] = this.checked;
    data['Qty'] = this.qty;
    return data;
  }
}

class TbDirectOrderPayment {
  int? modeofPay;
  double? amount;
  String? cardNo;

  TbDirectOrderPayment({this.modeofPay, this.amount, this.cardNo});

  TbDirectOrderPayment.fromJson(Map<String, dynamic> json) {
    modeofPay = json['ModeofPay'];
    amount = json['Amount'];
    cardNo = json['CardNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModeofPay'] = this.modeofPay;
    data['Amount'] = this.amount;
    // data['Amount'] = (this.amount as num?)?.toDouble();
    data['CardNo'] = this.cardNo;
    return data;
  }

  @override
  String toString() {
    return 'TbDirectOrderPayment{modeofPay: $modeofPay, amount: $amount, cardNo: $cardNo}';
  }
}
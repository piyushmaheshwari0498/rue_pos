class CartResponse {
  int? status;
  String? result;
  String? message;
  int? orderId;
  String? orderNo;
  int? ticketNo;
  List<TaxBreakDown>? taxBreakDown;

  CartResponse(
      {this.status,
        this.result,
        this.message,
        this.orderId,
        this.orderNo,
        this.ticketNo,
        this.taxBreakDown});

  CartResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    message = json['Message'];
    orderId = json['OrderId'];
    orderNo = json['OrderNo'];
    ticketNo = json['TicketNo'];
    if (json['TaxBreakDown'] != null) {
      taxBreakDown = <TaxBreakDown>[];
      json['TaxBreakDown'].forEach((v) {
        taxBreakDown!.add( TaxBreakDown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['Message'] = this.message;
    data['OrderId'] = this.orderId;
    data['OrderNo'] = this.orderNo;
    data['TicketNo'] = this.ticketNo;
    if (this.taxBreakDown != null) {
      data['TaxBreakDown'] = this.taxBreakDown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxBreakDown {
  String? taxCode;
  double? taxPercentage;
  double? taxableAmt;
  double? taxAmt;

  TaxBreakDown(
      {this.taxCode, this.taxPercentage, this.taxableAmt, this.taxAmt});

  TaxBreakDown.fromJson(Map<String, dynamic> json) {
    taxCode = json['TaxCode'];
    taxPercentage = json['TaxPercentage'];
    taxableAmt = json['TaxableAmt'];
    taxAmt = json['TaxAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TaxCode'] = this.taxCode;
    data['TaxPercentage'] = this.taxPercentage;
    data['TaxableAmt'] = this.taxableAmt;
    data['TaxAmt'] = this.taxAmt;
    return data;
  }
}
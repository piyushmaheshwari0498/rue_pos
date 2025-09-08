import 'dart:ffi';

class AllBranchModel {
  int? status;
  String? result;
  List<Branch>? branch;

  AllBranchModel({this.status, this.result, this.branch});

  AllBranchModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Branch'] != null) {
      branch = <Branch>[];
      json['Branch'].forEach((v) {
        branch!.add(new Branch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.branch != null) {
      data['Branch'] = this.branch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Branch {
  int? id;
  String? branchCode;
  String? name;
  String? address1;
  String? address2;
  String? address3;
  String? phoneNo;
  String? vATNo;
  String? cRNo;

  Branch(
      {this.id,
      this.branchCode,
      this.name,
      this.address1,
      this.address2,
      this.address3,
      this.phoneNo,
      this.vATNo,
      this.cRNo
      });

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchCode = json['BranchCode'];
    name = json['Name'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    address3 = json['Address3'];
    phoneNo = json['PhoneNo'];
    vATNo = json['VATNo'];
    cRNo = json['CRNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['BranchCode'] = this.branchCode;
    data['Name'] = this.name;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['Address3'] = this.address3;
    data['PhoneNo'] = this.phoneNo;
    data['VATNo'] = this.vATNo;
    data['CRNo'] = this.cRNo;
    return data;
  }
}

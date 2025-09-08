class ApiLoginResponse {
  int? status;
  String? result;
  String? token;
  String? message;
  Userdata? userdata;
  bool? newCashierLogin;
  String? cashierPin;

  ApiLoginResponse(
      {this.status,
      this.result,
      this.token,
      this.message,
      this.userdata,
      this.newCashierLogin,
      this.cashierPin});

  ApiLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    token = json['Token'];
    message = json['Message'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
    newCashierLogin = json['NewCashierLogin'];
    cashierPin = json['CashierPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['Token'] = this.token;
    data['Message'] = this.message;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    data['NewCashierLogin'] = this.newCashierLogin;
    data['CashierPin'] = this.cashierPin;
    return data;
  }
}

class Userdata {
  int? id;
  String? userName;
  Null? firstName;
  Null? lastName;
  Null? email;
  Null? mobile;
  Null? userImage;
  int? userTypeId;
  String? pwd;
  int? orgId;
  Null? branchId;
  bool? isDel;
  String? userPin;

  Userdata(
      {this.id,
      this.userName,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.userImage,
      this.userTypeId,
      this.pwd,
      this.orgId,
      this.branchId,
      this.isDel,
      this.userPin});

  Userdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['UserName'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
    mobile = json['Mobile'];
    userImage = json['userImage'];
    userTypeId = json['UserTypeId'];
    pwd = json['Pwd'];
    orgId = json['OrgId'];
    branchId = json['BranchId'];
    isDel = json['isDel'];
    userPin = json['UserPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserName'] = this.userName;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['userImage'] = this.userImage;
    data['UserTypeId'] = this.userTypeId;
    data['Pwd'] = this.pwd;
    data['OrgId'] = this.orgId;
    data['BranchId'] = this.branchId;
    data['isDel'] = this.isDel;
    data['UserPin'] = this.userPin;
    return data;
  }
}
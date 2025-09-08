class InsertCategoryAllocate {
  int? status;
  String? result;
  String? message;
  String? customer;

  InsertCategoryAllocate(
      {this.status, this.result, this.message, this.customer});

  InsertCategoryAllocate.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    message = json['Message'];
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['Message'] = this.message;
    data['customer'] = this.customer;
    return data;
  }
}

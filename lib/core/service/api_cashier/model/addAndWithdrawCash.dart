class AddWithdrawCash {
  int? status;
  String? result;
  String? message;

  AddWithdrawCash({this.status, this.result, this.message});

  AddWithdrawCash.fromJson(Map<String, dynamic> json) {
    try {
      status = json['Status'];
      result = json['Result'];
      message = json['Message'];
      print('inside try $status , $result , $message');
    } catch (e) {
      print('inside catch AddWithdrawCash... $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    data['Message'] = this.message;
    return data;
  }
}

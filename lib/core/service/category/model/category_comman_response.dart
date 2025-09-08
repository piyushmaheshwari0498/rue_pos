import 'package:nb_posx/core/service/category/model/categories.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';

///[CommanResponse] class to handle the basic response from api
class CategoryCommanResponse {
  int? status;
  dynamic message;
  List<Category>? data1;
  ApiStatus? apiStatus;

  //constructor
  CategoryCommanResponse(
      {this.status,
      this.message,
      this.apiStatus,
      this.data1});

  //create class object from json
  CategoryCommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Result'];
        apiStatus = json['apiStatus'];
    data1 = json['Category'];

  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Result'] = message;
     data['apiStatus'] = apiStatus;
    data['Category'] = data1;
    
    return data;
  }
}

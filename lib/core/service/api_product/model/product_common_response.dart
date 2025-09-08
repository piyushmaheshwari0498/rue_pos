import 'package:nb_posx/core/service/api_product/model/api_product.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';

class ProductCommanResponse {
  int? status;
  dynamic message;
  List<Product>? data1;
  ApiStatus? apiStatus;

  //constructor
  ProductCommanResponse(
      {this.status,
      this.message,
      this.apiStatus,
      this.data1});

  //create class object from json
  ProductCommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Result'];
        apiStatus = json['apiStatus'];
    data1 = json['Product'];

  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Result'] = message;
     data['apiStatus'] = apiStatus;
    data['Product'] = data1;
    
    return data;
  }
}

import 'package:dio/dio.dart';
import 'package:nb_posx/core/service/login/model/api_login_response.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';


///[CommanResponse] class to handle the basic response from api
class APILoginCommanResponse {
  bool? status;
  dynamic message;
  ApiStatus? apiStatus;
  late Response response;

  //constructor
  APILoginCommanResponse(
      {this.status,
      this.message,
      this.apiStatus,
     required this.response
      });

  APILoginCommanResponse.fromp( 
    {
      this.status,
      this.message,
      this.apiStatus,
    
  });
      

      

  //create class object from json
  APILoginCommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    apiStatus = json['apiStatus'];
    response = json['response'];
  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['apiStatus'] = apiStatus;
        data['response'] = apiStatus;
    return data;
  }
}

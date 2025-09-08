import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:nb_posx/core/service/category/model/categories.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';

///[CommanResponse] class to handle the basic response from api
class TableCommanResponse {
  int? status;
  dynamic message;
  List<Table>? data1;
  ApiStatus? apiStatus;
  int? tableCount,freeTable,busyTable;

  //constructor
  TableCommanResponse(
      {this.status,
      this.message,
      this.apiStatus,
      this.data1,
      this.tableCount,
      this.freeTable,
      this.busyTable,});

  //create class object from json
  TableCommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Result'];
        apiStatus = json['apiStatus'];
    data1 = json['Table'];

  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Result'] = message;
     data['apiStatus'] = apiStatus;
    data['Table'] = data1;
    
    return data;
  }
}

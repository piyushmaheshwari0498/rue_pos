class TableLocationModel {
  int? status;
  String? result;
  List<TableLocation>? tableLocation;

  TableLocationModel({this.status, this.result, this.tableLocation});

  TableLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['TableLocation'] != null) {
      tableLocation = <TableLocation>[];
      json['TableLocation'].forEach((v) {
        tableLocation!.add(new TableLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.tableLocation != null) {
      data['TableLocation'] =
          this.tableLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableLocation {
  int? id;
  int? floorId;
  String? floorNo;
  String? location;
  int? branchId;

  TableLocation(
      {this.id, this.floorId, this.floorNo, this.location, this.branchId});

  TableLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    floorId = json['FloorId'];
    floorNo = json['FloorNo'];
    location = json['Location'];
    branchId = json['BranchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['FloorId'] = this.floorId;
    data['FloorNo'] = this.floorNo;
    data['Location'] = this.location;
    data['BranchId'] = this.branchId;
    return data;
  }
}
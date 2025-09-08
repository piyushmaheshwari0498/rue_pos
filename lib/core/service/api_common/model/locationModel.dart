class LocationModel {
  int? status;
  String? result;
  List<Location>? location;

  LocationModel({this.status, this.result, this.location});

  LocationModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Location'] != null) {
      location = <Location>[];
      json['Location'].forEach((v) {
        location!.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.location != null) {
      data['Location'] = this.location!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  int? id;
  String? code;
  String? location;
  String? storesType;

  Location({this.id, this.code, this.location, this.storesType});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    location = json['Location'];
    storesType = json['StoresType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Code'] = this.code;
    data['Location'] = this.location;
    data['StoresType'] = this.storesType;
    return data;
  }

  @override
  String toString() {
    return 'Location{id: $id, code: $code, location: $location, storesType: $storesType}';
  }
}

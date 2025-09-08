class CounterModel {
  int? status;
  String? result;
  List<Counter>? counter;

  CounterModel({this.status, this.result, this.counter});

  CounterModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Counter'] != null) {
      counter = <Counter>[];
      json['Counter'].forEach((v) {
        counter!.add(new Counter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.counter != null) {
      data['Counter'] = this.counter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Counter {
  int? id;
  String? counterNo;
  String? description;

  Counter({this.id, this.counterNo, this.description});

  Counter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    counterNo = json['CounterNo'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['CounterNo'] = this.counterNo;
    data['Description'] = this.description;
    return data;
  }
}

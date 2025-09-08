
class Categories {
  int? status;
  String? result;
  List<Category>? category;

  Categories({this.status, this.result, this.category});

  Categories.fromJson(Map<String, dynamic> json) {
    if(json["Status"] is int) {
      status = json["Status"];
    }
    if(json["Result"] is String) {
      result = json["Result"];
    }
    if(json["Category"] is List) {
      category = json["Category"] == null ? null : (json["Category"] as List).map((e) => Category.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Status"] = status;
    _data["Result"] = result;
    if(category != null) {
      _data["Category"] = category?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Category {
  int? id;
  String? english;
  dynamic arabic;
  dynamic sequenceNo;
  dynamic coverImage;
  dynamic categoryMainId;

  Category({this.id, this.english, this.arabic, this.sequenceNo, this.coverImage, this.categoryMainId});

  Category.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["English"] is String) {
      english = json["English"];
    }
    arabic = json["Arabic"];
    sequenceNo = json["SequenceNo"];
    coverImage = json["CoverImage"];
    categoryMainId = json["CategoryMainId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["English"] = english;
    _data["Arabic"] = arabic;
    _data["SequenceNo"] = sequenceNo;
    _data["CoverImage"] = coverImage;
    _data["CategoryMainId"] = categoryMainId;
    return _data;
  }
}
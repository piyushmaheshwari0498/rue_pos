
class Apicatpromodel {
  int? status;
  String? result;
  List<Category>? category;
  List<SubCategory>? subCategory;
  List<Product>? product;

  Apicatpromodel({this.status, this.result, this.category, this.subCategory, this.product});

  Apicatpromodel.fromJson(Map<String, dynamic> json) {
    if(json["Status"] is int) {
      status = json["Status"];
    }
    if(json["Result"] is String) {
      result = json["Result"];
    }
    if(json["Category"] is List) {
      category = json["Category"] == null ? null : (json["Category"] as List).map((e) => Category.fromJson(e)).toList();
    }
    if(json["SubCategory"] is List) {
      subCategory = json["SubCategory"] == null ? null : (json["SubCategory"] as List).map((e) => SubCategory.fromJson(e)).toList();
    }
    if(json["Product"] is List) {
      product = json["Product"] == null ? null : (json["Product"] as List).map((e) => Product.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Status"] = status;
    _data["Result"] = result;
    if(category != null) {
      _data["Category"] = category?.map((e) => e.toJson()).toList();
    }
    if(subCategory != null) {
      _data["SubCategory"] = subCategory?.map((e) => e.toJson()).toList();
    }
    if(product != null) {
      _data["Product"] = product?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Product {
  int? id;
  String? code;
  String? headEnglish;
  String? headArabic;
  String? desEnglish;
  String? desArabic;
  double? rate;
  double? qty;
  double? displayQty;
  double? storesQty;
  int? sequenceNo;
  int? categoryId;
  int? categoryMainId;
  int? taxId;
  String? taxCode;
  String? taxClassName;
  double? taxPercentage;
  bool? status;
  String? uploadImage;
  List<TbAssortedProduct>? tbAssortedProduct;
  List<TbProductTopping>? tbProductTopping;

  Product(
      {this.id,
      this.code,
      this.headEnglish,
      this.headArabic,
      this.desEnglish,
      this.desArabic,
      this.rate,
      this.qty,
      this.displayQty,
      this.storesQty,
      this.sequenceNo,
      this.categoryId,
      this.categoryMainId,
      this.taxId,
      this.taxCode,
      this.taxClassName,
      this.taxPercentage,
      this.status,
      this.uploadImage,
      this.tbAssortedProduct,
      this.tbProductTopping});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    headEnglish = json['HeadEnglish'];
    headArabic = json['HeadArabic'];
    desEnglish = json['DesEnglish'];
    desArabic = json['DesArabic'];
    rate = json['Rate'];
    qty = json['Qty'];
    displayQty = json['DisplayQty'];
    storesQty = json['StoresQty'];
    sequenceNo = json['SequenceNo'];
    categoryId = json['CategoryId'];
    categoryMainId = json['CategoryMainId'];
    taxId = json['TaxId'];
    taxCode = json['TaxCode'];
    taxClassName = json['TaxClassName'];
    taxPercentage = json['TaxPercentage'];
    status = json['Status'];
    uploadImage = json['UploadImage'];
    if (json['tb_AssortedProduct'] != null) {
      tbAssortedProduct = <TbAssortedProduct>[];
      json['tb_AssortedProduct'].forEach((v) {
        tbAssortedProduct!.add(new TbAssortedProduct.fromJson(v));
      });
    }
    if (json['tb_ProductTopping'] != null) {
      tbProductTopping = <TbProductTopping>[];
      json['tb_ProductTopping'].forEach((v) {
        tbProductTopping!.add(new TbProductTopping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Code'] = this.code;
    data['HeadEnglish'] = this.headEnglish;
    data['HeadArabic'] = this.headArabic;
    data['DesEnglish'] = this.desEnglish;
    data['DesArabic'] = this.desArabic;
    data['Rate'] = this.rate;
    data['Qty'] = this.qty;
    data['DisplayQty'] = this.displayQty;
    data['StoresQty'] = this.storesQty;
    data['SequenceNo'] = this.sequenceNo;
    data['CategoryId'] = this.categoryId;
    data['CategoryMainId'] = this.categoryMainId;
    data['TaxId'] = this.taxId;
    data['TaxCode'] = this.taxCode;
    data['TaxClassName'] = this.taxClassName;
    data['TaxPercentage'] = this.taxPercentage;
    data['Status'] = this.status;
    data['UploadImage'] = this.uploadImage;
    if (this.tbAssortedProduct != null) {
      data['tb_AssortedProduct'] =
          this.tbAssortedProduct!.map((v) => v.toJson()).toList();
    }
    if (this.tbProductTopping != null) {
      data['tb_ProductTopping'] =
          this.tbProductTopping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TbAssortedProduct {
  int? productId;
  String? code;
  String? headEnglish;
  String? headArabic;
  String? desEnglish;
  String? desArabic;
  double? rate;
  int? qty;
  double? stock;
  double? displayQty;
  double? storesQty;
  String? uploadImage;

  TbAssortedProduct(
      {this.productId,
      this.code,
      this.headEnglish,
      this.headArabic,
      this.desEnglish,
      this.desArabic,
      this.rate,
      this.qty,
      this.stock,
      this.displayQty,
      this.storesQty,
      this.uploadImage});

  TbAssortedProduct.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    code = json['Code'];
    headEnglish = json['HeadEnglish'];
    headArabic = json['HeadArabic'];
    desEnglish = json['DesEnglish'];
    desArabic = json['DesArabic'];
    rate = json['Rate'];
    qty = json['Qty'];
    stock = json['Stock'];
    displayQty = json['DisplayQty'];
    storesQty = json['StoresQty'];
    uploadImage = json['UploadImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductId'] = this.productId;
    data['Code'] = this.code;
    data['HeadEnglish'] = this.headEnglish;
    data['HeadArabic'] = this.headArabic;
    data['DesEnglish'] = this.desEnglish;
    data['DesArabic'] = this.desArabic;
    data['Rate'] = this.rate;
    data['Qty'] = this.qty;
    data['Stock'] = this.stock;
    data['DisplayQty'] = this.displayQty;
    data['StoresQty'] = this.storesQty;
    data['UploadImage'] = this.uploadImage;
    return data;
  }
}

class TbProductTopping {
  int? id;
  int? toppingId;
  String? name;
  double? rate;

  TbProductTopping({this.id, this.toppingId, this.name, this.rate});

  TbProductTopping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingId = json['ToppingId'];
    name = json['Name'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ToppingId'] = this.toppingId;
    data['Name'] = this.name;
    data['Rate'] = this.rate;
    return data;
  }
}

class SubCategory {
  int? id;
  String? english;
  dynamic arabic;
  int? sequenceNo;
  dynamic coverImage;
  int? categoryMainId;

  SubCategory({this.id, this.english, this.arabic, this.sequenceNo, this.coverImage, this.categoryMainId});

  SubCategory.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["English"] is String) {
      english = json["English"];
    }
    arabic = json["Arabic"];
    if(json["SequenceNo"] is int) {
      sequenceNo = json["SequenceNo"];
    }
    coverImage = json["CoverImage"];
    if(json["CategoryMainId"] is int) {
      categoryMainId = json["CategoryMainId"];
    }
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

class Category {
  int? id;
  String? name;
  dynamic sequenceNo;

  Category({this.id, this.name, this.sequenceNo});

  Category.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["Name"] is String) {
      name = json["Name"];
    }
    sequenceNo = json["SequenceNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["Name"] = name;
    _data["SequenceNo"] = sequenceNo;
    return _data;
  }
}
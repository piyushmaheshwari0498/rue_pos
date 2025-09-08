class ApiProduct {
  int? status;
  String? result;
  List<Product>? product;

  ApiProduct({this.status, this.result, this.product});

  ApiProduct.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (product != null) {
      data['Product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? english;
  String? arabic;
  int? sequenceNo;
  String? coverImage;
  List<TbProduct>? tbProduct;

  Product(int id,String eng,String ar, int squ,String img, List<TbProduct> list)
      {
         this.id = id;
       this.english = eng;
     this.arabic = ar;
       this.sequenceNo = squ;
       this.coverImage = img;
       this.tbProduct = list;
       }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    english = json['English'];
    arabic = json['Arabic'];
    sequenceNo = json['SequenceNo'];
    coverImage = json['CoverImage'];
    if (json['tb_Product'] != null) {
      tbProduct = <TbProduct>[];
      json['tb_Product'].forEach((v) {
        tbProduct!.add(new TbProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['English'] = this.english;
    data['Arabic'] = this.arabic;
    data['SequenceNo'] = this.sequenceNo;
    data['CoverImage'] = this.coverImage;
    if (this.tbProduct != null) {
      data['tb_Product'] = this.tbProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TbProduct {
  int? id;
  String? code;
  String? headEnglish;
  String? headArabic;
  String? desEnglish;
  String? desArabic;
  double? rate;
  late double qty;
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

  TbProduct(
      {this.id,
      this.code,
      this.headEnglish,
      this.headArabic,
      this.desEnglish,
      this.desArabic,
      this.rate,
      required this.qty,
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

  TbProduct.fromJson(Map<String, dynamic> json) {
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
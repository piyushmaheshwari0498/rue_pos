class stock_model {
  int? status;
  String? result;
  List<Product>? product;

  stock_model({this.status, this.result, this.product});

  stock_model.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (product != null) {
      data['Product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
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
  int? sequenceNo;
  int? categoryId;
  int? taxId;
  bool? status;
  String? uploadImage;
  bool? isAssorted;
  int? assortProductQty;
  List<TbAssortedProduct>? tbAssortedProduct;
  List<TbProductTopping>? tbProductTopping;

  Product({
    this.id,
    this.code,
    this.headEnglish,
    this.headArabic,
    this.desEnglish,
    this.desArabic,
    this.rate,
    this.qty,
    this.sequenceNo,
    this.categoryId,
    this.taxId,
    this.status,
    this.uploadImage,
    this.isAssorted,
    this.assortProductQty,
    this.tbAssortedProduct,
    this.tbProductTopping,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    headEnglish = json['HeadEnglish'];
    headArabic = json['HeadArabic'];
    desEnglish = json['DesEnglish'];
    desArabic = json['DesArabic'];
    rate = (json['Rate'] ?? 0).toDouble();
    qty = json['Qty'] != null ? double.tryParse(json['Qty'].toString()) ?? 0.0 : 0.0;
    sequenceNo = json['SequenceNo'];
    categoryId = json['CategoryId'];
    taxId = json['TaxId'];
    status = json['Status'];
    uploadImage = json['UploadImage'];
    isAssorted = json['isAssorted'];
    assortProductQty = json['Assort_Product_Qty'];

    tbAssortedProduct = (json['tb_AssortedProduct'] as List?)
        ?.map((v) => TbAssortedProduct.fromJson(v))
        .toList();

    tbProductTopping = (json['tb_ProductTopping'] as List?)
        ?.map((v) => TbProductTopping.fromJson(v))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Code': code,
      'HeadEnglish': headEnglish,
      'HeadArabic': headArabic,
      'DesEnglish': desEnglish,
      'DesArabic': desArabic,
      'Rate': rate,
      'Qty': qty,
      'SequenceNo': sequenceNo,
      'CategoryId': categoryId,
      'TaxId': taxId,
      'Status': status,
      'UploadImage': uploadImage,
      'isAssorted': isAssorted,
      'Assort_Product_Qty': assortProductQty,
      'tb_AssortedProduct': tbAssortedProduct?.map((v) => v.toJson()).toList(),
      'tb_ProductTopping': tbProductTopping?.map((v) => v.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $headEnglish, qty: $qty, categoryId: $categoryId, rate: $rate, status: $status)';
  }
}


/*class Product {
  int? id;
  String? code;
  String? headEnglish;
  String? headArabic;
  String? desEnglish;
  String? desArabic;
  double? rate;
  double? qty;
  int? sequenceNo;
  int? categoryId;
  int? taxId;
  bool? status;
  String? uploadImage;
  bool? isAssorted;
  int? assortProductQty;
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
        this.sequenceNo,
        this.categoryId,
        this.taxId,
        this.status,
        this.uploadImage,
        this.isAssorted,
        this.assortProductQty,
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
    qty = json['Qty'] != null ? double.tryParse(json['Qty'].toString()) ?? 0.0 : 0.0;
    // qty = json['Qty'] != null ? double.tryParse(json['Qty'].toString()) ?? 0.0 : 0.0;
    // qty = (json['Qty'] ?? 0).toDouble();
    // qty = json['Qty'];
    sequenceNo = json['SequenceNo'];
    categoryId = json['CategoryId'];
    taxId = json['TaxId'];
    status = json['Status'];
    uploadImage = json['UploadImage'];
    isAssorted = json['isAssorted'];
    assortProductQty = json['Assort_Product_Qty'];
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
    data['Rate'] = rate;
    data['Qty'] = qty;
    data['SequenceNo'] = this.sequenceNo;
    data['CategoryId'] = this.categoryId;
    data['TaxId'] = this.taxId;
    data['Status'] = this.status;
    data['UploadImage'] = this.uploadImage;
    data['isAssorted'] = this.isAssorted;
    data['Assort_Product_Qty'] = this.assortProductQty;
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

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'headEnglish: $headEnglish, '
        'qty: $qty, '
        'categoryId: $categoryId, '
        'rate: $rate, '
        'status: $status, '
        'uploadImage: $uploadImage'
        ')';
  }

}*/

class TbAssortedProduct {
  int? productId;
  String? code;
  String? headEnglish;
  String? headArabic;
  String? desEnglish;
  String? desArabic;
  double? rate;
  int? qty;
  int? stock;
  int? displayQty;
  int? storesQty;
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

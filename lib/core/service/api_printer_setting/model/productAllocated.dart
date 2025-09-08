class GetproductAllocated {
  int? status;
  String? result;
  List<ProductAllocate>? productAllocate;

  GetproductAllocated({this.status, this.result, this.productAllocate});

  GetproductAllocated.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    result = json['Result'];
    if (json['ProductAllocate'] != null) {
      productAllocate = <ProductAllocate>[];
      json['ProductAllocate'].forEach((v) {
        productAllocate!.add(new ProductAllocate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Result'] = this.result;
    if (this.productAllocate != null) {
      data['ProductAllocate'] =
          this.productAllocate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductAllocate {
  int? id;
  int? branchId;
  String? branch;
  int? counterId;
  String? counterNo;
  int? categoryId;
  String? category;
  int? productId;
  String? product;
  int? locationId;
  String? location1;
  int? locationId1;
  String? location2;

  ProductAllocate(
      {this.id,
        this.branchId,
        this.branch,
        this.counterId,
        this.counterNo,
        this.categoryId,
        this.category,
        this.productId,
        this.product,
        this.locationId,
        this.location1,
        this.locationId1,
        this.location2});

  ProductAllocate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['BranchId'];
    branch = json['Branch'];
    counterId = json['CounterId'];
    counterNo = json['CounterNo'];
    categoryId = json['CategoryId'];
    category = json['Category'];
    productId = json['ProductId'];
    product = json['Product'];
    locationId = json['LocationId'];
    location1 = json['Location1'];
    locationId1 = json['LocationId1'];
    location2 = json['Location2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['BranchId'] = this.branchId;
    data['Branch'] = this.branch;
    data['CounterId'] = this.counterId;
    data['CounterNo'] = this.counterNo;
    data['CategoryId'] = this.categoryId;
    data['Category'] = this.category;
    data['ProductId'] = this.productId;
    data['Product'] = this.product;
    data['LocationId'] = this.locationId;
    data['Location1'] = this.location1;
    data['LocationId1'] = this.locationId1;
    data['Location2'] = this.location2;
    return data;
  }
}
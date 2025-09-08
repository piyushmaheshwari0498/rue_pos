class DeliveryResponse {
  final int status;
  final String result;
  final List<Area> area;

  DeliveryResponse({
    required this.status,
    required this.result,
    required this.area,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      status: json['Status'] ?? 0,
      result: json['Result'] ?? '',
      area: (json['Area'] as List<dynamic>?)
          ?.map((e) => Area.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Result": result,
      "Area": area.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DeliveryResponse(status: $status, result: $result, area: $area)';
  }
}

class Area {
  final int id;
  final String deliveryName;
  final String image;

  Area({
    required this.id,
    required this.deliveryName,
    required this.image,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] ?? 0,
      deliveryName: json['DeliveryName'] ?? '',
      image: json['Image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "DeliveryName": deliveryName,
      "Image": image,
    };
  }

  @override
  String toString() {
    return 'Area(id: $id, deliveryName: $deliveryName, image: $image)';
  }
}

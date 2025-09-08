class CancelOrderResponse {
  final int status;
  final String result;
  final String message;

  CancelOrderResponse({
    required this.status,
    required this.result,
    required this.message,
  });

  // Factory constructor for creating a new instance from a map
  factory CancelOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponse(
      status: json['Status'] ?? 0,
      result: json['Result'] ?? '',
      message: json['Message'] ?? '',
    );
  }

  // Convert the object to a map
  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Result': result,
      'Message': message,
    };
  }

  // Pretty printing / debugging
  @override
  String toString() {
    return 'CancelOrderResponse(status: $status, result: $result, message: $message)';
  }
}

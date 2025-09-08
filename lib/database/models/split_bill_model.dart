import 'dart:convert';


class SplitBill {
  String id;
  String payment_type;
  double amount;
  String transaction_no;

  SplitBill(
      {
        required this.id,
        required this.payment_type,
      required this.amount,
      required this.transaction_no});

  SplitBill copyWith({
    String? id,
    String? payment_type,
    double? amount,
    String? transaction_no,
  }) {
    return SplitBill(
        id: id ?? this.id,
        payment_type: payment_type ?? this.payment_type,
        amount: amount ?? this.amount,
        transaction_no: transaction_no ?? this.transaction_no);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payment_type': payment_type,
      'amount': amount,
      'transaction_no': transaction_no
    };
  }

  factory SplitBill.fromMap(Map<String, dynamic> map) {
    return SplitBill(
        id: map['id'],
        payment_type: map['payment_type'],
        amount: map['amount'],
        transaction_no: map['transaction_no']);
  }

  String toJson() => json.encode(toMap());

  factory SplitBill.fromJson(String source) =>
      SplitBill.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(id: $id,payment_type: $payment_type, amount: $amount, transaction_no: $transaction_no)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SplitBill &&
        other.id == id &&
        other.payment_type == payment_type &&
        other.amount == amount &&
        other.transaction_no == transaction_no ;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    payment_type.hashCode ^
    amount.hashCode ^
    transaction_no.hashCode ;
  }
}

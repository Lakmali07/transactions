class MoneyTransaction {
  int? id;
  int? typeId;
  String? typeCode;
  String? transactionNumber;
  double? amount;
  double? total;
  double? commision;
  String? date;

  MoneyTransaction(
      {this.id,
      this.typeId,
      this.typeCode,
      this.transactionNumber,
      this.amount,
      this.total,
      this.commision,
      this.date});

  MoneyTransaction.fromMap(Map<String, dynamic> map)
      : id = map['transaction_id'],
        typeCode = map['type'],
        transactionNumber = map['transaction_number'],
        amount = map['amount'],
        total = map['total'],
        commision = map['commision'],
        date = map['date'];
}

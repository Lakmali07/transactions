import 'package:flutter/material.dart';
import 'package:transactions/model/transaction.dart';
import 'package:transactions/widgets/label_value.dart';

import '../constants/constants.dart';

class TransactionDetailsView extends StatefulWidget {
  final MoneyTransaction transaction;
  const TransactionDetailsView({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionDetailsView> createState() => _TransactionDetailsViewState();
}

class _TransactionDetailsViewState extends State<TransactionDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.buttonColor,
        title: const Text(
          'Transaction Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LabelValue(
              label: 'Transaction Date', value: widget.transaction.date ?? ''),
          LabelValue(
              label: 'Amount', value: widget.transaction.amount.toString()),
          LabelValue(
              label: 'Commission',
              value: widget.transaction.commision.toString()),
          LabelValue(
              label: 'Total', value: widget.transaction.total.toString()),
          LabelValue(
              label: 'Transaction Number',
              value: widget.transaction.transactionNumber ?? ''),
          LabelValue(label: 'Type', value: widget.transaction.typeCode ?? ''),
          ElevatedButton(onPressed: () {}, child: const Text('Cancel'))
        ],
      ),
    );
  }
}

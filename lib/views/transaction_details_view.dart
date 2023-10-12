import 'package:flutter/material.dart';
import 'package:transactions/bloc/cancel_bloc.dart';
import 'package:transactions/model/transaction.dart';
import 'package:transactions/widgets/label_value.dart';

import '../constants/constants.dart';
import '../utils/response.dart';
import '../widgets/loading.dart';

class TransactionDetailsView extends StatefulWidget {
  final MoneyTransaction transaction;
  const TransactionDetailsView({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionDetailsView> createState() => _TransactionDetailsViewState();
}

class _TransactionDetailsViewState extends State<TransactionDetailsView> {
  late CancelBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = CancelBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

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
          ElevatedButton(
              onPressed: () {
                if (widget.transaction.id != null) {
                  _bloc.cancelTransaction(widget.transaction.id!);
                }
              },
              child: const Text('Cancel')),
          StreamBuilder<Response<bool>>(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Loading(loadingMessage: snapshot.data!.message);
                  case Status.COMPLETED:
                    bool canceled = snapshot.data!.data!;
                    if (canceled) {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => Navigator.pop(context, canceled));
                    }
                  case Status.ERROR:
                    return Text(snapshot.data!.message ?? '');
                  default:
                    break;
                }
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

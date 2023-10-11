import 'package:flutter/material.dart';
import 'package:transactions/bloc/transaction_bloc.dart';
import 'package:transactions/constants/constants.dart';
import 'package:transactions/model/transaction.dart';
import 'package:transactions/views/transaction_details_view.dart';

import '../utils/response.dart';

class TransactionsView extends StatefulWidget {
  static const routeName = '/transactions';
  const TransactionsView({Key? key}) : super(key: key);

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late TransactionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TransactionBloc();
    _bloc.getTransactionsDB();
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
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: StreamBuilder<ResponseList<MoneyTransaction>>(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  //return Loading(loadingMessage: snapshot.data!.message);
                  break;
                case Status.COMPLETED:
                  List<MoneyTransaction> list = snapshot.data!.data!;
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailsView(
                                  transaction: list[index],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(list[index].typeCode ?? '')),
                              SizedBox(
                                  width: 200,
                                  child: Text(
                                      list[index].transactionNumber ?? '')),
                              SizedBox(
                                  width: 100,
                                  child: Text(list[index].amount.toString())),
                            ],
                          ),
                        );
                      });
                case Status.ERROR:
                  return Text(snapshot.data!.message ?? '');
                default:
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}

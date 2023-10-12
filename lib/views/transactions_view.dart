import 'package:flutter/material.dart';
import 'package:transactions/bloc/transaction_bloc.dart';
import 'package:transactions/constants/constants.dart';
import 'package:transactions/model/transaction.dart';
import 'package:transactions/views/transaction_details_view.dart';
import "package:collection/collection.dart";

import '../utils/response.dart';
import '../widgets/loading.dart';

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
    return MaterialApp(
      home: StreamBuilder<ResponseList<MoneyTransaction>>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data!.message);
              case Status.COMPLETED:
                List<MoneyTransaction> list = snapshot.data!.data!;
                List<TransactionsGroupByType> groupByList = [];
                groupBy(
                  snapshot.data!.data!,
                  (MoneyTransaction tr) => tr.typeCode,
                ).forEach((key, value) {
                  groupByList.add(TransactionsGroupByType(key, value));
                });
                return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      bottom: const TabBar(
                        tabs: [
                          Tab(icon: Text('Transactions')),
                          Tab(icon: Text('Grouped Transactions')),
                        ],
                      ),
                      title: const Text('Transactions'),
                    ),
                    body: TabBarView(
                      children: [
                        //first tab
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  // style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.white,
                                  //     textStyle:
                                  //         const TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetailsView(
                                              transaction: list[index],
                                            ),
                                          ),
                                        )
                                        .then((value) => {
                                              if (value != null && value)
                                                {_bloc.getTransactionsDB()}
                                            });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          child:
                                              Text(list[index].typeCode ?? '')),
                                      SizedBox(
                                          width: 200,
                                          child: Text(
                                              list[index].transactionNumber ??
                                                  '')),
                                      SizedBox(
                                          width: 100,
                                          child: Text(
                                              list[index].amount.toString())),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        //second tab
                        ListView.builder(
                          itemCount: groupByList.length,
                          itemBuilder: (context, indexMain) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    groupByList[indexMain].type ?? '',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.buttonColor),
                                  ),
                                ),
                                SizedBox(
                                  height: groupByList[indexMain]
                                          .groupedList
                                          .length *
                                      60,
                                  child: ListView.builder(
                                      itemCount: groupByList[indexMain]
                                          .groupedList
                                          .length,
                                      itemBuilder: (context, indexSub) {
                                        return SizedBox(
                                          height: 60,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(groupByList[
                                                              indexMain]
                                                          .groupedList[indexSub]
                                                          .transactionNumber ??
                                                      '')),
                                              SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                      groupByList[indexMain]
                                                          .groupedList[indexSub]
                                                          .amount
                                                          .toString())),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              case Status.ERROR:
                return Text(snapshot.data!.message ?? '');
              default:
                break;
            }
          }
          return Container();
        },
      ),
    );
  }
}

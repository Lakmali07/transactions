import 'dart:async';

import 'package:transactions/model/transaction.dart';

import '../database/database.dart';
import '../utils/response.dart';

class TransactionBloc {
  StreamController? _controller;

  StreamSink<ResponseList<MoneyTransaction>> get sink =>
      _controller!.sink as StreamSink<ResponseList<MoneyTransaction>>;
  Stream<ResponseList<MoneyTransaction>> get stream =>
      _controller!.stream as Stream<ResponseList<MoneyTransaction>>;

  TransactionBloc() {
    _controller = StreamController<ResponseList<MoneyTransaction>>();
  }

  getTransactionsDB() async {
    DBHelper dbHelper = new DBHelper();
    await dbHelper.init();
    List<MoneyTransaction> transactions =
        await dbHelper.getTransactionDetails();
    sink.add(ResponseList.completed(transactions));
  }

  dispose() {
    _controller?.close();
  }
}

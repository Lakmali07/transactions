import 'dart:async';

import 'package:transactions/model/transaction.dart';

import '../database/database.dart';
import '../locator.dart';
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
    sink.add(ResponseList.loading(''));
    try {
      DBHelper dbHelper = locator.get<DBHelper>();
      List<MoneyTransaction> transactions =
          await dbHelper.getTransactionDetails();
      sink.add(ResponseList.completed(transactions));
    } catch (e) {
      sink.add(ResponseList.error(e.toString()));
    }
  }

  dispose() {
    _controller?.close();
  }
}

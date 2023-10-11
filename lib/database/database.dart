import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';

import '../model/transaction.dart';

class DBHelper {
  Database? _db;

  Future<void> init() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPathHRM = path.join(applicationDirectory.path, "hrm.db");

    bool dbExistHRM = await io.File(dbPathHRM).exists();

    if (!dbExistHRM) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(path.join("assets/", "transactions.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathHRM).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(dbPathHRM);
  }

  Future<List<MoneyTransaction>> getTransactionDetails() async {
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<MoneyTransaction> transactions = [];

    var results = await _db!.rawQuery(
        "SELECT transactions.transaction_id,transactions.amount,transactions.transaction_number,transactions.date,transactions.commision,transactions.total,transaction_type.type FROM transactions LEFT JOIN transaction_type ON transactions.type = transaction_type.id");
    for (Map result in results) {
      MoneyTransaction transaction =
          MoneyTransaction.fromMap(result as Map<String, dynamic>);
      transactions.add(transaction);
    }
    return transactions;
  }

  Future<bool> cancelTransaction(int id) async {
    try {
      final queryResult = await _db
          ?.rawQuery("SELECT * FROM transactions WHERE transaction_id = '$id'");
      if (queryResult!.isNotEmpty) {
        Map<String, dynamic> insertValues = {
          "cancelled": 1,
        };
        if ((await _db?.update('transactions', insertValues,
                where: "transaction_id = '${id}'"))! >
            0) return true;
      }
    } catch (err) {
      print(err);
    } finally {}
    return false;
  }
}

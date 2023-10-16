import 'dart:async';

import '../database/database.dart';
import '../locator.dart';
import '../utils/response.dart';

class CancelBloc {
  StreamController? _controller;

  StreamSink<Response<bool>> get sink =>
      _controller!.sink as StreamSink<Response<bool>>;
  Stream<Response<bool>> get stream =>
      _controller!.stream as Stream<Response<bool>>;

  CancelBloc() {
    _controller = StreamController<Response<bool>>();
  }

  cancelTransaction(int id) async {
    try {
      DBHelper dbHelper = locator.get<DBHelper>();
      bool canceled = await dbHelper.cancelTransaction(id);
      sink.add(Response.completed(canceled));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _controller?.close();
  }
}

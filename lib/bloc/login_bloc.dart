import 'dart:async';

import '../database/database.dart';
import '../utils/response.dart';

class LoginBloc {
  StreamController? _controller;

  StreamSink<Response<bool>> get sink =>
      _controller!.sink as StreamSink<Response<bool>>;
  Stream<Response<bool>> get stream =>
      _controller!.stream as Stream<Response<bool>>;

  LoginBloc() {
    _controller = StreamController<Response<bool>>();
  }

  validate(String userName, String password) async {
    sink.add(Response.loading(''));
    try {
      DBHelper dbHelper = DBHelper();
      await dbHelper.init();
      bool found = await dbHelper.checkUser(userName, password);
      if (found) {
        sink.add(Response.completed(found));
      } else {
        sink.add(Response.error('Invalid username or password'));
      }
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _controller?.close();
  }
}

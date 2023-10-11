class Response<T> {
  Status? status;
  T? data;
  String? message;

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;
  Response.dbError(this.message) : status = Status.DBERROR;
  Response.dbCompleted() : status = Status.DBCOMPLETED;

  Response.fromJson(x);

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

class ResponseList<T> {
  Status? status;
  List<T>? data;
  String? message;

  ResponseList.loading(this.message) : status = Status.LOADING;
  ResponseList.completed(this.data) : status = Status.COMPLETED;
  ResponseList.error(this.message) : status = Status.ERROR;
  ResponseList.dbError() : status = Status.DBERROR;
  ResponseList.dbCompleted() : status = Status.DBCOMPLETED;

  ResponseList.fromJson(x);

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR,DBERROR,DBCOMPLETED }



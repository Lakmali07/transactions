import 'package:get_it/get_it.dart';
import 'package:transactions/database/database.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DBHelper>(() => DBHelper());
}

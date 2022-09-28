import 'package:consuming_restapi/src/domain/notes_services.dart';
import 'package:get_it/get_it.dart';
import 'package:consuming_restapi/src/domain/notes_services.dart';

final sl = GetIt.instance;

void setUpLocator() {
  //sl.registerFactory(() => NoteServices());
  sl.registerLazySingleton(() => NoteServices());
}

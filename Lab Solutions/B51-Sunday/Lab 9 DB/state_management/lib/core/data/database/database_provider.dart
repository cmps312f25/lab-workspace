import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_tut/core/data/database/app_database.dart';

final databaseProvider = FutureProvider((ref) async {
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
});

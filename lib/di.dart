import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'hive.dart';
import 'home_page_provider.dart';

final GetIt di = GetIt.instance;

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.registerLazySingleton(() => HiveHelper());
  await di.get<HiveHelper>().init();
  di.registerLazySingleton(() => HomePageProvider());
  di.get<HomePageProvider>();
}

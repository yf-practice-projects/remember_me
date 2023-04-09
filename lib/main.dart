import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/fast_remember_page.dart';
import 'package:remember_me/service/task_service.dart';
import 'model/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase appDatabase = AppDatabase();
  NoticeService().initialize();
  runApp(ProviderScope(
      child: MyApp(
    database: appDatabase,
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FastRemember(
        database: database,
      ),
    );
  }
}

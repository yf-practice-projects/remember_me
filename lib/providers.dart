import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model/database.dart';

final databaseProvider = Provider((ref) => AppDatabase());
final tasksProvider = FutureProvider.autoDispose<List<Task>>((ref) async {
  final database = ref.watch(databaseProvider);
  return database.taskDao.getAllTasks();
});

final isNoticeProvider = StateProvider((ref) => false);
final noticeTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

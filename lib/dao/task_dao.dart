import 'package:drift/drift.dart';
import '../model/database.dart';

class TaskDao extends DatabaseAccessor<AppDatabase> {
  final AppDatabase db;

  TaskDao(this.db) : super(db);

  Future<void> insertTask(Task task) => into(db.tasks).insert(task);
  Future<void> updateTask(Task task) => update(db.tasks).replace(task);
  Future<void> deleteTask(Task task) => delete(db.tasks).delete(task);
  Future<List<Task>> getAllTasks() => select(db.tasks).get();
}

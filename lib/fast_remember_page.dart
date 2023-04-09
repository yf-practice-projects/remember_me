import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:remember_me/edit_task_page.dart';
import 'package:remember_me/model/database.dart';
import 'package:remember_me/common.dart';

import '../providers.dart';

class FastRemember extends ConsumerWidget {
  const FastRemember({Key? key, required this.database}) : super(key: key);
  final AppDatabase database;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("タスク リスト"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
          color: Colors.black87,
          child: tasksAsyncValue.when(
            data: (tasks) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                      closeOnScroll: true,
                      endActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            autoClose: true,
                            flex: 1,
                            onPressed: (BuildContext context) async {
                              await database.taskDao.deleteTask(tasks[index]);
                              ref.refresh(tasksProvider);
                            },

                            backgroundColor: HexColor("#dc143c"),
                            foregroundColor: Colors.white,
                            icon: Icons.delete_forever_outlined,
                            label: 'delete',
                          ),
                        ],
                      ),
                      child: buildList(context, tasks[index], ref));
                },
              );
            },
            error: (error, _) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditTaskPage(database: database)));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// タスクリスト表示
  Widget buildList(BuildContext context, Task task, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.white))),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          task.content,
          style: const TextStyle(fontSize: 22.0),
        ),
        textColor: Colors.white,
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTaskPage(task: task, database: database)));
          ref.refresh(tasksProvider);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/common.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'model/database.dart';
import 'providers.dart';

class EditTaskPage extends ConsumerWidget {
  EditTaskPage({this.task, required this.database});
  final AppDatabase database;
  final Task? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = TextEditingController(text: task?.content ?? "");
    bool _isNotice = ref.watch(isNoticeProvider);
    DateTime _noticeTime = ref.watch(noticeTimeProvider);
    dynamic _formatTime = DateFormat("yyyy年MM月dd日 hh:mm").format(_noticeTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text("edit"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: true,
                maxLength: 50,
                maxLines: 1,
                obscureText: false,
                style: const TextStyle(fontSize: 16),
                controller: _controller,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: HexColor("#808080"),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("通知"),
                    value: _isNotice,
                    onChanged: (bool isNotice) {
                      ref.read(isNoticeProvider.notifier).state = isNotice;
                    },
                    activeTrackColor: Colors.green,
                    activeColor: Colors.white,
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: HexColor("#808080"), width: 1.0),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 1, 1, 11, 22),
                              maxTime: DateTime(2023, 12, 31, 11, 22),
                              onChanged: (date) {
                            print(date);
                          }, onConfirm: (date) {
                            print(date);
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.jp);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Text('$_formatTime'),
                          ],
                        ),
                      ),
                    ),
                    crossFadeState: _isNotice
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  child: const Text('保存'),
                  onPressed: () async {
                    if (task == null) {
                      final newTask = Task(
                        id: const Uuid().v4(),
                        content: _controller.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      await database.taskDao.insertTask(newTask);
                      final DateTime now = DateTime.now();

                      // NoticeService()
                      //     .scheduleNotification(now.add(Duration(seconds: 60)));
                    } else {
                      final updateTask = task?.copyWith(
                        content: _controller.text,
                        updatedAt: DateTime.now(),
                      );
                      await database.taskDao.updateTask(updateTask!);
                    }

                    ref.refresh(tasksProvider);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

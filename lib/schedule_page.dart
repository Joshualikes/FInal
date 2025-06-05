import 'package:flutter/material.dart';
import 'db_helper.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> _schedule = [];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final data = await DBHelper.getSchedule();
    setState(() {
      _schedule = data;
    });
  }

  void _addEvent() {
    final timeController = TextEditingController();
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Schedule Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  final formattedTime = picked.format(context);
                  timeController.text = formattedTime;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: taskController,
              decoration: const InputDecoration(labelText: 'Task'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (timeController.text.isNotEmpty && taskController.text.isNotEmpty) {
                final newEvent = {
                  'time': timeController.text,
                  'task': taskController.text,
                };
                await DBHelper.insertSchedule(newEvent);
                await _loadSchedule();
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(int id) async {
    await DBHelper.deleteSchedule(id);
    await _loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: ListView.builder(
        itemCount: _schedule.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(_schedule[i]['task']),
          subtitle: Text(_schedule[i]['time']),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEvent(_schedule[i]['id']),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

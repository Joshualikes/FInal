import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'workout_model.dart';

class WorkoutPlanPage extends StatefulWidget {
  const WorkoutPlanPage({super.key});

  @override
  State<WorkoutPlanPage> createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await DBHelper.fetchWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  void _showWorkoutDialog({Workout? workout}) {
    final titleController = TextEditingController(text: workout?.title);
    final detailController = TextEditingController(text: workout?.details);
    final durationController = TextEditingController(text: workout?.duration.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(workout == null ? 'Add Workout' : 'Edit Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: detailController, decoration: const InputDecoration(labelText: 'Details')),
            TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newWorkout = Workout(
                id: workout?.id,
                title: titleController.text,
                details: detailController.text,
                duration: int.tryParse(durationController.text) ?? 0,
              );
              if (workout == null) {
                await DBHelper.insertWorkout(newWorkout);
              } else {
                await DBHelper.updateWorkout(newWorkout);
              }
              Navigator.of(ctx).pop();
              _loadWorkouts();
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plan')),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (ctx, i) => ListTile(
        title: Text(_workouts[i].title),
        subtitle: Text('${_workouts[i].details} • ${_workouts[i].duration} min'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
            icon: const Icon(Icons.edit),onPressed: () => _showWorkoutDialog(workout: _workouts[i]),),
            IconButton(icon: const Icon(Icons.delete),onPressed: () async {
              await DBHelper.deleteWorkout(_workouts[i].id!);
              _loadWorkouts();
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWorkoutDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
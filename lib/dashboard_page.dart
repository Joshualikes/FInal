import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Fitness')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Progress', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(value: 0.5),
                  SizedBox(height: 10),
                  Text("50% - 1500 kcal burned, 1.4h workout"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Exercises', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                ExerciseCard(name: "Pull Ups"),
                ExerciseCard(name: "Push Ups"),
                ExerciseCard(name: "Squats"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String name;
  const ExerciseCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 80, height: 80, color: Colors.grey[800]),
        const SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
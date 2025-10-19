import 'package:dailysync/model/exercise_model.dart';
import 'package:dailysync/widgets/addworkoutsheet.dart';
import 'package:flutter/material.dart';


class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final List<Workout> _workouts = [
    Workout(title: 'Morning Run', duration: '30 min', calories: '320 cal', icon: Icons.directions_run, status: WorkoutStatus.completed),
    Workout(title: 'Strength Training', duration: '45 min', calories: '450 cal', icon: Icons.fitness_center, status: WorkoutStatus.completed),
    Workout(title: 'Yoga Session', duration: '20 min', calories: '150 cal', icon: Icons.self_improvement),
    Workout(title: 'Evening Walk', duration: '15 min', calories: '100 cal', icon: Icons.directions_walk),
  ];

  void _toggleWorkoutStatus(int index) {
    setState(() {
      _workouts[index].status = _workouts[index].status == WorkoutStatus.pending
          ? WorkoutStatus.completed
          : WorkoutStatus.pending;
    });
  }

  // New method to show the bottom sheet and add a workout
  void _showAddWorkoutSheet() async {
    final newWorkout = await showModalBottomSheet<Workout>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddWorkoutSheet(),
    );

    if (newWorkout != null) {
      setState(() {
        _workouts.add(newWorkout);
      });
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newWorkout.title} has been added to your workouts.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Workouts", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                // MODIFIED HERE
                onPressed: _showAddWorkoutSheet,
                icon: const Icon(Icons.add),
                label: const Text('Add Workout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _workouts.length,
            itemBuilder: (context, index) {
              final workout = _workouts[index];
              final isCompleted = workout.status == WorkoutStatus.completed;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(workout.icon, color: Colors.teal, size: 30),
                  title: Text(workout.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${workout.duration} • ${workout.calories}'),
                  trailing: isCompleted
                      ? Chip(label: Text('Completed'), backgroundColor: Colors.teal.shade50)
                      : ElevatedButton(
                          onPressed: () => _toggleWorkoutStatus(index),
                          child: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal,
                            side: BorderSide(color: Colors.teal.shade200)
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

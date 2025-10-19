import 'package:dailysync/model/goal_model.dart';
import 'package:dailysync/view/sleep_screen_detail.dart';
import 'package:dailysync/view/steps_detail_screen.dart';
import 'package:dailysync/view/water_detail_screen.dart';
import 'package:dailysync/view/workout_detail_screen.dart';
import 'package:dailysync/widgets/addwatersheet.dart';
import 'package:dailysync/widgets/bottomsheet.dart';
import 'package:flutter/material.dart';




class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  void _showLogWorkoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for keyboard to not cover the sheet
      builder: (_) => const LogWorkoutSheet(),
    );
  }

  void _showAddWaterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const AddWaterSheet(),
    );
  }

  // New method to handle navigation
  void _navigateToDetail(BuildContext context, Goal goal) {
    Widget page;
    switch (goal.title) {
      case 'Steps':
        page = StepsDetailScreen(goal: goal);
        break;
      case 'Water':
        page = WaterDetailScreen(goal: goal);
        break;
      case 'Sleep':
        page = SleepDetailScreen(goal: goal);
        break;
      case 'Workouts':
        page = WorkoutsDetailScreen(goal: goal);
        break;
      default:
        return; 
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Goal> goals = [
      Goal(title: 'Steps', currentValue: '8,420', goalValue: '10,000 goal', progress: 0.84, icon: Icons.directions_walk, color: Colors.green),
      Goal(title: 'Water', currentValue: '6 cups', goalValue: '8 cups goal', progress: 0.75, icon: Icons.local_drink, color: Colors.blue),
      Goal(title: 'Sleep', currentValue: '7.5h', goalValue: '8h goal', progress: 0.93, icon: Icons.bedtime, color: Colors.purple),
      Goal(title: 'Workouts', currentValue: '3', goalValue: '4 weekly goal', progress: 0.75, icon: Icons.fitness_center, color: Colors.orange),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Goals", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              
              return InkWell(
                onTap: () => _navigateToDetail(context, goal),
                borderRadius: BorderRadius.circular(12.0), // Match card's border radius
                child: _buildGoalCard(context, goal),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text("Quick Actions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Log Workout'),
                  onPressed: () => _showLogWorkoutSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.opacity),
                  label: const Text('Add Water'),
                  onPressed: () => _showAddWaterSheet(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(goal.icon, color: goal.color),
                Text(
                  goal.currentValue,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: goal.color),
                ),
              ],
            ),
            const Spacer(),
            Text(goal.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(goal.goalValue, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: goal.color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(goal.color),
            ),
          ],
        ),
      ),
    );
  }
}


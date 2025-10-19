import 'package:dailysync/model/meal_model.dart';
import 'package:dailysync/widgets/logmeal_sheet.dart';
import 'package:flutter/material.dart';


class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final int _calorieGoal = 2000;
  int _currentCalories = 1070; // Pre-logged breakfast and lunch

  final List<Meal> _meals = [
    Meal(name: 'Breakfast', time: '8:00 AM', calories: 420, isLogged: true),
    Meal(name: 'Lunch', time: '1:00 PM', calories: 650, isLogged: true),
    Meal(name: 'Snack', time: '4:00 PM', calories: 180),
    Meal(name: 'Dinner', time: '7:00 PM', calories: 600),
  ];

  void _toggleLogStatus(int index) {
    setState(() {
      if (!_meals[index].isLogged) {
        _currentCalories += _meals[index].calories;
        _meals[index].isLogged = true;
      } else {
        _currentCalories -= _meals[index].calories;
        _meals[index].isLogged = false;
      }
    });
  }

  // New method to show the bottom sheet and add a meal
  void _showLogMealSheet() async {
    final newMeal = await showModalBottomSheet<Meal>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LogMealSheet(),
    );

    if (newMeal != null) {
      setState(() {
        _meals.add(newMeal);
        // A newly added meal is always logged, so we add its calories
        _currentCalories += newMeal.calories;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newMeal.name} has been logged.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _currentCalories / _calorieGoal;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Meal Tracking", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                // MODIFIED HERE
                onPressed: _showLogMealSheet,
                icon: const Icon(Icons.add),
                label: const Text('Log Meal'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Calories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_currentCalories / $_calorieGoal', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress > 1.0 ? 1.0 : progress, // Cap progress bar at 100%
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    // Show a red bar if calories exceed the goal
                    valueColor: AlwaysStoppedAnimation<Color>(progress > 1.0 ? Colors.red : Colors.teal),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _meals.length,
            itemBuilder: (context, index) {
              final meal = _meals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.restaurant_menu, color: Colors.teal),
                  title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${meal.time} • ${meal.calories} cal'),
                  trailing: meal.isLogged
                      ? Chip(label: const Text('Logged'), backgroundColor: Colors.teal.shade50)
                      : ElevatedButton(
                          onPressed: () => _toggleLogStatus(index),
                          child: const Text('Log'),
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

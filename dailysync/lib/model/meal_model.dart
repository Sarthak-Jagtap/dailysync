class Meal {
  final String name;
  final String time;
  final int calories;
  bool isLogged;

  Meal({
    required this.name,
    required this.time,
    required this.calories,
    this.isLogged = false,
  });
}
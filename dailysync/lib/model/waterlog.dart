class WaterLog {
  final String id;
  final int amountInMl;
  final DateTime date;

  WaterLog({
    required this.id,
    required this.amountInMl,
    required this.date,
  });

  // This will be useful for database integration
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amountInMl': amountInMl,
      'date': date.toIso8601String(),
    };
  }
}

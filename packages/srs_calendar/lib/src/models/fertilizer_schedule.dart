class FertilizerSchedule {
  final String stageName;
  final int daysFromSowing;
  final List<Map<String, dynamic>> fertilizers;
  final String notes;

  const FertilizerSchedule({
    required this.stageName,
    required this.daysFromSowing,
    required this.fertilizers,
    required this.notes,
  });
}

class RiceVariety {
  final int id;
  final String name;
  final int growthDuration;
  final String description;
  final String suitableSoil;
  final Map<String, int> growthStages;

  RiceVariety({
    required this.id,
    required this.name,
    required this.growthDuration,
    required this.description,
    required this.suitableSoil,
    required this.growthStages,
  });
}

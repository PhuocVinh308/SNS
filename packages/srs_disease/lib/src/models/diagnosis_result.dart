class DiagnosisResult {
  final String id;
  final String imagePath;
  final String diseaseName;
  final String description;
  final List<String> biologicalMeasures;
  final List<String> chemicalMeasures;
  final List<String> culturalMeasures;
  final DateTime timestamp;
  final double confidence;

  DiagnosisResult({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.description,
    required this.biologicalMeasures,
    required this.chemicalMeasures,
    required this.culturalMeasures,
    required this.timestamp,
    required this.confidence,
  });
}

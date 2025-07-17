import 'fertillizer.dart';
import 'rice_variety.dart';
import 'package:srs_calendar/srs_calendar.dart' as srs_calendar;

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

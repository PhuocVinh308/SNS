export 'diary_model.dart';
export 'category_model.dart';
export 'transaction_model.dart';

class DiaryTransaction {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final bool isExpense;
  final String category;
  final String? note;

  DiaryTransaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.isExpense,
    required this.category,
    this.note,
  });
}

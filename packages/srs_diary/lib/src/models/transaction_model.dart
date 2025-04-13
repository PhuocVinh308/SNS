class FarmTransaction {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final bool isExpense;
  final String category;
  final String? note;
  final String? imageUrl;

  FarmTransaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.isExpense,
    required this.category,
    this.note,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'description': description,
    'amount': amount,
    'isExpense': isExpense,
    'category': category,
    'note': note,
    'imageUrl': imageUrl,
  };

  factory FarmTransaction.fromJson(Map<String, dynamic> json) => FarmTransaction(
    id: json['id'],
    date: DateTime.parse(json['date']),
    description: json['description'],
    amount: json['amount'].toDouble(),
    isExpense: json['isExpense'],
    category: json['category'],
    note: json['note'],
    imageUrl: json['imageUrl'],
  );
} 
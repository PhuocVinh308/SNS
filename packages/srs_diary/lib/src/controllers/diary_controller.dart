import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class DiaryController extends GetxController {
  final RxList<DiaryTransaction> transactions = <DiaryTransaction>[].obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;

  // Danh mục chi phí
  final expenseCategories = [
    'Phân bón',
    'Thuốc BVTV',
    'Công lao động',
    'Giống',
    'Thuê máy móc',
    'Chi phí khác',
  ];

  // Danh mục thu nhập
  final incomeCategories = [
    'Bán lúa',
    'Bán rơm',
    'Hỗ trợ nông nghiệp',
    'Thu nhập khác',
  ];

  @override
  void onInit() {
    super.onInit();
    // Tạo dữ liệu mẫu
    _loadSampleData();
  }

  void _loadSampleData() {
    final sampleTransactions = [
      DiaryTransaction(
        id: '1',
        date: DateTime.now(),
        description: 'Mua phân NPK',
        amount: 2500000,
        isExpense: true,
        category: 'Phân bón',
        note: 'Phân bón đợt 1',
      ),
      DiaryTransaction(
        id: '2',
        date: DateTime.now().subtract(Duration(days: 2)),
        description: 'Thuê máy gặt',
        amount: 300000000,
        isExpense: true,
        category: 'Thuê máy móc',
      ),
      DiaryTransaction(
        id: '3',
        date: DateTime.now().subtract(Duration(days: 5)),
        description: 'Bán lúa đợt 1',
        amount: 15000000000,
        isExpense: false,
        category: 'Bán lúa',
        note: 'Giá 7,500đ/kg',
      ),
      DiaryTransaction(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 7)),
        description: 'Thuê công gặt',
        amount: 1800,
        isExpense: true,
        category: 'Công lao động',
      ),
      DiaryTransaction(
        id: '5',
        date: DateTime.now().subtract(Duration(days: 10)),
        description: 'Bán rơm',
        amount: 12000,
        isExpense: false,
        category: 'Bán rơm',
      ),
    ];

    transactions.addAll(sampleTransactions);
    _updateMonthlyTransactions();
  }

  void _updateMonthlyTransactions() {
    final monthlyTransactions = getTransactionsByMonth(selectedMonth.value);
    
    double income = 0;
    double expense = 0;
    
    for (var transaction in monthlyTransactions) {
      if (transaction.isExpense) {
        expense += transaction.amount;
      } else {
        income += transaction.amount;
      }
    }
    
    totalIncome.value = income;
    totalExpense.value = expense;
  }

  List<DiaryTransaction> getTransactionsByMonth(DateTime date) {
    return transactions
        .where((t) => 
            t.date.year == date.year && 
            t.date.month == date.month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
      1,
    );
    _updateMonthlyTransactions();
  }

  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
      1,
    );
    _updateMonthlyTransactions();
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    _updateMonthlyTransactions();
  }

  void addNewTransaction(DiaryTransaction transaction) {
    transactions.add(transaction);
    _updateMonthlyTransactions();
  }

  String generateTransactionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(amount);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
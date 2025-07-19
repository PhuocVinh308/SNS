import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart' hide Transaction;

import '../models/models.dart';
import '../configs/all_route.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_init_controller.dart';

class TransactionInitController {
  Rx<bool> options = false.obs;

  // Observable variables
  final RxList<Transaction> transactions = <Transaction>[].obs;
  final RxList<Transaction> filteredTransactions = <Transaction>[].obs;
  final RxInt pendingCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  // Thêm các biến mới
  // final Rx<String> userRole = 'farmer'.obs; // hoặc 'trader'
  final Rx<String> userRole = 'trader'.obs; // hoặc 'farmer'

  final RxBool isFilterActive = false.obs;
  final RxString activeFilters = ''.obs;

  // Filter variables
  final RxMap<String, dynamic> filters = <String, dynamic>{}.obs;
  final searchController = TextEditingController();

  init() async {
    try {
      await loadTransactions();
      await _initUserRole();
      ever(filters, (_) => _updateActiveFilters());
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  // Khởi tạo role người dùng
  Future<void> _initUserRole() async {
    try {
      // TODO: Implement get user role from API/local storage
      // userRole.value = await getUserRole();
    } catch (e) {
      print('Error getting user role: $e');
    }
  }

  // Hiển thị dialog tạo giao dịch mới
  void showCreateTransactionDialog() {
    if (userRole.value != 'farmer') {
      showErrorSnackbar('Chỉ nông dân mới có thể đăng tin');
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
        ),
      ),
    );
  }

  // Cập nhật trạng thái bộ lọc
  void _updateActiveFilters() {
    List<String> activeFiltersList = [];

    if (selectedCategory.isNotEmpty) {
      activeFiltersList.add('Danh mục: ${selectedCategory.value}');
    }

    if (filters['minPrice'] != null || filters['maxPrice'] != null) {
      String priceFilter = 'Giá: ';
      // if (filters['minPrice'] != null) {
      //   priceFilter += '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(filters['minPrice'])} - ';
      // }
      // if (filters['maxPrice'] != null) {
      //   priceFilter += NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(filters['maxPrice']);
      // }
      activeFiltersList.add(priceFilter);
    }

    if (filters['location'] != null) {
      activeFiltersList.add('Khu vực: ${filters['location']}');
    }

    if (activeFiltersList.isEmpty) {
      isFilterActive.value = false;
      activeFilters.value = '';
    } else {
      isFilterActive.value = true;
      activeFilters.value = activeFiltersList.join(' | ');
    }
  }

  // Clear all filters
  void clearFilters() {
    filters.clear();
    selectedCategory.value = '';
    searchController.clear();
    isFilterActive.value = false;
    activeFilters.value = '';
    applyFilters();
  }

  // Apply filters
  void applyFilters() {
    var filtered = transactions.toList();

    // Apply category filter
    if (selectedCategory.isNotEmpty) {
      filtered = filtered.where((t) => t.category == selectedCategory.value).toList();
    }

    // Apply search
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      filtered = filtered.where((t) => t.title.toLowerCase().contains(query) || t.location.toLowerCase().contains(query)).toList();
    }

    // Apply price range
    if (filters['minPrice'] != null) {
      filtered = filtered.where((t) => t.price >= filters['minPrice']).toList();
    }
    if (filters['maxPrice'] != null) {
      filtered = filtered.where((t) => t.price <= filters['maxPrice']).toList();
    }

    // Apply location filter
    if (filters['location'] != null) {
      filtered = filtered.where((t) => t.location.toLowerCase().contains(filters['location'].toLowerCase())).toList();
    }

    filteredTransactions.value = filtered;
  }

  // Set category
  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  // Set price range
  void setPriceRange(double? min, double? max) {
    filters['minPrice'] = min;
    filters['maxPrice'] = max;
    applyFilters();
  }

  // Set location
  void setLocation(String? location) {
    filters['location'] = location;
    applyFilters();
  }

  // Helper methods for showing notifications
  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Thành công',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Lỗi',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // Load transactions from API/Database
  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // final response = await apiService.getTransactions();
      // transactions.value = response;
      updateCounts();
      applyFilters();
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update transaction counts
  void updateCounts() {
    pendingCount.value = transactions.where((t) => t.status == 'pending').length;
    completedCount.value = transactions.where((t) => t.status == 'completed').length;
  }

  // Create new transaction post
  Future<void> createTransaction(Transaction transaction) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await apiService.createTransaction(transaction);
      transactions.add(transaction);
      updateCounts();
      applyFilters();
      Get.back();
      showSuccessSnackbar('Đăng tin thành công');
    } catch (e) {
      showErrorSnackbar('Đăng tin thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  // Send negotiation request
  Future<void> sendNegotiation(String transactionId, double price, String note) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await apiService.sendNegotiation(transactionId, price, note);
      showSuccessSnackbar('Đã gửi yêu cầu thương lượng');
      Get.back();
    } catch (e) {
      showErrorSnackbar('Gửi yêu cầu thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  // Accept negotiation and create contract
  Future<void> acceptNegotiation(String negotiationId) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await apiService.acceptNegotiation(negotiationId);
      showSuccessSnackbar('Đã chấp nhận thương lượng');
      Get.back();
    } catch (e) {
      showErrorSnackbar('Thao tác thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign contract
  Future<void> signContract(String contractId) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await apiService.signContract(contractId);
      showSuccessSnackbar('Đã ký hợp đồng thành công');
      Get.back();
    } catch (e) {
      showErrorSnackbar('Ký hợp đồng thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  // Update transaction status
  Future<void> updateTransactionStatus(String transactionId, String status) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await apiService.updateTransactionStatus(transactionId, status);
      final index = transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        transactions[index] = transactions[index].copyWith(status: status);
        updateCounts();
        applyFilters();
      }
    } catch (e) {
      showErrorSnackbar('Cập nhật trạng thái thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}

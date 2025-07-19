import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

class TransactionInitController {
  final service = TransactionService();
  final autoValid = AutovalidateMode.onUnfocus;

  // scroll
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  bool get hasMore => service.hasMore;

  //drive
  final DriveService _driveService = DriveService();
  bool googleDriveInitialized = false;

  // global
  Rx<srs_authen.UserInfoModel> userModel = srs_authen.UserInfoModel().obs;

  // search
  TextEditingController searchController = TextEditingController();

  // add
  TextEditingController addTitleController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();
  TextEditingController addAreaController = TextEditingController();
  TextEditingController addPriceController = TextEditingController();
  TextEditingController addRiceTypeController = TextEditingController();
  TextEditingController addLocationController = TextEditingController();
  TextEditingController addSowingDateController = TextEditingController();
  Rx<String> addSowingDateString = ''.obs;
  TextEditingController addHarvestDateController = TextEditingController();
  Rx<String> addHarvestDateString = ''.obs;

  // image
  final ImagePicker picker = ImagePicker();
  var progress = 0.0.obs;
  Rxn<String> imageOriginalPath = Rxn<String>();
  Rxn<String> imageOriginalName = Rxn<String>();
  Rxn<Uint8List> imageOriginalBytes = Rxn<Uint8List>();

  // list
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  List<String> trangThaiPosts = TransactionService().trangThaiPosts;
  RxMap<String, int> counts = <String, int>{}.obs;
  late Stream<Map<String, int>> _countStream;
  late StreamSubscription<Map<String, int>> _subscription;

  //======
  final RxString selectedCategory = ''.obs;

  // Thêm các biến mới

  final RxBool isFilterActive = false.obs;
  final RxString activeFilters = ''.obs;

  // Filter variables
  final RxMap<String, dynamic> filters = <String, dynamic>{}.obs;

  init() async {
    try {
      await _initAddSowingDate();
      await _initUserModel();
      await _initGoogleDriveService();
      await initSyncTransactionsPost();
      await initScrollController();
      await initCountPost();

      // await loadTransactions();
      // await _initUserRole();
      // ever(filters, (_) => _updateActiveFilters());
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  close() async {
    _subscription.cancel();
    searchController.dispose();
  }

  initScrollController() async {
    try {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          fetchMorePosts();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  _initAddSowingDate() async {
    try {
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String formatDateYMD = DateFormat("yyyy-MM-dd HH:mm:ss:SSS").format(DateTime.now());
      addSowingDateController.text = formattedDate;
      addSowingDateString.value = formatDateYMD;

      addHarvestDateController.text = formattedDate;
      addHarvestDateString.value = formatDateYMD;
    } catch (e) {
      rethrow;
    }
  }

  _initUserModel() async {
    try {
      userModel.value = CustomGlobals().userInfo;
    } catch (e) {
      rethrow;
    }
  }

  String getTrangThaiPostToName(String code) {
    return code == trangThaiPosts.first
        ? "đang bán".tr.toCapitalized()
        : code == trangThaiPosts[1]
            ? "đã thương lượng".tr.toCapitalized()
            : "đã hoàn thành".tr.toCapitalized();
  }

  corePickImage(ImageSource src) async {
    try {
      final image = await picker.pickImage(source: src);
      if (image != null) {
        imageOriginalPath.value = image.path;
        imageOriginalName.value = image.name;
        imageOriginalBytes.value = await image.readAsBytes();
      }
    } catch (e) {
      _refreshSelect();
      DialogUtil.catchException(obj: e);
    }
  }

  coreRefreshSelect() async {
    await _refreshSelect();
    await _initAddSowingDate();
  }

  _refreshSelect() async {
    //image
    imageOriginalPath.value = null;
    imageOriginalName.value = null;
    imageOriginalBytes.value = null;
    progress.value = 0.0;
    //add
    addTitleController.clear();
    addDescriptionController.clear();
    addAreaController.clear();
    addPriceController.clear();
    addRiceTypeController.clear();
    addLocationController.clear();
    addSowingDateController.clear();
    addSowingDateString.value = '';
    addHarvestDateController.clear();
    addHarvestDateString.value = '';
  }

  corePostItem() async {
    try {
      DialogUtil.showLoading();
      TransactionModel postModel = TransactionModel(
        title: addTitleController.text,
        description: addDescriptionController.text,
        dienTich: double.tryParse(addAreaController.text),
        gia: double.tryParse(addPriceController.text),
        diaDiem: addLocationController.text,
        giongLua: addRiceTypeController.text,
        ngayGieoSa: addSowingDateString.value,
        ngayThuHoach: addHarvestDateString.value,
        email: userModel.value.email,
        trangThai: trangThaiPosts.first,
        isVerified: true,
      );

      String? fileId = await _uploadImage();
      if (fileId != null && fileId.isNotEmpty) {
        final fileUrl = await _driveService.getFileUrl(fileId);
        postModel.fileId = fileId;
        postModel.fileUrl = fileUrl;
      } else {
        postModel.fileId = "";
        postModel.fileUrl = "";
      }
      await service.postItem(postModel);
      DialogUtil.hideLoading();

      DialogUtil.catchException(
        msg: "${"đăng tin thành công".tr.toCapitalized()}!",
        status: CustomSnackBarStatus.success,
        onCallback: () {
          Get.back(closeOverlays: true);
          coreRefreshSelect();
          initSyncTransactionsPost();
        },
        snackBarShowTime: 1,
      );
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
    }
  }

  _uploadImage() async {
    try {
      if (imageOriginalBytes.value != null) {
        final fileId = await _driveService.uploadFileUint8List(
          imageOriginalBytes.value!,
          imageOriginalName.value!,
          folderId: CustomConsts.googleDriveFolderId,
        );
        return fileId;
      }
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  _initGoogleDriveService() async {
    try {
      await _driveService.initialize();
      googleDriveInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initSyncTransactionsPost() async {
    transactions.clear();
    service.resetPagination();
    await fetchMorePosts();
  }

  Future<void> fetchMorePosts() async {
    if (isLoading || !service.hasMore) return;
    isLoading = true;
    DialogUtil.showLoading();
    try {
      final newTransactions = await service.fetchItemPosts();
      transactions.addAll(newTransactions);
    } finally {
      isLoading = false;
      DialogUtil.hideLoading();
    }
  }

  initCountPost() async {
    try {
      _countStream = service.countItems(trangThaiPosts);
      _subscription = _countStream.listen((data) {
        counts.value = data;
      });
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  //

  // Khởi tạo role người dùng
  Future<void> _initUserRole() async {
    // try {
    //   // TODO: Implement get user role from API/local storage
    //   // userRole.value = await getUserRole();
    // } catch (e) {
    //   print('Error getting user role: $e');
    // }
  }

  // Cập nhật trạng thái bộ lọc
  void _updateActiveFilters() {
    // List<String> activeFiltersList = [];
    //
    // if (selectedCategory.isNotEmpty) {
    //   activeFiltersList.add('Danh mục: ${selectedCategory.value}');
    // }
    //
    // if (filters['minPrice'] != null || filters['maxPrice'] != null) {
    //   String priceFilter = 'Giá: ';
    //   // if (filters['minPrice'] != null) {
    //   //   priceFilter += '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(filters['minPrice'])} - ';
    //   // }
    //   // if (filters['maxPrice'] != null) {
    //   //   priceFilter += NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(filters['maxPrice']);
    //   // }
    //   activeFiltersList.add(priceFilter);
    // }
    //
    // if (filters['location'] != null) {
    //   activeFiltersList.add('Khu vực: ${filters['location']}');
    // }
    //
    // if (activeFiltersList.isEmpty) {
    //   isFilterActive.value = false;
    //   activeFilters.value = '';
    // } else {
    //   isFilterActive.value = true;
    //   activeFilters.value = activeFiltersList.join(' | ');
    // }
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
    // var filtered = transactions.toList();
    //
    // // Apply category filter
    // if (selectedCategory.isNotEmpty) {
    //   filtered = filtered.where((t) => t.category == selectedCategory.value).toList();
    // }
    //
    // // Apply search
    // if (searchController.text.isNotEmpty) {
    //   final query = searchController.text.toLowerCase();
    //   filtered = filtered.where((t) => t.title.toLowerCase().contains(query) || t.location.toLowerCase().contains(query)).toList();
    // }
    //
    // // Apply price range
    // if (filters['minPrice'] != null) {
    //   filtered = filtered.where((t) => t.price >= filters['minPrice']).toList();
    // }
    // if (filters['maxPrice'] != null) {
    //   filtered = filtered.where((t) => t.price <= filters['maxPrice']).toList();
    // }
    //
    // // Apply location filter
    // if (filters['location'] != null) {
    //   filtered = filtered.where((t) => t.location.toLowerCase().contains(filters['location'].toLowerCase())).toList();
    // }
    //
    // filteredTransactions.value = filtered;
  }

  // Set category
  void setCategory(String category) {
    // selectedCategory.value = category;
    // applyFilters();
  }

  // Set price range
  void setPriceRange(double? min, double? max) {
    // filters['minPrice'] = min;
    // filters['maxPrice'] = max;
    // applyFilters();
  }

  // Set location
  void setLocation(String? location) {
    // filters['location'] = location;
    // applyFilters();
  }

  // Helper methods for showing notifications
  void showSuccessSnackbar(String message) {
    // Get.snackbar(
    //   'Thành công',
    //   message,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.TOP,
    //   margin: EdgeInsets.all(10),
    //   borderRadius: 10,
    //   icon: Icon(Icons.check_circle, color: Colors.white),
    // );
  }

  void showErrorSnackbar(String message) {
    // Get.snackbar(
    //   'Lỗi',
    //   message,
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.TOP,
    //   margin: EdgeInsets.all(10),
    //   borderRadius: 10,
    //   icon: Icon(Icons.error_outline, color: Colors.white),
    // );
  }

  // Update transaction counts
  void updateCounts() {
    // pendingCount.value = transactions.where((t) => t.status == 'pending').length;
    // completedCount.value = transactions.where((t) => t.status == 'completed').length;
  }

  // Create new transaction post
  Future<void> createTransaction(TransactionModel transaction) async {
    // try {
    //   isLoading.value = true;
    //   // TODO: Implement API call
    //   // await apiService.createTransaction(transaction);
    //   transactions.add(transaction);
    //   updateCounts();
    //   applyFilters();
    //   Get.back();
    //   showSuccessSnackbar('Đăng tin thành công');
    // } catch (e) {
    //   showErrorSnackbar('Đăng tin thất bại');
    // } finally {
    //   isLoading.value = false;
    // }
  }

  // Send negotiation request
  Future<void> sendNegotiation(String transactionId, double price, String note) async {
    // try {
    //   isLoading.value = true;
    //   // TODO: Implement API call
    //   // await apiService.sendNegotiation(transactionId, price, note);
    //   showSuccessSnackbar('Đã gửi yêu cầu thương lượng');
    //   Get.back();
    // } catch (e) {
    //   showErrorSnackbar('Gửi yêu cầu thất bại');
    // } finally {
    //   isLoading.value = false;
    // }
  }

  // Accept negotiation and create contract
  Future<void> acceptNegotiation(String negotiationId) async {
    // try {
    //   isLoading.value = true;
    //   // TODO: Implement API call
    //   // await apiService.acceptNegotiation(negotiationId);
    //   showSuccessSnackbar('Đã chấp nhận thương lượng');
    //   Get.back();
    // } catch (e) {
    //   showErrorSnackbar('Thao tác thất bại');
    // } finally {
    //   isLoading.value = false;
    // }
  }

  // Sign contract
  Future<void> signContract(String contractId) async {
    // try {
    //   isLoading.value = true;
    //   // TODO: Implement API call
    //   // await apiService.signContract(contractId);
    //   showSuccessSnackbar('Đã ký hợp đồng thành công');
    //   Get.back();
    // } catch (e) {
    //   showErrorSnackbar('Ký hợp đồng thất bại');
    // } finally {
    //   isLoading.value = false;
    // }
  }

  // Update transaction status
  Future<void> updateTransactionStatus(String transactionId, String status) async {
    // try {
    //   isLoading.value = true;
    //   // TODO: Implement API call
    //   // await apiService.updateTransactionStatus(transactionId, status);
    //   final index = transactions.indexWhere((t) => t.id == transactionId);
    //   if (index != -1) {
    //     transactions[index] = transactions[index].copyWith(status: status);
    //     updateCounts();
    //     applyFilters();
    //   }
    // } catch (e) {
    //   showErrorSnackbar('Cập nhật trạng thái thất bại');
    // } finally {
    //   isLoading.value = false;
    // }
  }
}

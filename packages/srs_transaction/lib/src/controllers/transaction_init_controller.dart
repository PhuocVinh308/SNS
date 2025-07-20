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
  RxList<TransactionModel> itemSearchPosts = <TransactionModel>[].obs;
  final ScrollController scrollSearchController = ScrollController();
  bool isSearchLoading = false;

  bool get hasMoreSearch => service.hasMoreSearch;

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

  // negotiate
  TextEditingController negotiatePriceController = TextEditingController();
  TextEditingController negotiateNoteController = TextEditingController();

//===
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

      await initScrollSearchController();
      await initSyncItemSearchPost();

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
    service.cancelNegotiateListener();
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
    //negotiate
    negotiatePriceController.clear();
    negotiateNoteController.clear();
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

  corePostNegotiate(String? documentIdParent) async {
    try {
      DialogUtil.showLoading();
      NegotiateModel postModel = NegotiateModel(
        documentIdParent: documentIdParent,
        email: userModel.value.email,
        gia: double.tryParse(negotiatePriceController.text),
        note: negotiateNoteController.text,
        isChot: false,
      );

      await service.postItemNegotiate(dataChild: postModel);
      service.listenToNegotiatesAndUpdate(documentIdParent);
      DialogUtil.hideLoading();

      DialogUtil.catchException(
        msg: "${"thương lượng thành công".tr.toCapitalized()}!",
        status: CustomSnackBarStatus.success,
        onCallback: () {
          Get.back(closeOverlays: true);
          coreRefreshSelect();
          service.cancelNegotiateListener();
          initSyncTransactionsPost();
        },
        snackBarShowTime: 1,
      );
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
    }
  }

  coreNegotiateDone(String? documentIdParent, String? documentId) async {
    try {
      DialogUtil.showLoading();

      await service.postNegotiateDone(documentIdParent, documentId);
      service.listenToNegotiatesAndUpdate(documentIdParent, done: trangThaiPosts.last);
      DialogUtil.hideLoading();

      DialogUtil.catchException(
        msg: "${"thương lượng thành công".tr.toCapitalized()}!",
        status: CustomSnackBarStatus.success,
        onCallback: () {
          Get.back(closeOverlays: true);
          coreRefreshSelect();
          service.cancelNegotiateListener();
          initSyncTransactionsPost();
        },
        snackBarShowTime: 1,
      );
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.catchException(obj: e);
      rethrow;
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

  Future<List<NegotiateModel>> fetchNegotiateList(String? documentIdParent) async {
    DialogUtil.showLoading();
    try {
      final list = await service.fetchItemNegotiate(documentIdParent);
      return list;
    } finally {
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

  coreClearSearch() async {
    searchController.clear();
    itemSearchPosts.clear();
  }

  initScrollSearchController() async {
    try {
      scrollSearchController.addListener(() {
        if (scrollSearchController.position.pixels >= scrollSearchController.position.maxScrollExtent - 200) {
          fetchMoreSearchPosts();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initSyncItemSearchPost() async {
    itemSearchPosts.clear();
    service.resetSearchPagination();
    await fetchMoreSearchPosts();
  }

  Future<void> fetchMoreSearchPosts() async {
    if (isSearchLoading || !service.hasMoreSearch) return;
    isSearchLoading = true;
    DialogUtil.showLoading();
    try {
      final newPosts = await service.fetchItemSearchPosts(keyword: searchController.value.text.trim());
      itemSearchPosts.addAll(newPosts);
    } finally {
      isSearchLoading = false;
      DialogUtil.hideLoading();
    }
  }

  coreSearchPost() async => initSyncItemSearchPost();
}

import 'dart:developer';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

import 'transaction_init_controller.dart';

class TransactionController extends GetxController with TransactionInitController {
  @override
  void onInit() async {
    log('initialize Controller', name: TransactionConfig.packageName);
    await init();
    super.onInit();
  }

  funPostItem() async => await corePostItem();

  funPostNegotiate(String? documentIdParent) async => await corePostNegotiate(documentIdParent);

  funCoreNegotiateDone(String? documentIdParent, String? documentId) async => await coreNegotiateDone(documentIdParent, documentId);

  funPickImage(ImageSource src) async => await corePickImage(src);

  funRefreshSelect() => coreRefreshSelect();

  funClearSearch() async => await coreClearSearch();

  funSearchPost() async => await coreSearchPost();

  @override
  void onClose() {
    close();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'transaction_init_controller.dart';

class TransactionController extends GetxController with TransactionInitController {
  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

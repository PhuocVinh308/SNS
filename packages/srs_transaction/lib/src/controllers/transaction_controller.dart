import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../configs/all_route.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
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

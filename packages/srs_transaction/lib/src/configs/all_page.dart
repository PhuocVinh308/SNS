import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

import '../bindings/all_binding.dart';

allPageTransaction() async {
  log('initialize All Page Route', name: TransactionConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const TransactionPage(),
      binding: AllBindingTransaction(),
    ),
    GetPage(
      name: AllRoute.searchRoute,
      page: () => TransactionSearchPage(),
      binding: AllBindingTransaction(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}

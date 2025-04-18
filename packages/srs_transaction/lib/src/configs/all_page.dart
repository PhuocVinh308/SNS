import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';
import '../bindings/all_binding.dart';
import 'all_route.dart';

allPageTransaction() async {
  log('initialize All Page Route', name: TransactionConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRouteTransaction.transactionMainRoute,
      page: () =>  const TransactionPage(),
      binding:  AllBindingTransaction(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}

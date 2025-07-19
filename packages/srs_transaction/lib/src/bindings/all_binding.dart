import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart' as srs_transaction;

class AllBindingTransaction extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => srs_transaction.TransactionController());
  }
}

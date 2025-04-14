import 'dart:developer';
import 'package:srs_transaction/src/configs/all_page.dart';
import 'package:srs_transaction/srs_transaction.dart';
import '../translations/app_translations.dart';

initPackage() async {
  log('initialize Package', name: TransactionConfig.packageName);
  await allPageTransaction();
  await initAppTranslations();
}

import 'package_config.dart';

class AllRoute {
  static const String mainRoute = "/${TransactionConfig.packageName}/main-route";
  static const String transactionDetailRoute = "$mainRoute/detail-route";
  static const String searchRoute = "$mainRoute/search-route";
}

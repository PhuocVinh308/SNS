import 'package:get/get.dart';

class GetPageCenter {
  static List<GetPage<dynamic>> pages = [];

  static add(GetPage<dynamic> page) {
    GetPageCenter.pages.add(page);
  }

  static addAll(List<GetPage<dynamic>> pages) {
    GetPageCenter.pages.addAll(pages);
  }
}

import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_diary/srs_diary.dart';
import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: DiaryConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRouteDiary.diaryMainRoute,
      page: () => const DiaryPage(),
      binding: AllBindingDiary(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}

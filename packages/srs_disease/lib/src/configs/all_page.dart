import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_disease/srs_disease.dart';

import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: DiseaseConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRouteDisease.diseaseMainRoute,
      page: () => DiseasePage(),
      binding: AllBindingDisease(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
